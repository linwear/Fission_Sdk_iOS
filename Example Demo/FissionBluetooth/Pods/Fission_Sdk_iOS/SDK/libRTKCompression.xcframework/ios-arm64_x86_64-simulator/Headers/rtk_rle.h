#pragma once


#include <stdlib.h>
#include <stdio.h>
#include "rtk_rtzip.h"
#include "string.h"

typedef unsigned char  rleuint8;
typedef unsigned short rleuint16;
typedef unsigned int   rleuint32;
typedef unsigned long long rleuint64;

#define RUN_MAX_LENGTH 0xFF

#if defined (__cplusplus)
extern "C" {
#endif

static int GET_NEXT_N_BYTE(const void * input_buffer, int n);

static int RLE_COMPRESS_STAGE1(const unsigned char* input_buffer, int input_pixel_length, int pixel_size, unsigned char* output_buffer, int max_run_length_pixel);

static int RLE_COMPRESS_STAGE2(const unsigned char* stage1_output_buffer, int stage1_output_buffer_length, int stage1_run_length_size, int raw_pixel_length, int raw_pixel_size, unsigned char* stage2_output_buffer, int stage2_run_length_size);

static int RLE_DECOMPRESS_STAGE1(const unsigned char* compressed_buffer, unsigned char* decompressed_buffer, int pixel_length, int pixel_size, int max_run_length_pixel);

static int RLE_DECOMPRESS_STAGE2(const unsigned char* stage2_input_buffer, int stage2_input_buffer_length, int stage1_run_length_size, int stage2_run_length_size, int raw_pixel_size, unsigned char* stage1_output_buffer);

int rle_compressor_with_header_stage1(const unsigned char color_space, int frame_width_pixel, int frame_height_line, int bytes_per_pixel, const unsigned char* input_image_data, const char* output_file_path, int stage1_run_length_size);

int rle_compressor_with_header_stage2(const unsigned char color_space, int frame_width_pixel, int frame_height_line, int bytes_per_pixel, const unsigned char* input_image_data, const char* output_file_path, int stage1_run_length_size, int stage2_run_length_size);

int rle_decompressor_with_header_stage1(int frame_width_pixel, int frame_height_line, int bytes_per_pixel, const char* input_file_path, char* output_file_path, int stage1_run_length_size);

int rle_decompressor_with_header_stage2(int frame_width_pixel, int frame_height_line, int bytes_per_pixel, const char* input_file_path, char* output_file_path, int stage1_run_length_size, int stage2_run_length_size);

#if defined (__cplusplus)
}
#endif
