//
//  AppDelegate.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/1/5.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [FBLogManager sharedInstance];
    
    BuglyConfig *config = [BuglyConfig new];
    config.debugMode = YES;
    config.blockMonitorEnable = YES;
    config.blockMonitorTimeout = 2;
    config.unexpectedTerminatingDetectionEnable = YES;
    config.reportLogLevel = BuglyLogLevelWarn;
    [Bugly startWithAppId:@"c7e22878ff" developmentDevice:YES config:config];
    
    [SVProgressHUD setBackgroundColor:UIColorBlack];
    [SVProgressHUD setForegroundColor:UIColorWhite];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0f];
    [SVProgressHUD setMaximumDismissTimeInterval:3.0f];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = UIColorWhite;
    FBBaseNavigationController *naviBar = [[FBBaseNavigationController alloc] initWithRootViewController:ViewController.new];
    self.window.rootViewController = naviBar;
    [self.window makeKeyAndVisible];
    self.window.clipsToBounds = YES;
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.enableAutoToolbar = NO;
    
    if (@available(ios 11.0,*)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
    }
    
    [self MoreSettings];
    
    return YES;
}

- (void)execute:(NSNotification *)notification{
    // log
    NSString *string = notification.object;
    DDLog(@"%@", string);
}


- (void)MoreSettings {
    
    // SDK log
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(execute:) name:@"FBLOGNOTIFICATIONOFOUTPUT" object:nil];
    
    // token
    NSString *string = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [LWNetworkingManager requestURL:@"api/v1/base/login/local" httpMethod:POST params:@{@"userIdentify" : string} success:^(id  _Nonnull result) {
        
        if ([result[@"code"] integerValue] == 200) {
            NSString *token = result[@"data"][@"xtoken"];
            [NSUserDefaults.standardUserDefaults setObject: token forKey: @"LW_TOKEN"];
        }
    } failure:^(NSError * _Nonnull error, id  _Nullable responseObject) {
        FBLog(@"%@",error);
    }];
    
    // Scan to device callback method
    [FBBluetoothManager.sharedInstance fbDiscoverPeripheralsWithBlock:^(BOOL isPair, NSString * _Nonnull device_Name, NSString * _Nonnull mac_Address, NSString * _Nonnull adapt_Number, CBPeripheral * _Nonnull peripheral, NSDictionary * _Nonnull advertisementData, NSNumber * _Nonnull RSSI) {
        
        DeviceListModel *model = DeviceListModel.new;
        model.isPair = isPair;
        model.device_Name = device_Name;
        model.mac_Address = mac_Address;
        model.adapt_Number = adapt_Number;
        model.peripheral = peripheral;
        model.advertisementData = advertisementData;
        model.RSSI = RSSI;
        
        [NSNotificationCenter.defaultCenter postNotificationName:FISSION_SDK_CONNECTBINGSTATE object:model];
        
    }];
       
    // Device disconnection callback method
    [FBBluetoothManager.sharedInstance fbOnDisconnectAtChannelWithBlock:^(CBCentralManager * _Nonnull central, CBPeripheral * _Nonnull peripheral, NSError * _Nonnull error) {
        
        [NSNotificationCenter.defaultCenter postNotificationName:FISSION_SDK_CONNECTBINGSTATE object:@(CONNECTBINGSTATE_DISCONNECT)];
        [NSObject showHUDText:LWLocalizbleString(@"Device disconnected")];
    }];
    
    // Bluetooth status change callback method
    [FBBluetoothManager.sharedInstance fbOnCentralManagerDidUpdateStateWithBlock:^(CBCentralManager * _Nonnull central, CBManagerState state) {
        // state...
    }];
    
    // Callback method for device connection success / failure
    [[FBBluetoothManager sharedInstance] fbOnConnectedAtChannelWithBlock:^(CBCentralManager * _Nonnull central, CBPeripheral * _Nonnull peripheral, NSError * _Nonnull error) {
        
        [self ConnectionResults:error];
    }];
    
    // Bluetooth system error callback method
    [FBBluetoothManager.sharedInstance fbBluetoothSystemErrorWithBlock:^(id  _Nonnull object1, id  _Nonnull object2, NSError * _Nonnull error) {
        
        [NSNotificationCenter.defaultCenter postNotificationName:FISSION_SDK_CONNECTBINGSTATE object:@(CONNECTBINGSTATE_ERROR)];
        [NSObject showHUDText:error.localizedDescription];
    }];
    
    // Monitor device - > find mobile callback
    [FBAtCommand.sharedInstance fbUpFindPhoneDataWithBlock:^{
        
        [NSObject showHUDText:LWLocalizbleString(@"Device Find Phone")];
        AudioServicesPlaySystemSound(1007);
    }];
    
    // Monitor device - > give up looking for mobile phone callback
    [FBAtCommand.sharedInstance fbAbandonFindingPhoneWithBlock:^{
        
        [NSObject showHUDText:LWLocalizbleString(@"Device cancel find phone")];
        AudioServicesPlaySystemSound(1001);
    }];
    
    // Monitoring device - > instant camera callback of mobile phone
    [FBAtCommand.sharedInstance fbUpTakePhotoClickDataWithBlock:^{
        
        [NSObject showHUDText:LWLocalizbleString(@"Take Photo")];
        [NSNotificationCenter.defaultCenter postNotificationName:FISSION_SDK_WATCHCLICKTAKEPHOTO object:nil];
    }];
    
    // Monitoring device - > successful phone pairing IOS callback
    [FBAtCommand.sharedInstance fbUpPairingCompleteDataWithBlock:^{
        
        [NSObject showHUDText:LWLocalizbleString(@"Bluetooth pairing successful")];
    }];
    
    // Monitor the status change of GPS Sports Watch - > callback of mobile phone results
    [FBAtCommand.sharedInstance fbGPS_MotionWatchStatusChangeCallbackWithBlock:^(FBGPSMotionActionModel * _Nullable responseObject) {
        
        FBLog(@"🏊change: %@", responseObject.mj_keyValues);
    }];
    
    // Monitor the status of the function switch on the device side and synchronize it to the callback on the mobile phone side
    [FBAtCommand.sharedInstance fbReceiveFunctionSwitchSynchronizationWithBlock:^(FBWatchFunctionChangeNoticeModel * _Nullable responseObject) {
        
        FBLog(@"🖍️change: %@", responseObject.mj_keyValues);

        [NSNotificationCenter.defaultCenter postNotificationName:FISSION_SDK_CONNECTBINGSTATE object:responseObject];
        
        [NSNotificationCenter.defaultCenter postNotificationName:FISSION_SDK_FUNCTIONSTATUSCHANGE object:responseObject];
    }];
    
    // Method of receiving stream data after starting stream instruction
    [FBAtCommand.sharedInstance fbStreamDataHandlerWithBlock:^(FBStreamDataModel * _Nonnull responseObject, NSError * _Nonnull error) {
        
        if (error) {
            [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
        }
        else {
            [NSNotificationCenter.defaultCenter postNotificationName:FISSION_SDK_CONNECTBINGSTATE object:responseObject];
        }
    }];
}

- (void)ConnectionResults:(NSError *)error {
    
    /**
     以下连接失败、绑定失败逻辑处理请根据贵司自身业务处理，以下只是示例；如果都成功，请严格按照文档说明执行流程｜Please handle the logic of connection failure and binding failure according to your company's own business. The following are just examples; if all succeed, please strictly follow the documentation to execute the process
     */
    WeakSelf(self);
    if (error) {
        
        [NSNotificationCenter.defaultCenter postNotificationName:FISSION_SDK_CONNECTBINGSTATE object:@(CONNECTBINGSTATE_ERROR)];
        [NSObject showHUDText:error.localizedDescription];
        
    } else {
        
        [NSNotificationCenter.defaultCenter postNotificationName:FISSION_SDK_CONNECTBINGSTATE object:@(CONNECTBINGSTATE_BINDING)];
        
        // 绑定设备请求｜Bind device request
        [FBAtCommand.sharedInstance fbBindDeviceRequestWithBlock:^(NSInteger responseObject, NSError * _Nullable error) {
            
            if (error) {
                [NSNotificationCenter.defaultCenter postNotificationName:FISSION_SDK_CONNECTBINGSTATE object:@(CONNECTBINGSTATE_BINDING_FAILED)];
                [NSObject showHUDText:error.domain];
                [FBBluetoothManager.sharedInstance disconnectPeripheral];
                
            } else {
                /**
                 @note 🔑设备绑定结果: 0拒绝绑定，1同意绑定，2已被绑定，3确认超时，4递交秘钥错误，5递交秘钥正确，6无需绑定｜🔑 Device binding result: 0 refuses to bind, 1 agrees to bind, 2 has been bound, 3 confirmation timeout, 4 submits the secret key incorrectly, 5 submits the secret key correctly, 6 does not need to bind
                 */
                
                
                // 0 refuses to bind
                if (responseObject==0) {
                    
                    [NSNotificationCenter.defaultCenter postNotificationName:FISSION_SDK_CONNECTBINGSTATE object:@(CONNECTBINGSTATE_BINDING_FAILED)];
                    [NSObject showHUDText:LWLocalizbleString(@"Refuse to bind")];
                }
                // 1 agrees to bind
                else if (responseObject == 1) {

                    [NSNotificationCenter.defaultCenter postNotificationName:FISSION_SDK_CONNECTBINGSTATE object:@(CONNECTBINGSTATE_GETDEVICEINFO)];
                    [NSObject showHUDText:LWLocalizbleString(@"Bind Successfully")];
                }
                // 2 has been bound
                else if (responseObject == 2) {
                    
                    [NSNotificationCenter.defaultCenter postNotificationName:FISSION_SDK_CONNECTBINGSTATE object:@(CONNECTBINGSTATE_BINDING_FAILED)];
                    [NSObject showHUDText:LWLocalizbleString(@"Has been bound")];
                }
                // 3 confirmation timeout
                else if (responseObject == 3) {
                    
                    [NSNotificationCenter.defaultCenter postNotificationName:FISSION_SDK_CONNECTBINGSTATE object:@(CONNECTBINGSTATE_BINDING_FAILED)];
                    [NSObject showHUDText:LWLocalizbleString(@"Binding confirmation timed out")];
                }
                // 4 submits the secret key incorrectly
                else if (responseObject == 4) {
                    
                    [NSNotificationCenter.defaultCenter postNotificationName:FISSION_SDK_CONNECTBINGSTATE object:@(CONNECTBINGSTATE_BINDING_FAILED)];
                    [NSObject showHUDText:LWLocalizbleString(@"Bind key error")];
                    
                }
                // 5 submits the secret key correctly
                else if (responseObject == 5) {
                    
                    [NSNotificationCenter.defaultCenter postNotificationName:FISSION_SDK_CONNECTBINGSTATE object:@(CONNECTBINGSTATE_GETDEVICEINFO)];
                    [NSObject showHUDText:LWLocalizbleString(@"The binding key is correct")];
                }
                // 6 does not need to bind
                else if (responseObject == 6) {
                    
                    [NSNotificationCenter.defaultCenter postNotificationName:FISSION_SDK_CONNECTBINGSTATE object:@(CONNECTBINGSTATE_GETDEVICEINFO)];
                    [NSObject showHUDText:LWLocalizbleString(@"No binding required")];
                }
                
                
                if (responseObject == 1 || responseObject == 5 || responseObject == 6) {
                    // 获取设备硬件信息｜Get device hardware information
                    [FBBgCommand.sharedInstance fbGetHardwareInformationDataWithBlock:^(FB_RET_CMD status, float progress, FBDeviceInfoModel * _Nullable responseObject, NSError * _Nullable error) {
                        
                        if (error) {
                            [NSNotificationCenter.defaultCenter postNotificationName:FISSION_SDK_CONNECTBINGSTATE object:@(CONNECTBINGSTATE_GETDEVICEINFO_FAILED)];
                            [NSObject showHUDText:error.domain];
                        }
                        else if (status == FB_INDATATRANSMISSION) {
                            // Request progress...
                        }
                        else if (status == FB_DATATRANSMISSIONDONE) {
                            
                            [weakSelf SynchronizationTime]; // Synchronization Time
                            
                            [weakSelf SetTimeDisplayMode]; // Set time display mode
                            
                            [weakSelf SetDeviceLanguage]; // Set device language
                            
                            [NSNotificationCenter.defaultCenter postNotificationName:FISSION_SDK_CONNECTBINGSTATE object:@(CONNECTBINGSTATE_COMPLETE)];
                        }
                    }];
                } else {
                    [FBBluetoothManager.sharedInstance disconnectPeripheral];
                }
            }
        }];
    }
}

- (void)SynchronizationTime {
//    [FBAtCommand.sharedInstance fbSynchronizeUTCTimeWithBlock:^(NSError * _Nullable error) {
//        if (error) {
//            // error...
//        }
//    }];
//    
//    NSTimeZone *systemZone = [NSTimeZone systemTimeZone];
//    NSInteger minute = systemZone.secondsFromGMT/60;
//    [FBAtCommand.sharedInstance fbUpTimezoneMinuteData:minute withBlock:^(NSError * _Nullable error) {
//        if (error) {
//            // error...
//        }
//    }];
    
    [FBAtCommand.sharedInstance fbAutomaticallySynchronizeSystemTimeWithBlock:^(NSError * _Nullable error) {
        if (error) {
            // error...
        }
    }];
}

- (void)SetTimeDisplayMode {
    [FBAtCommand.sharedInstance fbUpTimeModeData:FB_TimeDisplayMode24Hours withBlock:^(NSError * _Nullable error) {
        if (error) {
            // error...
        }
    }];
}

- (void)SetDeviceLanguage {
    FB_LANGUAGES language =  FBBluetoothManager.sharedInstance.SDK_Language; // If follow system language by default
    
    [FBAtCommand.sharedInstance fbUpLanguageData:language withBlock:^(NSError * _Nullable error) {
        if (error) {
            // error...
        }
    }];
}


@end
