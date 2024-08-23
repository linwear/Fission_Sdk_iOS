//
//  CPicZipApi.hpp
//  SCompressLib
//
//  Created by l30037444 on 2023/10/26.
//

#ifndef CPicZipApi_hpp
#define CPicZipApi_hpp

#include <stdio.h>

struct DecompressRet {
    int width;
    int height;
    int format;
    unsigned char* redChannel;
    unsigned char* greenChannel;
    unsigned char* blueChannel;
    unsigned char* alphaChannel;
};

struct CompressParam {
    int id;
    int width;
    int height;
    int stride;
    int pixelFormat; // 0-- RGB888, 1-- ARGB8888, 2-- RGB565
    int tileWidth;   //TILE: 4-- 4x4, 6-- 6x4, 8-- 8x4, 16-- 16x4
    int modeAlpha;   //0-- A_BYPASS,   1-- A_MERGE,  2-- A_SEPARATE, 3-- A_CONST,   4-- A_BINARY
    int modeRgb;     //0-- RGB_BYPASS, 1-- RGB_ASTC, 2-- RGB_TABLE,  3-- RGB_CONST ,4-- RGB_BINARY
    int cmpMode;
    unsigned char* redChannel;
    unsigned char* greenChannel;
    unsigned char* blueChannel;
    unsigned char* alphaChannel;
};

class CPicZipApi {
public:
    void Compress(const CompressParam& param);
    void Decompress(int id, unsigned char* fileBuffer, int buffLen);
};

#endif /* CPicZipApi_hpp */
