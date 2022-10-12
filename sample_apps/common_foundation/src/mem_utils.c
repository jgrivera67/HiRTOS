/**
 * @file mem_utils.c
 *
 * Memory utilities implementation
 *
 * @author: German Rivera
 */

#include "mem_utils.h"

#pragma GCC diagnostic ignored "-Wimplicit-fallthrough"

#define HOW_MANY(_m, _n)    (((uintptr_t)(_m) - 1) / (_n) + 1)

#define ROUND_UP(_m, _n)    (HOW_MANY(_m, _n) * (_n))

#define ROUND_DOWN(_m, _n)    (((uintptr_t)(_m) / (_n)) * (_n))

#define UNROLL_TIMES	4

/**
 * Copies a 32-bit aligned block of memory from one location to another
 *
 * @param src: pointer to source location
 * @param dst: pointer to destination location
 * @param size: size in bytes
 *
 * @pre dst must be a 4-byte aligned address
 * @pre src must be a 4-byte aligned address
 * @pre size must be a multiple of 4
 */
static inline void memcpy32(uint32_t *dst, const uint32_t *src, size_t size)
{
	register uint32_t *dst_cursor = dst;
	register const uint32_t *src_cursor = src;

	const uint32_t num_words = size / sizeof(uint32_t);
	register const uint32_t *const dst_end =
		dst + ((num_words / UNROLL_TIMES) * UNROLL_TIMES);

	while (dst_cursor != dst_end) {
		*dst_cursor++ = *src_cursor++;
		*dst_cursor++ = *src_cursor++;
		*dst_cursor++ = *src_cursor++;
		*dst_cursor++ = *src_cursor++;
	}

	switch (num_words % UNROLL_TIMES) {
	case 3:
		*dst_cursor++ = *src_cursor++;
	case 2:
		*dst_cursor++ = *src_cursor++;
	case 1:
		*dst_cursor++ = *src_cursor++;
	}
}

void *memcpy(void *dst, const void *src, size_t size)
{
    uint32_t *dst_words = (uint32_t *)ROUND_UP(dst, sizeof(uint32_t));
    const uint32_t *src_words = (uint32_t *)ROUND_UP(src, sizeof(uint32_t));
    size_t dst_bytes_before_align = (uintptr_t)dst_words - (uintptr_t)dst;
    size_t src_bytes_before_align = (uintptr_t)src_words - (uintptr_t)src;

    if (dst_bytes_before_align != src_bytes_before_align) {
	/* slow path */
	uint8_t *dst_bytes = dst;
	uint8_t *const dst_end = dst_bytes + size;
	const uint8_t *src_bytes = src;

	while (dst_bytes != dst_end) {
	    *dst_bytes++ = *src_bytes++;
	}

	return dst;
   }

   size_t bytes_after_align = (size - dst_bytes_before_align) % sizeof(uint32_t);
   size_t aligned_size = size - dst_bytes_before_align - bytes_after_align;

   if (dst_bytes_before_align != 0) {
	uint8_t *dst_bytes = dst;
	const uint8_t *src_bytes = src;

      	switch (dst_bytes_before_align) {
	case 3:
	    *dst_bytes++ = *src_bytes++;
	case 2:
	    *dst_bytes++ = *src_bytes++;
	case 1:
	    *dst_bytes++ = *src_bytes++;
	}
   }

   if (aligned_size != 0) {
       memcpy32(dst_words, src_words, aligned_size);
   }

   if (bytes_after_align != 0) {
      	uint8_t *dst_bytes = (uint8_t *)dst_words + aligned_size;
	const uint8_t *src_bytes = (uint8_t *)src_words + aligned_size;

      	switch (bytes_after_align) {
	case 3:
	    *dst_bytes++ = *src_bytes++;
	case 2:
	    *dst_bytes++ = *src_bytes++;
	case 1:
	    *dst_bytes++ = *src_bytes++;
	}
   }

   return dst;
}

/**
 * Copies a 32-bit aligned block of memory from one location to another,
 * moving backwards
 *
 * @param src: pointer to source location
 * @param dst: pointer to destination location
 * @param size: size in bytes
 *
 * @pre dst must be a 4-byte aligned address
 * @pre src must be a 4-byte aligned address
 * @pre size must be a multiple of 4
 */
static inline void memcpy32_backwards(uint32_t *dst, const uint32_t *src,
	                              size_t size)
{
    const uint32_t num_words = size / sizeof(uint32_t);
    register uint32_t *dst_cursor = dst + (num_words - 1);
    register const uint32_t *src_cursor = src + (num_words - 1);

    while (dst_cursor >= dst + (UNROLL_TIMES - 1)) {
	*dst_cursor-- = *src_cursor--;
	*dst_cursor-- = *src_cursor--;
	*dst_cursor-- = *src_cursor--;
	*dst_cursor-- = *src_cursor--;
    }

    switch (num_words % UNROLL_TIMES) {
    case 3:
	*dst_cursor-- = *src_cursor--;
    case 2:
	*dst_cursor-- = *src_cursor--;
    case 1:
	*dst_cursor-- = *src_cursor--;
    }
}

/**
 * Same as memcpy() but 'src' and 'dst' may overlap
 */
void *memmove(void *dst, const void *src, size_t size)
{
    if ((uintptr_t)src + size <= (uintptr_t)dst ||
	(uintptr_t)dst + size <= (uintptr_t)src) {
	return memcpy(dst, src, size);
    }

    if (dst < src) {
	if ((uintptr_t)dst % sizeof(uint32_t) == 0 &&
            (uintptr_t)src % sizeof(uint32_t) == 0 &&
	    size % sizeof(uint32_t) == 0) {
	    memcpy32(dst, src, size);
	} else {
	    /* slow path */
	    uint8_t *dst_bytes = (uint8_t *)dst;
	    uint8_t *const dst_end = (uint8_t *)dst + size;
	    const uint8_t *src_bytes = (uint8_t *)src;

	    while (dst_bytes < dst_end) {
		*dst_bytes++ = *src_bytes++;
	    }
	}
    } else if (dst > src) {
	if ((uintptr_t)dst % sizeof(uint32_t) == 0 &&
            (uintptr_t)src % sizeof(uint32_t) == 0 &&
	    size % sizeof(uint32_t) == 0) {
	    memcpy32_backwards(dst, src, size);
	} else {
	    /* slow path */
	    uint8_t *dst_bytes = (uint8_t *)dst + (size - 1);
	    uint8_t *const dst_start = (uint8_t *)dst;
	    const uint8_t *src_bytes = (uint8_t *)src + (size - 1);

	    while (dst_bytes >= dst_start) {
		*dst_bytes-- = *src_bytes--;
	    }
	}
    }

    return dst;
}

/**
 * Initializes all bytes of a 32-bit-aligned memory block to a given value
 *
 * @param dst: pointer to destination location
 * @param size: size in bytes
 *
 * @pre dst must be a 4-byte aligned address
 * @pre size must be a multiple of 4
 */
static inline void memset32(uint32_t *dst, uint_fast8_t byte_value,
                            size_t size)
{
	register uint32_t *dst_cursor = dst;
	register uint32_t word_value;

	const uint32_t num_words = size / sizeof(uint32_t);
	register const uint32_t *const dst_end = dst + ((num_words / UNROLL_TIMES) * UNROLL_TIMES);

	if (byte_value != 0) {
		word_value = (((uint32_t)byte_value << 24) |
			      ((uint32_t)byte_value << 16) |
			      ((uint32_t)byte_value << 8) |
			      byte_value);
	} else {
		word_value = 0;
	}

	while (dst_cursor != dst_end) {
		*dst_cursor++ = word_value;
		*dst_cursor++ = word_value;
		*dst_cursor++ = word_value;
		*dst_cursor++ = word_value;
	}

	switch (num_words % UNROLL_TIMES) {
	case 3:
		*dst_cursor++ = word_value;
	case 2:
		*dst_cursor++ = word_value;
	case 1:
		*dst_cursor++ = word_value;
	}
}

void *memset(void *dst, int byte_value, size_t size)
{
   uint32_t *dst_words = (uint32_t *)ROUND_UP(dst, sizeof(uint32_t));
   size_t bytes_before_align = (uintptr_t)dst_words - (uintptr_t)dst;
   size_t bytes_after_align = (size - bytes_before_align) % sizeof(uint32_t);
   size_t aligned_size = size - bytes_before_align - bytes_after_align;

   if (bytes_before_align != 0) {
	uint8_t *dst_bytes = dst;

      	switch (bytes_before_align) {
	case 3:
		*dst_bytes++ = byte_value;
	case 2:
		*dst_bytes++ = byte_value;
	case 1:
		*dst_bytes++ = byte_value;
	}
   }

   if (aligned_size != 0) {
       memset32(dst_words, byte_value, aligned_size);
   }

   if (bytes_after_align != 0) {
      	uint8_t *dst_bytes = (uint8_t *)dst_words + aligned_size;

      	switch (bytes_after_align) {
	case 3:
		*dst_bytes++ = byte_value;
	case 2:
		*dst_bytes++ = byte_value;
	case 1:
		*dst_bytes++ = byte_value;
	}
   }

   return dst;
}

int memcmp(const void *src1, const void *src2, size_t size)
{
    register const uint8_t *src1_bytes = src1;
    register const uint8_t *const src1_end = src1_bytes + size;
    register const uint8_t *src2_bytes = src2;

    while (src1_bytes != src1_end) {
	const uint8_t byte1 = *src1_bytes++;
	const uint8_t byte2 = *src2_bytes++;
	if (byte1 < byte2) {
	    return -1;
	} else if (byte1 > byte2) {
	    return 1;
	}
    }

    return 0;
}

