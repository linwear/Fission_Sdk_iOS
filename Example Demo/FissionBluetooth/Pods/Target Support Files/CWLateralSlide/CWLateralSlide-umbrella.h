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

#import "CWDrawerTransition.h"
#import "CWInteractiveTransition.h"
#import "CWLateralSlideAnimator.h"
#import "CWLateralSlideConfiguration.h"
#import "UIViewController+CWLateralSlide.h"

FOUNDATION_EXPORT double CWLateralSlideVersionNumber;
FOUNDATION_EXPORT const unsigned char CWLateralSlideVersionString[];

