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

#import "SGPermission.h"
#import "SGPermissionCamera.h"
#import "SGPermissionPhoto.h"
#import "SGGenerateQRCode.h"
#import "SGScanCode.h"
#import "SGScanCodeDelegate.h"
#import "SGScanView.h"
#import "SGScanViewConfigure.h"
#import "SGQRCode.h"
#import "SGQRCodeLog.h"
#import "SGSoundEffect.h"
#import "SGTorch.h"
#import "SGWeakProxy.h"

FOUNDATION_EXPORT double SGQRCodeVersionNumber;
FOUNDATION_EXPORT const unsigned char SGQRCodeVersionString[];

