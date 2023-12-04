------------------------ MODULE HiRTOS_separation_kernel ------------------
(***********************************************************************)
(* Specification of the HiRTOS separation kernel                       *)
(***********************************************************************)

EXTENDS FiniteSets, Sequences, Naturals, TLC

CONSTANTS
  numCpus,
  numInterrupts,
  numInterruptPriorities,
  minMemoryAddress,
  maxMemoryAddress,
  maxNumPartitionsPerCpu,
  tickTimerPeriodUs,
  CpuRegistersType

ASSUME
  /\ numCpus \in Nat /\ numCpus /= 0
  /\ numInterrupts \in Nat /\ numInterrupts /= 0
  /\ numInterruptPriorities \in Nat /\ numInterruptPriorities /= 0
  /\ minMemoryAddress \in Nat
  /\ maxMemoryAddress \in Nat
  /\ minMemoryAddress < maxMemoryAddress
  /\ maxNumPartitionsPerCpu \in Nat /\ maxNumPartitionsPerCpu /= 0
  /\ tickTimerPeriodUs \in Nat /\ tickTimerPeriodUs /= 0
  /\ IsFiniteSet(CpuRegistersType)

VARIABLES
  separationKernelCpuInstances, \* separation kernel instances, one per CPU
  zAllCreatedPartitionInstances \* set of all partitions across all CPUs

(* PRIMITIVE TYPES *)
CpuIdType == 0 .. numCpus
invalidCpuId == numCpus
ValidCpuIdType == CpuIdType \ { invalidCpuId }

InterruptIdType == 0 .. numInterrupts
invalidInterruptId == numInterrupts
ValidInterruptIdType == InterruptIdType \ { invalidInterruptId }

InterruptPriorityType == 0 .. numInterruptPriorities
invalidInterruptPriority == numInterruptPriorities
ValidInterruptPriorityType == InterruptPriorityType \ { invalidInterruptPriority }

MemoryAddressType == minMemoryAddress .. maxMemoryAddress
AddressRangeType == MemoryAddressType \X MemoryAddressType

PartitionIdType == 0 .. maxNumPartitionsPerCpu
invalidPartitionId == maxNumPartitionsPerCpu
ValidPartitionIdType == PartitionIdType \ { invalidPartitionId }
PartitionSchedulerStateType == { "partitionSchedulerStopped", "partitionSchedulerRunning" }
PartitionStateType == { "partitionNotCreated", "partitionRunnable", "partitionRunning", "partitionSuspended" }
AddressRange(r) == { r[0] .. r[1] : r \in AddressRangeType }

(* Range of a function *)
Range(f) == { f[x] : x \in DOMAIN f }

InjectiveFunctionType(S, T) == { f \in [S -> T] : \A a,b \in S : f[a] = f[b] => a = b }

InjectiveSequenceType(T) == { s \in Seq(T) : s \in InjectiveFunctionType(DOMAIN s, T) }

PartitionQueueType == InjectiveSequenceType(ValidPartitionIdType)

(* PARTITION TYPE *)
PartitionType == [
    id : PartitionIdType,
    failoverPartitionId : PartitionIdType,
    state : PartitionStateType,
    timeSliceLeftUs : Nat,
    savedCpuContext : CpuRegistersType,
    savedHypervisorLevelMpuRegions : SUBSET AddressRangeType,
    savedSupervisorLevelMpuRegions : SUBSET AddressRangeType,
    savedInterruptVectorTableAddr : MemoryAddressType,
    savedInterruptsEnabled : SUBSET InterruptIdType,
    savedHighestInterruptPriorityDisabled : InterruptPriorityType
]

(* PER-CPU SEPARATION KERNEL INSTANCE TYPE *)
SeparationKernelCpuInstanceType == [
    cpuId : ValidCpuIdType,
    interruptStack : AddressRangeType,
    partitionSchedulerState : PartitionSchedulerStateType,
    currentPartitionId : PartitionIdType,
    timerTicksSinceBoot : Nat,
    runnablePartitionsQueue : PartitionQueueType,
    partitions : InjectiveFunctionType(ValidPartitionIdType, PartitionType),
    hwCurrentCpuContext : CpuRegistersType,
    hwCurrentHypervisorLevelMpuRegions : SUBSET AddressRangeType,
    hwCurrentSupervisorLevelMpuRegions : SUBSET AddressRangeType,
    hwCurrentSupervisorLevelInterruptVectorTableAddr : MemoryAddressType,
    hwCurrentSupervisorLevelInterruptsEnabled : SUBSET ValidInterruptIdType,
    hwCurrentHighestInterruptPriorityDisabled : InterruptPriorityType
]

TypeInvariant ==
  /\ separationKernelCpuInstances \in InjectiveFunctionType(ValidCpuIdType, SeparationKernelCpuInstanceType)
  /\ Cardinality(separationKernelCpuInstances) >= 1
  /\ zAllCreatedPartitionInstances \in SUBSET PartitionType

ParrtitionInit(p) ==
    /\ p.id /= invalidPartitionId
    /\ p.state = "partitionRunnable"
    /\ p.timeSliceLeftUs = tickTimerPeriodUs

SeparationKerneCpuInstanceInit(k, cpuId) ==
    /\ AddressRange(k.interruptStack) /= {}
    /\ k.cpuId = cpuId
    /\ k.partitionSchedulerState = "partitionSchedulerStopped"
    /\ k.currentPartitionId = invalidPartitionId
    /\ k.timerTicksSinceBoot = 0
    /\ k.runnablePartitionsQueue = {}
    /\ k.partitions = {}

-------------------------------------------------------------------------

(* Initially, no partitions have been created in any CPU. *)
Init ==
    \A i \in ValidCpuIdType : SeparationKerneCpuInstanceInit(separationKernelCpuInstances[i], i)

(* A client c may request a set of resources provided that all of its  *)
(* previous requests have been satisfied and that it doesn't hold any  *)
(* resources. The client is added to the pool of clients with          *)
(* outstanding requests.                                               *)
Request(c,S) ==
  /\ unsat[c] = {} /\ alloc[c] = {}
  /\ S # {} /\ unsat' = [unsat EXCEPT ![c] = S]
  /\ UNCHANGED <<alloc,sched>>

(* Allocation of a set of available resources to a client that has     *)
(* requested them (the entire request does not have to be filled).     *)
(* The process must appear in the schedule, and no process earlier in  *)
(* the schedule may have requested one of the resources.               *)
Allocate(c,S) ==
  /\ S # {} /\ S \subseteq available \cap unsat[c]
  /\ \E i \in DOMAIN sched :
        /\ sched[i] = c
        /\ \A j \in 1..i-1 : unsat[sched[j]] \cap S = {}
        /\ sched' = IF S = unsat[c] THEN Drop(sched,i) ELSE sched
  /\ alloc' = [alloc EXCEPT ![c] = @ \cup S]
  /\ unsat' = [unsat EXCEPT ![c] = @ \ S]

(* Client c returns a set of resources that it holds. It may do so     *)
(* even before its full request has been honored.                      *)
Return(c,S) ==
  /\ S # {} /\ S \subseteq alloc[c]
  /\ alloc' = [alloc EXCEPT ![c] = @ \ S]
  /\ UNCHANGED <<unsat,sched>>

(* The allocator extends its schedule by adding the processes from     *)
(* the set of clients to be scheduled, in some unspecified order.      *)
Schedule ==
  /\ toSchedule # {}
  /\ \E sq \in PermSeqs(toSchedule) : sched' = sched \circ sq
  /\ UNCHANGED <<unsat,alloc>>

(* The next-state relation per client and set of resources.            *)
Next ==
  \/ \E c \in Clients, S \in SUBSET Resources :
        Request(c,S) \/ Allocate(c,S) \/ Return(c,S)
  \/ Schedule

vars == <<unsat,alloc,sched>>

-------------------------------------------------------------------------

(***********************************************************************)
(* Liveness assumptions:                                               *)
(* - Clients must return resources if their request has been satisfied.*)
(* - The allocator must eventually allocate resources when possible.   *)
(* - The allocator must schedule the processes in the pool.            *)
(***********************************************************************)

Liveness ==
  /\ \A c \in Clients : WF_vars(unsat[c]={} /\ Return(c,alloc[c]))
  /\ \A c \in Clients : WF_vars(\E S \in SUBSET Resources : Allocate(c, S))
  /\ WF_vars(Schedule)

(* The specification of the scheduling allocator. *)
Allocator == Init /\ [][Next]_vars /\ Liveness

-------------------------------------------------------------------------

ResourceMutex ==   \** resources are allocated exclusively
  \A c1,c2 \in Clients : c1 # c2 => alloc[c1] \cap alloc[c2] = {}

UnscheduledClients ==    \** clients that do not appear in the schedule
  Clients \ Range(sched)

PrevResources(i) ==
  \** resources that will be available when client i has to be satisfied
  available
  \cup (UNION {unsat[sched[j]] \cup alloc[sched[j]] : j \in 1..i-1})
  \cup (UNION {alloc[c] : c \in UnscheduledClients})

AllocatorInvariant ==  \** a lower-level invariant
  /\ \** all clients in the schedule have outstanding requests
     \A i \in DOMAIN sched : unsat[sched[i]] # {}
  /\ \** all clients that need to be scheduled have outstanding requests
     \A c \in toSchedule : unsat[c] # {}
  /\ \** clients never hold a resource requested by a process earlier
     \** in the schedule
     \A i \in DOMAIN sched : \A j \in 1..i-1 :
        alloc[sched[i]] \cap unsat[sched[j]] = {}
  /\ \** the allocator can satisfy the requests of any scheduled client
     \** assuming that the clients scheduled earlier release their resources
     \A i \in DOMAIN sched : unsat[sched[i]] \subseteq PrevResources(i)

ClientsWillReturn ==
  \A c \in Clients: (unsat[c]={} ~> alloc[c]={})

ClientsWillObtain ==
  \A c \in Clients, r \in Resources : r \in unsat[c] ~> r \in alloc[c]

InfOftenSatisfied ==
  \A c \in Clients : []<>(unsat[c] = {})

(* Used for symmetry reduction with TLC.
   Note: because of the schedule sequence, the specification is no
   longer symmetric with respect to the processes!
*)
Symmetry == Permutations(Resources)

-------------------------------------------------------------------------

THEOREM Allocator => []TypeInvariant
THEOREM Allocator => []ResourceMutex
THEOREM Allocator => []AllocatorInvariant
THEOREM Allocator => ClientsWillReturn
THEOREM Allocator => ClientsWillObtain
THEOREM Allocator => InfOftenSatisfied

=========================================================================
