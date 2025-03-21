//
//  FBDeviceAuthCodeModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2024-12-31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 设备授权码｜Device authorization code
*/
@interface FBDeviceAuthCodeModel : NSObject

/**
 授权码类型｜Authorization code type
*/
@property (nonatomic, assign) FB_AUTHCODETYPE authCodeType;

/**
 授权码｜Authorization Code
*/
@property (nonatomic, copy) NSString *authCode;

@end

NS_ASSUME_NONNULL_END
