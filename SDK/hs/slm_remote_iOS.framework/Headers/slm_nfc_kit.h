//
//  slm_nfc_kit.h
//  slm_remote_iOS
//
//  Created by huangyeqing on 2025/7/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface slm_nfc_kit : NSObject

+ (NSData *)crackM1CardWithInput:(NSData *)inputData;

@end

NS_ASSUME_NONNULL_END
