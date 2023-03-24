//
//  UIAlertObject.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/3/11.
//

#import "UIAlertObject.h"

@implementation UIAlertObject

+ (void)presentAlertTitle:(NSString *)title message:(NSString *)message cancel:(NSString *)cancel sure:(NSString *)sure block:(void (^)(AlertClickType))block {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UILabel *messageLabel = [alert.view valueForKeyPath:@"_messageLabel"];
    messageLabel.textAlignment = NSTextAlignmentLeft;
    
    if (!StringIsEmpty(cancel)) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            if (block) {
                block(AlertClickType_Cancel);
            }
        }];
        [cancelAction setValue:COLOR_HEX(0x909090, 1) forKey:@"_titleTextColor"];
        [alert addAction:cancelAction];
    }

    if (!StringIsEmpty(sure)) {
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:sure style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

            if (block) {
                block(AlertClickType_Sure);
            }
        }];
        [sureAction setValue:GreenColor forKey:@"_titleTextColor"];
        [alert addAction:sureAction];
    }
    
    GCD_MAIN_QUEUE(^{
        [QMUIHelper.visibleViewController presentViewController:alert animated:YES completion:nil];
    });
}

@end
