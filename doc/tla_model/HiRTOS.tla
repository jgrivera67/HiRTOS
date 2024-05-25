------------------------------ MODULE HiRTOS ------------------------------
(***************************************************************************)
(* Copyright (c) 2024, German Rivera                                       *)
(*                                                                         *)
(* SPDX-License-Identifier: Apache-2.0                                     *)
(*                                                                         *)
(* This spec describes the thread scheduler of a per-CPU HiRTOS instance.  *)
(***************************************************************************)

EXTENDS FiniteSets, Sequences, Naturals, TLC

CONSTANTS
   Invalid_Thread_Priority

Num_Thread_Priorities == 3
Num_Interrupt_Priorities == 2

Valid_Thread_Priority_Type == 0 .. Num_Thread_Priorities - 1
Thread_Priority_Type == Valid_Thread_Priority_Type \cup { Invalid_Thread_Priority }

Threads == { "Idle_Thread", "thread1", "thread2", "thread3" }
Mutexes == { "mutex1" }
Condvars == { "thread1_condvar", "thread2_condvar", "thread3_condvar", "condvar1" }
Timers == { "thread1_timer", "thread2_timer", "thread3_timer" }
Interrupts == { "Timer_Interrupt", "Other_Interrupt" }

Thread_Id_Type == Threads \cup { "Invalid_Thread_Id" }
Mutex_Id_Type == Mutexes \cup { "Invalid_Mutex_Id" }
Condvar_Id_Type == Condvars \cup { "Invalid_Condvar_Id" }
Timer_Id_Type == Timers \cup { "Invalid_Timer_Id" }
Interrupt_Id_Type == Interrupts \cup { "Invalid_Interrupt_Id" }

Thread_State_Type == { "Suspended", "Runnable", "Running",
                       "Blocked_On_Condvar", "Blocked_On_Mutex" }

Timer_State_Type == { "Timer_Stopped", "Timer_Running" }

Injective_Sequence_Type(S) ==
    { x \in Seq(S) : Len(x) /= 0 =>
                     \A i, j \in 1 .. Len(x) : i /= j => x[i] /= x[j] }

Range(f) == { f[x] : x \in DOMAIN f }

Thread_Queue_Type == Injective_Sequence_Type(Thread_Id_Type)

Thread_Priority_Queue_Type == [ Valid_Thread_Priority_Type -> Thread_Queue_Type ]

HiRTOS_Type == [
   Current_Thread_Id : Thread_Id_Type,
   Runnable_Threads_Queue : Thread_Priority_Queue_Type,
   Interrupts_Enabled : BOOLEAN
]

HiRTOS_Initializer == [
   Current_Thread_Id |-> "Invalid_Thread_Id",
   Runnable_Threads_Queue |->
        [ p \in Valid_Thread_Priority_Type |->
            CASE p = 0 -> <<"Idle_Thread">>
            [] p = 1 -> <<"thread1">>
            [] p = 2 -> <<"thread2", "thread3">>
        ],
   Interrupts_Enabled |-> TRUE
]

Thread_Object_Type == [
    State : Thread_State_Type,
    Current_Priority : Valid_Thread_Priority_Type,
    Base_Priority : Valid_Thread_Priority_Type,
    Builtin_Timer_Id : Timer_Id_Type,
    Builtin_Condvar_Id : Condvar_Id_Type,
    Waiting_On_Condvar_Id : Condvar_Id_Type,
    Waiting_On_Mutex_Id : Mutex_Id_Type,
    Owned_Mutexes : Injective_Sequence_Type(Mutex_Id_Type),
    ghost_Time_Slice_Consumed : BOOLEAN,
    ghost_Condvar_Wait_Mutex_Id : Mutex_Id_Type
]

Thread_Object_Initializer(priority, timer_id, condvar_id) == [
    State |-> "Runnable",
    Current_Priority |-> priority,
    Base_Priority  |-> priority,
    Builtin_Timer_Id |-> timer_id,
    Builtin_Condvar_Id |-> condvar_id,
    Waiting_On_Condvar_Id |-> "Invalid_Condvar_Id",
    Waiting_On_Mutex_Id |-> "Invalid_Mutex_Id",
    Owned_Mutexes |-> <<>>,
    ghost_Time_Slice_Consumed |-> FALSE,
    ghost_Condvar_Wait_Mutex_Id |-> "Invalid_Mutex_Id"
]

Mutex_Object_Type == [
    Owner_Thread_Id : Thread_Id_Type,
    Last_Inherited_Priority : Thread_Priority_Type,
    Waiting_Threads_Queue : Thread_Priority_Queue_Type
]

Mutex_Object_Initializer == [
    Owner_Thread_Id |-> "Invalid_Thread_Id",
    Last_Inherited_Priority |-> Invalid_Thread_Priority,
    Waiting_Threads_Queue |->
        [ p \in Valid_Thread_Priority_Type |-> <<>> ]
]

Condvar_Object_Type == [
    Wakeup_Mutex_Id : Mutex_Id_Type,
    Waiting_Threads_Queue : Thread_Priority_Queue_Type
]

Condvar_Object_Initializer == [
    Wakeup_Mutex_Id |-> "Invalid_Mutex_Id",
    Waiting_Threads_Queue |->
        [ p \in Valid_Thread_Priority_Type |-> <<>> ]
]

Timer_Object_Type == [
    State : Timer_State_Type
]

Timer_Object_Initializer == [
    State |-> "Timer_Stopped"
]

Is_Thread_Priority_Queue_Empty(prio_queue) ==
   \A p \in Valid_Thread_Priority_Type : prio_queue[p] = <<>>

Is_Thread_In_Priority_Queue(prio_queue, thread_id) ==
    \E p \in Valid_Thread_Priority_Type : thread_id \in Range(prio_queue[p])

Is_Thread_In_Priority_Queue_In_Only_One_Queue(prio_queue, thread_id) ==
    Is_Thread_In_Priority_Queue(prio_queue, thread_id) =>
    Cardinality({ p \in Valid_Thread_Priority_Type : thread_id \in Range(prio_queue[p]) }) = 1

Get_Highest_Priority(prio_queue) ==
    LET
       Non_Empty_Queues == {p \in Valid_Thread_Priority_Type : prio_queue[p] /= <<>>}
    IN
       CHOOSE p1 \in Non_Empty_Queues :
          \A p2 \in Non_Empty_Queues \ {p1} : p2 < p1

Get_Highest_Priority_Queue(prio_queue) ==
      prio_queue[Get_Highest_Priority(prio_queue)]

(******************************************************************************
--algorithm hirtos_threads_model
   variables
      HiRTOS = HiRTOS_Initializer,
      Thread_Objects = [
         Idle_Thread |->
            Thread_Object_Initializer(0, "Invalid_Timer_Id", "Invalid_Condvar_Id"),
         thread1 |->
            Thread_Object_Initializer(1, "thread1_timer", "thread1_condvar"),
         thread2 |->
            Thread_Object_Initializer(2, "thread2_timer", "thread2_condvar"),
         thread3 |->
            Thread_Object_Initializer(2, "thread3_timer", "thread3_condvar")
      ],
      Mutex_Objects = [ m \in Mutexes |-> Mutex_Object_Initializer ],
      Condvar_Objects = [ cv \in Condvars |-> Condvar_Object_Initializer ],
      Timer_Objects = [ tm \in Timers |-> Timer_Object_Initializer ],
      Global_Resource_Available = FALSE;

   define
      Enqueue_Thread(priority_queue, thread_id) ==
         LET
            priority == Thread_Objects[thread_id].Current_Priority
         IN
            [ priority_queue EXCEPT ![priority] = Append(@, thread_id) ]

      Enqueue_Thread_As_Head(priority_queue, thread_id) ==
         LET
            priority == Thread_Objects[thread_id].Current_Priority
         IN
            [ priority_queue EXCEPT ![priority] = <<thread_id>> \o @ ]

      Priority_Queue_Head(priority_queue) ==
        Head(Get_Highest_Priority_Queue(priority_queue))

      Priority_Queue_Tail(priority_queue) == [
            priority_queue EXCEPT ![Get_Highest_Priority(priority_queue)] = Tail(@)
      ]

   end define;

   \*=================================================================
   \* Macros
   \*=================================================================

   macro Move_Thread_To_Another_Queue(priority_queue, thread_id, old_prio, new_prio)
   begin
      assert new_prio /= old_prio;
       \* Remove thread from its current queue:
      priority_queue[old_prio] := SelectSeq(priority_queue[old_prio], LAMBDA x : x /= thread_id) ||
       \* Enqueue thread to new queue:
      priority_queue[new_prio] := Append(priority_queue[new_prio], thread_id) ||
      Thread_Objects[thread_id].Current_Priority := new_prio;
   end macro;

    macro Enter_Critical_Section(context_id)
    begin
      await HiRTOS.Interrupts_Enabled /\
            (context_id \in Threads =>
                Thread_Objects[context_id].State = "Running");
      HiRTOS.Interrupts_Enabled := FALSE;
    end macro;

    macro Exit_Critical_Section()
    begin
      HiRTOS.Interrupts_Enabled := TRUE;
    end macro;

   \*=================================================================
   \* Procedures
   \*=================================================================

   procedure Run_Thread_Scheduler()
   begin
      check_time_slice_step:
      assert ~HiRTOS.Interrupts_Enabled;
      if HiRTOS.Current_Thread_Id /= "Invalid_Thread_Id" then
         Thread_Objects[HiRTOS.Current_Thread_Id].State := "Runnable";
         if Thread_Objects[HiRTOS.Current_Thread_Id].ghost_Time_Slice_Consumed then
            HiRTOS.Runnable_Threads_Queue :=
                Enqueue_Thread(HiRTOS.Runnable_Threads_Queue, HiRTOS.Current_Thread_Id) ||
            HiRTOS.Current_Thread_Id := "Invalid_Thread_Id";
         else
            HiRTOS.Runnable_Threads_Queue :=
                Enqueue_Thread_As_Head(HiRTOS.Runnable_Threads_Queue,
                                       HiRTOS.Current_Thread_Id) ||
            HiRTOS.Current_Thread_Id := "Invalid_Thread_Id";
         end if;
      end if;

      choose_next_thread_step:
      HiRTOS.Current_Thread_Id := Priority_Queue_Head(HiRTOS.Runnable_Threads_Queue) ||
      HiRTOS.Runnable_Threads_Queue := Priority_Queue_Tail(HiRTOS.Runnable_Threads_Queue);
      assert HiRTOS.Current_Thread_Id /= "Invalid_Thread_Id";
      Thread_Objects[HiRTOS.Current_Thread_Id].ghost_Time_Slice_Consumed := FALSE ||
      Thread_Objects[HiRTOS.Current_Thread_Id].State := "Running";

      run_scheduler_return_step:
      return;
   end procedure;

   procedure Do_Acquire_Mutex(thread_id, mutex_id, waking_up_thread_after_condvar_wait)
      variable owner_thread_id = "Invalid_Thread_Id";
   begin
      acquire_mutex_step:
      assert ~HiRTOS.Interrupts_Enabled;
      if Mutex_Objects[mutex_id].Owner_Thread_Id = "Invalid_Thread_Id" then
         acquire_mutex_acquire_step:
         Mutex_Objects[mutex_id].Owner_Thread_Id := thread_id ||
         Thread_Objects[thread_id].Owned_Mutexes :=
             <<mutex_id>> \o Thread_Objects[thread_id].Owned_Mutexes;
         if waking_up_thread_after_condvar_wait then
            acquire_mutex_make_condvar_wait_awoken_thread_runnable_step:
            assert thread_id /= HiRTOS.Current_Thread_Id;
            assert Thread_Objects[thread_id].State = "Blocked_On_Condvar";
            assert thread_id \notin
                Range(HiRTOS.Runnable_Threads_Queue[Thread_Objects[thread_id].Current_Priority]);
            HiRTOS.Runnable_Threads_Queue :=
               Enqueue_Thread(HiRTOS.Runnable_Threads_Queue, thread_id) ||
            Thread_Objects[thread_id].State := "Runnable";
         else
            assert thread_id = HiRTOS.Current_Thread_Id;
            assert Thread_Objects[thread_id].State = "Running";
         end if;
      else
         acquire_mutex_wait_on_mutex_step:
         owner_thread_id := Mutex_Objects[mutex_id].Owner_Thread_Id;
         assert owner_thread_id /= thread_id;
         Mutex_Objects[mutex_id].Waiting_Threads_Queue :=
            Enqueue_Thread(Mutex_Objects[mutex_id].Waiting_Threads_Queue, thread_id);
         if waking_up_thread_after_condvar_wait then
            assert thread_id /= HiRTOS.Current_Thread_Id;
            assert Thread_Objects[thread_id].State = "Blocked_On_Condvar";
         else
            assert thread_id = HiRTOS.Current_Thread_Id;
            assert Thread_Objects[thread_id].State = "Running";
            HiRTOS.Current_Thread_Id := "Invalid_Thread_Id";
         end if;

         Thread_Objects[thread_id].State := "Blocked_On_Mutex" ||
         Thread_Objects[thread_id].Waiting_On_Mutex_Id := mutex_id;

         acquire_mutex_check_if_priority_inheritance_needed_step:
         if Thread_Objects[owner_thread_id].Current_Priority <
              Thread_Objects[thread_id].Current_Priority then
            acquire_mutex_priority_inheritance_step:
            Mutex_Objects[mutex_id].Last_Inherited_Priority :=
               Thread_Objects[thread_id].Current_Priority;
            if Thread_Objects[owner_thread_id].State = "Runnable" then
               acquire_mutex_priority_inheritance_if_mutex_owner_runnable_step:
               Move_Thread_To_Another_Queue(
                    HiRTOS.Runnable_Threads_Queue,
                    owner_thread_id,
                    Thread_Objects[owner_thread_id].Current_Priority,
                    Thread_Objects[thread_id].Current_Priority);
            elsif Thread_Objects[owner_thread_id].State = "Blocked_On_Mutex" then
               acquire_mutex_priority_inheritance_if_mutex_owner_blocked_on_mutex_step:
               Move_Thread_To_Another_Queue(
                  Mutex_Objects[Thread_Objects[owner_thread_id].Waiting_On_Mutex_Id].
                     Waiting_Threads_Queue,
                  owner_thread_id,
                  Thread_Objects[owner_thread_id].Current_Priority,
                  Thread_Objects[thread_id].Current_Priority);
            else
               assert Thread_Objects[owner_thread_id].State = "Blocked_On_Condvar";
               acquire_mutex_priority_inheritance_if_mutex_owner_blocked_on_condvar_step:
               Move_Thread_To_Another_Queue(
                  Mutex_Objects[Thread_Objects[owner_thread_id].Waiting_On_Condvar_Id].
                     Waiting_Threads_Queue,
                  owner_thread_id,
                  Thread_Objects[owner_thread_id].Current_Priority,
                  Thread_Objects[thread_id].Current_Priority);
            end if;

            acquire_mutex_priority_inheritance_update_prio_step:
            Thread_Objects[owner_thread_id].Current_Priority :=
               Thread_Objects[thread_id].Current_Priority;
         end if;

         acquire_mutex_check_if_synchronous_context_switch_needed_step:
         if ~waking_up_thread_after_condvar_wait then
            acquire_mutex_synchronous_context_switch_step:
            call Run_Thread_Scheduler();
         end if;
      end if;

      do_acquire_mutex_return_step:
      return;
   end procedure;

   procedure Acquire_Mutex(thread_id, mutex_id)
      variable owner_thread_id = "Invalid_Thread_Id";
   begin
      enter_critical_section_step:
      Enter_Critical_Section(thread_id);
      assert HiRTOS.Current_Thread_Id = thread_id;
      call Do_Acquire_Mutex(thread_id, mutex_id, FALSE);
      exit_critical_section_step:
      Exit_Critical_Section();
      acquire_mutex_return_step:
      return;
   end procedure;

   procedure Do_Release_Mutex(thread_id, mutex_id, doing_condvar_wait)
      variable awoken_thread_id = "Invalid_Thread_Id";
   begin
      release_mutex_step:
      assert ~HiRTOS.Interrupts_Enabled;
      assert Mutex_Objects[mutex_id].Owner_Thread_Id = thread_id;
      assert Thread_Objects[thread_id].Owned_Mutexes /= <<>>;
      assert Head(Thread_Objects[thread_id].Owned_Mutexes) = mutex_id;
      Thread_Objects[thread_id].Owned_Mutexes := Tail(Thread_Objects[thread_id].Owned_Mutexes);

      release_mutex_restore_priority_step:
      if Thread_Objects[thread_id].Owned_Mutexes /= <<>> /\ ~doing_condvar_wait then
         with prev_mutex_obj = Mutex_Objects[Head(Thread_Objects[thread_id].Owned_Mutexes)] do
            if prev_mutex_obj.Last_Inherited_Priority /= Invalid_Thread_Priority then
               Thread_Objects[thread_id].Current_Priority := prev_mutex_obj.Last_Inherited_Priority;
            end if;
         end with;
      else
         Thread_Objects[thread_id].Current_Priority := Thread_Objects[thread_id].Base_Priority;
      end if;

      release_mutex_check_if_mutex_waiters_step:
      if Is_Thread_Priority_Queue_Empty(Mutex_Objects[mutex_id].Waiting_Threads_Queue) then
         Mutex_Objects[mutex_id].Owner_Thread_Id := "Invalid_Thread_Id";
      else
         release_mutex_wakeup_mutex_waiter_step:
         awoken_thread_id :=
            Priority_Queue_Head(Mutex_Objects[mutex_id].Waiting_Threads_Queue);
         assert Thread_Objects[awoken_thread_id].Waiting_On_Mutex_Id = mutex_id;
         Mutex_Objects[mutex_id].Owner_Thread_Id := awoken_thread_id ||
         Mutex_Objects[mutex_id].Waiting_Threads_Queue :=
            Priority_Queue_Tail(Mutex_Objects[mutex_id].Waiting_Threads_Queue) ||
         HiRTOS.Runnable_Threads_Queue :=
            Enqueue_Thread(HiRTOS.Runnable_Threads_Queue, awoken_thread_id) ||
         Thread_Objects[awoken_thread_id].State := "Runnable" ||
         Thread_Objects[awoken_thread_id].Waiting_On_Mutex_Id := "Invalid_Mutex_Id" ||
         Thread_Objects[awoken_thread_id].Owned_Mutexes :=
            <<mutex_id>> \o Thread_Objects[awoken_thread_id].Owned_Mutexes;

         if ~doing_condvar_wait then
            release_mutex_synchronous_context_switch_step:
            call Run_Thread_Scheduler();
         end if;
      end if;

      do_release_mutex_return_step:
      return;
   end procedure;

procedure Release_Mutex(thread_id, mutex_id)
   begin
      enter_critical_section_step:
      Enter_Critical_Section(thread_id);
      assert HiRTOS.Current_Thread_Id = thread_id;
      call Do_Release_Mutex(thread_id, mutex_id, FALSE);
      exit_critical_section_step:
      Exit_Critical_Section();
      release_mutex_return_step:
      return;
   end procedure;

   procedure Do_Wait_On_Condvar(thread_id, condvar_id, mutex_id)
   begin
      wait_on_condvar_wait_step:
      assert ~HiRTOS.Interrupts_Enabled;
      Thread_Objects[thread_id].ghost_Condvar_Wait_Mutex_Id := mutex_id ||
      Condvar_Objects[condvar_id].Waiting_Threads_Queue :=
         Enqueue_Thread(Condvar_Objects[condvar_id].Waiting_Threads_Queue, thread_id) ||
      Thread_Objects[thread_id].State := "Blocked_On_Condvar" ||
      Thread_Objects[thread_id].Waiting_On_Condvar_Id := condvar_id;
      HiRTOS.Current_Thread_Id := "Invalid_Thread_Id";

      wait_on_condvar_release_mutex_step:
      if mutex_id /= "Invalid_Mutex_Id" then
         call Do_Release_Mutex(thread_id, mutex_id, TRUE);
      end if;

      wait_on_condvar_synchronous_context_switch_step:
      call Run_Thread_Scheduler();

      do_wait_on_condvar_return_step:
      return;
   end procedure;

   procedure Wait_On_Condvar(thread_id, condvar_id, mutex_id)
   begin
      enter_critical_section_step:
      Enter_Critical_Section(thread_id);
      call Do_Wait_On_Condvar(thread_id, condvar_id, mutex_id);
      exit_critical_section_step:
      Exit_Critical_Section();
      wait_on_condvar_return_step:
      return;
   end procedure;

   procedure Do_Signal_Condvar(condvar_id, do_context_switch)
      variables awoken_thread_id = "Invalid_Thread_Id",
                to_reacquire_mutex_id = "Invalid_Mutex_Id";
   begin
      signal_condvar_step:
      assert ~HiRTOS.Interrupts_Enabled;
      if ~Is_Thread_Priority_Queue_Empty(Condvar_Objects[condvar_id].Waiting_Threads_Queue)
      then
         signal_condvar_wakeup_waiter_step:
         awoken_thread_id :=
            Priority_Queue_Head(Condvar_Objects[condvar_id].Waiting_Threads_Queue);
        Condvar_Objects[condvar_id].Waiting_Threads_Queue :=
            Priority_Queue_Tail(Condvar_Objects[condvar_id].Waiting_Threads_Queue);
         assert awoken_thread_id /= HiRTOS.Current_Thread_Id;
         assert Thread_Objects[awoken_thread_id].Waiting_On_Condvar_Id = condvar_id;
         assert Thread_Objects[awoken_thread_id].Waiting_On_Mutex_Id = "Invalid_Mutex_Id";

         to_reacquire_mutex_id := Thread_Objects[awoken_thread_id].ghost_Condvar_Wait_Mutex_Id;
         Thread_Objects[awoken_thread_id].ghost_Condvar_Wait_Mutex_Id := "Invalid_Mutex_Id" ||
         Thread_Objects[awoken_thread_id].Waiting_On_Condvar_Id := "Invalid_Condvar_Id";

         signal_condvar_check_if_mutex_reacquire_needed_step:
         if to_reacquire_mutex_id /= "Invalid_Mutex_Id" then
            signal_condvar_reacquire_mutex_step:
            call Do_Acquire_Mutex(awoken_thread_id, to_reacquire_mutex_id, TRUE);
         else
            signal_condvar_awoken_thread_runnable_step:
            HiRTOS.Runnable_Threads_Queue :=
               Enqueue_Thread(HiRTOS.Runnable_Threads_Queue, awoken_thread_id) ||
            Thread_Objects[awoken_thread_id].State := "Runnable";
         end if;

         signal_condvar_check_if_sync_context_switch_needed_step:
         if do_context_switch then
            signal_condvar_synchronous_context_switch_step:
            call Run_Thread_Scheduler();
         end if;
      end if;

      do_condvar_signal_return_step:
      return;
   end procedure;

   procedure Signal_Condvar(context_id, condvar_id)
   begin
      enter_critical_section_step:
      Enter_Critical_Section(context_id);
      call Do_Signal_Condvar(condvar_id, TRUE);
      exit_critical_section_step:
      Exit_Critical_Section();
      condvar_signaled_step:
      return;
   end procedure;

   procedure Broadcast_Condvar(context_id, condvar_id)
      variable thread_was_awaken = FALSE;
   begin
      enter_critical_section_step:
      Enter_Critical_Section(context_id);

      broadcast_condvar_step:
      while ~Is_Thread_Priority_Queue_Empty(Condvar_Objects[condvar_id].Waiting_Threads_Queue)
      do
         broadcast_condvar_wakeup_waiter_step:
         call Do_Signal_Condvar(condvar_id, FALSE);
        broadcast_condvar_after_waking_up_one_waiter_step:
        thread_was_awaken := TRUE;
      end while;

      broadcast_condvar_check_if_sync_context_switch_needed_step:
      if context_id \in Threads /\ thread_was_awaken then
         broadcast_condvar_synchronous_context_switch_step:
         call Run_Thread_Scheduler();
      end if;

      exit_critical_section_step:
      Exit_Critical_Section();
      condvar_broadcasted_step:
      return;
   end procedure;

   procedure Delay_Until(thread_id)
   begin
      enter_critical_section_step:
      Enter_Critical_Section(thread_id);

      delay_until_step:
      Timer_Objects[Thread_Objects[thread_id].Builtin_Timer_Id].State := "Timer_Running";
      call Do_Wait_On_Condvar(thread_id, Thread_Objects[thread_id].Builtin_Condvar_Id,
                              "Invalid_Mutex_Id");

      exit_critical_section_step:
      Exit_Critical_Section();

      after_delay_until_step:
      return;
   end procedure;

   \*=================================================================
   \* Processes
   \*=================================================================

   fair process Thread_State_Machine \in Threads \ { "Idle_Thread" }
   begin
      thread_state_machine_next_state_loop:
      while TRUE do
         await Thread_Objects[self].State = "Running" /\ HiRTOS.Interrupts_Enabled;
         context_switch0:
         either
            acquire_mutex_step:
            call Acquire_Mutex(self, "mutex1");
            context_switch1:
            await Thread_Objects[self].State = "Running" /\ HiRTOS.Interrupts_Enabled;
            assert(Mutex_Objects["mutex1"].Owner_Thread_Id = self);

            either
                waiting_for_resource_step:
                while ~Global_Resource_Available do
                    call Wait_On_Condvar(self, "condvar1", "mutex1");
                    context_switch2:
                    await Thread_Objects[self].State = "Running" /\ HiRTOS.Interrupts_Enabled;
                    assert Mutex_Objects["mutex1"].Owner_Thread_Id = self;
                end while;

                Global_Resource_Available := FALSE;
            or
              skip;
            end either;

            release_mutex_step:
            call Release_Mutex(self, "mutex1");
         or
            Global_Resource_Available := TRUE;
            either
               call Signal_Condvar(self, "condvar1");
            or
               call Broadcast_Condvar(self, "condvar1");
            end either;
         or
            call Delay_Until(self)
          end either;

         thread_iteration_completed_step:
         skip;
      end while;
   end process;

   fair process Idle_Thread = "Idle_Thread"
   begin
      idle_thread_next_state_loop:
      while TRUE do
          await Thread_Objects["Idle_Thread"].State = "Running" /\ HiRTOS.Interrupts_Enabled;
      end while;
   end process;

   fair process Timer_Interrupt = "Timer_Interrupt"
      variable delayed_threads = {};
   begin
      timer_interrupt_next_state_loop:
      while TRUE do
         enter_critical_section_step:
         Enter_Critical_Section("Timer_Interrupt");

         track_time_slice:
         if HiRTOS.Current_Thread_Id /= "Invalid_Thread_Id" then
            assert ~Thread_Objects[HiRTOS.Current_Thread_Id].ghost_Time_Slice_Consumed;
            Thread_Objects[HiRTOS.Current_Thread_Id].ghost_Time_Slice_Consumed := TRUE;
         end if;

         delayed_threads :=
            { t \in Threads \ { "Idle_Thread" } :
              Timer_Objects[Thread_Objects[t].Builtin_Timer_Id].State = "Timer_Running" };

         wakeup_delay_until_waiters:
         while delayed_threads /= {} do
             with t \in delayed_threads do
                 delayed_threads := delayed_threads \ {t};
                 Timer_Objects[Thread_Objects[t].Builtin_Timer_Id].State := "Timer_Stopped";
                 call Do_Signal_Condvar(Thread_Objects[t].Builtin_Condvar_Id, FALSE);
             end with;
         end while;

         timer_interupt_asynchronous_context_switch_step:
         call Run_Thread_Scheduler();

         exit_critical_section_step:
         Exit_Critical_Section();
      end while;
   end process;

   fair process Other_Interrupt = "Other_Interrupt"
   begin
      other_interrupt_next_state_loop:
      while TRUE do
         enter_critical_section_step:
         Enter_Critical_Section("Other_Interrupt");

         other_interupt_asynchronous_context_switch_step:
         call Run_Thread_Scheduler();

         exit_critical_section_step:
         Exit_Critical_Section();
      end while;
   end process;

end algorithm;
******************************************************************************)
\* BEGIN TRANSLATION (chksum(pcal) = "ec6916c" /\ chksum(tla) = "5dd4fa09")
\* Label acquire_mutex_step of procedure Do_Acquire_Mutex at line 248 col 7 changed to acquire_mutex_step_
\* Label enter_critical_section_step of procedure Acquire_Mutex at line 200 col 7 changed to enter_critical_section_step_
\* Label exit_critical_section_step of procedure Acquire_Mutex at line 208 col 7 changed to exit_critical_section_step_
\* Label release_mutex_step of procedure Do_Release_Mutex at line 350 col 7 changed to release_mutex_step_
\* Label enter_critical_section_step of procedure Release_Mutex at line 200 col 7 changed to enter_critical_section_step_R
\* Label exit_critical_section_step of procedure Release_Mutex at line 208 col 7 changed to exit_critical_section_step_R
\* Label enter_critical_section_step of procedure Wait_On_Condvar at line 200 col 7 changed to enter_critical_section_step_W
\* Label exit_critical_section_step of procedure Wait_On_Condvar at line 208 col 7 changed to exit_critical_section_step_W
\* Label enter_critical_section_step of procedure Signal_Condvar at line 200 col 7 changed to enter_critical_section_step_S
\* Label exit_critical_section_step of procedure Signal_Condvar at line 208 col 7 changed to exit_critical_section_step_S
\* Label enter_critical_section_step of procedure Broadcast_Condvar at line 200 col 7 changed to enter_critical_section_step_B
\* Label exit_critical_section_step of procedure Broadcast_Condvar at line 208 col 7 changed to exit_critical_section_step_B
\* Label enter_critical_section_step of procedure Delay_Until at line 200 col 7 changed to enter_critical_section_step_D
\* Label exit_critical_section_step of procedure Delay_Until at line 208 col 7 changed to exit_critical_section_step_D
\* Label enter_critical_section_step of process Timer_Interrupt at line 200 col 7 changed to enter_critical_section_step_T
\* Label exit_critical_section_step of process Timer_Interrupt at line 208 col 7 changed to exit_critical_section_step_T
\* Procedure variable owner_thread_id of procedure Do_Acquire_Mutex at line 245 col 16 changed to owner_thread_id_
\* Procedure variable awoken_thread_id of procedure Do_Release_Mutex at line 347 col 16 changed to awoken_thread_id_
\* Parameter thread_id of procedure Do_Acquire_Mutex at line 244 col 31 changed to thread_id_
\* Parameter mutex_id of procedure Do_Acquire_Mutex at line 244 col 42 changed to mutex_id_
\* Parameter thread_id of procedure Acquire_Mutex at line 333 col 28 changed to thread_id_A
\* Parameter mutex_id of procedure Acquire_Mutex at line 333 col 39 changed to mutex_id_A
\* Parameter thread_id of procedure Do_Release_Mutex at line 346 col 31 changed to thread_id_D
\* Parameter mutex_id of procedure Do_Release_Mutex at line 346 col 42 changed to mutex_id_D
\* Parameter thread_id of procedure Release_Mutex at line 395 col 25 changed to thread_id_R
\* Parameter mutex_id of procedure Release_Mutex at line 395 col 36 changed to mutex_id_R
\* Parameter thread_id of procedure Do_Wait_On_Condvar at line 407 col 33 changed to thread_id_Do
\* Parameter condvar_id of procedure Do_Wait_On_Condvar at line 407 col 44 changed to condvar_id_
\* Parameter mutex_id of procedure Do_Wait_On_Condvar at line 407 col 56 changed to mutex_id_Do
\* Parameter thread_id of procedure Wait_On_Condvar at line 430 col 30 changed to thread_id_W
\* Parameter condvar_id of procedure Wait_On_Condvar at line 430 col 41 changed to condvar_id_W
\* Parameter condvar_id of procedure Do_Signal_Condvar at line 441 col 32 changed to condvar_id_D
\* Parameter context_id of procedure Signal_Condvar at line 484 col 29 changed to context_id_
\* Parameter condvar_id of procedure Signal_Condvar at line 484 col 41 changed to condvar_id_S
CONSTANT defaultInitValue
VARIABLES HiRTOS, Thread_Objects, Mutex_Objects, Condvar_Objects,
          Timer_Objects, Global_Resource_Available, pc, stack

(* define statement *)
Enqueue_Thread(priority_queue, thread_id) ==
   LET
      priority == Thread_Objects[thread_id].Current_Priority
   IN
      [ priority_queue EXCEPT ![priority] = Append(@, thread_id) ]

Enqueue_Thread_As_Head(priority_queue, thread_id) ==
   LET
      priority == Thread_Objects[thread_id].Current_Priority
   IN
      [ priority_queue EXCEPT ![priority] = <<thread_id>> \o @ ]

Priority_Queue_Head(priority_queue) ==
  Head(Get_Highest_Priority_Queue(priority_queue))

Priority_Queue_Tail(priority_queue) == [
      priority_queue EXCEPT ![Get_Highest_Priority(priority_queue)] = Tail(@)
]

VARIABLES thread_id_, mutex_id_, waking_up_thread_after_condvar_wait,
          owner_thread_id_, thread_id_A, mutex_id_A, owner_thread_id,
          thread_id_D, mutex_id_D, doing_condvar_wait, awoken_thread_id_,
          thread_id_R, mutex_id_R, thread_id_Do, condvar_id_, mutex_id_Do,
          thread_id_W, condvar_id_W, mutex_id, condvar_id_D,
          do_context_switch, awoken_thread_id, to_reacquire_mutex_id,
          context_id_, condvar_id_S, context_id, condvar_id,
          thread_was_awaken, thread_id, delayed_threads

vars == << HiRTOS, Thread_Objects, Mutex_Objects, Condvar_Objects,
           Timer_Objects, Global_Resource_Available, pc, stack, thread_id_,
           mutex_id_, waking_up_thread_after_condvar_wait, owner_thread_id_,
           thread_id_A, mutex_id_A, owner_thread_id, thread_id_D, mutex_id_D,
           doing_condvar_wait, awoken_thread_id_, thread_id_R, mutex_id_R,
           thread_id_Do, condvar_id_, mutex_id_Do, thread_id_W, condvar_id_W,
           mutex_id, condvar_id_D, do_context_switch, awoken_thread_id,
           to_reacquire_mutex_id, context_id_, condvar_id_S, context_id,
           condvar_id, thread_was_awaken, thread_id, delayed_threads >>

ProcSet == (Threads \ { "Idle_Thread" }) \cup {"Idle_Thread"} \cup {"Timer_Interrupt"} \cup {"Other_Interrupt"}

Init == (* Global variables *)
        /\ HiRTOS = HiRTOS_Initializer
        /\ Thread_Objects =                  [
                               Idle_Thread |->
                                  Thread_Object_Initializer(0, "Invalid_Timer_Id", "Invalid_Condvar_Id"),
                               thread1 |->
                                  Thread_Object_Initializer(1, "thread1_timer", "thread1_condvar"),
                               thread2 |->
                                  Thread_Object_Initializer(2, "thread2_timer", "thread2_condvar"),
                               thread3 |->
                                  Thread_Object_Initializer(2, "thread3_timer", "thread3_condvar")
                            ]
        /\ Mutex_Objects = [ m \in Mutexes |-> Mutex_Object_Initializer ]
        /\ Condvar_Objects = [ cv \in Condvars |-> Condvar_Object_Initializer ]
        /\ Timer_Objects = [ tm \in Timers |-> Timer_Object_Initializer ]
        /\ Global_Resource_Available = FALSE
        (* Procedure Do_Acquire_Mutex *)
        /\ thread_id_ = [ self \in ProcSet |-> defaultInitValue]
        /\ mutex_id_ = [ self \in ProcSet |-> defaultInitValue]
        /\ waking_up_thread_after_condvar_wait = [ self \in ProcSet |-> defaultInitValue]
        /\ owner_thread_id_ = [ self \in ProcSet |-> "Invalid_Thread_Id"]
        (* Procedure Acquire_Mutex *)
        /\ thread_id_A = [ self \in ProcSet |-> defaultInitValue]
        /\ mutex_id_A = [ self \in ProcSet |-> defaultInitValue]
        /\ owner_thread_id = [ self \in ProcSet |-> "Invalid_Thread_Id"]
        (* Procedure Do_Release_Mutex *)
        /\ thread_id_D = [ self \in ProcSet |-> defaultInitValue]
        /\ mutex_id_D = [ self \in ProcSet |-> defaultInitValue]
        /\ doing_condvar_wait = [ self \in ProcSet |-> defaultInitValue]
        /\ awoken_thread_id_ = [ self \in ProcSet |-> "Invalid_Thread_Id"]
        (* Procedure Release_Mutex *)
        /\ thread_id_R = [ self \in ProcSet |-> defaultInitValue]
        /\ mutex_id_R = [ self \in ProcSet |-> defaultInitValue]
        (* Procedure Do_Wait_On_Condvar *)
        /\ thread_id_Do = [ self \in ProcSet |-> defaultInitValue]
        /\ condvar_id_ = [ self \in ProcSet |-> defaultInitValue]
        /\ mutex_id_Do = [ self \in ProcSet |-> defaultInitValue]
        (* Procedure Wait_On_Condvar *)
        /\ thread_id_W = [ self \in ProcSet |-> defaultInitValue]
        /\ condvar_id_W = [ self \in ProcSet |-> defaultInitValue]
        /\ mutex_id = [ self \in ProcSet |-> defaultInitValue]
        (* Procedure Do_Signal_Condvar *)
        /\ condvar_id_D = [ self \in ProcSet |-> defaultInitValue]
        /\ do_context_switch = [ self \in ProcSet |-> defaultInitValue]
        /\ awoken_thread_id = [ self \in ProcSet |-> "Invalid_Thread_Id"]
        /\ to_reacquire_mutex_id = [ self \in ProcSet |-> "Invalid_Mutex_Id"]
        (* Procedure Signal_Condvar *)
        /\ context_id_ = [ self \in ProcSet |-> defaultInitValue]
        /\ condvar_id_S = [ self \in ProcSet |-> defaultInitValue]
        (* Procedure Broadcast_Condvar *)
        /\ context_id = [ self \in ProcSet |-> defaultInitValue]
        /\ condvar_id = [ self \in ProcSet |-> defaultInitValue]
        /\ thread_was_awaken = [ self \in ProcSet |-> FALSE]
        (* Procedure Delay_Until *)
        /\ thread_id = [ self \in ProcSet |-> defaultInitValue]
        (* Process Timer_Interrupt *)
        /\ delayed_threads = {}
        /\ stack = [self \in ProcSet |-> << >>]
        /\ pc = [self \in ProcSet |-> CASE self \in Threads \ { "Idle_Thread" } -> "thread_state_machine_next_state_loop"
                                        [] self = "Idle_Thread" -> "idle_thread_next_state_loop"
                                        [] self = "Timer_Interrupt" -> "timer_interrupt_next_state_loop"
                                        [] self = "Other_Interrupt" -> "other_interrupt_next_state_loop"]

check_time_slice_step(self) == /\ pc[self] = "check_time_slice_step"
                               /\ Assert(~HiRTOS.Interrupts_Enabled,
                                         "Failure of assertion at line 218, column 7.")
                               /\ IF HiRTOS.Current_Thread_Id /= "Invalid_Thread_Id"
                                     THEN /\ Thread_Objects' = [Thread_Objects EXCEPT ![HiRTOS.Current_Thread_Id].State = "Runnable"]
                                          /\ IF Thread_Objects'[HiRTOS.Current_Thread_Id].ghost_Time_Slice_Consumed
                                                THEN /\ HiRTOS' = [HiRTOS EXCEPT !.Runnable_Threads_Queue = Enqueue_Thread(HiRTOS.Runnable_Threads_Queue, HiRTOS.Current_Thread_Id),
                                                                                 !.Current_Thread_Id = "Invalid_Thread_Id"]
                                                ELSE /\ HiRTOS' = [HiRTOS EXCEPT !.Runnable_Threads_Queue = Enqueue_Thread_As_Head(HiRTOS.Runnable_Threads_Queue,
                                                                                                                                   HiRTOS.Current_Thread_Id),
                                                                                 !.Current_Thread_Id = "Invalid_Thread_Id"]
                                     ELSE /\ TRUE
                                          /\ UNCHANGED << HiRTOS,
                                                          Thread_Objects >>
                               /\ pc' = [pc EXCEPT ![self] = "choose_next_thread_step"]
                               /\ UNCHANGED << Mutex_Objects, Condvar_Objects,
                                               Timer_Objects,
                                               Global_Resource_Available,
                                               stack, thread_id_, mutex_id_,
                                               waking_up_thread_after_condvar_wait,
                                               owner_thread_id_, thread_id_A,
                                               mutex_id_A, owner_thread_id,
                                               thread_id_D, mutex_id_D,
                                               doing_condvar_wait,
                                               awoken_thread_id_, thread_id_R,
                                               mutex_id_R, thread_id_Do,
                                               condvar_id_, mutex_id_Do,
                                               thread_id_W, condvar_id_W,
                                               mutex_id, condvar_id_D,
                                               do_context_switch,
                                               awoken_thread_id,
                                               to_reacquire_mutex_id,
                                               context_id_, condvar_id_S,
                                               context_id, condvar_id,
                                               thread_was_awaken, thread_id,
                                               delayed_threads >>

choose_next_thread_step(self) == /\ pc[self] = "choose_next_thread_step"
                                 /\ HiRTOS' = [HiRTOS EXCEPT !.Current_Thread_Id = Priority_Queue_Head(HiRTOS.Runnable_Threads_Queue),
                                                             !.Runnable_Threads_Queue = Priority_Queue_Tail(HiRTOS.Runnable_Threads_Queue)]
                                 /\ Assert(HiRTOS'.Current_Thread_Id /= "Invalid_Thread_Id",
                                           "Failure of assertion at line 236, column 7.")
                                 /\ Thread_Objects' = [Thread_Objects EXCEPT ![HiRTOS'.Current_Thread_Id].ghost_Time_Slice_Consumed = FALSE,
                                                                             ![HiRTOS'.Current_Thread_Id].State = "Running"]
                                 /\ pc' = [pc EXCEPT ![self] = "run_scheduler_return_step"]
                                 /\ UNCHANGED << Mutex_Objects,
                                                 Condvar_Objects,
                                                 Timer_Objects,
                                                 Global_Resource_Available,
                                                 stack, thread_id_, mutex_id_,
                                                 waking_up_thread_after_condvar_wait,
                                                 owner_thread_id_, thread_id_A,
                                                 mutex_id_A, owner_thread_id,
                                                 thread_id_D, mutex_id_D,
                                                 doing_condvar_wait,
                                                 awoken_thread_id_,
                                                 thread_id_R, mutex_id_R,
                                                 thread_id_Do, condvar_id_,
                                                 mutex_id_Do, thread_id_W,
                                                 condvar_id_W, mutex_id,
                                                 condvar_id_D,
                                                 do_context_switch,
                                                 awoken_thread_id,
                                                 to_reacquire_mutex_id,
                                                 context_id_, condvar_id_S,
                                                 context_id, condvar_id,
                                                 thread_was_awaken, thread_id,
                                                 delayed_threads >>

run_scheduler_return_step(self) == /\ pc[self] = "run_scheduler_return_step"
                                   /\ pc' = [pc EXCEPT ![self] = Head(stack[self]).pc]
                                   /\ stack' = [stack EXCEPT ![self] = Tail(stack[self])]
                                   /\ UNCHANGED << HiRTOS, Thread_Objects,
                                                   Mutex_Objects,
                                                   Condvar_Objects,
                                                   Timer_Objects,
                                                   Global_Resource_Available,
                                                   thread_id_, mutex_id_,
                                                   waking_up_thread_after_condvar_wait,
                                                   owner_thread_id_,
                                                   thread_id_A, mutex_id_A,
                                                   owner_thread_id,
                                                   thread_id_D, mutex_id_D,
                                                   doing_condvar_wait,
                                                   awoken_thread_id_,
                                                   thread_id_R, mutex_id_R,
                                                   thread_id_Do, condvar_id_,
                                                   mutex_id_Do, thread_id_W,
                                                   condvar_id_W, mutex_id,
                                                   condvar_id_D,
                                                   do_context_switch,
                                                   awoken_thread_id,
                                                   to_reacquire_mutex_id,
                                                   context_id_, condvar_id_S,
                                                   context_id, condvar_id,
                                                   thread_was_awaken,
                                                   thread_id, delayed_threads >>

Run_Thread_Scheduler(self) == check_time_slice_step(self)
                                 \/ choose_next_thread_step(self)
                                 \/ run_scheduler_return_step(self)

acquire_mutex_step_(self) == /\ pc[self] = "acquire_mutex_step_"
                             /\ Assert(~HiRTOS.Interrupts_Enabled,
                                       "Failure of assertion at line 248, column 7.")
                             /\ IF Mutex_Objects[mutex_id_[self]].Owner_Thread_Id = "Invalid_Thread_Id"
                                   THEN /\ pc' = [pc EXCEPT ![self] = "acquire_mutex_acquire_step"]
                                   ELSE /\ pc' = [pc EXCEPT ![self] = "acquire_mutex_wait_on_mutex_step"]
                             /\ UNCHANGED << HiRTOS, Thread_Objects,
                                             Mutex_Objects, Condvar_Objects,
                                             Timer_Objects,
                                             Global_Resource_Available, stack,
                                             thread_id_, mutex_id_,
                                             waking_up_thread_after_condvar_wait,
                                             owner_thread_id_, thread_id_A,
                                             mutex_id_A, owner_thread_id,
                                             thread_id_D, mutex_id_D,
                                             doing_condvar_wait,
                                             awoken_thread_id_, thread_id_R,
                                             mutex_id_R, thread_id_Do,
                                             condvar_id_, mutex_id_Do,
                                             thread_id_W, condvar_id_W,
                                             mutex_id, condvar_id_D,
                                             do_context_switch,
                                             awoken_thread_id,
                                             to_reacquire_mutex_id,
                                             context_id_, condvar_id_S,
                                             context_id, condvar_id,
                                             thread_was_awaken, thread_id,
                                             delayed_threads >>

acquire_mutex_acquire_step(self) == /\ pc[self] = "acquire_mutex_acquire_step"
                                    /\ /\ Mutex_Objects' = [Mutex_Objects EXCEPT ![mutex_id_[self]].Owner_Thread_Id = thread_id_[self]]
                                       /\ Thread_Objects' = [Thread_Objects EXCEPT ![thread_id_[self]].Owned_Mutexes = <<mutex_id_[self]>> \o Thread_Objects[thread_id_[self]].Owned_Mutexes]
                                    /\ IF waking_up_thread_after_condvar_wait[self]
                                          THEN /\ pc' = [pc EXCEPT ![self] = "acquire_mutex_make_condvar_wait_awoken_thread_runnable_step"]
                                          ELSE /\ Assert(thread_id_[self] = HiRTOS.Current_Thread_Id,
                                                         "Failure of assertion at line 264, column 13.")
                                               /\ Assert(Thread_Objects'[thread_id_[self]].State = "Running",
                                                         "Failure of assertion at line 265, column 13.")
                                               /\ pc' = [pc EXCEPT ![self] = "do_acquire_mutex_return_step"]
                                    /\ UNCHANGED << HiRTOS, Condvar_Objects,
                                                    Timer_Objects,
                                                    Global_Resource_Available,
                                                    stack, thread_id_,
                                                    mutex_id_,
                                                    waking_up_thread_after_condvar_wait,
                                                    owner_thread_id_,
                                                    thread_id_A, mutex_id_A,
                                                    owner_thread_id,
                                                    thread_id_D, mutex_id_D,
                                                    doing_condvar_wait,
                                                    awoken_thread_id_,
                                                    thread_id_R, mutex_id_R,
                                                    thread_id_Do, condvar_id_,
                                                    mutex_id_Do, thread_id_W,
                                                    condvar_id_W, mutex_id,
                                                    condvar_id_D,
                                                    do_context_switch,
                                                    awoken_thread_id,
                                                    to_reacquire_mutex_id,
                                                    context_id_, condvar_id_S,
                                                    context_id, condvar_id,
                                                    thread_was_awaken,
                                                    thread_id, delayed_threads >>

acquire_mutex_make_condvar_wait_awoken_thread_runnable_step(self) == /\ pc[self] = "acquire_mutex_make_condvar_wait_awoken_thread_runnable_step"
                                                                     /\ Assert(thread_id_[self] /= HiRTOS.Current_Thread_Id,
                                                                               "Failure of assertion at line 256, column 13.")
                                                                     /\ Assert(Thread_Objects[thread_id_[self]].State = "Blocked_On_Condvar",
                                                                               "Failure of assertion at line 257, column 13.")
                                                                     /\ Assert(   thread_id_[self] \notin
                                                                               Range(HiRTOS.Runnable_Threads_Queue[Thread_Objects[thread_id_[self]].Current_Priority]),
                                                                               "Failure of assertion at line 258, column 13.")
                                                                     /\ /\ HiRTOS' = [HiRTOS EXCEPT !.Runnable_Threads_Queue = Enqueue_Thread(HiRTOS.Runnable_Threads_Queue, thread_id_[self])]
                                                                        /\ Thread_Objects' = [Thread_Objects EXCEPT ![thread_id_[self]].State = "Runnable"]
                                                                     /\ pc' = [pc EXCEPT ![self] = "do_acquire_mutex_return_step"]
                                                                     /\ UNCHANGED << Mutex_Objects,
                                                                                     Condvar_Objects,
                                                                                     Timer_Objects,
                                                                                     Global_Resource_Available,
                                                                                     stack,
                                                                                     thread_id_,
                                                                                     mutex_id_,
                                                                                     waking_up_thread_after_condvar_wait,
                                                                                     owner_thread_id_,
                                                                                     thread_id_A,
                                                                                     mutex_id_A,
                                                                                     owner_thread_id,
                                                                                     thread_id_D,
                                                                                     mutex_id_D,
                                                                                     doing_condvar_wait,
                                                                                     awoken_thread_id_,
                                                                                     thread_id_R,
                                                                                     mutex_id_R,
                                                                                     thread_id_Do,
                                                                                     condvar_id_,
                                                                                     mutex_id_Do,
                                                                                     thread_id_W,
                                                                                     condvar_id_W,
                                                                                     mutex_id,
                                                                                     condvar_id_D,
                                                                                     do_context_switch,
                                                                                     awoken_thread_id,
                                                                                     to_reacquire_mutex_id,
                                                                                     context_id_,
                                                                                     condvar_id_S,
                                                                                     context_id,
                                                                                     condvar_id,
                                                                                     thread_was_awaken,
                                                                                     thread_id,
                                                                                     delayed_threads >>

acquire_mutex_wait_on_mutex_step(self) == /\ pc[self] = "acquire_mutex_wait_on_mutex_step"
                                          /\ owner_thread_id_' = [owner_thread_id_ EXCEPT ![self] = Mutex_Objects[mutex_id_[self]].Owner_Thread_Id]
                                          /\ Assert(owner_thread_id_'[self] /= thread_id_[self],
                                                    "Failure of assertion at line 270, column 10.")
                                          /\ Mutex_Objects' = [Mutex_Objects EXCEPT ![mutex_id_[self]].Waiting_Threads_Queue = Enqueue_Thread(Mutex_Objects[mutex_id_[self]].Waiting_Threads_Queue, thread_id_[self])]
                                          /\ IF waking_up_thread_after_condvar_wait[self]
                                                THEN /\ Assert(thread_id_[self] /= HiRTOS.Current_Thread_Id,
                                                               "Failure of assertion at line 274, column 13.")
                                                     /\ Assert(Thread_Objects[thread_id_[self]].State = "Blocked_On_Condvar",
                                                               "Failure of assertion at line 275, column 13.")
                                                     /\ UNCHANGED HiRTOS
                                                ELSE /\ Assert(thread_id_[self] = HiRTOS.Current_Thread_Id,
                                                               "Failure of assertion at line 277, column 13.")
                                                     /\ Assert(Thread_Objects[thread_id_[self]].State = "Running",
                                                               "Failure of assertion at line 278, column 13.")
                                                     /\ HiRTOS' = [HiRTOS EXCEPT !.Current_Thread_Id = "Invalid_Thread_Id"]
                                          /\ Thread_Objects' = [Thread_Objects EXCEPT ![thread_id_[self]].State = "Blocked_On_Mutex",
                                                                                      ![thread_id_[self]].Waiting_On_Mutex_Id = mutex_id_[self]]
                                          /\ pc' = [pc EXCEPT ![self] = "acquire_mutex_check_if_priority_inheritance_needed_step"]
                                          /\ UNCHANGED << Condvar_Objects,
                                                          Timer_Objects,
                                                          Global_Resource_Available,
                                                          stack, thread_id_,
                                                          mutex_id_,
                                                          waking_up_thread_after_condvar_wait,
                                                          thread_id_A,
                                                          mutex_id_A,
                                                          owner_thread_id,
                                                          thread_id_D,
                                                          mutex_id_D,
                                                          doing_condvar_wait,
                                                          awoken_thread_id_,
                                                          thread_id_R,
                                                          mutex_id_R,
                                                          thread_id_Do,
                                                          condvar_id_,
                                                          mutex_id_Do,
                                                          thread_id_W,
                                                          condvar_id_W,
                                                          mutex_id,
                                                          condvar_id_D,
                                                          do_context_switch,
                                                          awoken_thread_id,
                                                          to_reacquire_mutex_id,
                                                          context_id_,
                                                          condvar_id_S,
                                                          context_id,
                                                          condvar_id,
                                                          thread_was_awaken,
                                                          thread_id,
                                                          delayed_threads >>

acquire_mutex_check_if_priority_inheritance_needed_step(self) == /\ pc[self] = "acquire_mutex_check_if_priority_inheritance_needed_step"
                                                                 /\ IF Thread_Objects[owner_thread_id_[self]].Current_Priority <
                                                                         Thread_Objects[thread_id_[self]].Current_Priority
                                                                       THEN /\ pc' = [pc EXCEPT ![self] = "acquire_mutex_priority_inheritance_step"]
                                                                       ELSE /\ pc' = [pc EXCEPT ![self] = "acquire_mutex_check_if_synchronous_context_switch_needed_step"]
                                                                 /\ UNCHANGED << HiRTOS,
                                                                                 Thread_Objects,
                                                                                 Mutex_Objects,
                                                                                 Condvar_Objects,
                                                                                 Timer_Objects,
                                                                                 Global_Resource_Available,
                                                                                 stack,
                                                                                 thread_id_,
                                                                                 mutex_id_,
                                                                                 waking_up_thread_after_condvar_wait,
                                                                                 owner_thread_id_,
                                                                                 thread_id_A,
                                                                                 mutex_id_A,
                                                                                 owner_thread_id,
                                                                                 thread_id_D,
                                                                                 mutex_id_D,
                                                                                 doing_condvar_wait,
                                                                                 awoken_thread_id_,
                                                                                 thread_id_R,
                                                                                 mutex_id_R,
                                                                                 thread_id_Do,
                                                                                 condvar_id_,
                                                                                 mutex_id_Do,
                                                                                 thread_id_W,
                                                                                 condvar_id_W,
                                                                                 mutex_id,
                                                                                 condvar_id_D,
                                                                                 do_context_switch,
                                                                                 awoken_thread_id,
                                                                                 to_reacquire_mutex_id,
                                                                                 context_id_,
                                                                                 condvar_id_S,
                                                                                 context_id,
                                                                                 condvar_id,
                                                                                 thread_was_awaken,
                                                                                 thread_id,
                                                                                 delayed_threads >>

acquire_mutex_priority_inheritance_step(self) == /\ pc[self] = "acquire_mutex_priority_inheritance_step"
                                                 /\ Mutex_Objects' = [Mutex_Objects EXCEPT ![mutex_id_[self]].Last_Inherited_Priority = Thread_Objects[thread_id_[self]].Current_Priority]
                                                 /\ IF Thread_Objects[owner_thread_id_[self]].State = "Runnable"
                                                       THEN /\ pc' = [pc EXCEPT ![self] = "acquire_mutex_priority_inheritance_if_mutex_owner_runnable_step"]
                                                       ELSE /\ IF Thread_Objects[owner_thread_id_[self]].State = "Blocked_On_Mutex"
                                                                  THEN /\ pc' = [pc EXCEPT ![self] = "acquire_mutex_priority_inheritance_if_mutex_owner_blocked_on_mutex_step"]
                                                                  ELSE /\ Assert(Thread_Objects[owner_thread_id_[self]].State = "Blocked_On_Condvar",
                                                                                 "Failure of assertion at line 307, column 16.")
                                                                       /\ pc' = [pc EXCEPT ![self] = "acquire_mutex_priority_inheritance_if_mutex_owner_blocked_on_condvar_step"]
                                                 /\ UNCHANGED << HiRTOS,
                                                                 Thread_Objects,
                                                                 Condvar_Objects,
                                                                 Timer_Objects,
                                                                 Global_Resource_Available,
                                                                 stack,
                                                                 thread_id_,
                                                                 mutex_id_,
                                                                 waking_up_thread_after_condvar_wait,
                                                                 owner_thread_id_,
                                                                 thread_id_A,
                                                                 mutex_id_A,
                                                                 owner_thread_id,
                                                                 thread_id_D,
                                                                 mutex_id_D,
                                                                 doing_condvar_wait,
                                                                 awoken_thread_id_,
                                                                 thread_id_R,
                                                                 mutex_id_R,
                                                                 thread_id_Do,
                                                                 condvar_id_,
                                                                 mutex_id_Do,
                                                                 thread_id_W,
                                                                 condvar_id_W,
                                                                 mutex_id,
                                                                 condvar_id_D,
                                                                 do_context_switch,
                                                                 awoken_thread_id,
                                                                 to_reacquire_mutex_id,
                                                                 context_id_,
                                                                 condvar_id_S,
                                                                 context_id,
                                                                 condvar_id,
                                                                 thread_was_awaken,
                                                                 thread_id,
                                                                 delayed_threads >>

acquire_mutex_priority_inheritance_if_mutex_owner_runnable_step(self) == /\ pc[self] = "acquire_mutex_priority_inheritance_if_mutex_owner_runnable_step"
                                                                         /\ Assert((Thread_Objects[thread_id_[self]].Current_Priority) /= (Thread_Objects[owner_thread_id_[self]].Current_Priority),
                                                                                   "Failure of assertion at line 190, column 7 of macro called at line 293, column 16.")
                                                                         /\ /\ HiRTOS' = [HiRTOS EXCEPT !.Runnable_Threads_Queue[(Thread_Objects[owner_thread_id_[self]].Current_Priority)] = SelectSeq((HiRTOS.Runnable_Threads_Queue)[(Thread_Objects[owner_thread_id_[self]].Current_Priority)], LAMBDA x : x /= owner_thread_id_[self]),
                                                                                                        !.Runnable_Threads_Queue[(Thread_Objects[thread_id_[self]].Current_Priority)] = Append((HiRTOS.Runnable_Threads_Queue)[(Thread_Objects[thread_id_[self]].Current_Priority)], owner_thread_id_[self])]
                                                                            /\ Thread_Objects' = [Thread_Objects EXCEPT ![owner_thread_id_[self]].Current_Priority = Thread_Objects[thread_id_[self]].Current_Priority]
                                                                         /\ pc' = [pc EXCEPT ![self] = "acquire_mutex_priority_inheritance_update_prio_step"]
                                                                         /\ UNCHANGED << Mutex_Objects,
                                                                                         Condvar_Objects,
                                                                                         Timer_Objects,
                                                                                         Global_Resource_Available,
                                                                                         stack,
                                                                                         thread_id_,
                                                                                         mutex_id_,
                                                                                         waking_up_thread_after_condvar_wait,
                                                                                         owner_thread_id_,
                                                                                         thread_id_A,
                                                                                         mutex_id_A,
                                                                                         owner_thread_id,
                                                                                         thread_id_D,
                                                                                         mutex_id_D,
                                                                                         doing_condvar_wait,
                                                                                         awoken_thread_id_,
                                                                                         thread_id_R,
                                                                                         mutex_id_R,
                                                                                         thread_id_Do,
                                                                                         condvar_id_,
                                                                                         mutex_id_Do,
                                                                                         thread_id_W,
                                                                                         condvar_id_W,
                                                                                         mutex_id,
                                                                                         condvar_id_D,
                                                                                         do_context_switch,
                                                                                         awoken_thread_id,
                                                                                         to_reacquire_mutex_id,
                                                                                         context_id_,
                                                                                         condvar_id_S,
                                                                                         context_id,
                                                                                         condvar_id,
                                                                                         thread_was_awaken,
                                                                                         thread_id,
                                                                                         delayed_threads >>

acquire_mutex_priority_inheritance_if_mutex_owner_blocked_on_mutex_step(self) == /\ pc[self] = "acquire_mutex_priority_inheritance_if_mutex_owner_blocked_on_mutex_step"
                                                                                 /\ Assert((Thread_Objects[thread_id_[self]].Current_Priority) /= (Thread_Objects[owner_thread_id_[self]].Current_Priority),
                                                                                           "Failure of assertion at line 190, column 7 of macro called at line 300, column 16.")
                                                                                 /\ /\ Mutex_Objects' = [Mutex_Objects EXCEPT !          [Thread_Objects[owner_thread_id_[self]].Waiting_On_Mutex_Id].
                                                                                                                               Waiting_Threads_Queue[(Thread_Objects[owner_thread_id_[self]].Current_Priority)] = SelectSeq((Mutex_Objects[Thread_Objects[owner_thread_id_[self]].Waiting_On_Mutex_Id].
                                                                                                                                                                                                                                Waiting_Threads_Queue)[(Thread_Objects[owner_thread_id_[self]].Current_Priority)], LAMBDA x : x /= owner_thread_id_[self]),
                                                                                                                              !          [Thread_Objects[owner_thread_id_[self]].Waiting_On_Mutex_Id].
                                                                                                                               Waiting_Threads_Queue[(Thread_Objects[thread_id_[self]].Current_Priority)] = Append((Mutex_Objects[Thread_Objects[owner_thread_id_[self]].Waiting_On_Mutex_Id].
                                                                                                                                                                                                                       Waiting_Threads_Queue)[(Thread_Objects[thread_id_[self]].Current_Priority)], owner_thread_id_[self])]
                                                                                    /\ Thread_Objects' = [Thread_Objects EXCEPT ![owner_thread_id_[self]].Current_Priority = Thread_Objects[thread_id_[self]].Current_Priority]
                                                                                 /\ pc' = [pc EXCEPT ![self] = "acquire_mutex_priority_inheritance_update_prio_step"]
                                                                                 /\ UNCHANGED << HiRTOS,
                                                                                                 Condvar_Objects,
                                                                                                 Timer_Objects,
                                                                                                 Global_Resource_Available,
                                                                                                 stack,
                                                                                                 thread_id_,
                                                                                                 mutex_id_,
                                                                                                 waking_up_thread_after_condvar_wait,
                                                                                                 owner_thread_id_,
                                                                                                 thread_id_A,
                                                                                                 mutex_id_A,
                                                                                                 owner_thread_id,
                                                                                                 thread_id_D,
                                                                                                 mutex_id_D,
                                                                                                 doing_condvar_wait,
                                                                                                 awoken_thread_id_,
                                                                                                 thread_id_R,
                                                                                                 mutex_id_R,
                                                                                                 thread_id_Do,
                                                                                                 condvar_id_,
                                                                                                 mutex_id_Do,
                                                                                                 thread_id_W,
                                                                                                 condvar_id_W,
                                                                                                 mutex_id,
                                                                                                 condvar_id_D,
                                                                                                 do_context_switch,
                                                                                                 awoken_thread_id,
                                                                                                 to_reacquire_mutex_id,
                                                                                                 context_id_,
                                                                                                 condvar_id_S,
                                                                                                 context_id,
                                                                                                 condvar_id,
                                                                                                 thread_was_awaken,
                                                                                                 thread_id,
                                                                                                 delayed_threads >>

acquire_mutex_priority_inheritance_if_mutex_owner_blocked_on_condvar_step(self) == /\ pc[self] = "acquire_mutex_priority_inheritance_if_mutex_owner_blocked_on_condvar_step"
                                                                                   /\ Assert((Thread_Objects[thread_id_[self]].Current_Priority) /= (Thread_Objects[owner_thread_id_[self]].Current_Priority),
                                                                                             "Failure of assertion at line 190, column 7 of macro called at line 309, column 16.")
                                                                                   /\ /\ Mutex_Objects' = [Mutex_Objects EXCEPT !          [Thread_Objects[owner_thread_id_[self]].Waiting_On_Condvar_Id].
                                                                                                                                 Waiting_Threads_Queue[(Thread_Objects[owner_thread_id_[self]].Current_Priority)] = SelectSeq((Mutex_Objects[Thread_Objects[owner_thread_id_[self]].Waiting_On_Condvar_Id].
                                                                                                                                                                                                                                  Waiting_Threads_Queue)[(Thread_Objects[owner_thread_id_[self]].Current_Priority)], LAMBDA x : x /= owner_thread_id_[self]),
                                                                                                                                !          [Thread_Objects[owner_thread_id_[self]].Waiting_On_Condvar_Id].
                                                                                                                                 Waiting_Threads_Queue[(Thread_Objects[thread_id_[self]].Current_Priority)] = Append((Mutex_Objects[Thread_Objects[owner_thread_id_[self]].Waiting_On_Condvar_Id].
                                                                                                                                                                                                                         Waiting_Threads_Queue)[(Thread_Objects[thread_id_[self]].Current_Priority)], owner_thread_id_[self])]
                                                                                      /\ Thread_Objects' = [Thread_Objects EXCEPT ![owner_thread_id_[self]].Current_Priority = Thread_Objects[thread_id_[self]].Current_Priority]
                                                                                   /\ pc' = [pc EXCEPT ![self] = "acquire_mutex_priority_inheritance_update_prio_step"]
                                                                                   /\ UNCHANGED << HiRTOS,
                                                                                                   Condvar_Objects,
                                                                                                   Timer_Objects,
                                                                                                   Global_Resource_Available,
                                                                                                   stack,
                                                                                                   thread_id_,
                                                                                                   mutex_id_,
                                                                                                   waking_up_thread_after_condvar_wait,
                                                                                                   owner_thread_id_,
                                                                                                   thread_id_A,
                                                                                                   mutex_id_A,
                                                                                                   owner_thread_id,
                                                                                                   thread_id_D,
                                                                                                   mutex_id_D,
                                                                                                   doing_condvar_wait,
                                                                                                   awoken_thread_id_,
                                                                                                   thread_id_R,
                                                                                                   mutex_id_R,
                                                                                                   thread_id_Do,
                                                                                                   condvar_id_,
                                                                                                   mutex_id_Do,
                                                                                                   thread_id_W,
                                                                                                   condvar_id_W,
                                                                                                   mutex_id,
                                                                                                   condvar_id_D,
                                                                                                   do_context_switch,
                                                                                                   awoken_thread_id,
                                                                                                   to_reacquire_mutex_id,
                                                                                                   context_id_,
                                                                                                   condvar_id_S,
                                                                                                   context_id,
                                                                                                   condvar_id,
                                                                                                   thread_was_awaken,
                                                                                                   thread_id,
                                                                                                   delayed_threads >>

acquire_mutex_priority_inheritance_update_prio_step(self) == /\ pc[self] = "acquire_mutex_priority_inheritance_update_prio_step"
                                                             /\ Thread_Objects' = [Thread_Objects EXCEPT ![owner_thread_id_[self]].Current_Priority = Thread_Objects[thread_id_[self]].Current_Priority]
                                                             /\ pc' = [pc EXCEPT ![self] = "acquire_mutex_check_if_synchronous_context_switch_needed_step"]
                                                             /\ UNCHANGED << HiRTOS,
                                                                             Mutex_Objects,
                                                                             Condvar_Objects,
                                                                             Timer_Objects,
                                                                             Global_Resource_Available,
                                                                             stack,
                                                                             thread_id_,
                                                                             mutex_id_,
                                                                             waking_up_thread_after_condvar_wait,
                                                                             owner_thread_id_,
                                                                             thread_id_A,
                                                                             mutex_id_A,
                                                                             owner_thread_id,
                                                                             thread_id_D,
                                                                             mutex_id_D,
                                                                             doing_condvar_wait,
                                                                             awoken_thread_id_,
                                                                             thread_id_R,
                                                                             mutex_id_R,
                                                                             thread_id_Do,
                                                                             condvar_id_,
                                                                             mutex_id_Do,
                                                                             thread_id_W,
                                                                             condvar_id_W,
                                                                             mutex_id,
                                                                             condvar_id_D,
                                                                             do_context_switch,
                                                                             awoken_thread_id,
                                                                             to_reacquire_mutex_id,
                                                                             context_id_,
                                                                             condvar_id_S,
                                                                             context_id,
                                                                             condvar_id,
                                                                             thread_was_awaken,
                                                                             thread_id,
                                                                             delayed_threads >>

acquire_mutex_check_if_synchronous_context_switch_needed_step(self) == /\ pc[self] = "acquire_mutex_check_if_synchronous_context_switch_needed_step"
                                                                       /\ IF ~waking_up_thread_after_condvar_wait[self]
                                                                             THEN /\ pc' = [pc EXCEPT ![self] = "acquire_mutex_synchronous_context_switch_step"]
                                                                             ELSE /\ pc' = [pc EXCEPT ![self] = "do_acquire_mutex_return_step"]
                                                                       /\ UNCHANGED << HiRTOS,
                                                                                       Thread_Objects,
                                                                                       Mutex_Objects,
                                                                                       Condvar_Objects,
                                                                                       Timer_Objects,
                                                                                       Global_Resource_Available,
                                                                                       stack,
                                                                                       thread_id_,
                                                                                       mutex_id_,
                                                                                       waking_up_thread_after_condvar_wait,
                                                                                       owner_thread_id_,
                                                                                       thread_id_A,
                                                                                       mutex_id_A,
                                                                                       owner_thread_id,
                                                                                       thread_id_D,
                                                                                       mutex_id_D,
                                                                                       doing_condvar_wait,
                                                                                       awoken_thread_id_,
                                                                                       thread_id_R,
                                                                                       mutex_id_R,
                                                                                       thread_id_Do,
                                                                                       condvar_id_,
                                                                                       mutex_id_Do,
                                                                                       thread_id_W,
                                                                                       condvar_id_W,
                                                                                       mutex_id,
                                                                                       condvar_id_D,
                                                                                       do_context_switch,
                                                                                       awoken_thread_id,
                                                                                       to_reacquire_mutex_id,
                                                                                       context_id_,
                                                                                       condvar_id_S,
                                                                                       context_id,
                                                                                       condvar_id,
                                                                                       thread_was_awaken,
                                                                                       thread_id,
                                                                                       delayed_threads >>

acquire_mutex_synchronous_context_switch_step(self) == /\ pc[self] = "acquire_mutex_synchronous_context_switch_step"
                                                       /\ stack' = [stack EXCEPT ![self] = << [ procedure |->  "Run_Thread_Scheduler",
                                                                                                pc        |->  "do_acquire_mutex_return_step" ] >>
                                                                                            \o stack[self]]
                                                       /\ pc' = [pc EXCEPT ![self] = "check_time_slice_step"]
                                                       /\ UNCHANGED << HiRTOS,
                                                                       Thread_Objects,
                                                                       Mutex_Objects,
                                                                       Condvar_Objects,
                                                                       Timer_Objects,
                                                                       Global_Resource_Available,
                                                                       thread_id_,
                                                                       mutex_id_,
                                                                       waking_up_thread_after_condvar_wait,
                                                                       owner_thread_id_,
                                                                       thread_id_A,
                                                                       mutex_id_A,
                                                                       owner_thread_id,
                                                                       thread_id_D,
                                                                       mutex_id_D,
                                                                       doing_condvar_wait,
                                                                       awoken_thread_id_,
                                                                       thread_id_R,
                                                                       mutex_id_R,
                                                                       thread_id_Do,
                                                                       condvar_id_,
                                                                       mutex_id_Do,
                                                                       thread_id_W,
                                                                       condvar_id_W,
                                                                       mutex_id,
                                                                       condvar_id_D,
                                                                       do_context_switch,
                                                                       awoken_thread_id,
                                                                       to_reacquire_mutex_id,
                                                                       context_id_,
                                                                       condvar_id_S,
                                                                       context_id,
                                                                       condvar_id,
                                                                       thread_was_awaken,
                                                                       thread_id,
                                                                       delayed_threads >>

do_acquire_mutex_return_step(self) == /\ pc[self] = "do_acquire_mutex_return_step"
                                      /\ pc' = [pc EXCEPT ![self] = Head(stack[self]).pc]
                                      /\ owner_thread_id_' = [owner_thread_id_ EXCEPT ![self] = Head(stack[self]).owner_thread_id_]
                                      /\ thread_id_' = [thread_id_ EXCEPT ![self] = Head(stack[self]).thread_id_]
                                      /\ mutex_id_' = [mutex_id_ EXCEPT ![self] = Head(stack[self]).mutex_id_]
                                      /\ waking_up_thread_after_condvar_wait' = [waking_up_thread_after_condvar_wait EXCEPT ![self] = Head(stack[self]).waking_up_thread_after_condvar_wait]
                                      /\ stack' = [stack EXCEPT ![self] = Tail(stack[self])]
                                      /\ UNCHANGED << HiRTOS, Thread_Objects,
                                                      Mutex_Objects,
                                                      Condvar_Objects,
                                                      Timer_Objects,
                                                      Global_Resource_Available,
                                                      thread_id_A, mutex_id_A,
                                                      owner_thread_id,
                                                      thread_id_D, mutex_id_D,
                                                      doing_condvar_wait,
                                                      awoken_thread_id_,
                                                      thread_id_R, mutex_id_R,
                                                      thread_id_Do,
                                                      condvar_id_, mutex_id_Do,
                                                      thread_id_W,
                                                      condvar_id_W, mutex_id,
                                                      condvar_id_D,
                                                      do_context_switch,
                                                      awoken_thread_id,
                                                      to_reacquire_mutex_id,
                                                      context_id_,
                                                      condvar_id_S, context_id,
                                                      condvar_id,
                                                      thread_was_awaken,
                                                      thread_id,
                                                      delayed_threads >>

Do_Acquire_Mutex(self) == acquire_mutex_step_(self)
                             \/ acquire_mutex_acquire_step(self)
                             \/ acquire_mutex_make_condvar_wait_awoken_thread_runnable_step(self)
                             \/ acquire_mutex_wait_on_mutex_step(self)
                             \/ acquire_mutex_check_if_priority_inheritance_needed_step(self)
                             \/ acquire_mutex_priority_inheritance_step(self)
                             \/ acquire_mutex_priority_inheritance_if_mutex_owner_runnable_step(self)
                             \/ acquire_mutex_priority_inheritance_if_mutex_owner_blocked_on_mutex_step(self)
                             \/ acquire_mutex_priority_inheritance_if_mutex_owner_blocked_on_condvar_step(self)
                             \/ acquire_mutex_priority_inheritance_update_prio_step(self)
                             \/ acquire_mutex_check_if_synchronous_context_switch_needed_step(self)
                             \/ acquire_mutex_synchronous_context_switch_step(self)
                             \/ do_acquire_mutex_return_step(self)

enter_critical_section_step_(self) == /\ pc[self] = "enter_critical_section_step_"
                                      /\ HiRTOS.Interrupts_Enabled /\
                                         (thread_id_A[self] \in Threads =>
                                             Thread_Objects[thread_id_A[self]].State = "Running")
                                      /\ HiRTOS' = [HiRTOS EXCEPT !.Interrupts_Enabled = FALSE]
                                      /\ Assert(HiRTOS'.Current_Thread_Id = thread_id_A[self],
                                                "Failure of assertion at line 338, column 7.")
                                      /\ /\ mutex_id_' = [mutex_id_ EXCEPT ![self] = mutex_id_A[self]]
                                         /\ stack' = [stack EXCEPT ![self] = << [ procedure |->  "Do_Acquire_Mutex",
                                                                                  pc        |->  "exit_critical_section_step_",
                                                                                  owner_thread_id_ |->  owner_thread_id_[self],
                                                                                  thread_id_ |->  thread_id_[self],
                                                                                  mutex_id_ |->  mutex_id_[self],
                                                                                  waking_up_thread_after_condvar_wait |->  waking_up_thread_after_condvar_wait[self] ] >>
                                                                              \o stack[self]]
                                         /\ thread_id_' = [thread_id_ EXCEPT ![self] = thread_id_A[self]]
                                         /\ waking_up_thread_after_condvar_wait' = [waking_up_thread_after_condvar_wait EXCEPT ![self] = FALSE]
                                      /\ owner_thread_id_' = [owner_thread_id_ EXCEPT ![self] = "Invalid_Thread_Id"]
                                      /\ pc' = [pc EXCEPT ![self] = "acquire_mutex_step_"]
                                      /\ UNCHANGED << Thread_Objects,
                                                      Mutex_Objects,
                                                      Condvar_Objects,
                                                      Timer_Objects,
                                                      Global_Resource_Available,
                                                      thread_id_A, mutex_id_A,
                                                      owner_thread_id,
                                                      thread_id_D, mutex_id_D,
                                                      doing_condvar_wait,
                                                      awoken_thread_id_,
                                                      thread_id_R, mutex_id_R,
                                                      thread_id_Do,
                                                      condvar_id_, mutex_id_Do,
                                                      thread_id_W,
                                                      condvar_id_W, mutex_id,
                                                      condvar_id_D,
                                                      do_context_switch,
                                                      awoken_thread_id,
                                                      to_reacquire_mutex_id,
                                                      context_id_,
                                                      condvar_id_S, context_id,
                                                      condvar_id,
                                                      thread_was_awaken,
                                                      thread_id,
                                                      delayed_threads >>

exit_critical_section_step_(self) == /\ pc[self] = "exit_critical_section_step_"
                                     /\ HiRTOS' = [HiRTOS EXCEPT !.Interrupts_Enabled = TRUE]
                                     /\ pc' = [pc EXCEPT ![self] = "acquire_mutex_return_step"]
                                     /\ UNCHANGED << Thread_Objects,
                                                     Mutex_Objects,
                                                     Condvar_Objects,
                                                     Timer_Objects,
                                                     Global_Resource_Available,
                                                     stack, thread_id_,
                                                     mutex_id_,
                                                     waking_up_thread_after_condvar_wait,
                                                     owner_thread_id_,
                                                     thread_id_A, mutex_id_A,
                                                     owner_thread_id,
                                                     thread_id_D, mutex_id_D,
                                                     doing_condvar_wait,
                                                     awoken_thread_id_,
                                                     thread_id_R, mutex_id_R,
                                                     thread_id_Do, condvar_id_,
                                                     mutex_id_Do, thread_id_W,
                                                     condvar_id_W, mutex_id,
                                                     condvar_id_D,
                                                     do_context_switch,
                                                     awoken_thread_id,
                                                     to_reacquire_mutex_id,
                                                     context_id_, condvar_id_S,
                                                     context_id, condvar_id,
                                                     thread_was_awaken,
                                                     thread_id,
                                                     delayed_threads >>

acquire_mutex_return_step(self) == /\ pc[self] = "acquire_mutex_return_step"
                                   /\ pc' = [pc EXCEPT ![self] = Head(stack[self]).pc]
                                   /\ owner_thread_id' = [owner_thread_id EXCEPT ![self] = Head(stack[self]).owner_thread_id]
                                   /\ thread_id_A' = [thread_id_A EXCEPT ![self] = Head(stack[self]).thread_id_A]
                                   /\ mutex_id_A' = [mutex_id_A EXCEPT ![self] = Head(stack[self]).mutex_id_A]
                                   /\ stack' = [stack EXCEPT ![self] = Tail(stack[self])]
                                   /\ UNCHANGED << HiRTOS, Thread_Objects,
                                                   Mutex_Objects,
                                                   Condvar_Objects,
                                                   Timer_Objects,
                                                   Global_Resource_Available,
                                                   thread_id_, mutex_id_,
                                                   waking_up_thread_after_condvar_wait,
                                                   owner_thread_id_,
                                                   thread_id_D, mutex_id_D,
                                                   doing_condvar_wait,
                                                   awoken_thread_id_,
                                                   thread_id_R, mutex_id_R,
                                                   thread_id_Do, condvar_id_,
                                                   mutex_id_Do, thread_id_W,
                                                   condvar_id_W, mutex_id,
                                                   condvar_id_D,
                                                   do_context_switch,
                                                   awoken_thread_id,
                                                   to_reacquire_mutex_id,
                                                   context_id_, condvar_id_S,
                                                   context_id, condvar_id,
                                                   thread_was_awaken,
                                                   thread_id, delayed_threads >>

Acquire_Mutex(self) == enter_critical_section_step_(self)
                          \/ exit_critical_section_step_(self)
                          \/ acquire_mutex_return_step(self)

release_mutex_step_(self) == /\ pc[self] = "release_mutex_step_"
                             /\ Assert(~HiRTOS.Interrupts_Enabled,
                                       "Failure of assertion at line 350, column 7.")
                             /\ Assert(Mutex_Objects[mutex_id_D[self]].Owner_Thread_Id = thread_id_D[self],
                                       "Failure of assertion at line 351, column 7.")
                             /\ Assert(Thread_Objects[thread_id_D[self]].Owned_Mutexes /= <<>>,
                                       "Failure of assertion at line 352, column 7.")
                             /\ Assert(Head(Thread_Objects[thread_id_D[self]].Owned_Mutexes) = mutex_id_D[self],
                                       "Failure of assertion at line 353, column 7.")
                             /\ Thread_Objects' = [Thread_Objects EXCEPT ![thread_id_D[self]].Owned_Mutexes = Tail(Thread_Objects[thread_id_D[self]].Owned_Mutexes)]
                             /\ pc' = [pc EXCEPT ![self] = "release_mutex_restore_priority_step"]
                             /\ UNCHANGED << HiRTOS, Mutex_Objects,
                                             Condvar_Objects, Timer_Objects,
                                             Global_Resource_Available, stack,
                                             thread_id_, mutex_id_,
                                             waking_up_thread_after_condvar_wait,
                                             owner_thread_id_, thread_id_A,
                                             mutex_id_A, owner_thread_id,
                                             thread_id_D, mutex_id_D,
                                             doing_condvar_wait,
                                             awoken_thread_id_, thread_id_R,
                                             mutex_id_R, thread_id_Do,
                                             condvar_id_, mutex_id_Do,
                                             thread_id_W, condvar_id_W,
                                             mutex_id, condvar_id_D,
                                             do_context_switch,
                                             awoken_thread_id,
                                             to_reacquire_mutex_id,
                                             context_id_, condvar_id_S,
                                             context_id, condvar_id,
                                             thread_was_awaken, thread_id,
                                             delayed_threads >>

release_mutex_restore_priority_step(self) == /\ pc[self] = "release_mutex_restore_priority_step"
                                             /\ IF Thread_Objects[thread_id_D[self]].Owned_Mutexes /= <<>> /\ ~doing_condvar_wait[self]
                                                   THEN /\ LET prev_mutex_obj == Mutex_Objects[Head(Thread_Objects[thread_id_D[self]].Owned_Mutexes)] IN
                                                             IF prev_mutex_obj.Last_Inherited_Priority /= Invalid_Thread_Priority
                                                                THEN /\ Thread_Objects' = [Thread_Objects EXCEPT ![thread_id_D[self]].Current_Priority = prev_mutex_obj.Last_Inherited_Priority]
                                                                ELSE /\ TRUE
                                                                     /\ UNCHANGED Thread_Objects
                                                   ELSE /\ Thread_Objects' = [Thread_Objects EXCEPT ![thread_id_D[self]].Current_Priority = Thread_Objects[thread_id_D[self]].Base_Priority]
                                             /\ pc' = [pc EXCEPT ![self] = "release_mutex_check_if_mutex_waiters_step"]
                                             /\ UNCHANGED << HiRTOS,
                                                             Mutex_Objects,
                                                             Condvar_Objects,
                                                             Timer_Objects,
                                                             Global_Resource_Available,
                                                             stack, thread_id_,
                                                             mutex_id_,
                                                             waking_up_thread_after_condvar_wait,
                                                             owner_thread_id_,
                                                             thread_id_A,
                                                             mutex_id_A,
                                                             owner_thread_id,
                                                             thread_id_D,
                                                             mutex_id_D,
                                                             doing_condvar_wait,
                                                             awoken_thread_id_,
                                                             thread_id_R,
                                                             mutex_id_R,
                                                             thread_id_Do,
                                                             condvar_id_,
                                                             mutex_id_Do,
                                                             thread_id_W,
                                                             condvar_id_W,
                                                             mutex_id,
                                                             condvar_id_D,
                                                             do_context_switch,
                                                             awoken_thread_id,
                                                             to_reacquire_mutex_id,
                                                             context_id_,
                                                             condvar_id_S,
                                                             context_id,
                                                             condvar_id,
                                                             thread_was_awaken,
                                                             thread_id,
                                                             delayed_threads >>

release_mutex_check_if_mutex_waiters_step(self) == /\ pc[self] = "release_mutex_check_if_mutex_waiters_step"
                                                   /\ IF Is_Thread_Priority_Queue_Empty(Mutex_Objects[mutex_id_D[self]].Waiting_Threads_Queue)
                                                         THEN /\ Mutex_Objects' = [Mutex_Objects EXCEPT ![mutex_id_D[self]].Owner_Thread_Id = "Invalid_Thread_Id"]
                                                              /\ pc' = [pc EXCEPT ![self] = "do_release_mutex_return_step"]
                                                         ELSE /\ pc' = [pc EXCEPT ![self] = "release_mutex_wakeup_mutex_waiter_step"]
                                                              /\ UNCHANGED Mutex_Objects
                                                   /\ UNCHANGED << HiRTOS,
                                                                   Thread_Objects,
                                                                   Condvar_Objects,
                                                                   Timer_Objects,
                                                                   Global_Resource_Available,
                                                                   stack,
                                                                   thread_id_,
                                                                   mutex_id_,
                                                                   waking_up_thread_after_condvar_wait,
                                                                   owner_thread_id_,
                                                                   thread_id_A,
                                                                   mutex_id_A,
                                                                   owner_thread_id,
                                                                   thread_id_D,
                                                                   mutex_id_D,
                                                                   doing_condvar_wait,
                                                                   awoken_thread_id_,
                                                                   thread_id_R,
                                                                   mutex_id_R,
                                                                   thread_id_Do,
                                                                   condvar_id_,
                                                                   mutex_id_Do,
                                                                   thread_id_W,
                                                                   condvar_id_W,
                                                                   mutex_id,
                                                                   condvar_id_D,
                                                                   do_context_switch,
                                                                   awoken_thread_id,
                                                                   to_reacquire_mutex_id,
                                                                   context_id_,
                                                                   condvar_id_S,
                                                                   context_id,
                                                                   condvar_id,
                                                                   thread_was_awaken,
                                                                   thread_id,
                                                                   delayed_threads >>

release_mutex_wakeup_mutex_waiter_step(self) == /\ pc[self] = "release_mutex_wakeup_mutex_waiter_step"
                                                /\ awoken_thread_id_' = [awoken_thread_id_ EXCEPT ![self] = Priority_Queue_Head(Mutex_Objects[mutex_id_D[self]].Waiting_Threads_Queue)]
                                                /\ Assert(Thread_Objects[awoken_thread_id_'[self]].Waiting_On_Mutex_Id = mutex_id_D[self],
                                                          "Failure of assertion at line 374, column 10.")
                                                /\ /\ HiRTOS' = [HiRTOS EXCEPT !.Runnable_Threads_Queue = Enqueue_Thread(HiRTOS.Runnable_Threads_Queue, awoken_thread_id_'[self])]
                                                   /\ Mutex_Objects' = [Mutex_Objects EXCEPT ![mutex_id_D[self]].Owner_Thread_Id = awoken_thread_id_'[self],
                                                                                             ![mutex_id_D[self]].Waiting_Threads_Queue = Priority_Queue_Tail(Mutex_Objects[mutex_id_D[self]].Waiting_Threads_Queue)]
                                                   /\ Thread_Objects' = [Thread_Objects EXCEPT ![awoken_thread_id_'[self]].State = "Runnable",
                                                                                               ![awoken_thread_id_'[self]].Waiting_On_Mutex_Id = "Invalid_Mutex_Id",
                                                                                               ![awoken_thread_id_'[self]].Owned_Mutexes = <<mutex_id_D[self]>> \o Thread_Objects[awoken_thread_id_'[self]].Owned_Mutexes]
                                                /\ IF ~doing_condvar_wait[self]
                                                      THEN /\ pc' = [pc EXCEPT ![self] = "release_mutex_synchronous_context_switch_step"]
                                                      ELSE /\ pc' = [pc EXCEPT ![self] = "do_release_mutex_return_step"]
                                                /\ UNCHANGED << Condvar_Objects,
                                                                Timer_Objects,
                                                                Global_Resource_Available,
                                                                stack,
                                                                thread_id_,
                                                                mutex_id_,
                                                                waking_up_thread_after_condvar_wait,
                                                                owner_thread_id_,
                                                                thread_id_A,
                                                                mutex_id_A,
                                                                owner_thread_id,
                                                                thread_id_D,
                                                                mutex_id_D,
                                                                doing_condvar_wait,
                                                                thread_id_R,
                                                                mutex_id_R,
                                                                thread_id_Do,
                                                                condvar_id_,
                                                                mutex_id_Do,
                                                                thread_id_W,
                                                                condvar_id_W,
                                                                mutex_id,
                                                                condvar_id_D,
                                                                do_context_switch,
                                                                awoken_thread_id,
                                                                to_reacquire_mutex_id,
                                                                context_id_,
                                                                condvar_id_S,
                                                                context_id,
                                                                condvar_id,
                                                                thread_was_awaken,
                                                                thread_id,
                                                                delayed_threads >>

release_mutex_synchronous_context_switch_step(self) == /\ pc[self] = "release_mutex_synchronous_context_switch_step"
                                                       /\ stack' = [stack EXCEPT ![self] = << [ procedure |->  "Run_Thread_Scheduler",
                                                                                                pc        |->  "do_release_mutex_return_step" ] >>
                                                                                            \o stack[self]]
                                                       /\ pc' = [pc EXCEPT ![self] = "check_time_slice_step"]
                                                       /\ UNCHANGED << HiRTOS,
                                                                       Thread_Objects,
                                                                       Mutex_Objects,
                                                                       Condvar_Objects,
                                                                       Timer_Objects,
                                                                       Global_Resource_Available,
                                                                       thread_id_,
                                                                       mutex_id_,
                                                                       waking_up_thread_after_condvar_wait,
                                                                       owner_thread_id_,
                                                                       thread_id_A,
                                                                       mutex_id_A,
                                                                       owner_thread_id,
                                                                       thread_id_D,
                                                                       mutex_id_D,
                                                                       doing_condvar_wait,
                                                                       awoken_thread_id_,
                                                                       thread_id_R,
                                                                       mutex_id_R,
                                                                       thread_id_Do,
                                                                       condvar_id_,
                                                                       mutex_id_Do,
                                                                       thread_id_W,
                                                                       condvar_id_W,
                                                                       mutex_id,
                                                                       condvar_id_D,
                                                                       do_context_switch,
                                                                       awoken_thread_id,
                                                                       to_reacquire_mutex_id,
                                                                       context_id_,
                                                                       condvar_id_S,
                                                                       context_id,
                                                                       condvar_id,
                                                                       thread_was_awaken,
                                                                       thread_id,
                                                                       delayed_threads >>

do_release_mutex_return_step(self) == /\ pc[self] = "do_release_mutex_return_step"
                                      /\ pc' = [pc EXCEPT ![self] = Head(stack[self]).pc]
                                      /\ awoken_thread_id_' = [awoken_thread_id_ EXCEPT ![self] = Head(stack[self]).awoken_thread_id_]
                                      /\ thread_id_D' = [thread_id_D EXCEPT ![self] = Head(stack[self]).thread_id_D]
                                      /\ mutex_id_D' = [mutex_id_D EXCEPT ![self] = Head(stack[self]).mutex_id_D]
                                      /\ doing_condvar_wait' = [doing_condvar_wait EXCEPT ![self] = Head(stack[self]).doing_condvar_wait]
                                      /\ stack' = [stack EXCEPT ![self] = Tail(stack[self])]
                                      /\ UNCHANGED << HiRTOS, Thread_Objects,
                                                      Mutex_Objects,
                                                      Condvar_Objects,
                                                      Timer_Objects,
                                                      Global_Resource_Available,
                                                      thread_id_, mutex_id_,
                                                      waking_up_thread_after_condvar_wait,
                                                      owner_thread_id_,
                                                      thread_id_A, mutex_id_A,
                                                      owner_thread_id,
                                                      thread_id_R, mutex_id_R,
                                                      thread_id_Do,
                                                      condvar_id_, mutex_id_Do,
                                                      thread_id_W,
                                                      condvar_id_W, mutex_id,
                                                      condvar_id_D,
                                                      do_context_switch,
                                                      awoken_thread_id,
                                                      to_reacquire_mutex_id,
                                                      context_id_,
                                                      condvar_id_S, context_id,
                                                      condvar_id,
                                                      thread_was_awaken,
                                                      thread_id,
                                                      delayed_threads >>

Do_Release_Mutex(self) == release_mutex_step_(self)
                             \/ release_mutex_restore_priority_step(self)
                             \/ release_mutex_check_if_mutex_waiters_step(self)
                             \/ release_mutex_wakeup_mutex_waiter_step(self)
                             \/ release_mutex_synchronous_context_switch_step(self)
                             \/ do_release_mutex_return_step(self)

enter_critical_section_step_R(self) == /\ pc[self] = "enter_critical_section_step_R"
                                       /\ HiRTOS.Interrupts_Enabled /\
                                          (thread_id_R[self] \in Threads =>
                                              Thread_Objects[thread_id_R[self]].State = "Running")
                                       /\ HiRTOS' = [HiRTOS EXCEPT !.Interrupts_Enabled = FALSE]
                                       /\ Assert(HiRTOS'.Current_Thread_Id = thread_id_R[self],
                                                 "Failure of assertion at line 399, column 7.")
                                       /\ /\ doing_condvar_wait' = [doing_condvar_wait EXCEPT ![self] = FALSE]
                                          /\ mutex_id_D' = [mutex_id_D EXCEPT ![self] = mutex_id_R[self]]
                                          /\ stack' = [stack EXCEPT ![self] = << [ procedure |->  "Do_Release_Mutex",
                                                                                   pc        |->  "exit_critical_section_step_R",
                                                                                   awoken_thread_id_ |->  awoken_thread_id_[self],
                                                                                   thread_id_D |->  thread_id_D[self],
                                                                                   mutex_id_D |->  mutex_id_D[self],
                                                                                   doing_condvar_wait |->  doing_condvar_wait[self] ] >>
                                                                               \o stack[self]]
                                          /\ thread_id_D' = [thread_id_D EXCEPT ![self] = thread_id_R[self]]
                                       /\ awoken_thread_id_' = [awoken_thread_id_ EXCEPT ![self] = "Invalid_Thread_Id"]
                                       /\ pc' = [pc EXCEPT ![self] = "release_mutex_step_"]
                                       /\ UNCHANGED << Thread_Objects,
                                                       Mutex_Objects,
                                                       Condvar_Objects,
                                                       Timer_Objects,
                                                       Global_Resource_Available,
                                                       thread_id_, mutex_id_,
                                                       waking_up_thread_after_condvar_wait,
                                                       owner_thread_id_,
                                                       thread_id_A, mutex_id_A,
                                                       owner_thread_id,
                                                       thread_id_R, mutex_id_R,
                                                       thread_id_Do,
                                                       condvar_id_,
                                                       mutex_id_Do,
                                                       thread_id_W,
                                                       condvar_id_W, mutex_id,
                                                       condvar_id_D,
                                                       do_context_switch,
                                                       awoken_thread_id,
                                                       to_reacquire_mutex_id,
                                                       context_id_,
                                                       condvar_id_S,
                                                       context_id, condvar_id,
                                                       thread_was_awaken,
                                                       thread_id,
                                                       delayed_threads >>

exit_critical_section_step_R(self) == /\ pc[self] = "exit_critical_section_step_R"
                                      /\ HiRTOS' = [HiRTOS EXCEPT !.Interrupts_Enabled = TRUE]
                                      /\ pc' = [pc EXCEPT ![self] = "release_mutex_return_step"]
                                      /\ UNCHANGED << Thread_Objects,
                                                      Mutex_Objects,
                                                      Condvar_Objects,
                                                      Timer_Objects,
                                                      Global_Resource_Available,
                                                      stack, thread_id_,
                                                      mutex_id_,
                                                      waking_up_thread_after_condvar_wait,
                                                      owner_thread_id_,
                                                      thread_id_A, mutex_id_A,
                                                      owner_thread_id,
                                                      thread_id_D, mutex_id_D,
                                                      doing_condvar_wait,
                                                      awoken_thread_id_,
                                                      thread_id_R, mutex_id_R,
                                                      thread_id_Do,
                                                      condvar_id_, mutex_id_Do,
                                                      thread_id_W,
                                                      condvar_id_W, mutex_id,
                                                      condvar_id_D,
                                                      do_context_switch,
                                                      awoken_thread_id,
                                                      to_reacquire_mutex_id,
                                                      context_id_,
                                                      condvar_id_S, context_id,
                                                      condvar_id,
                                                      thread_was_awaken,
                                                      thread_id,
                                                      delayed_threads >>

release_mutex_return_step(self) == /\ pc[self] = "release_mutex_return_step"
                                   /\ pc' = [pc EXCEPT ![self] = Head(stack[self]).pc]
                                   /\ thread_id_R' = [thread_id_R EXCEPT ![self] = Head(stack[self]).thread_id_R]
                                   /\ mutex_id_R' = [mutex_id_R EXCEPT ![self] = Head(stack[self]).mutex_id_R]
                                   /\ stack' = [stack EXCEPT ![self] = Tail(stack[self])]
                                   /\ UNCHANGED << HiRTOS, Thread_Objects,
                                                   Mutex_Objects,
                                                   Condvar_Objects,
                                                   Timer_Objects,
                                                   Global_Resource_Available,
                                                   thread_id_, mutex_id_,
                                                   waking_up_thread_after_condvar_wait,
                                                   owner_thread_id_,
                                                   thread_id_A, mutex_id_A,
                                                   owner_thread_id,
                                                   thread_id_D, mutex_id_D,
                                                   doing_condvar_wait,
                                                   awoken_thread_id_,
                                                   thread_id_Do, condvar_id_,
                                                   mutex_id_Do, thread_id_W,
                                                   condvar_id_W, mutex_id,
                                                   condvar_id_D,
                                                   do_context_switch,
                                                   awoken_thread_id,
                                                   to_reacquire_mutex_id,
                                                   context_id_, condvar_id_S,
                                                   context_id, condvar_id,
                                                   thread_was_awaken,
                                                   thread_id, delayed_threads >>

Release_Mutex(self) == enter_critical_section_step_R(self)
                          \/ exit_critical_section_step_R(self)
                          \/ release_mutex_return_step(self)

wait_on_condvar_wait_step(self) == /\ pc[self] = "wait_on_condvar_wait_step"
                                   /\ Assert(~HiRTOS.Interrupts_Enabled,
                                             "Failure of assertion at line 410, column 7.")
                                   /\ /\ Condvar_Objects' = [Condvar_Objects EXCEPT ![condvar_id_[self]].Waiting_Threads_Queue = Enqueue_Thread(Condvar_Objects[condvar_id_[self]].Waiting_Threads_Queue, thread_id_Do[self])]
                                      /\ Thread_Objects' = [Thread_Objects EXCEPT ![thread_id_Do[self]].ghost_Condvar_Wait_Mutex_Id = mutex_id_Do[self],
                                                                                  ![thread_id_Do[self]].State = "Blocked_On_Condvar",
                                                                                  ![thread_id_Do[self]].Waiting_On_Condvar_Id = condvar_id_[self]]
                                   /\ HiRTOS' = [HiRTOS EXCEPT !.Current_Thread_Id = "Invalid_Thread_Id"]
                                   /\ pc' = [pc EXCEPT ![self] = "wait_on_condvar_release_mutex_step"]
                                   /\ UNCHANGED << Mutex_Objects,
                                                   Timer_Objects,
                                                   Global_Resource_Available,
                                                   stack, thread_id_,
                                                   mutex_id_,
                                                   waking_up_thread_after_condvar_wait,
                                                   owner_thread_id_,
                                                   thread_id_A, mutex_id_A,
                                                   owner_thread_id,
                                                   thread_id_D, mutex_id_D,
                                                   doing_condvar_wait,
                                                   awoken_thread_id_,
                                                   thread_id_R, mutex_id_R,
                                                   thread_id_Do, condvar_id_,
                                                   mutex_id_Do, thread_id_W,
                                                   condvar_id_W, mutex_id,
                                                   condvar_id_D,
                                                   do_context_switch,
                                                   awoken_thread_id,
                                                   to_reacquire_mutex_id,
                                                   context_id_, condvar_id_S,
                                                   context_id, condvar_id,
                                                   thread_was_awaken,
                                                   thread_id, delayed_threads >>

wait_on_condvar_release_mutex_step(self) == /\ pc[self] = "wait_on_condvar_release_mutex_step"
                                            /\ IF mutex_id_Do[self] /= "Invalid_Mutex_Id"
                                                  THEN /\ /\ doing_condvar_wait' = [doing_condvar_wait EXCEPT ![self] = TRUE]
                                                          /\ mutex_id_D' = [mutex_id_D EXCEPT ![self] = mutex_id_Do[self]]
                                                          /\ stack' = [stack EXCEPT ![self] = << [ procedure |->  "Do_Release_Mutex",
                                                                                                   pc        |->  "wait_on_condvar_synchronous_context_switch_step",
                                                                                                   awoken_thread_id_ |->  awoken_thread_id_[self],
                                                                                                   thread_id_D |->  thread_id_D[self],
                                                                                                   mutex_id_D |->  mutex_id_D[self],
                                                                                                   doing_condvar_wait |->  doing_condvar_wait[self] ] >>
                                                                                               \o stack[self]]
                                                          /\ thread_id_D' = [thread_id_D EXCEPT ![self] = thread_id_Do[self]]
                                                       /\ awoken_thread_id_' = [awoken_thread_id_ EXCEPT ![self] = "Invalid_Thread_Id"]
                                                       /\ pc' = [pc EXCEPT ![self] = "release_mutex_step_"]
                                                  ELSE /\ pc' = [pc EXCEPT ![self] = "wait_on_condvar_synchronous_context_switch_step"]
                                                       /\ UNCHANGED << stack,
                                                                       thread_id_D,
                                                                       mutex_id_D,
                                                                       doing_condvar_wait,
                                                                       awoken_thread_id_ >>
                                            /\ UNCHANGED << HiRTOS,
                                                            Thread_Objects,
                                                            Mutex_Objects,
                                                            Condvar_Objects,
                                                            Timer_Objects,
                                                            Global_Resource_Available,
                                                            thread_id_,
                                                            mutex_id_,
                                                            waking_up_thread_after_condvar_wait,
                                                            owner_thread_id_,
                                                            thread_id_A,
                                                            mutex_id_A,
                                                            owner_thread_id,
                                                            thread_id_R,
                                                            mutex_id_R,
                                                            thread_id_Do,
                                                            condvar_id_,
                                                            mutex_id_Do,
                                                            thread_id_W,
                                                            condvar_id_W,
                                                            mutex_id,
                                                            condvar_id_D,
                                                            do_context_switch,
                                                            awoken_thread_id,
                                                            to_reacquire_mutex_id,
                                                            context_id_,
                                                            condvar_id_S,
                                                            context_id,
                                                            condvar_id,
                                                            thread_was_awaken,
                                                            thread_id,
                                                            delayed_threads >>

wait_on_condvar_synchronous_context_switch_step(self) == /\ pc[self] = "wait_on_condvar_synchronous_context_switch_step"
                                                         /\ stack' = [stack EXCEPT ![self] = << [ procedure |->  "Run_Thread_Scheduler",
                                                                                                  pc        |->  "do_wait_on_condvar_return_step" ] >>
                                                                                              \o stack[self]]
                                                         /\ pc' = [pc EXCEPT ![self] = "check_time_slice_step"]
                                                         /\ UNCHANGED << HiRTOS,
                                                                         Thread_Objects,
                                                                         Mutex_Objects,
                                                                         Condvar_Objects,
                                                                         Timer_Objects,
                                                                         Global_Resource_Available,
                                                                         thread_id_,
                                                                         mutex_id_,
                                                                         waking_up_thread_after_condvar_wait,
                                                                         owner_thread_id_,
                                                                         thread_id_A,
                                                                         mutex_id_A,
                                                                         owner_thread_id,
                                                                         thread_id_D,
                                                                         mutex_id_D,
                                                                         doing_condvar_wait,
                                                                         awoken_thread_id_,
                                                                         thread_id_R,
                                                                         mutex_id_R,
                                                                         thread_id_Do,
                                                                         condvar_id_,
                                                                         mutex_id_Do,
                                                                         thread_id_W,
                                                                         condvar_id_W,
                                                                         mutex_id,
                                                                         condvar_id_D,
                                                                         do_context_switch,
                                                                         awoken_thread_id,
                                                                         to_reacquire_mutex_id,
                                                                         context_id_,
                                                                         condvar_id_S,
                                                                         context_id,
                                                                         condvar_id,
                                                                         thread_was_awaken,
                                                                         thread_id,
                                                                         delayed_threads >>

do_wait_on_condvar_return_step(self) == /\ pc[self] = "do_wait_on_condvar_return_step"
                                        /\ pc' = [pc EXCEPT ![self] = Head(stack[self]).pc]
                                        /\ thread_id_Do' = [thread_id_Do EXCEPT ![self] = Head(stack[self]).thread_id_Do]
                                        /\ condvar_id_' = [condvar_id_ EXCEPT ![self] = Head(stack[self]).condvar_id_]
                                        /\ mutex_id_Do' = [mutex_id_Do EXCEPT ![self] = Head(stack[self]).mutex_id_Do]
                                        /\ stack' = [stack EXCEPT ![self] = Tail(stack[self])]
                                        /\ UNCHANGED << HiRTOS, Thread_Objects,
                                                        Mutex_Objects,
                                                        Condvar_Objects,
                                                        Timer_Objects,
                                                        Global_Resource_Available,
                                                        thread_id_, mutex_id_,
                                                        waking_up_thread_after_condvar_wait,
                                                        owner_thread_id_,
                                                        thread_id_A,
                                                        mutex_id_A,
                                                        owner_thread_id,
                                                        thread_id_D,
                                                        mutex_id_D,
                                                        doing_condvar_wait,
                                                        awoken_thread_id_,
                                                        thread_id_R,
                                                        mutex_id_R,
                                                        thread_id_W,
                                                        condvar_id_W, mutex_id,
                                                        condvar_id_D,
                                                        do_context_switch,
                                                        awoken_thread_id,
                                                        to_reacquire_mutex_id,
                                                        context_id_,
                                                        condvar_id_S,
                                                        context_id, condvar_id,
                                                        thread_was_awaken,
                                                        thread_id,
                                                        delayed_threads >>

Do_Wait_On_Condvar(self) == wait_on_condvar_wait_step(self)
                               \/ wait_on_condvar_release_mutex_step(self)
                               \/ wait_on_condvar_synchronous_context_switch_step(self)
                               \/ do_wait_on_condvar_return_step(self)

enter_critical_section_step_W(self) == /\ pc[self] = "enter_critical_section_step_W"
                                       /\ HiRTOS.Interrupts_Enabled /\
                                          (thread_id_W[self] \in Threads =>
                                              Thread_Objects[thread_id_W[self]].State = "Running")
                                       /\ HiRTOS' = [HiRTOS EXCEPT !.Interrupts_Enabled = FALSE]
                                       /\ /\ condvar_id_' = [condvar_id_ EXCEPT ![self] = condvar_id_W[self]]
                                          /\ mutex_id_Do' = [mutex_id_Do EXCEPT ![self] = mutex_id[self]]
                                          /\ stack' = [stack EXCEPT ![self] = << [ procedure |->  "Do_Wait_On_Condvar",
                                                                                   pc        |->  "exit_critical_section_step_W",
                                                                                   thread_id_Do |->  thread_id_Do[self],
                                                                                   condvar_id_ |->  condvar_id_[self],
                                                                                   mutex_id_Do |->  mutex_id_Do[self] ] >>
                                                                               \o stack[self]]
                                          /\ thread_id_Do' = [thread_id_Do EXCEPT ![self] = thread_id_W[self]]
                                       /\ pc' = [pc EXCEPT ![self] = "wait_on_condvar_wait_step"]
                                       /\ UNCHANGED << Thread_Objects,
                                                       Mutex_Objects,
                                                       Condvar_Objects,
                                                       Timer_Objects,
                                                       Global_Resource_Available,
                                                       thread_id_, mutex_id_,
                                                       waking_up_thread_after_condvar_wait,
                                                       owner_thread_id_,
                                                       thread_id_A, mutex_id_A,
                                                       owner_thread_id,
                                                       thread_id_D, mutex_id_D,
                                                       doing_condvar_wait,
                                                       awoken_thread_id_,
                                                       thread_id_R, mutex_id_R,
                                                       thread_id_W,
                                                       condvar_id_W, mutex_id,
                                                       condvar_id_D,
                                                       do_context_switch,
                                                       awoken_thread_id,
                                                       to_reacquire_mutex_id,
                                                       context_id_,
                                                       condvar_id_S,
                                                       context_id, condvar_id,
                                                       thread_was_awaken,
                                                       thread_id,
                                                       delayed_threads >>

exit_critical_section_step_W(self) == /\ pc[self] = "exit_critical_section_step_W"
                                      /\ HiRTOS' = [HiRTOS EXCEPT !.Interrupts_Enabled = TRUE]
                                      /\ pc' = [pc EXCEPT ![self] = "wait_on_condvar_return_step"]
                                      /\ UNCHANGED << Thread_Objects,
                                                      Mutex_Objects,
                                                      Condvar_Objects,
                                                      Timer_Objects,
                                                      Global_Resource_Available,
                                                      stack, thread_id_,
                                                      mutex_id_,
                                                      waking_up_thread_after_condvar_wait,
                                                      owner_thread_id_,
                                                      thread_id_A, mutex_id_A,
                                                      owner_thread_id,
                                                      thread_id_D, mutex_id_D,
                                                      doing_condvar_wait,
                                                      awoken_thread_id_,
                                                      thread_id_R, mutex_id_R,
                                                      thread_id_Do,
                                                      condvar_id_, mutex_id_Do,
                                                      thread_id_W,
                                                      condvar_id_W, mutex_id,
                                                      condvar_id_D,
                                                      do_context_switch,
                                                      awoken_thread_id,
                                                      to_reacquire_mutex_id,
                                                      context_id_,
                                                      condvar_id_S, context_id,
                                                      condvar_id,
                                                      thread_was_awaken,
                                                      thread_id,
                                                      delayed_threads >>

wait_on_condvar_return_step(self) == /\ pc[self] = "wait_on_condvar_return_step"
                                     /\ pc' = [pc EXCEPT ![self] = Head(stack[self]).pc]
                                     /\ thread_id_W' = [thread_id_W EXCEPT ![self] = Head(stack[self]).thread_id_W]
                                     /\ condvar_id_W' = [condvar_id_W EXCEPT ![self] = Head(stack[self]).condvar_id_W]
                                     /\ mutex_id' = [mutex_id EXCEPT ![self] = Head(stack[self]).mutex_id]
                                     /\ stack' = [stack EXCEPT ![self] = Tail(stack[self])]
                                     /\ UNCHANGED << HiRTOS, Thread_Objects,
                                                     Mutex_Objects,
                                                     Condvar_Objects,
                                                     Timer_Objects,
                                                     Global_Resource_Available,
                                                     thread_id_, mutex_id_,
                                                     waking_up_thread_after_condvar_wait,
                                                     owner_thread_id_,
                                                     thread_id_A, mutex_id_A,
                                                     owner_thread_id,
                                                     thread_id_D, mutex_id_D,
                                                     doing_condvar_wait,
                                                     awoken_thread_id_,
                                                     thread_id_R, mutex_id_R,
                                                     thread_id_Do, condvar_id_,
                                                     mutex_id_Do, condvar_id_D,
                                                     do_context_switch,
                                                     awoken_thread_id,
                                                     to_reacquire_mutex_id,
                                                     context_id_, condvar_id_S,
                                                     context_id, condvar_id,
                                                     thread_was_awaken,
                                                     thread_id,
                                                     delayed_threads >>

Wait_On_Condvar(self) == enter_critical_section_step_W(self)
                            \/ exit_critical_section_step_W(self)
                            \/ wait_on_condvar_return_step(self)

signal_condvar_step(self) == /\ pc[self] = "signal_condvar_step"
                             /\ Assert(~HiRTOS.Interrupts_Enabled,
                                       "Failure of assertion at line 446, column 7.")
                             /\ IF ~Is_Thread_Priority_Queue_Empty(Condvar_Objects[condvar_id_D[self]].Waiting_Threads_Queue)
                                   THEN /\ pc' = [pc EXCEPT ![self] = "signal_condvar_wakeup_waiter_step"]
                                   ELSE /\ pc' = [pc EXCEPT ![self] = "do_condvar_signal_return_step"]
                             /\ UNCHANGED << HiRTOS, Thread_Objects,
                                             Mutex_Objects, Condvar_Objects,
                                             Timer_Objects,
                                             Global_Resource_Available, stack,
                                             thread_id_, mutex_id_,
                                             waking_up_thread_after_condvar_wait,
                                             owner_thread_id_, thread_id_A,
                                             mutex_id_A, owner_thread_id,
                                             thread_id_D, mutex_id_D,
                                             doing_condvar_wait,
                                             awoken_thread_id_, thread_id_R,
                                             mutex_id_R, thread_id_Do,
                                             condvar_id_, mutex_id_Do,
                                             thread_id_W, condvar_id_W,
                                             mutex_id, condvar_id_D,
                                             do_context_switch,
                                             awoken_thread_id,
                                             to_reacquire_mutex_id,
                                             context_id_, condvar_id_S,
                                             context_id, condvar_id,
                                             thread_was_awaken, thread_id,
                                             delayed_threads >>

signal_condvar_wakeup_waiter_step(self) == /\ pc[self] = "signal_condvar_wakeup_waiter_step"
                                           /\ awoken_thread_id' = [awoken_thread_id EXCEPT ![self] = Priority_Queue_Head(Condvar_Objects[condvar_id_D[self]].Waiting_Threads_Queue)]
                                           /\ Condvar_Objects' = [Condvar_Objects EXCEPT ![condvar_id_D[self]].Waiting_Threads_Queue = Priority_Queue_Tail(Condvar_Objects[condvar_id_D[self]].Waiting_Threads_Queue)]
                                           /\ Assert(awoken_thread_id'[self] /= HiRTOS.Current_Thread_Id,
                                                     "Failure of assertion at line 454, column 10.")
                                           /\ Assert(Thread_Objects[awoken_thread_id'[self]].Waiting_On_Condvar_Id = condvar_id_D[self],
                                                     "Failure of assertion at line 455, column 10.")
                                           /\ Assert(Thread_Objects[awoken_thread_id'[self]].Waiting_On_Mutex_Id = "Invalid_Mutex_Id",
                                                     "Failure of assertion at line 456, column 10.")
                                           /\ to_reacquire_mutex_id' = [to_reacquire_mutex_id EXCEPT ![self] = Thread_Objects[awoken_thread_id'[self]].ghost_Condvar_Wait_Mutex_Id]
                                           /\ Thread_Objects' = [Thread_Objects EXCEPT ![awoken_thread_id'[self]].ghost_Condvar_Wait_Mutex_Id = "Invalid_Mutex_Id",
                                                                                       ![awoken_thread_id'[self]].Waiting_On_Condvar_Id = "Invalid_Condvar_Id"]
                                           /\ pc' = [pc EXCEPT ![self] = "signal_condvar_check_if_mutex_reacquire_needed_step"]
                                           /\ UNCHANGED << HiRTOS,
                                                           Mutex_Objects,
                                                           Timer_Objects,
                                                           Global_Resource_Available,
                                                           stack, thread_id_,
                                                           mutex_id_,
                                                           waking_up_thread_after_condvar_wait,
                                                           owner_thread_id_,
                                                           thread_id_A,
                                                           mutex_id_A,
                                                           owner_thread_id,
                                                           thread_id_D,
                                                           mutex_id_D,
                                                           doing_condvar_wait,
                                                           awoken_thread_id_,
                                                           thread_id_R,
                                                           mutex_id_R,
                                                           thread_id_Do,
                                                           condvar_id_,
                                                           mutex_id_Do,
                                                           thread_id_W,
                                                           condvar_id_W,
                                                           mutex_id,
                                                           condvar_id_D,
                                                           do_context_switch,
                                                           context_id_,
                                                           condvar_id_S,
                                                           context_id,
                                                           condvar_id,
                                                           thread_was_awaken,
                                                           thread_id,
                                                           delayed_threads >>

signal_condvar_check_if_mutex_reacquire_needed_step(self) == /\ pc[self] = "signal_condvar_check_if_mutex_reacquire_needed_step"
                                                             /\ IF to_reacquire_mutex_id[self] /= "Invalid_Mutex_Id"
                                                                   THEN /\ pc' = [pc EXCEPT ![self] = "signal_condvar_reacquire_mutex_step"]
                                                                   ELSE /\ pc' = [pc EXCEPT ![self] = "signal_condvar_awoken_thread_runnable_step"]
                                                             /\ UNCHANGED << HiRTOS,
                                                                             Thread_Objects,
                                                                             Mutex_Objects,
                                                                             Condvar_Objects,
                                                                             Timer_Objects,
                                                                             Global_Resource_Available,
                                                                             stack,
                                                                             thread_id_,
                                                                             mutex_id_,
                                                                             waking_up_thread_after_condvar_wait,
                                                                             owner_thread_id_,
                                                                             thread_id_A,
                                                                             mutex_id_A,
                                                                             owner_thread_id,
                                                                             thread_id_D,
                                                                             mutex_id_D,
                                                                             doing_condvar_wait,
                                                                             awoken_thread_id_,
                                                                             thread_id_R,
                                                                             mutex_id_R,
                                                                             thread_id_Do,
                                                                             condvar_id_,
                                                                             mutex_id_Do,
                                                                             thread_id_W,
                                                                             condvar_id_W,
                                                                             mutex_id,
                                                                             condvar_id_D,
                                                                             do_context_switch,
                                                                             awoken_thread_id,
                                                                             to_reacquire_mutex_id,
                                                                             context_id_,
                                                                             condvar_id_S,
                                                                             context_id,
                                                                             condvar_id,
                                                                             thread_was_awaken,
                                                                             thread_id,
                                                                             delayed_threads >>

signal_condvar_reacquire_mutex_step(self) == /\ pc[self] = "signal_condvar_reacquire_mutex_step"
                                             /\ /\ mutex_id_' = [mutex_id_ EXCEPT ![self] = to_reacquire_mutex_id[self]]
                                                /\ stack' = [stack EXCEPT ![self] = << [ procedure |->  "Do_Acquire_Mutex",
                                                                                         pc        |->  "signal_condvar_check_if_sync_context_switch_needed_step",
                                                                                         owner_thread_id_ |->  owner_thread_id_[self],
                                                                                         thread_id_ |->  thread_id_[self],
                                                                                         mutex_id_ |->  mutex_id_[self],
                                                                                         waking_up_thread_after_condvar_wait |->  waking_up_thread_after_condvar_wait[self] ] >>
                                                                                     \o stack[self]]
                                                /\ thread_id_' = [thread_id_ EXCEPT ![self] = awoken_thread_id[self]]
                                                /\ waking_up_thread_after_condvar_wait' = [waking_up_thread_after_condvar_wait EXCEPT ![self] = TRUE]
                                             /\ owner_thread_id_' = [owner_thread_id_ EXCEPT ![self] = "Invalid_Thread_Id"]
                                             /\ pc' = [pc EXCEPT ![self] = "acquire_mutex_step_"]
                                             /\ UNCHANGED << HiRTOS,
                                                             Thread_Objects,
                                                             Mutex_Objects,
                                                             Condvar_Objects,
                                                             Timer_Objects,
                                                             Global_Resource_Available,
                                                             thread_id_A,
                                                             mutex_id_A,
                                                             owner_thread_id,
                                                             thread_id_D,
                                                             mutex_id_D,
                                                             doing_condvar_wait,
                                                             awoken_thread_id_,
                                                             thread_id_R,
                                                             mutex_id_R,
                                                             thread_id_Do,
                                                             condvar_id_,
                                                             mutex_id_Do,
                                                             thread_id_W,
                                                             condvar_id_W,
                                                             mutex_id,
                                                             condvar_id_D,
                                                             do_context_switch,
                                                             awoken_thread_id,
                                                             to_reacquire_mutex_id,
                                                             context_id_,
                                                             condvar_id_S,
                                                             context_id,
                                                             condvar_id,
                                                             thread_was_awaken,
                                                             thread_id,
                                                             delayed_threads >>

signal_condvar_awoken_thread_runnable_step(self) == /\ pc[self] = "signal_condvar_awoken_thread_runnable_step"
                                                    /\ /\ HiRTOS' = [HiRTOS EXCEPT !.Runnable_Threads_Queue = Enqueue_Thread(HiRTOS.Runnable_Threads_Queue, awoken_thread_id[self])]
                                                       /\ Thread_Objects' = [Thread_Objects EXCEPT ![awoken_thread_id[self]].State = "Runnable"]
                                                    /\ pc' = [pc EXCEPT ![self] = "signal_condvar_check_if_sync_context_switch_needed_step"]
                                                    /\ UNCHANGED << Mutex_Objects,
                                                                    Condvar_Objects,
                                                                    Timer_Objects,
                                                                    Global_Resource_Available,
                                                                    stack,
                                                                    thread_id_,
                                                                    mutex_id_,
                                                                    waking_up_thread_after_condvar_wait,
                                                                    owner_thread_id_,
                                                                    thread_id_A,
                                                                    mutex_id_A,
                                                                    owner_thread_id,
                                                                    thread_id_D,
                                                                    mutex_id_D,
                                                                    doing_condvar_wait,
                                                                    awoken_thread_id_,
                                                                    thread_id_R,
                                                                    mutex_id_R,
                                                                    thread_id_Do,
                                                                    condvar_id_,
                                                                    mutex_id_Do,
                                                                    thread_id_W,
                                                                    condvar_id_W,
                                                                    mutex_id,
                                                                    condvar_id_D,
                                                                    do_context_switch,
                                                                    awoken_thread_id,
                                                                    to_reacquire_mutex_id,
                                                                    context_id_,
                                                                    condvar_id_S,
                                                                    context_id,
                                                                    condvar_id,
                                                                    thread_was_awaken,
                                                                    thread_id,
                                                                    delayed_threads >>

signal_condvar_check_if_sync_context_switch_needed_step(self) == /\ pc[self] = "signal_condvar_check_if_sync_context_switch_needed_step"
                                                                 /\ IF do_context_switch[self]
                                                                       THEN /\ pc' = [pc EXCEPT ![self] = "signal_condvar_synchronous_context_switch_step"]
                                                                       ELSE /\ pc' = [pc EXCEPT ![self] = "do_condvar_signal_return_step"]
                                                                 /\ UNCHANGED << HiRTOS,
                                                                                 Thread_Objects,
                                                                                 Mutex_Objects,
                                                                                 Condvar_Objects,
                                                                                 Timer_Objects,
                                                                                 Global_Resource_Available,
                                                                                 stack,
                                                                                 thread_id_,
                                                                                 mutex_id_,
                                                                                 waking_up_thread_after_condvar_wait,
                                                                                 owner_thread_id_,
                                                                                 thread_id_A,
                                                                                 mutex_id_A,
                                                                                 owner_thread_id,
                                                                                 thread_id_D,
                                                                                 mutex_id_D,
                                                                                 doing_condvar_wait,
                                                                                 awoken_thread_id_,
                                                                                 thread_id_R,
                                                                                 mutex_id_R,
                                                                                 thread_id_Do,
                                                                                 condvar_id_,
                                                                                 mutex_id_Do,
                                                                                 thread_id_W,
                                                                                 condvar_id_W,
                                                                                 mutex_id,
                                                                                 condvar_id_D,
                                                                                 do_context_switch,
                                                                                 awoken_thread_id,
                                                                                 to_reacquire_mutex_id,
                                                                                 context_id_,
                                                                                 condvar_id_S,
                                                                                 context_id,
                                                                                 condvar_id,
                                                                                 thread_was_awaken,
                                                                                 thread_id,
                                                                                 delayed_threads >>

signal_condvar_synchronous_context_switch_step(self) == /\ pc[self] = "signal_condvar_synchronous_context_switch_step"
                                                        /\ stack' = [stack EXCEPT ![self] = << [ procedure |->  "Run_Thread_Scheduler",
                                                                                                 pc        |->  "do_condvar_signal_return_step" ] >>
                                                                                             \o stack[self]]
                                                        /\ pc' = [pc EXCEPT ![self] = "check_time_slice_step"]
                                                        /\ UNCHANGED << HiRTOS,
                                                                        Thread_Objects,
                                                                        Mutex_Objects,
                                                                        Condvar_Objects,
                                                                        Timer_Objects,
                                                                        Global_Resource_Available,
                                                                        thread_id_,
                                                                        mutex_id_,
                                                                        waking_up_thread_after_condvar_wait,
                                                                        owner_thread_id_,
                                                                        thread_id_A,
                                                                        mutex_id_A,
                                                                        owner_thread_id,
                                                                        thread_id_D,
                                                                        mutex_id_D,
                                                                        doing_condvar_wait,
                                                                        awoken_thread_id_,
                                                                        thread_id_R,
                                                                        mutex_id_R,
                                                                        thread_id_Do,
                                                                        condvar_id_,
                                                                        mutex_id_Do,
                                                                        thread_id_W,
                                                                        condvar_id_W,
                                                                        mutex_id,
                                                                        condvar_id_D,
                                                                        do_context_switch,
                                                                        awoken_thread_id,
                                                                        to_reacquire_mutex_id,
                                                                        context_id_,
                                                                        condvar_id_S,
                                                                        context_id,
                                                                        condvar_id,
                                                                        thread_was_awaken,
                                                                        thread_id,
                                                                        delayed_threads >>

do_condvar_signal_return_step(self) == /\ pc[self] = "do_condvar_signal_return_step"
                                       /\ pc' = [pc EXCEPT ![self] = Head(stack[self]).pc]
                                       /\ awoken_thread_id' = [awoken_thread_id EXCEPT ![self] = Head(stack[self]).awoken_thread_id]
                                       /\ to_reacquire_mutex_id' = [to_reacquire_mutex_id EXCEPT ![self] = Head(stack[self]).to_reacquire_mutex_id]
                                       /\ condvar_id_D' = [condvar_id_D EXCEPT ![self] = Head(stack[self]).condvar_id_D]
                                       /\ do_context_switch' = [do_context_switch EXCEPT ![self] = Head(stack[self]).do_context_switch]
                                       /\ stack' = [stack EXCEPT ![self] = Tail(stack[self])]
                                       /\ UNCHANGED << HiRTOS, Thread_Objects,
                                                       Mutex_Objects,
                                                       Condvar_Objects,
                                                       Timer_Objects,
                                                       Global_Resource_Available,
                                                       thread_id_, mutex_id_,
                                                       waking_up_thread_after_condvar_wait,
                                                       owner_thread_id_,
                                                       thread_id_A, mutex_id_A,
                                                       owner_thread_id,
                                                       thread_id_D, mutex_id_D,
                                                       doing_condvar_wait,
                                                       awoken_thread_id_,
                                                       thread_id_R, mutex_id_R,
                                                       thread_id_Do,
                                                       condvar_id_,
                                                       mutex_id_Do,
                                                       thread_id_W,
                                                       condvar_id_W, mutex_id,
                                                       context_id_,
                                                       condvar_id_S,
                                                       context_id, condvar_id,
                                                       thread_was_awaken,
                                                       thread_id,
                                                       delayed_threads >>

Do_Signal_Condvar(self) == signal_condvar_step(self)
                              \/ signal_condvar_wakeup_waiter_step(self)
                              \/ signal_condvar_check_if_mutex_reacquire_needed_step(self)
                              \/ signal_condvar_reacquire_mutex_step(self)
                              \/ signal_condvar_awoken_thread_runnable_step(self)
                              \/ signal_condvar_check_if_sync_context_switch_needed_step(self)
                              \/ signal_condvar_synchronous_context_switch_step(self)
                              \/ do_condvar_signal_return_step(self)

enter_critical_section_step_S(self) == /\ pc[self] = "enter_critical_section_step_S"
                                       /\ HiRTOS.Interrupts_Enabled /\
                                          (context_id_[self] \in Threads =>
                                              Thread_Objects[context_id_[self]].State = "Running")
                                       /\ HiRTOS' = [HiRTOS EXCEPT !.Interrupts_Enabled = FALSE]
                                       /\ /\ condvar_id_D' = [condvar_id_D EXCEPT ![self] = condvar_id_S[self]]
                                          /\ do_context_switch' = [do_context_switch EXCEPT ![self] = TRUE]
                                          /\ stack' = [stack EXCEPT ![self] = << [ procedure |->  "Do_Signal_Condvar",
                                                                                   pc        |->  "exit_critical_section_step_S",
                                                                                   awoken_thread_id |->  awoken_thread_id[self],
                                                                                   to_reacquire_mutex_id |->  to_reacquire_mutex_id[self],
                                                                                   condvar_id_D |->  condvar_id_D[self],
                                                                                   do_context_switch |->  do_context_switch[self] ] >>
                                                                               \o stack[self]]
                                       /\ awoken_thread_id' = [awoken_thread_id EXCEPT ![self] = "Invalid_Thread_Id"]
                                       /\ to_reacquire_mutex_id' = [to_reacquire_mutex_id EXCEPT ![self] = "Invalid_Mutex_Id"]
                                       /\ pc' = [pc EXCEPT ![self] = "signal_condvar_step"]
                                       /\ UNCHANGED << Thread_Objects,
                                                       Mutex_Objects,
                                                       Condvar_Objects,
                                                       Timer_Objects,
                                                       Global_Resource_Available,
                                                       thread_id_, mutex_id_,
                                                       waking_up_thread_after_condvar_wait,
                                                       owner_thread_id_,
                                                       thread_id_A, mutex_id_A,
                                                       owner_thread_id,
                                                       thread_id_D, mutex_id_D,
                                                       doing_condvar_wait,
                                                       awoken_thread_id_,
                                                       thread_id_R, mutex_id_R,
                                                       thread_id_Do,
                                                       condvar_id_,
                                                       mutex_id_Do,
                                                       thread_id_W,
                                                       condvar_id_W, mutex_id,
                                                       context_id_,
                                                       condvar_id_S,
                                                       context_id, condvar_id,
                                                       thread_was_awaken,
                                                       thread_id,
                                                       delayed_threads >>

exit_critical_section_step_S(self) == /\ pc[self] = "exit_critical_section_step_S"
                                      /\ HiRTOS' = [HiRTOS EXCEPT !.Interrupts_Enabled = TRUE]
                                      /\ pc' = [pc EXCEPT ![self] = "condvar_signaled_step"]
                                      /\ UNCHANGED << Thread_Objects,
                                                      Mutex_Objects,
                                                      Condvar_Objects,
                                                      Timer_Objects,
                                                      Global_Resource_Available,
                                                      stack, thread_id_,
                                                      mutex_id_,
                                                      waking_up_thread_after_condvar_wait,
                                                      owner_thread_id_,
                                                      thread_id_A, mutex_id_A,
                                                      owner_thread_id,
                                                      thread_id_D, mutex_id_D,
                                                      doing_condvar_wait,
                                                      awoken_thread_id_,
                                                      thread_id_R, mutex_id_R,
                                                      thread_id_Do,
                                                      condvar_id_, mutex_id_Do,
                                                      thread_id_W,
                                                      condvar_id_W, mutex_id,
                                                      condvar_id_D,
                                                      do_context_switch,
                                                      awoken_thread_id,
                                                      to_reacquire_mutex_id,
                                                      context_id_,
                                                      condvar_id_S, context_id,
                                                      condvar_id,
                                                      thread_was_awaken,
                                                      thread_id,
                                                      delayed_threads >>

condvar_signaled_step(self) == /\ pc[self] = "condvar_signaled_step"
                               /\ pc' = [pc EXCEPT ![self] = Head(stack[self]).pc]
                               /\ context_id_' = [context_id_ EXCEPT ![self] = Head(stack[self]).context_id_]
                               /\ condvar_id_S' = [condvar_id_S EXCEPT ![self] = Head(stack[self]).condvar_id_S]
                               /\ stack' = [stack EXCEPT ![self] = Tail(stack[self])]
                               /\ UNCHANGED << HiRTOS, Thread_Objects,
                                               Mutex_Objects, Condvar_Objects,
                                               Timer_Objects,
                                               Global_Resource_Available,
                                               thread_id_, mutex_id_,
                                               waking_up_thread_after_condvar_wait,
                                               owner_thread_id_, thread_id_A,
                                               mutex_id_A, owner_thread_id,
                                               thread_id_D, mutex_id_D,
                                               doing_condvar_wait,
                                               awoken_thread_id_, thread_id_R,
                                               mutex_id_R, thread_id_Do,
                                               condvar_id_, mutex_id_Do,
                                               thread_id_W, condvar_id_W,
                                               mutex_id, condvar_id_D,
                                               do_context_switch,
                                               awoken_thread_id,
                                               to_reacquire_mutex_id,
                                               context_id, condvar_id,
                                               thread_was_awaken, thread_id,
                                               delayed_threads >>

Signal_Condvar(self) == enter_critical_section_step_S(self)
                           \/ exit_critical_section_step_S(self)
                           \/ condvar_signaled_step(self)

enter_critical_section_step_B(self) == /\ pc[self] = "enter_critical_section_step_B"
                                       /\ HiRTOS.Interrupts_Enabled /\
                                          (context_id[self] \in Threads =>
                                              Thread_Objects[context_id[self]].State = "Running")
                                       /\ HiRTOS' = [HiRTOS EXCEPT !.Interrupts_Enabled = FALSE]
                                       /\ pc' = [pc EXCEPT ![self] = "broadcast_condvar_step"]
                                       /\ UNCHANGED << Thread_Objects,
                                                       Mutex_Objects,
                                                       Condvar_Objects,
                                                       Timer_Objects,
                                                       Global_Resource_Available,
                                                       stack, thread_id_,
                                                       mutex_id_,
                                                       waking_up_thread_after_condvar_wait,
                                                       owner_thread_id_,
                                                       thread_id_A, mutex_id_A,
                                                       owner_thread_id,
                                                       thread_id_D, mutex_id_D,
                                                       doing_condvar_wait,
                                                       awoken_thread_id_,
                                                       thread_id_R, mutex_id_R,
                                                       thread_id_Do,
                                                       condvar_id_,
                                                       mutex_id_Do,
                                                       thread_id_W,
                                                       condvar_id_W, mutex_id,
                                                       condvar_id_D,
                                                       do_context_switch,
                                                       awoken_thread_id,
                                                       to_reacquire_mutex_id,
                                                       context_id_,
                                                       condvar_id_S,
                                                       context_id, condvar_id,
                                                       thread_was_awaken,
                                                       thread_id,
                                                       delayed_threads >>

broadcast_condvar_step(self) == /\ pc[self] = "broadcast_condvar_step"
                                /\ IF ~Is_Thread_Priority_Queue_Empty(Condvar_Objects[condvar_id[self]].Waiting_Threads_Queue)
                                      THEN /\ pc' = [pc EXCEPT ![self] = "broadcast_condvar_wakeup_waiter_step"]
                                      ELSE /\ pc' = [pc EXCEPT ![self] = "broadcast_condvar_check_if_sync_context_switch_needed_step"]
                                /\ UNCHANGED << HiRTOS, Thread_Objects,
                                                Mutex_Objects, Condvar_Objects,
                                                Timer_Objects,
                                                Global_Resource_Available,
                                                stack, thread_id_, mutex_id_,
                                                waking_up_thread_after_condvar_wait,
                                                owner_thread_id_, thread_id_A,
                                                mutex_id_A, owner_thread_id,
                                                thread_id_D, mutex_id_D,
                                                doing_condvar_wait,
                                                awoken_thread_id_, thread_id_R,
                                                mutex_id_R, thread_id_Do,
                                                condvar_id_, mutex_id_Do,
                                                thread_id_W, condvar_id_W,
                                                mutex_id, condvar_id_D,
                                                do_context_switch,
                                                awoken_thread_id,
                                                to_reacquire_mutex_id,
                                                context_id_, condvar_id_S,
                                                context_id, condvar_id,
                                                thread_was_awaken, thread_id,
                                                delayed_threads >>

broadcast_condvar_wakeup_waiter_step(self) == /\ pc[self] = "broadcast_condvar_wakeup_waiter_step"
                                              /\ /\ condvar_id_D' = [condvar_id_D EXCEPT ![self] = condvar_id[self]]
                                                 /\ do_context_switch' = [do_context_switch EXCEPT ![self] = FALSE]
                                                 /\ stack' = [stack EXCEPT ![self] = << [ procedure |->  "Do_Signal_Condvar",
                                                                                          pc        |->  "broadcast_condvar_after_waking_up_one_waiter_step",
                                                                                          awoken_thread_id |->  awoken_thread_id[self],
                                                                                          to_reacquire_mutex_id |->  to_reacquire_mutex_id[self],
                                                                                          condvar_id_D |->  condvar_id_D[self],
                                                                                          do_context_switch |->  do_context_switch[self] ] >>
                                                                                      \o stack[self]]
                                              /\ awoken_thread_id' = [awoken_thread_id EXCEPT ![self] = "Invalid_Thread_Id"]
                                              /\ to_reacquire_mutex_id' = [to_reacquire_mutex_id EXCEPT ![self] = "Invalid_Mutex_Id"]
                                              /\ pc' = [pc EXCEPT ![self] = "signal_condvar_step"]
                                              /\ UNCHANGED << HiRTOS,
                                                              Thread_Objects,
                                                              Mutex_Objects,
                                                              Condvar_Objects,
                                                              Timer_Objects,
                                                              Global_Resource_Available,
                                                              thread_id_,
                                                              mutex_id_,
                                                              waking_up_thread_after_condvar_wait,
                                                              owner_thread_id_,
                                                              thread_id_A,
                                                              mutex_id_A,
                                                              owner_thread_id,
                                                              thread_id_D,
                                                              mutex_id_D,
                                                              doing_condvar_wait,
                                                              awoken_thread_id_,
                                                              thread_id_R,
                                                              mutex_id_R,
                                                              thread_id_Do,
                                                              condvar_id_,
                                                              mutex_id_Do,
                                                              thread_id_W,
                                                              condvar_id_W,
                                                              mutex_id,
                                                              context_id_,
                                                              condvar_id_S,
                                                              context_id,
                                                              condvar_id,
                                                              thread_was_awaken,
                                                              thread_id,
                                                              delayed_threads >>

broadcast_condvar_after_waking_up_one_waiter_step(self) == /\ pc[self] = "broadcast_condvar_after_waking_up_one_waiter_step"
                                                           /\ thread_was_awaken' = [thread_was_awaken EXCEPT ![self] = TRUE]
                                                           /\ pc' = [pc EXCEPT ![self] = "broadcast_condvar_step"]
                                                           /\ UNCHANGED << HiRTOS,
                                                                           Thread_Objects,
                                                                           Mutex_Objects,
                                                                           Condvar_Objects,
                                                                           Timer_Objects,
                                                                           Global_Resource_Available,
                                                                           stack,
                                                                           thread_id_,
                                                                           mutex_id_,
                                                                           waking_up_thread_after_condvar_wait,
                                                                           owner_thread_id_,
                                                                           thread_id_A,
                                                                           mutex_id_A,
                                                                           owner_thread_id,
                                                                           thread_id_D,
                                                                           mutex_id_D,
                                                                           doing_condvar_wait,
                                                                           awoken_thread_id_,
                                                                           thread_id_R,
                                                                           mutex_id_R,
                                                                           thread_id_Do,
                                                                           condvar_id_,
                                                                           mutex_id_Do,
                                                                           thread_id_W,
                                                                           condvar_id_W,
                                                                           mutex_id,
                                                                           condvar_id_D,
                                                                           do_context_switch,
                                                                           awoken_thread_id,
                                                                           to_reacquire_mutex_id,
                                                                           context_id_,
                                                                           condvar_id_S,
                                                                           context_id,
                                                                           condvar_id,
                                                                           thread_id,
                                                                           delayed_threads >>

broadcast_condvar_check_if_sync_context_switch_needed_step(self) == /\ pc[self] = "broadcast_condvar_check_if_sync_context_switch_needed_step"
                                                                    /\ IF context_id[self] \in Threads /\ thread_was_awaken[self]
                                                                          THEN /\ pc' = [pc EXCEPT ![self] = "broadcast_condvar_synchronous_context_switch_step"]
                                                                          ELSE /\ pc' = [pc EXCEPT ![self] = "exit_critical_section_step_B"]
                                                                    /\ UNCHANGED << HiRTOS,
                                                                                    Thread_Objects,
                                                                                    Mutex_Objects,
                                                                                    Condvar_Objects,
                                                                                    Timer_Objects,
                                                                                    Global_Resource_Available,
                                                                                    stack,
                                                                                    thread_id_,
                                                                                    mutex_id_,
                                                                                    waking_up_thread_after_condvar_wait,
                                                                                    owner_thread_id_,
                                                                                    thread_id_A,
                                                                                    mutex_id_A,
                                                                                    owner_thread_id,
                                                                                    thread_id_D,
                                                                                    mutex_id_D,
                                                                                    doing_condvar_wait,
                                                                                    awoken_thread_id_,
                                                                                    thread_id_R,
                                                                                    mutex_id_R,
                                                                                    thread_id_Do,
                                                                                    condvar_id_,
                                                                                    mutex_id_Do,
                                                                                    thread_id_W,
                                                                                    condvar_id_W,
                                                                                    mutex_id,
                                                                                    condvar_id_D,
                                                                                    do_context_switch,
                                                                                    awoken_thread_id,
                                                                                    to_reacquire_mutex_id,
                                                                                    context_id_,
                                                                                    condvar_id_S,
                                                                                    context_id,
                                                                                    condvar_id,
                                                                                    thread_was_awaken,
                                                                                    thread_id,
                                                                                    delayed_threads >>

broadcast_condvar_synchronous_context_switch_step(self) == /\ pc[self] = "broadcast_condvar_synchronous_context_switch_step"
                                                           /\ stack' = [stack EXCEPT ![self] = << [ procedure |->  "Run_Thread_Scheduler",
                                                                                                    pc        |->  "exit_critical_section_step_B" ] >>
                                                                                                \o stack[self]]
                                                           /\ pc' = [pc EXCEPT ![self] = "check_time_slice_step"]
                                                           /\ UNCHANGED << HiRTOS,
                                                                           Thread_Objects,
                                                                           Mutex_Objects,
                                                                           Condvar_Objects,
                                                                           Timer_Objects,
                                                                           Global_Resource_Available,
                                                                           thread_id_,
                                                                           mutex_id_,
                                                                           waking_up_thread_after_condvar_wait,
                                                                           owner_thread_id_,
                                                                           thread_id_A,
                                                                           mutex_id_A,
                                                                           owner_thread_id,
                                                                           thread_id_D,
                                                                           mutex_id_D,
                                                                           doing_condvar_wait,
                                                                           awoken_thread_id_,
                                                                           thread_id_R,
                                                                           mutex_id_R,
                                                                           thread_id_Do,
                                                                           condvar_id_,
                                                                           mutex_id_Do,
                                                                           thread_id_W,
                                                                           condvar_id_W,
                                                                           mutex_id,
                                                                           condvar_id_D,
                                                                           do_context_switch,
                                                                           awoken_thread_id,
                                                                           to_reacquire_mutex_id,
                                                                           context_id_,
                                                                           condvar_id_S,
                                                                           context_id,
                                                                           condvar_id,
                                                                           thread_was_awaken,
                                                                           thread_id,
                                                                           delayed_threads >>

exit_critical_section_step_B(self) == /\ pc[self] = "exit_critical_section_step_B"
                                      /\ HiRTOS' = [HiRTOS EXCEPT !.Interrupts_Enabled = TRUE]
                                      /\ pc' = [pc EXCEPT ![self] = "condvar_broadcasted_step"]
                                      /\ UNCHANGED << Thread_Objects,
                                                      Mutex_Objects,
                                                      Condvar_Objects,
                                                      Timer_Objects,
                                                      Global_Resource_Available,
                                                      stack, thread_id_,
                                                      mutex_id_,
                                                      waking_up_thread_after_condvar_wait,
                                                      owner_thread_id_,
                                                      thread_id_A, mutex_id_A,
                                                      owner_thread_id,
                                                      thread_id_D, mutex_id_D,
                                                      doing_condvar_wait,
                                                      awoken_thread_id_,
                                                      thread_id_R, mutex_id_R,
                                                      thread_id_Do,
                                                      condvar_id_, mutex_id_Do,
                                                      thread_id_W,
                                                      condvar_id_W, mutex_id,
                                                      condvar_id_D,
                                                      do_context_switch,
                                                      awoken_thread_id,
                                                      to_reacquire_mutex_id,
                                                      context_id_,
                                                      condvar_id_S, context_id,
                                                      condvar_id,
                                                      thread_was_awaken,
                                                      thread_id,
                                                      delayed_threads >>

condvar_broadcasted_step(self) == /\ pc[self] = "condvar_broadcasted_step"
                                  /\ pc' = [pc EXCEPT ![self] = Head(stack[self]).pc]
                                  /\ thread_was_awaken' = [thread_was_awaken EXCEPT ![self] = Head(stack[self]).thread_was_awaken]
                                  /\ context_id' = [context_id EXCEPT ![self] = Head(stack[self]).context_id]
                                  /\ condvar_id' = [condvar_id EXCEPT ![self] = Head(stack[self]).condvar_id]
                                  /\ stack' = [stack EXCEPT ![self] = Tail(stack[self])]
                                  /\ UNCHANGED << HiRTOS, Thread_Objects,
                                                  Mutex_Objects,
                                                  Condvar_Objects,
                                                  Timer_Objects,
                                                  Global_Resource_Available,
                                                  thread_id_, mutex_id_,
                                                  waking_up_thread_after_condvar_wait,
                                                  owner_thread_id_,
                                                  thread_id_A, mutex_id_A,
                                                  owner_thread_id, thread_id_D,
                                                  mutex_id_D,
                                                  doing_condvar_wait,
                                                  awoken_thread_id_,
                                                  thread_id_R, mutex_id_R,
                                                  thread_id_Do, condvar_id_,
                                                  mutex_id_Do, thread_id_W,
                                                  condvar_id_W, mutex_id,
                                                  condvar_id_D,
                                                  do_context_switch,
                                                  awoken_thread_id,
                                                  to_reacquire_mutex_id,
                                                  context_id_, condvar_id_S,
                                                  thread_id, delayed_threads >>

Broadcast_Condvar(self) == enter_critical_section_step_B(self)
                              \/ broadcast_condvar_step(self)
                              \/ broadcast_condvar_wakeup_waiter_step(self)
                              \/ broadcast_condvar_after_waking_up_one_waiter_step(self)
                              \/ broadcast_condvar_check_if_sync_context_switch_needed_step(self)
                              \/ broadcast_condvar_synchronous_context_switch_step(self)
                              \/ exit_critical_section_step_B(self)
                              \/ condvar_broadcasted_step(self)

enter_critical_section_step_D(self) == /\ pc[self] = "enter_critical_section_step_D"
                                       /\ HiRTOS.Interrupts_Enabled /\
                                          (thread_id[self] \in Threads =>
                                              Thread_Objects[thread_id[self]].State = "Running")
                                       /\ HiRTOS' = [HiRTOS EXCEPT !.Interrupts_Enabled = FALSE]
                                       /\ pc' = [pc EXCEPT ![self] = "delay_until_step"]
                                       /\ UNCHANGED << Thread_Objects,
                                                       Mutex_Objects,
                                                       Condvar_Objects,
                                                       Timer_Objects,
                                                       Global_Resource_Available,
                                                       stack, thread_id_,
                                                       mutex_id_,
                                                       waking_up_thread_after_condvar_wait,
                                                       owner_thread_id_,
                                                       thread_id_A, mutex_id_A,
                                                       owner_thread_id,
                                                       thread_id_D, mutex_id_D,
                                                       doing_condvar_wait,
                                                       awoken_thread_id_,
                                                       thread_id_R, mutex_id_R,
                                                       thread_id_Do,
                                                       condvar_id_,
                                                       mutex_id_Do,
                                                       thread_id_W,
                                                       condvar_id_W, mutex_id,
                                                       condvar_id_D,
                                                       do_context_switch,
                                                       awoken_thread_id,
                                                       to_reacquire_mutex_id,
                                                       context_id_,
                                                       condvar_id_S,
                                                       context_id, condvar_id,
                                                       thread_was_awaken,
                                                       thread_id,
                                                       delayed_threads >>

delay_until_step(self) == /\ pc[self] = "delay_until_step"
                          /\ Timer_Objects' = [Timer_Objects EXCEPT ![Thread_Objects[thread_id[self]].Builtin_Timer_Id].State = "Timer_Running"]
                          /\ /\ condvar_id_' = [condvar_id_ EXCEPT ![self] = Thread_Objects[thread_id[self]].Builtin_Condvar_Id]
                             /\ mutex_id_Do' = [mutex_id_Do EXCEPT ![self] = "Invalid_Mutex_Id"]
                             /\ stack' = [stack EXCEPT ![self] = << [ procedure |->  "Do_Wait_On_Condvar",
                                                                      pc        |->  "exit_critical_section_step_D",
                                                                      thread_id_Do |->  thread_id_Do[self],
                                                                      condvar_id_ |->  condvar_id_[self],
                                                                      mutex_id_Do |->  mutex_id_Do[self] ] >>
                                                                  \o stack[self]]
                             /\ thread_id_Do' = [thread_id_Do EXCEPT ![self] = thread_id[self]]
                          /\ pc' = [pc EXCEPT ![self] = "wait_on_condvar_wait_step"]
                          /\ UNCHANGED << HiRTOS, Thread_Objects,
                                          Mutex_Objects, Condvar_Objects,
                                          Global_Resource_Available,
                                          thread_id_, mutex_id_,
                                          waking_up_thread_after_condvar_wait,
                                          owner_thread_id_, thread_id_A,
                                          mutex_id_A, owner_thread_id,
                                          thread_id_D, mutex_id_D,
                                          doing_condvar_wait,
                                          awoken_thread_id_, thread_id_R,
                                          mutex_id_R, thread_id_W,
                                          condvar_id_W, mutex_id, condvar_id_D,
                                          do_context_switch, awoken_thread_id,
                                          to_reacquire_mutex_id, context_id_,
                                          condvar_id_S, context_id, condvar_id,
                                          thread_was_awaken, thread_id,
                                          delayed_threads >>

exit_critical_section_step_D(self) == /\ pc[self] = "exit_critical_section_step_D"
                                      /\ HiRTOS' = [HiRTOS EXCEPT !.Interrupts_Enabled = TRUE]
                                      /\ pc' = [pc EXCEPT ![self] = "after_delay_until_step"]
                                      /\ UNCHANGED << Thread_Objects,
                                                      Mutex_Objects,
                                                      Condvar_Objects,
                                                      Timer_Objects,
                                                      Global_Resource_Available,
                                                      stack, thread_id_,
                                                      mutex_id_,
                                                      waking_up_thread_after_condvar_wait,
                                                      owner_thread_id_,
                                                      thread_id_A, mutex_id_A,
                                                      owner_thread_id,
                                                      thread_id_D, mutex_id_D,
                                                      doing_condvar_wait,
                                                      awoken_thread_id_,
                                                      thread_id_R, mutex_id_R,
                                                      thread_id_Do,
                                                      condvar_id_, mutex_id_Do,
                                                      thread_id_W,
                                                      condvar_id_W, mutex_id,
                                                      condvar_id_D,
                                                      do_context_switch,
                                                      awoken_thread_id,
                                                      to_reacquire_mutex_id,
                                                      context_id_,
                                                      condvar_id_S, context_id,
                                                      condvar_id,
                                                      thread_was_awaken,
                                                      thread_id,
                                                      delayed_threads >>

after_delay_until_step(self) == /\ pc[self] = "after_delay_until_step"
                                /\ pc' = [pc EXCEPT ![self] = Head(stack[self]).pc]
                                /\ thread_id' = [thread_id EXCEPT ![self] = Head(stack[self]).thread_id]
                                /\ stack' = [stack EXCEPT ![self] = Tail(stack[self])]
                                /\ UNCHANGED << HiRTOS, Thread_Objects,
                                                Mutex_Objects, Condvar_Objects,
                                                Timer_Objects,
                                                Global_Resource_Available,
                                                thread_id_, mutex_id_,
                                                waking_up_thread_after_condvar_wait,
                                                owner_thread_id_, thread_id_A,
                                                mutex_id_A, owner_thread_id,
                                                thread_id_D, mutex_id_D,
                                                doing_condvar_wait,
                                                awoken_thread_id_, thread_id_R,
                                                mutex_id_R, thread_id_Do,
                                                condvar_id_, mutex_id_Do,
                                                thread_id_W, condvar_id_W,
                                                mutex_id, condvar_id_D,
                                                do_context_switch,
                                                awoken_thread_id,
                                                to_reacquire_mutex_id,
                                                context_id_, condvar_id_S,
                                                context_id, condvar_id,
                                                thread_was_awaken,
                                                delayed_threads >>

Delay_Until(self) == enter_critical_section_step_D(self)
                        \/ delay_until_step(self)
                        \/ exit_critical_section_step_D(self)
                        \/ after_delay_until_step(self)

thread_state_machine_next_state_loop(self) == /\ pc[self] = "thread_state_machine_next_state_loop"
                                              /\ Thread_Objects[self].State = "Running" /\ HiRTOS.Interrupts_Enabled
                                              /\ pc' = [pc EXCEPT ![self] = "context_switch0"]
                                              /\ UNCHANGED << HiRTOS,
                                                              Thread_Objects,
                                                              Mutex_Objects,
                                                              Condvar_Objects,
                                                              Timer_Objects,
                                                              Global_Resource_Available,
                                                              stack,
                                                              thread_id_,
                                                              mutex_id_,
                                                              waking_up_thread_after_condvar_wait,
                                                              owner_thread_id_,
                                                              thread_id_A,
                                                              mutex_id_A,
                                                              owner_thread_id,
                                                              thread_id_D,
                                                              mutex_id_D,
                                                              doing_condvar_wait,
                                                              awoken_thread_id_,
                                                              thread_id_R,
                                                              mutex_id_R,
                                                              thread_id_Do,
                                                              condvar_id_,
                                                              mutex_id_Do,
                                                              thread_id_W,
                                                              condvar_id_W,
                                                              mutex_id,
                                                              condvar_id_D,
                                                              do_context_switch,
                                                              awoken_thread_id,
                                                              to_reacquire_mutex_id,
                                                              context_id_,
                                                              condvar_id_S,
                                                              context_id,
                                                              condvar_id,
                                                              thread_was_awaken,
                                                              thread_id,
                                                              delayed_threads >>

context_switch0(self) == /\ pc[self] = "context_switch0"
                         /\ \/ /\ pc' = [pc EXCEPT ![self] = "acquire_mutex_step"]
                               /\ UNCHANGED <<Global_Resource_Available, stack, context_id_, condvar_id_S, context_id, condvar_id, thread_was_awaken, thread_id>>
                            \/ /\ Global_Resource_Available' = TRUE
                               /\ \/ /\ /\ condvar_id_S' = [condvar_id_S EXCEPT ![self] = "condvar1"]
                                        /\ context_id_' = [context_id_ EXCEPT ![self] = self]
                                        /\ stack' = [stack EXCEPT ![self] = << [ procedure |->  "Signal_Condvar",
                                                                                 pc        |->  "thread_iteration_completed_step",
                                                                                 context_id_ |->  context_id_[self],
                                                                                 condvar_id_S |->  condvar_id_S[self] ] >>
                                                                             \o stack[self]]
                                     /\ pc' = [pc EXCEPT ![self] = "enter_critical_section_step_S"]
                                     /\ UNCHANGED <<context_id, condvar_id, thread_was_awaken>>
                                  \/ /\ /\ condvar_id' = [condvar_id EXCEPT ![self] = "condvar1"]
                                        /\ context_id' = [context_id EXCEPT ![self] = self]
                                        /\ stack' = [stack EXCEPT ![self] = << [ procedure |->  "Broadcast_Condvar",
                                                                                 pc        |->  "thread_iteration_completed_step",
                                                                                 thread_was_awaken |->  thread_was_awaken[self],
                                                                                 context_id |->  context_id[self],
                                                                                 condvar_id |->  condvar_id[self] ] >>
                                                                             \o stack[self]]
                                     /\ thread_was_awaken' = [thread_was_awaken EXCEPT ![self] = FALSE]
                                     /\ pc' = [pc EXCEPT ![self] = "enter_critical_section_step_B"]
                                     /\ UNCHANGED <<context_id_, condvar_id_S>>
                               /\ UNCHANGED thread_id
                            \/ /\ /\ stack' = [stack EXCEPT ![self] = << [ procedure |->  "Delay_Until",
                                                                           pc        |->  "thread_iteration_completed_step",
                                                                           thread_id |->  thread_id[self] ] >>
                                                                       \o stack[self]]
                                  /\ thread_id' = [thread_id EXCEPT ![self] = self]
                               /\ pc' = [pc EXCEPT ![self] = "enter_critical_section_step_D"]
                               /\ UNCHANGED <<Global_Resource_Available, context_id_, condvar_id_S, context_id, condvar_id, thread_was_awaken>>
                         /\ UNCHANGED << HiRTOS, Thread_Objects, Mutex_Objects,
                                         Condvar_Objects, Timer_Objects,
                                         thread_id_, mutex_id_,
                                         waking_up_thread_after_condvar_wait,
                                         owner_thread_id_, thread_id_A,
                                         mutex_id_A, owner_thread_id,
                                         thread_id_D, mutex_id_D,
                                         doing_condvar_wait, awoken_thread_id_,
                                         thread_id_R, mutex_id_R, thread_id_Do,
                                         condvar_id_, mutex_id_Do, thread_id_W,
                                         condvar_id_W, mutex_id, condvar_id_D,
                                         do_context_switch, awoken_thread_id,
                                         to_reacquire_mutex_id,
                                         delayed_threads >>

acquire_mutex_step(self) == /\ pc[self] = "acquire_mutex_step"
                            /\ /\ mutex_id_A' = [mutex_id_A EXCEPT ![self] = "mutex1"]
                               /\ stack' = [stack EXCEPT ![self] = << [ procedure |->  "Acquire_Mutex",
                                                                        pc        |->  "context_switch1",
                                                                        owner_thread_id |->  owner_thread_id[self],
                                                                        thread_id_A |->  thread_id_A[self],
                                                                        mutex_id_A |->  mutex_id_A[self] ] >>
                                                                    \o stack[self]]
                               /\ thread_id_A' = [thread_id_A EXCEPT ![self] = self]
                            /\ owner_thread_id' = [owner_thread_id EXCEPT ![self] = "Invalid_Thread_Id"]
                            /\ pc' = [pc EXCEPT ![self] = "enter_critical_section_step_"]
                            /\ UNCHANGED << HiRTOS, Thread_Objects,
                                            Mutex_Objects, Condvar_Objects,
                                            Timer_Objects,
                                            Global_Resource_Available,
                                            thread_id_, mutex_id_,
                                            waking_up_thread_after_condvar_wait,
                                            owner_thread_id_, thread_id_D,
                                            mutex_id_D, doing_condvar_wait,
                                            awoken_thread_id_, thread_id_R,
                                            mutex_id_R, thread_id_Do,
                                            condvar_id_, mutex_id_Do,
                                            thread_id_W, condvar_id_W,
                                            mutex_id, condvar_id_D,
                                            do_context_switch,
                                            awoken_thread_id,
                                            to_reacquire_mutex_id, context_id_,
                                            condvar_id_S, context_id,
                                            condvar_id, thread_was_awaken,
                                            thread_id, delayed_threads >>

context_switch1(self) == /\ pc[self] = "context_switch1"
                         /\ Thread_Objects[self].State = "Running" /\ HiRTOS.Interrupts_Enabled
                         /\ Assert((Mutex_Objects["mutex1"].Owner_Thread_Id = self),
                                   "Failure of assertion at line 554, column 13.")
                         /\ \/ /\ pc' = [pc EXCEPT ![self] = "waiting_for_resource_step"]
                            \/ /\ TRUE
                               /\ pc' = [pc EXCEPT ![self] = "release_mutex_step"]
                         /\ UNCHANGED << HiRTOS, Thread_Objects, Mutex_Objects,
                                         Condvar_Objects, Timer_Objects,
                                         Global_Resource_Available, stack,
                                         thread_id_, mutex_id_,
                                         waking_up_thread_after_condvar_wait,
                                         owner_thread_id_, thread_id_A,
                                         mutex_id_A, owner_thread_id,
                                         thread_id_D, mutex_id_D,
                                         doing_condvar_wait, awoken_thread_id_,
                                         thread_id_R, mutex_id_R, thread_id_Do,
                                         condvar_id_, mutex_id_Do, thread_id_W,
                                         condvar_id_W, mutex_id, condvar_id_D,
                                         do_context_switch, awoken_thread_id,
                                         to_reacquire_mutex_id, context_id_,
                                         condvar_id_S, context_id, condvar_id,
                                         thread_was_awaken, thread_id,
                                         delayed_threads >>

waiting_for_resource_step(self) == /\ pc[self] = "waiting_for_resource_step"
                                   /\ IF ~Global_Resource_Available
                                         THEN /\ /\ condvar_id_W' = [condvar_id_W EXCEPT ![self] = "condvar1"]
                                                 /\ mutex_id' = [mutex_id EXCEPT ![self] = "mutex1"]
                                                 /\ stack' = [stack EXCEPT ![self] = << [ procedure |->  "Wait_On_Condvar",
                                                                                          pc        |->  "context_switch2",
                                                                                          thread_id_W |->  thread_id_W[self],
                                                                                          condvar_id_W |->  condvar_id_W[self],
                                                                                          mutex_id  |->  mutex_id[self] ] >>
                                                                                      \o stack[self]]
                                                 /\ thread_id_W' = [thread_id_W EXCEPT ![self] = self]
                                              /\ pc' = [pc EXCEPT ![self] = "enter_critical_section_step_W"]
                                              /\ UNCHANGED Global_Resource_Available
                                         ELSE /\ Global_Resource_Available' = FALSE
                                              /\ pc' = [pc EXCEPT ![self] = "release_mutex_step"]
                                              /\ UNCHANGED << stack,
                                                              thread_id_W,
                                                              condvar_id_W,
                                                              mutex_id >>
                                   /\ UNCHANGED << HiRTOS, Thread_Objects,
                                                   Mutex_Objects,
                                                   Condvar_Objects,
                                                   Timer_Objects, thread_id_,
                                                   mutex_id_,
                                                   waking_up_thread_after_condvar_wait,
                                                   owner_thread_id_,
                                                   thread_id_A, mutex_id_A,
                                                   owner_thread_id,
                                                   thread_id_D, mutex_id_D,
                                                   doing_condvar_wait,
                                                   awoken_thread_id_,
                                                   thread_id_R, mutex_id_R,
                                                   thread_id_Do, condvar_id_,
                                                   mutex_id_Do, condvar_id_D,
                                                   do_context_switch,
                                                   awoken_thread_id,
                                                   to_reacquire_mutex_id,
                                                   context_id_, condvar_id_S,
                                                   context_id, condvar_id,
                                                   thread_was_awaken,
                                                   thread_id, delayed_threads >>

context_switch2(self) == /\ pc[self] = "context_switch2"
                         /\ Thread_Objects[self].State = "Running" /\ HiRTOS.Interrupts_Enabled
                         /\ Assert(Mutex_Objects["mutex1"].Owner_Thread_Id = self,
                                   "Failure of assertion at line 562, column 21.")
                         /\ pc' = [pc EXCEPT ![self] = "waiting_for_resource_step"]
                         /\ UNCHANGED << HiRTOS, Thread_Objects, Mutex_Objects,
                                         Condvar_Objects, Timer_Objects,
                                         Global_Resource_Available, stack,
                                         thread_id_, mutex_id_,
                                         waking_up_thread_after_condvar_wait,
                                         owner_thread_id_, thread_id_A,
                                         mutex_id_A, owner_thread_id,
                                         thread_id_D, mutex_id_D,
                                         doing_condvar_wait, awoken_thread_id_,
                                         thread_id_R, mutex_id_R, thread_id_Do,
                                         condvar_id_, mutex_id_Do, thread_id_W,
                                         condvar_id_W, mutex_id, condvar_id_D,
                                         do_context_switch, awoken_thread_id,
                                         to_reacquire_mutex_id, context_id_,
                                         condvar_id_S, context_id, condvar_id,
                                         thread_was_awaken, thread_id,
                                         delayed_threads >>

release_mutex_step(self) == /\ pc[self] = "release_mutex_step"
                            /\ /\ mutex_id_R' = [mutex_id_R EXCEPT ![self] = "mutex1"]
                               /\ stack' = [stack EXCEPT ![self] = << [ procedure |->  "Release_Mutex",
                                                                        pc        |->  "thread_iteration_completed_step",
                                                                        thread_id_R |->  thread_id_R[self],
                                                                        mutex_id_R |->  mutex_id_R[self] ] >>
                                                                    \o stack[self]]
                               /\ thread_id_R' = [thread_id_R EXCEPT ![self] = self]
                            /\ pc' = [pc EXCEPT ![self] = "enter_critical_section_step_R"]
                            /\ UNCHANGED << HiRTOS, Thread_Objects,
                                            Mutex_Objects, Condvar_Objects,
                                            Timer_Objects,
                                            Global_Resource_Available,
                                            thread_id_, mutex_id_,
                                            waking_up_thread_after_condvar_wait,
                                            owner_thread_id_, thread_id_A,
                                            mutex_id_A, owner_thread_id,
                                            thread_id_D, mutex_id_D,
                                            doing_condvar_wait,
                                            awoken_thread_id_, thread_id_Do,
                                            condvar_id_, mutex_id_Do,
                                            thread_id_W, condvar_id_W,
                                            mutex_id, condvar_id_D,
                                            do_context_switch,
                                            awoken_thread_id,
                                            to_reacquire_mutex_id, context_id_,
                                            condvar_id_S, context_id,
                                            condvar_id, thread_was_awaken,
                                            thread_id, delayed_threads >>

thread_iteration_completed_step(self) == /\ pc[self] = "thread_iteration_completed_step"
                                         /\ TRUE
                                         /\ pc' = [pc EXCEPT ![self] = "thread_state_machine_next_state_loop"]
                                         /\ UNCHANGED << HiRTOS,
                                                         Thread_Objects,
                                                         Mutex_Objects,
                                                         Condvar_Objects,
                                                         Timer_Objects,
                                                         Global_Resource_Available,
                                                         stack, thread_id_,
                                                         mutex_id_,
                                                         waking_up_thread_after_condvar_wait,
                                                         owner_thread_id_,
                                                         thread_id_A,
                                                         mutex_id_A,
                                                         owner_thread_id,
                                                         thread_id_D,
                                                         mutex_id_D,
                                                         doing_condvar_wait,
                                                         awoken_thread_id_,
                                                         thread_id_R,
                                                         mutex_id_R,
                                                         thread_id_Do,
                                                         condvar_id_,
                                                         mutex_id_Do,
                                                         thread_id_W,
                                                         condvar_id_W,
                                                         mutex_id,
                                                         condvar_id_D,
                                                         do_context_switch,
                                                         awoken_thread_id,
                                                         to_reacquire_mutex_id,
                                                         context_id_,
                                                         condvar_id_S,
                                                         context_id,
                                                         condvar_id,
                                                         thread_was_awaken,
                                                         thread_id,
                                                         delayed_threads >>

Thread_State_Machine(self) == thread_state_machine_next_state_loop(self)
                                 \/ context_switch0(self)
                                 \/ acquire_mutex_step(self)
                                 \/ context_switch1(self)
                                 \/ waiting_for_resource_step(self)
                                 \/ context_switch2(self)
                                 \/ release_mutex_step(self)
                                 \/ thread_iteration_completed_step(self)

idle_thread_next_state_loop == /\ pc["Idle_Thread"] = "idle_thread_next_state_loop"
                               /\ Thread_Objects["Idle_Thread"].State = "Running" /\ HiRTOS.Interrupts_Enabled
                               /\ pc' = [pc EXCEPT !["Idle_Thread"] = "idle_thread_next_state_loop"]
                               /\ UNCHANGED << HiRTOS, Thread_Objects,
                                               Mutex_Objects, Condvar_Objects,
                                               Timer_Objects,
                                               Global_Resource_Available,
                                               stack, thread_id_, mutex_id_,
                                               waking_up_thread_after_condvar_wait,
                                               owner_thread_id_, thread_id_A,
                                               mutex_id_A, owner_thread_id,
                                               thread_id_D, mutex_id_D,
                                               doing_condvar_wait,
                                               awoken_thread_id_, thread_id_R,
                                               mutex_id_R, thread_id_Do,
                                               condvar_id_, mutex_id_Do,
                                               thread_id_W, condvar_id_W,
                                               mutex_id, condvar_id_D,
                                               do_context_switch,
                                               awoken_thread_id,
                                               to_reacquire_mutex_id,
                                               context_id_, condvar_id_S,
                                               context_id, condvar_id,
                                               thread_was_awaken, thread_id,
                                               delayed_threads >>

Idle_Thread == idle_thread_next_state_loop

timer_interrupt_next_state_loop == /\ pc["Timer_Interrupt"] = "timer_interrupt_next_state_loop"
                                   /\ pc' = [pc EXCEPT !["Timer_Interrupt"] = "enter_critical_section_step_T"]
                                   /\ UNCHANGED << HiRTOS, Thread_Objects,
                                                   Mutex_Objects,
                                                   Condvar_Objects,
                                                   Timer_Objects,
                                                   Global_Resource_Available,
                                                   stack, thread_id_,
                                                   mutex_id_,
                                                   waking_up_thread_after_condvar_wait,
                                                   owner_thread_id_,
                                                   thread_id_A, mutex_id_A,
                                                   owner_thread_id,
                                                   thread_id_D, mutex_id_D,
                                                   doing_condvar_wait,
                                                   awoken_thread_id_,
                                                   thread_id_R, mutex_id_R,
                                                   thread_id_Do, condvar_id_,
                                                   mutex_id_Do, thread_id_W,
                                                   condvar_id_W, mutex_id,
                                                   condvar_id_D,
                                                   do_context_switch,
                                                   awoken_thread_id,
                                                   to_reacquire_mutex_id,
                                                   context_id_, condvar_id_S,
                                                   context_id, condvar_id,
                                                   thread_was_awaken,
                                                   thread_id, delayed_threads >>

enter_critical_section_step_T == /\ pc["Timer_Interrupt"] = "enter_critical_section_step_T"
                                 /\ HiRTOS.Interrupts_Enabled /\
                                    ("Timer_Interrupt" \in Threads =>
                                        Thread_Objects["Timer_Interrupt"].State = "Running")
                                 /\ HiRTOS' = [HiRTOS EXCEPT !.Interrupts_Enabled = FALSE]
                                 /\ pc' = [pc EXCEPT !["Timer_Interrupt"] = "track_time_slice"]
                                 /\ UNCHANGED << Thread_Objects, Mutex_Objects,
                                                 Condvar_Objects,
                                                 Timer_Objects,
                                                 Global_Resource_Available,
                                                 stack, thread_id_, mutex_id_,
                                                 waking_up_thread_after_condvar_wait,
                                                 owner_thread_id_, thread_id_A,
                                                 mutex_id_A, owner_thread_id,
                                                 thread_id_D, mutex_id_D,
                                                 doing_condvar_wait,
                                                 awoken_thread_id_,
                                                 thread_id_R, mutex_id_R,
                                                 thread_id_Do, condvar_id_,
                                                 mutex_id_Do, thread_id_W,
                                                 condvar_id_W, mutex_id,
                                                 condvar_id_D,
                                                 do_context_switch,
                                                 awoken_thread_id,
                                                 to_reacquire_mutex_id,
                                                 context_id_, condvar_id_S,
                                                 context_id, condvar_id,
                                                 thread_was_awaken, thread_id,
                                                 delayed_threads >>

track_time_slice == /\ pc["Timer_Interrupt"] = "track_time_slice"
                    /\ IF HiRTOS.Current_Thread_Id /= "Invalid_Thread_Id"
                          THEN /\ Assert(~Thread_Objects[HiRTOS.Current_Thread_Id].ghost_Time_Slice_Consumed,
                                         "Failure of assertion at line 606, column 13.")
                               /\ Thread_Objects' = [Thread_Objects EXCEPT ![HiRTOS.Current_Thread_Id].ghost_Time_Slice_Consumed = TRUE]
                          ELSE /\ TRUE
                               /\ UNCHANGED Thread_Objects
                    /\ delayed_threads' = { t \in Threads \ { "Idle_Thread" } :
                                            Timer_Objects[Thread_Objects'[t].Builtin_Timer_Id].State = "Timer_Running" }
                    /\ pc' = [pc EXCEPT !["Timer_Interrupt"] = "wakeup_delay_until_waiters"]
                    /\ UNCHANGED << HiRTOS, Mutex_Objects, Condvar_Objects,
                                    Timer_Objects, Global_Resource_Available,
                                    stack, thread_id_, mutex_id_,
                                    waking_up_thread_after_condvar_wait,
                                    owner_thread_id_, thread_id_A, mutex_id_A,
                                    owner_thread_id, thread_id_D, mutex_id_D,
                                    doing_condvar_wait, awoken_thread_id_,
                                    thread_id_R, mutex_id_R, thread_id_Do,
                                    condvar_id_, mutex_id_Do, thread_id_W,
                                    condvar_id_W, mutex_id, condvar_id_D,
                                    do_context_switch, awoken_thread_id,
                                    to_reacquire_mutex_id, context_id_,
                                    condvar_id_S, context_id, condvar_id,
                                    thread_was_awaken, thread_id >>

wakeup_delay_until_waiters == /\ pc["Timer_Interrupt"] = "wakeup_delay_until_waiters"
                              /\ IF delayed_threads /= {}
                                    THEN /\ \E t \in delayed_threads:
                                              /\ delayed_threads' = delayed_threads \ {t}
                                              /\ Timer_Objects' = [Timer_Objects EXCEPT ![Thread_Objects[t].Builtin_Timer_Id].State = "Timer_Stopped"]
                                              /\ /\ condvar_id_D' = [condvar_id_D EXCEPT !["Timer_Interrupt"] = Thread_Objects[t].Builtin_Condvar_Id]
                                                 /\ do_context_switch' = [do_context_switch EXCEPT !["Timer_Interrupt"] = FALSE]
                                                 /\ stack' = [stack EXCEPT !["Timer_Interrupt"] = << [ procedure |->  "Do_Signal_Condvar",
                                                                                                       pc        |->  "wakeup_delay_until_waiters",
                                                                                                       awoken_thread_id |->  awoken_thread_id["Timer_Interrupt"],
                                                                                                       to_reacquire_mutex_id |->  to_reacquire_mutex_id["Timer_Interrupt"],
                                                                                                       condvar_id_D |->  condvar_id_D["Timer_Interrupt"],
                                                                                                       do_context_switch |->  do_context_switch["Timer_Interrupt"] ] >>
                                                                                                   \o stack["Timer_Interrupt"]]
                                              /\ awoken_thread_id' = [awoken_thread_id EXCEPT !["Timer_Interrupt"] = "Invalid_Thread_Id"]
                                              /\ to_reacquire_mutex_id' = [to_reacquire_mutex_id EXCEPT !["Timer_Interrupt"] = "Invalid_Mutex_Id"]
                                              /\ pc' = [pc EXCEPT !["Timer_Interrupt"] = "signal_condvar_step"]
                                    ELSE /\ pc' = [pc EXCEPT !["Timer_Interrupt"] = "timer_interupt_asynchronous_context_switch_step"]
                                         /\ UNCHANGED << Timer_Objects, stack,
                                                         condvar_id_D,
                                                         do_context_switch,
                                                         awoken_thread_id,
                                                         to_reacquire_mutex_id,
                                                         delayed_threads >>
                              /\ UNCHANGED << HiRTOS, Thread_Objects,
                                              Mutex_Objects, Condvar_Objects,
                                              Global_Resource_Available,
                                              thread_id_, mutex_id_,
                                              waking_up_thread_after_condvar_wait,
                                              owner_thread_id_, thread_id_A,
                                              mutex_id_A, owner_thread_id,
                                              thread_id_D, mutex_id_D,
                                              doing_condvar_wait,
                                              awoken_thread_id_, thread_id_R,
                                              mutex_id_R, thread_id_Do,
                                              condvar_id_, mutex_id_Do,
                                              thread_id_W, condvar_id_W,
                                              mutex_id, context_id_,
                                              condvar_id_S, context_id,
                                              condvar_id, thread_was_awaken,
                                              thread_id >>

timer_interupt_asynchronous_context_switch_step == /\ pc["Timer_Interrupt"] = "timer_interupt_asynchronous_context_switch_step"
                                                   /\ stack' = [stack EXCEPT !["Timer_Interrupt"] = << [ procedure |->  "Run_Thread_Scheduler",
                                                                                                         pc        |->  "exit_critical_section_step_T" ] >>
                                                                                                     \o stack["Timer_Interrupt"]]
                                                   /\ pc' = [pc EXCEPT !["Timer_Interrupt"] = "check_time_slice_step"]
                                                   /\ UNCHANGED << HiRTOS,
                                                                   Thread_Objects,
                                                                   Mutex_Objects,
                                                                   Condvar_Objects,
                                                                   Timer_Objects,
                                                                   Global_Resource_Available,
                                                                   thread_id_,
                                                                   mutex_id_,
                                                                   waking_up_thread_after_condvar_wait,
                                                                   owner_thread_id_,
                                                                   thread_id_A,
                                                                   mutex_id_A,
                                                                   owner_thread_id,
                                                                   thread_id_D,
                                                                   mutex_id_D,
                                                                   doing_condvar_wait,
                                                                   awoken_thread_id_,
                                                                   thread_id_R,
                                                                   mutex_id_R,
                                                                   thread_id_Do,
                                                                   condvar_id_,
                                                                   mutex_id_Do,
                                                                   thread_id_W,
                                                                   condvar_id_W,
                                                                   mutex_id,
                                                                   condvar_id_D,
                                                                   do_context_switch,
                                                                   awoken_thread_id,
                                                                   to_reacquire_mutex_id,
                                                                   context_id_,
                                                                   condvar_id_S,
                                                                   context_id,
                                                                   condvar_id,
                                                                   thread_was_awaken,
                                                                   thread_id,
                                                                   delayed_threads >>

exit_critical_section_step_T == /\ pc["Timer_Interrupt"] = "exit_critical_section_step_T"
                                /\ HiRTOS' = [HiRTOS EXCEPT !.Interrupts_Enabled = TRUE]
                                /\ pc' = [pc EXCEPT !["Timer_Interrupt"] = "timer_interrupt_next_state_loop"]
                                /\ UNCHANGED << Thread_Objects, Mutex_Objects,
                                                Condvar_Objects, Timer_Objects,
                                                Global_Resource_Available,
                                                stack, thread_id_, mutex_id_,
                                                waking_up_thread_after_condvar_wait,
                                                owner_thread_id_, thread_id_A,
                                                mutex_id_A, owner_thread_id,
                                                thread_id_D, mutex_id_D,
                                                doing_condvar_wait,
                                                awoken_thread_id_, thread_id_R,
                                                mutex_id_R, thread_id_Do,
                                                condvar_id_, mutex_id_Do,
                                                thread_id_W, condvar_id_W,
                                                mutex_id, condvar_id_D,
                                                do_context_switch,
                                                awoken_thread_id,
                                                to_reacquire_mutex_id,
                                                context_id_, condvar_id_S,
                                                context_id, condvar_id,
                                                thread_was_awaken, thread_id,
                                                delayed_threads >>

Timer_Interrupt == timer_interrupt_next_state_loop
                      \/ enter_critical_section_step_T \/ track_time_slice
                      \/ wakeup_delay_until_waiters
                      \/ timer_interupt_asynchronous_context_switch_step
                      \/ exit_critical_section_step_T

other_interrupt_next_state_loop == /\ pc["Other_Interrupt"] = "other_interrupt_next_state_loop"
                                   /\ pc' = [pc EXCEPT !["Other_Interrupt"] = "enter_critical_section_step"]
                                   /\ UNCHANGED << HiRTOS, Thread_Objects,
                                                   Mutex_Objects,
                                                   Condvar_Objects,
                                                   Timer_Objects,
                                                   Global_Resource_Available,
                                                   stack, thread_id_,
                                                   mutex_id_,
                                                   waking_up_thread_after_condvar_wait,
                                                   owner_thread_id_,
                                                   thread_id_A, mutex_id_A,
                                                   owner_thread_id,
                                                   thread_id_D, mutex_id_D,
                                                   doing_condvar_wait,
                                                   awoken_thread_id_,
                                                   thread_id_R, mutex_id_R,
                                                   thread_id_Do, condvar_id_,
                                                   mutex_id_Do, thread_id_W,
                                                   condvar_id_W, mutex_id,
                                                   condvar_id_D,
                                                   do_context_switch,
                                                   awoken_thread_id,
                                                   to_reacquire_mutex_id,
                                                   context_id_, condvar_id_S,
                                                   context_id, condvar_id,
                                                   thread_was_awaken,
                                                   thread_id, delayed_threads >>

enter_critical_section_step == /\ pc["Other_Interrupt"] = "enter_critical_section_step"
                               /\ HiRTOS.Interrupts_Enabled /\
                                  ("Other_Interrupt" \in Threads =>
                                      Thread_Objects["Other_Interrupt"].State = "Running")
                               /\ HiRTOS' = [HiRTOS EXCEPT !.Interrupts_Enabled = FALSE]
                               /\ pc' = [pc EXCEPT !["Other_Interrupt"] = "other_interupt_asynchronous_context_switch_step"]
                               /\ UNCHANGED << Thread_Objects, Mutex_Objects,
                                               Condvar_Objects, Timer_Objects,
                                               Global_Resource_Available,
                                               stack, thread_id_, mutex_id_,
                                               waking_up_thread_after_condvar_wait,
                                               owner_thread_id_, thread_id_A,
                                               mutex_id_A, owner_thread_id,
                                               thread_id_D, mutex_id_D,
                                               doing_condvar_wait,
                                               awoken_thread_id_, thread_id_R,
                                               mutex_id_R, thread_id_Do,
                                               condvar_id_, mutex_id_Do,
                                               thread_id_W, condvar_id_W,
                                               mutex_id, condvar_id_D,
                                               do_context_switch,
                                               awoken_thread_id,
                                               to_reacquire_mutex_id,
                                               context_id_, condvar_id_S,
                                               context_id, condvar_id,
                                               thread_was_awaken, thread_id,
                                               delayed_threads >>

other_interupt_asynchronous_context_switch_step == /\ pc["Other_Interrupt"] = "other_interupt_asynchronous_context_switch_step"
                                                   /\ stack' = [stack EXCEPT !["Other_Interrupt"] = << [ procedure |->  "Run_Thread_Scheduler",
                                                                                                         pc        |->  "exit_critical_section_step" ] >>
                                                                                                     \o stack["Other_Interrupt"]]
                                                   /\ pc' = [pc EXCEPT !["Other_Interrupt"] = "check_time_slice_step"]
                                                   /\ UNCHANGED << HiRTOS,
                                                                   Thread_Objects,
                                                                   Mutex_Objects,
                                                                   Condvar_Objects,
                                                                   Timer_Objects,
                                                                   Global_Resource_Available,
                                                                   thread_id_,
                                                                   mutex_id_,
                                                                   waking_up_thread_after_condvar_wait,
                                                                   owner_thread_id_,
                                                                   thread_id_A,
                                                                   mutex_id_A,
                                                                   owner_thread_id,
                                                                   thread_id_D,
                                                                   mutex_id_D,
                                                                   doing_condvar_wait,
                                                                   awoken_thread_id_,
                                                                   thread_id_R,
                                                                   mutex_id_R,
                                                                   thread_id_Do,
                                                                   condvar_id_,
                                                                   mutex_id_Do,
                                                                   thread_id_W,
                                                                   condvar_id_W,
                                                                   mutex_id,
                                                                   condvar_id_D,
                                                                   do_context_switch,
                                                                   awoken_thread_id,
                                                                   to_reacquire_mutex_id,
                                                                   context_id_,
                                                                   condvar_id_S,
                                                                   context_id,
                                                                   condvar_id,
                                                                   thread_was_awaken,
                                                                   thread_id,
                                                                   delayed_threads >>

exit_critical_section_step == /\ pc["Other_Interrupt"] = "exit_critical_section_step"
                              /\ HiRTOS' = [HiRTOS EXCEPT !.Interrupts_Enabled = TRUE]
                              /\ pc' = [pc EXCEPT !["Other_Interrupt"] = "other_interrupt_next_state_loop"]
                              /\ UNCHANGED << Thread_Objects, Mutex_Objects,
                                              Condvar_Objects, Timer_Objects,
                                              Global_Resource_Available, stack,
                                              thread_id_, mutex_id_,
                                              waking_up_thread_after_condvar_wait,
                                              owner_thread_id_, thread_id_A,
                                              mutex_id_A, owner_thread_id,
                                              thread_id_D, mutex_id_D,
                                              doing_condvar_wait,
                                              awoken_thread_id_, thread_id_R,
                                              mutex_id_R, thread_id_Do,
                                              condvar_id_, mutex_id_Do,
                                              thread_id_W, condvar_id_W,
                                              mutex_id, condvar_id_D,
                                              do_context_switch,
                                              awoken_thread_id,
                                              to_reacquire_mutex_id,
                                              context_id_, condvar_id_S,
                                              context_id, condvar_id,
                                              thread_was_awaken, thread_id,
                                              delayed_threads >>

Other_Interrupt == other_interrupt_next_state_loop
                      \/ enter_critical_section_step
                      \/ other_interupt_asynchronous_context_switch_step
                      \/ exit_critical_section_step

Next == Idle_Thread \/ Timer_Interrupt \/ Other_Interrupt
           \/ (\E self \in ProcSet:  \/ Run_Thread_Scheduler(self)
                                     \/ Do_Acquire_Mutex(self)
                                     \/ Acquire_Mutex(self)
                                     \/ Do_Release_Mutex(self)
                                     \/ Release_Mutex(self)
                                     \/ Do_Wait_On_Condvar(self)
                                     \/ Wait_On_Condvar(self)
                                     \/ Do_Signal_Condvar(self)
                                     \/ Signal_Condvar(self)
                                     \/ Broadcast_Condvar(self)
                                     \/ Delay_Until(self))
           \/ (\E self \in Threads \ { "Idle_Thread" }: Thread_State_Machine(self))

Spec == /\ Init /\ [][Next]_vars
        /\ \A self \in Threads \ { "Idle_Thread" } : /\ WF_vars(Thread_State_Machine(self))
                                                     /\ WF_vars(Acquire_Mutex(self))                                                     /\ WF_vars(Wait_On_Condvar(self))                                                     /\ WF_vars(Release_Mutex(self))                                                     /\ WF_vars(Signal_Condvar(self))                                                     /\ WF_vars(Broadcast_Condvar(self))                                                     /\ WF_vars(Delay_Until(self))                                                     /\ WF_vars(Run_Thread_Scheduler(self))                                                     /\ WF_vars(Do_Acquire_Mutex(self))                                                     /\ WF_vars(Do_Release_Mutex(self))                                                     /\ WF_vars(Do_Wait_On_Condvar(self))                                                     /\ WF_vars(Do_Signal_Condvar(self))
        /\ WF_vars(Idle_Thread)
        /\ /\ WF_vars(Timer_Interrupt)
           /\ WF_vars(Do_Signal_Condvar("Timer_Interrupt"))
           /\ WF_vars(Run_Thread_Scheduler("Timer_Interrupt"))
           /\ WF_vars(Do_Acquire_Mutex("Timer_Interrupt"))
        /\ /\ WF_vars(Other_Interrupt)
           /\ WF_vars(Run_Thread_Scheduler("Other_Interrupt"))

\* END TRANSLATION

\*=================================================================
\* Correctness Properties
\*=================================================================

TypeInvariant ==
   /\ HiRTOS \in HiRTOS_Type
   /\ Thread_Objects \in [Threads -> Thread_Object_Type]
   /\ Mutex_Objects \in [Mutexes -> Mutex_Object_Type]
   /\ Condvar_Objects \in [Condvars -> Condvar_Object_Type]
   /\ Timer_Objects \in [Timers -> Timer_Object_Type]

\* There can be at most only one "running" thread
SafetyInvariant1 ==
    HiRTOS.Interrupts_Enabled =>
        IF HiRTOS.Current_Thread_Id /= "Invalid_Thread_Id" THEN
           /\ Cardinality({ t \in Threads : Thread_Objects[t].State = "Running" }) = 1
           /\ HiRTOS.Current_Thread_Id =
               CHOOSE t \in Threads : Thread_Objects[t].State = "Running"
        ELSE
           { t \in Threads : Thread_Objects[t].State = "Running" } = {}


\* The running thread is not in any queue
SafetyInvariant2 ==
    (HiRTOS.Interrupts_Enabled /\
     HiRTOS.Current_Thread_Id /= "Invalid_Thread_Id") =>
       (/\ Thread_Objects[HiRTOS.Current_Thread_Id].State = "Running"
        /\ Thread_Objects[HiRTOS.Current_Thread_Id].Waiting_On_Condvar_Id = "Invalid_Condvar_Id"
        /\ Thread_Objects[HiRTOS.Current_Thread_Id].Waiting_On_Mutex_Id = "Invalid_Mutex_Id"
        /\ ~Is_Thread_In_Priority_Queue(HiRTOS.Runnable_Threads_Queue,
                                        HiRTOS.Current_Thread_Id)
        /\ \A m \in Mutexes :
             ~Is_Thread_In_Priority_Queue(Mutex_Objects[m].Waiting_Threads_Queue,
                                          HiRTOS.Current_Thread_Id)
        /\ \A cv \in Condvars :
             ~Is_Thread_In_Priority_Queue(Condvar_Objects[cv].Waiting_Threads_Queue,
                                          HiRTOS.Current_Thread_Id)
       )

\* All Runnable threads are in the Runnable threads queue and in no other queue
SafetyInvariant3 ==
    HiRTOS.Interrupts_Enabled =>
    \A t \in Threads : Thread_Objects[t].State = "Runnable" =>
        /\ Thread_Objects[t].Waiting_On_Condvar_Id = "Invalid_Condvar_Id"
        /\ Thread_Objects[t].Waiting_On_Mutex_Id = "Invalid_Mutex_Id"
        /\ Is_Thread_In_Priority_Queue(HiRTOS.Runnable_Threads_Queue, t)
        /\ Is_Thread_In_Priority_Queue_In_Only_One_Queue(HiRTOS.Runnable_Threads_Queue, t)
        /\ \A m \in Mutexes :
             ~Is_Thread_In_Priority_Queue(Mutex_Objects[m].Waiting_Threads_Queue, t)
        /\ \A cv \in Condvars :
             ~Is_Thread_In_Priority_Queue(Condvar_Objects[cv].Waiting_Threads_Queue, t)

\* Each thread blocked on a mutex is in only one mutex's wait queue and in no other queue
SafetyInvariant4 ==
    HiRTOS.Interrupts_Enabled =>
    \A t \in Threads :
      LET
         thread_obj == Thread_Objects[t]
      IN
         thread_obj.State = "Blocked_On_Mutex" =>
            /\ thread_obj.Waiting_On_Mutex_Id /= "Invalid_Mutex_Id"
            /\ thread_obj.Waiting_On_Condvar_Id = "Invalid_Condvar_Id"
            /\ (LET
                   mutex_obj == Mutex_Objects[thread_obj.Waiting_On_Mutex_Id]
                IN
                   /\ Is_Thread_In_Priority_Queue(mutex_obj.Waiting_Threads_Queue, t)
                   /\ Is_Thread_In_Priority_Queue_In_Only_One_Queue(
                         mutex_obj.Waiting_Threads_Queue, t))
            /\ ~Is_Thread_In_Priority_Queue(HiRTOS.Runnable_Threads_Queue, t)
            /\ \A m \in Mutexes \ { thread_obj.Waiting_On_Mutex_Id } :
                  ~Is_Thread_In_Priority_Queue(Mutex_Objects[m].Waiting_Threads_Queue, t)
            /\ \A cv \in Condvars :
                  ~Is_Thread_In_Priority_Queue(Condvar_Objects[cv].Waiting_Threads_Queue, t)

\* Each thread blocked on a condvar is in only one condvar's wait queue and in no other queue
SafetyInvariant5 ==
    HiRTOS.Interrupts_Enabled =>
    \A t \in Threads :
      LET
         thread_obj == Thread_Objects[t]
      IN
         thread_obj.State = "Blocked_On_Condvar" =>
            /\ thread_obj.Waiting_On_Condvar_Id /= "Invalid_Condvar_Id"
            /\ thread_obj.Waiting_On_Mutex_Id = "Invalid_Mutex_Id"
            /\ (LET
                   condvar_obj == Condvar_Objects[thread_obj.Waiting_On_Condvar_Id]
                IN
                   /\ Is_Thread_In_Priority_Queue(condvar_obj.Waiting_Threads_Queue, t)
                   /\ Is_Thread_In_Priority_Queue_In_Only_One_Queue(
                         condvar_obj.Waiting_Threads_Queue, t))
            /\ ~Is_Thread_In_Priority_Queue(HiRTOS.Runnable_Threads_Queue, t)
            /\ \A cv \in Condvars \ { thread_obj.Waiting_On_Condvar_Id } :
                  ~Is_Thread_In_Priority_Queue(Condvar_Objects[cv].Waiting_Threads_Queue, t)
            /\ \A m \in Mutexes :
                  ~Is_Thread_In_Priority_Queue(Mutex_Objects[m].Waiting_Threads_Queue, t)

\* Each mutex that is currently owned by a thread must be in the list of mutexes owned by that thread
SafetyInvariant6 ==
    HiRTOS.Interrupts_Enabled =>
    \A m \in Mutexes :
      LET
        t == Mutex_Objects[m].Owner_Thread_Id
    IN
        t /= "Invalid_Thread_Id" =>
           m \in Range(Thread_Objects[t].Owned_Mutexes)

\* If a mutex is not owned by a thread, its wait queue should be empty
SafetyInvariant7 ==
   HiRTOS.Interrupts_Enabled =>
   \A m \in Mutexes :
      Mutex_Objects[m].Owner_Thread_Id = "Invalid_Thread_Id" =>
        Is_Thread_Priority_Queue_Empty(Mutex_Objects[m].Waiting_Threads_Queue)

\* The thread owning a mutex can never have lower priority than any thread waiting
\* for the mutex
SafetyInvariant8 ==
   (HiRTOS.Interrupts_Enabled /\
    HiRTOS.Current_Thread_Id /= "Invalid_Thread_Id") =>
     \A m \in Mutexes :
        LET
            t == Mutex_Objects[m].Owner_Thread_Id
            prio_queue == Mutex_Objects[m].Waiting_Threads_Queue
        IN
            (t /= "Invalid_Thread_Id" /\ ~Is_Thread_Priority_Queue_Empty(prio_queue)) =>
                \A wt \in UNION { Range(q) : q \in Range(prio_queue) } :
                Thread_Objects[wt].State = "Blocked_On_Mutex" /\
                Thread_Objects[t].Current_Priority >= Thread_Objects[wt].Current_Priority

\* A thread not owning any mutex and not waiting on a condvar always has its current
\* priority set to its base priority
SafetyInvariant9 ==
    HiRTOS.Interrupts_Enabled =>
    \A t \in Threads :
       (Thread_Objects[t].Owned_Mutexes = <<>> /\ Thread_Objects[t].State /= "Blocked_On_Condvar") =>
       Thread_Objects[t].Current_Priority = Thread_Objects[t].Base_Priority

\* Interrupts are not disabled indefinitely:
LivenessProperty1 ==
    ~HiRTOS.Interrupts_Enabled => <>HiRTOS.Interrupts_Enabled

\* All runnable app threads of the same proirity eventually get the CPU:
LivenessProperty2 ==
    \A t \in Threads \ { "Idle_Thread" }, p \in Valid_Thread_Priority_Type \ { 0 } :
       (Thread_Objects[t].Current_Priority = p /\ Thread_Objects[t].State = "Runnable") =>
          <>(Thread_Objects[t].State = "Running")

\* All app threads complete at least one iteration
LivenessProperty3 ==
    \A t \in Threads \ { "Idle_Thread" } :
        <>(pc[t] = "thread_iteration_completed_step")

\* Every thread waiting to acquire a mutex, eventually gets it:
LivenessProperty4 ==
    \A t \in Threads :
        Thread_Objects[t].State = "Waiting_On_Mutex" => <>(Thread_Objects[t].State = "Runnable")

\* Every thread waiting on a condvar is eventually awaken:
LivenessProperty5 ==
    \A t \in Threads :
        Thread_Objects[t].State = "Waiting_On_Condvar" => <>(Thread_Objects[t].State = "Runnable")

THEOREM Spec => []TypeInvariant
THEOREM Spec => []SafetyInvariant1
THEOREM Spec => []SafetyInvariant2
THEOREM Spec => []SafetyInvariant3
THEOREM Spec => []SafetyInvariant4
THEOREM Spec => []SafetyInvariant5
THEOREM Spec => []SafetyInvariant6
THEOREM Spec => []SafetyInvariant7
THEOREM Spec => []SafetyInvariant8
THEOREM Spec => []SafetyInvariant9
THEOREM Spec => []LivenessProperty1
THEOREM Spec => []LivenessProperty2
THEOREM Spec => []LivenessProperty3
THEOREM Spec => []LivenessProperty4
THEOREM Spec => []LivenessProperty5

=============================================================================
