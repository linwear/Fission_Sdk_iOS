//
//  NSObject+Authorized.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/1/5.
//

#import "NSObject+Authorized.h"

@implementation NSObject (Authorized)

+ (BOOL)accessCamera {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        // 无相机权限 做一个友好的提示
        NSString *string = [NSString stringWithFormat:LWLocalizbleString(@"Please allow %@ to access the camera in \"Settings-Privacy-Camera\" of the iPhone"), Tools.appName];
        [self showAlertController:string];
        return NO;
    } else {
        return YES;
    }
}


+ (void)showAlertController:(NSString *)message {
    
    [UIAlertObject presentAlertTitle:LWLocalizbleString(@"Tip") message:message cancel:LWLocalizbleString(@"Cancel") sure:LWLocalizbleString(@"Set") block:^(AlertClickType clickType) {
        
        if (clickType == AlertClickType_Sure) {
            //进入系统设置页面，APP本身的权限管理页面
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }
    }];
}

@end
