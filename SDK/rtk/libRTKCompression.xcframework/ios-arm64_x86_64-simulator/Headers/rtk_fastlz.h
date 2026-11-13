/**************************************
 * Description     : fastlz - fast lossless compression library,based on the relization of 2007 Ariya Hidayat
 * Author          : feihu
 * Date            : 2022-06-02
 * LastEditors     :
 * LastEditTime    :
 * FilePath        :
 **************************************/

#include <stdio.h>
#include <stdlib.h>
#include "rtk_rtzip.h"
#include "string.h"

#define FASTLZ_COMPRESS_LEVEL1 1
#define FASTLZ_COMPRESS_LEVEL2 2

#define LITERAL_RUN				1
#define SHORT_MATCH				2
#define LONG_MATCH				3

#define MAX_COPY				32
 //#define MAX_LEN					264  /* 256 + 8 */
 //#define MAX_DISTANCE			8192

 //#define MAX_LEN					64  /* 256 + 8 */
 //#define MAX_DISTANCE			64

#define MAX_LEN					264  /* 256 + 8 */
#define MAX_DISTANCE			64

#define MAX_FARDISTANCE			(65535+MAX_DISTANCE-1)

#define FASTLZ_READU16(p)		((p)[0] | (p)[1]<<8)
#define HASH_LOG				13
#define HASH_SIZE				(1<< HASH_LOG)
#define HASH_MASK				(HASH_SIZE-1)
#define HASH_FUNCTION(v,p)		{ v = FASTLZ_READU16(p); v ^= FASTLZ_READU16(p+1)^(v>>(16-HASH_LOG));v &= HASH_MASK;}

typedef unsigned char  flzuint8;
typedef unsigned short flzuint16;
typedef unsigned int   flzuint32;
typedef unsigned long long flzuint64;

#if defined (__cplusplus)
extern "C" {
#endif

int rtk_fastrlz_compressor_withoutheader(int frame_width_pixel, int frame_height_line, int bytes_per_pixel, int fastlz_level,
	const char* input_file_path, const char* output_file_path, int compress_block_line_nunmber);

int rtk_fastrlz_compressor_withheader(const unsigned char color_space, int frame_width_pixel, int frame_height_line, int bytes_per_pixel, int fastlz_level,
	const unsigned char* input_file_data, const char* output_file_path, int compress_block_line_nunmber);

int rtk_fastrlz_decompressor_withoutheader(int frame_width_pixel, int frame_height_line, int bytes_per_pixel,
	const char* input_file_path, const char* output_file_path);

int rtk_fastrlz_decompressor_withheader(int frame_width_pixel, int frame_height_line, int bytes_per_pixel,
	const char* input_file_path, const char* output_file_path, int compress_block_line_nunmber);

int rtk_fastrlz_decompressor_lines(int frame_width_pixel, int frame_height_line, int bytes_per_pixel,
	const char* input_file_path, const char* output_file_path, int compress_block_line_nunmber,
	int decompress_start_line, int decompress_line_number);


int RTK_FASTLZ_COMPRESSOR_LEVEL1(const void* input, int length, void* output);

int RTK_FASTLZ_DECOMPRESSOR_LEVEL1(const void* input, int length, void* output, int maxout);

#if defined (__cplusplus)
}
#endif
