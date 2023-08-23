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
    
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:title];
    [attributedTitle addAttributes:@{NSForegroundColorAttributeName:BlueColor} range:NSMakeRange(0, title.length)];
    [attributedTitle addAttributes:@{NSFontAttributeName:[NSObject BahnschriftFont:17]} range:NSMakeRange(0, title.length)];
    [alert setValue:attributedTitle forKey:@"attributedTitle"];
    
    NSMutableAttributedString *attributedMessage = [[NSMutableAttributedString alloc] initWithString:message];
    [attributedMessage addAttributes:@{NSForegroundColorAttributeName:UIColorRed} range:NSMakeRange(0, message.length)];
    [attributedMessage addAttributes:@{NSFontAttributeName:[NSObject BahnschriftFont:15]} range:NSMakeRange(0, message.length)];
    [alert setValue:attributedMessage forKey:@"attributedMessage"];
    
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
