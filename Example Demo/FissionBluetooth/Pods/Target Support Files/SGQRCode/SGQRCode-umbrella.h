#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "SGAuthorization.h"
#import "SGCreateCode.h"
#import "SGQRCode.h"
#import "SGScanCode.h"
#import "SGScanView.h"

FOUNDATION_EXPORT double SGQRCodeVersionNumber;
FOUNDATION_EXPORT const unsigned char SGQRCodeVersionString[];

