/**
 * @file mem_utils.h
 *
 * Memory utilities interface
 *
 * @author: German Rivera
 */
#ifndef MEM_UTILS_H_
#define MEM_UTILS_H_

#include <stdint.h>
#include <stddef.h>

void *memcpy(void *dst, const void *src, size_t size);

void *memmove(void *dst, const void *src, size_t size);

void *memset(void *dst, int byte_value, size_t size);

int memcmp(const void *src1, const void *src2, size_t size);

#endif /* MEM_UTILS_H_ */
