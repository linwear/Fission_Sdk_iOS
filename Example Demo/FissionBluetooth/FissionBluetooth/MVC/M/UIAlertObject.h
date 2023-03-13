//
//  UIAlertObject.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/3/11.
//

#import <Foundation/Foundation.h>

typedef enum {
    AlertClickType_Cancel,
    AlertClickType_Sure,
}AlertClickType;

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertObject : NSObject

+ (void)presentAlertTitle:(nullable NSString *)title message:(nullable NSString *)message cancel:(nullable NSString *)cancel sure:(nullable NSString *)sure block:(void (^)(AlertClickType clickType))block;

@end

NS_ASSUME_NONNULL_END
