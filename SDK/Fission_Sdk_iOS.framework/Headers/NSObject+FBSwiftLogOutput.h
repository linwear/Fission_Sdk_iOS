//
//  NSObject+FBSwiftLogOutput.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2024-12-11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (FBSwiftLogOutput)

/** log输出字符串 Swift */
+ (void)logOutput_Swift:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
