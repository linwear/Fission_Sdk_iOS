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
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:LWLocalizbleString(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            if (block) {
                block(AlertClickType_Cancel);
            }
        }];
        [cancel setValue:UIColorGray forKey:@"_titleTextColor"];
        [alert addAction:cancel];
    }

    if (!StringIsEmpty(sure)) {
        UIAlertAction *sure = [UIAlertAction actionWithTitle:LWLocalizbleString(@"OK") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

            if (block) {
                block(AlertClickType_Sure);
            }
        }];
        [sure setValue:GreenColor forKey:@"_titleTextColor"];
        [alert addAction:sure];
    }
    
    GCD_MAIN_QUEUE(^{
        [QMUIHelper.visibleViewController presentViewController:alert animated:YES completion:nil];
    });
}

@end
