//
//  NSObject+Authorized.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/1/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Authorized)

/// 访问相机
+ (BOOL)accessCamera;

@end

NS_ASSUME_NONNULL_END
