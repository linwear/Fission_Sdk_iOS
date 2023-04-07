//
//  AppDelegate+FissionSDK.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/3/10.
//

#import "AppDelegate+FissionSDK.h"

@implementation AppDelegate (FissionSDK)

- (void)logOutput:(NSNotification *)notification{
    // SDK日志｜SDK log
    NSString *string = notification.object;
    DDLog(@"%@", string);
}

- (void)FissionSDK_Initialization {
    
    // SDK日志｜SDK log
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOutput:) name:FBLOGNOTIFICATIONOFOUTPUT object:nil];
    
    // 扫描到设备的回调方法｜Scan to device callback method
    [FBBluetoothManager.sharedInstance fbDiscoverPeripheralsWithBlock:^(FBPeripheralModel * _Nonnull peripheralModel) {
        
        [NSNotificationCenter.defaultCenter postNotificationName:FISSION_SDK_CONNECTBINGSTATE object:peripheralModel];
    }];
       
    // 设备断开连接回调方法｜Device disconnection callback method
    [FBBluetoothManager.sharedInstance fbOnDisconnectAtChannelWithBlock:^(CBCentralManager * _Nonnull central, CBPeripheral * _Nonnull peripheral, NSError * _Nonnull error) {
        
        [NSNotificationCenter.defaultCenter postNotificationName:FISSION_SDK_CONNECTBINGSTATE object:@(CONNECTBINGSTATE_DISCONNECT)];
        [NSObject showHUDText:LWLocalizbleString(@"Device disconnected")];
    }];
    
    // 蓝牙状态改变回调方法｜Bluetooth status change callback method
    [FBBluetoothManager.sharedInstance fbOnCentralManagerDidUpdateStateWithBlock:^(CBCentralManager * _Nonnull central, CBManagerState state) {
        // state...
    }];
    
    // 设备连接成功/失败回调方法｜Callback method for device connection success / failure
    [[FBBluetoothManager sharedInstance] fbOnConnectedAtChannelWithBlock:^(CBCentralManager * _Nonnull central, CBPeripheral * _Nonnull peripheral, NSError * _Nonnull error) {
        
        [self ConnectionResults:error];
    }];
    
    // 蓝牙系统错误回调方法｜Bluetooth system error callback method
    [FBBluetoothManager.sharedInstance fbBluetoothSystemErrorWithBlock:^(id  _Nonnull object1, id  _Nonnull object2, NSError * _Nonnull error) {
        
        [NSNotificationCenter.defaultCenter postNotificationName:FISSION_SDK_CONNECTBINGSTATE object:@(CONNECTBINGSTATE_ERROR)];
        [NSObject showHUDText:error.localizedDescription];
    }];
    
    // 设备->查找手机｜Monitor device - > find mobile callback
    [FBAtCommand.sharedInstance fbUpFindPhoneDataWithBlock:^{
        
        [NSObject showHUDText:LWLocalizbleString(@"Device Find Phone")];
        AudioServicesPlaySystemSound(1007);
    }];
    
    // 设备->放弃查找手机｜Monitor device - > give up looking for mobile phone callback
    [FBAtCommand.sharedInstance fbAbandonFindingPhoneWithBlock:^{
        
        [NSObject showHUDText:LWLocalizbleString(@"Device cancel find phone")];
        AudioServicesPlaySystemSound(1001);
    }];
    
    // 设备->手机即时拍照｜Monitoring device - > instant camera callback of mobile phone
    [FBAtCommand.sharedInstance fbUpTakePhotoClickDataWithBlock:^{
        
        [NSObject showHUDText:LWLocalizbleString(@"Take Photo")];
        [NSNotificationCenter.defaultCenter postNotificationName:FISSION_SDK_WATCHCLICKTAKEPHOTO object:nil];
    }];
    
    // 设备->手机配对成功｜Monitoring device - > successful phone pairing IOS callback
    [FBAtCommand.sharedInstance fbUpPairingCompleteDataWithBlock:^{
        
        [NSObject showHUDText:LWLocalizbleString(@"Bluetooth pairing successful")];
    }];
    
    // 设备运动状态变更->手机｜Monitor the status change of GPS Sports Watch - > callback of mobile phone results
    [FBAtCommand.sharedInstance fbGPS_MotionWatchStatusChangeCallbackWithBlock:^(FBGPSMotionActionModel * _Nullable responseObject) {
        
        FBLog(@"🏊change: %@", responseObject.mj_keyValues);
    }];
    
    // 设备端功能开关状态->手机｜Monitor the status of the function switch on the device side and synchronize it to the callback on the mobile phone side
    [FBAtCommand.sharedInstance fbReceiveFunctionSwitchSynchronizationWithBlock:^(FBWatchFunctionChangeNoticeModel * _Nullable responseObject) {
        
        FBLog(@"🖍️change: %@", responseObject.mj_keyValues);

        [NSNotificationCenter.defaultCenter postNotificationName:FISSION_SDK_CONNECTBINGSTATE object:responseObject];
        
        [NSNotificationCenter.defaultCenter postNotificationName:FISSION_SDK_FUNCTIONSTATUSCHANGE object:responseObject];
    }];
    
    // 设备数据流->手机｜Method of receiving stream data after starting stream instruction
    [FBAtCommand.sharedInstance fbStreamDataHandlerWithBlock:^(FBStreamDataModel * _Nonnull responseObject, NSError * _Nonnull error) {
        
        if (error) {
            [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
        }
        else {
            [NSNotificationCenter.defaultCenter postNotificationName:FISSION_SDK_CONNECTBINGSTATE object:responseObject];
        }
    }];
}

#pragma mark - 设备连接结果
- (void)ConnectionResults:(NSError *)error {
    
    /**
     以下连接失败、绑定失败逻辑处理请根据贵司自身业务处理，以下只是示例；如果都成功，请严格按照文档说明执行流程｜Please handle the logic of connection failure and binding failure according to your company's own business. The following are just examples; if all succeed, please strictly follow the documentation to execute the process
     */
    WeakSelf(self);
    if (error) {
        
        [NSNotificationCenter.defaultCenter postNotificationName:FISSION_SDK_CONNECTBINGSTATE object:@(CONNECTBINGSTATE_ERROR)];
        [NSObject showHUDText:error.localizedDescription];
        
    } else {
        
        /** 以下业务逻辑只是为了展示 设备恢复出厂设置 后，APP端弹窗提示是否重新绑定，仅供参考｜The following business logic is just to show that after the device is restored to factory settings, a pop-up window on the APP prompts whether to re-bind, for reference only
         
         1. 连接成功先判断本地是否有连接记录｜1. If the connection is successful, first determine whether there is a connection record locally
            如果本地无连接记录，即首次绑定，跳过查询设备绑定状态，直接发起绑定（FBAtCommand）fbBindDeviceRequest｜If there is no local connection record, that is, the first binding, skip querying the device binding status, and directly initiate the binding (FBAtCommand) fbBindDeviceRequest
         
         2. 本地有连接记录，先查询设备绑定状态｜2. There are connection records locally, first query the device binding status
            查询设备绑定状态（FBAtCommand）fbGetBindingStatusRequestWithBlock｜Query device binding status (FBAtCommand) fbGetBindingStatusRequestWithBlock
         
         3. 设备已有绑定密钥，直接递交密钥，请求绑定｜3. The device already has a binding key, submit the key directly, and request binding
            直接发起绑定（FBAtCommand）fbBindDeviceRequest｜Directly initiate binding (FBAtCommand) fbBindDeviceRequest
         
         4. 设备密钥不存在，弹窗询问客户是否重新绑定｜4. The device key does not exist, and a pop-up window asks the customer whether to re-bind
            确认重新绑定（FBAtCommand）fbBindDeviceRequest｜Confirm Rebind (FBAtCommand) fbBindDeviceRequest
         */
        
        // 1. 本地无连接记录，即首次绑定，跳过查询设备绑定状态，直接发起绑定｜1. There is no local connection record, that is, the first binding, skip querying the device binding status, and directly initiate the binding
        if (StringIsEmpty(FBAllConfigObject.firmwareConfig.deviceName))
        {
            [self RequestBinding]; // 请求绑定｜Request binding
        }
        else // 2. 本地有连接记录，先查询设备绑定状态｜2. There are connection records locally, first query the device binding status
        {
            // 查询设备绑定状态｜Query device binding status
            [FBAtCommand.sharedInstance fbGetBindingStatusRequestWithBlock:^(NSInteger responseObject, NSError * _Nullable error) {
                if (error) {
                    
                    [NSNotificationCenter.defaultCenter postNotificationName:FISSION_SDK_CONNECTBINGSTATE object:@(CONNECTBINGSTATE_BINDING_FAILED)];
                    [NSObject showHUDText:error.domain];
                    [FBBluetoothManager.sharedInstance disconnectPeripheral];
                    
                } else {
                    
                    if (responseObject > 0) // 3. 设备已有绑定密钥，直接递交密钥，请求绑定｜3. The device already has a binding key, submit the key directly, and request binding
                    {
                        [weakSelf RequestBinding]; // 请求绑定｜Request binding
                    }
                    else // 4. 设备密钥不存在，弹窗询问客户是否重新绑定｜4. The device key does not exist, a pop-up window asks the customer whether to re-bind
                    {
                        [UIAlertObject presentAlertTitle:LWLocalizbleString(@"Tip") message:LWLocalizbleString(@"Device reset, do you want to rebind?") cancel:LWLocalizbleString(@"Cancel") sure:LWLocalizbleString(@"Rebind") block:^(AlertClickType clickType) {
                                 
                            if (clickType == AlertClickType_Cancel) // 选择了【取消】｜Selected【Cancel】
                            {
                                [NSNotificationCenter.defaultCenter postNotificationName:FISSION_SDK_CONNECTBINGSTATE object:@(CONNECTBINGSTATE_BINDING_FAILED)];
                                [FBBluetoothManager.sharedInstance disconnectPeripheral];
                                [NSObject showHUDText:LWLocalizbleString(@"Refuse to bind")];
                            }
                            else if (clickType == AlertClickType_Sure) // 选择了【重新绑定】｜Select [Rebind]
                            {
                                [weakSelf RequestBinding]; // 请求绑定｜Request binding
                            }
                        }];
                    }
                }
            }];
        }
    }
}


#pragma mark - 请求绑定｜Request binding
- (void)RequestBinding {
    WeakSelf(self);
    [NSNotificationCenter.defaultCenter postNotificationName:FISSION_SDK_CONNECTBINGSTATE object:@(CONNECTBINGSTATE_BINDING)];
    
    // 绑定设备请求｜Bind device request
    [FBAtCommand.sharedInstance fbBindDeviceRequest:nil withBlock:^(NSInteger responseObject, NSError * _Nullable error) {
                        
        if (error) {
            [NSNotificationCenter.defaultCenter postNotificationName:FISSION_SDK_CONNECTBINGSTATE object:@(CONNECTBINGSTATE_BINDING_FAILED)];
            [NSObject showHUDText:error.domain];
            [FBBluetoothManager.sharedInstance disconnectPeripheral];
            
        } else {
            /**
             @note 🔑设备绑定结果: 0拒绝绑定，1同意绑定，2已被绑定，3确认超时，4递交秘钥错误，5递交秘钥正确，6无需绑定｜🔑 Device binding result: 0 refuses to bind, 1 agrees to bind, 2 has been bound, 3 confirmation timeout, 4 submits the secret key incorrectly, 5 submits the secret key correctly, 6 does not need to bind
             */
            
            
            // 0拒绝绑定｜0 refuses to bind
            if (responseObject==0) {
                
                [NSNotificationCenter.defaultCenter postNotificationName:FISSION_SDK_CONNECTBINGSTATE object:@(CONNECTBINGSTATE_BINDING_FAILED)];
                [NSObject showHUDText:LWLocalizbleString(@"Refuse to bind")];
            }
            // 1同意绑定｜1 agrees to bind
            else if (responseObject == 1) {

                [NSNotificationCenter.defaultCenter postNotificationName:FISSION_SDK_CONNECTBINGSTATE object:@(CONNECTBINGSTATE_GETDEVICEINFO)];
                [NSObject showHUDText:LWLocalizbleString(@"Bind Successfully")];
            }
            // 2已被绑定｜2 has been bound
            else if (responseObject == 2) {
                
                [NSNotificationCenter.defaultCenter postNotificationName:FISSION_SDK_CONNECTBINGSTATE object:@(CONNECTBINGSTATE_BINDING_FAILED)];
                [NSObject showHUDText:LWLocalizbleString(@"Has been bound")];
            }
            // 3确认超时｜3 confirmation timeout
            else if (responseObject == 3) {
                
                [NSNotificationCenter.defaultCenter postNotificationName:FISSION_SDK_CONNECTBINGSTATE object:@(CONNECTBINGSTATE_BINDING_FAILED)];
                [NSObject showHUDText:LWLocalizbleString(@"Binding confirmation timed out")];
            }
            // 4递交秘钥错误｜4 submits the secret key incorrectly
            else if (responseObject == 4) {
                
                [NSNotificationCenter.defaultCenter postNotificationName:FISSION_SDK_CONNECTBINGSTATE object:@(CONNECTBINGSTATE_BINDING_FAILED)];
                [NSObject showHUDText:LWLocalizbleString(@"Bind key error")];
                
            }
            // 5递交秘钥正确｜5 submits the secret key correctly
            else if (responseObject == 5) {
                
                [NSNotificationCenter.defaultCenter postNotificationName:FISSION_SDK_CONNECTBINGSTATE object:@(CONNECTBINGSTATE_GETDEVICEINFO)];
                [NSObject showHUDText:LWLocalizbleString(@"The binding key is correct")];
            }
            // 6无需绑定｜6 does not need to bind
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
                        
                        [weakSelf SynchronizationTime]; // 同步时间｜Synchronization Time
                        
                        [weakSelf SetTimeDisplayMode]; // 同步时间显示格式｜Set time display mode
                        
                        [weakSelf SetDeviceLanguage]; // 同步设备语言｜Set device language
                        
                        // 更多其他设置...｜any more settings...
                        
                        [NSNotificationCenter.defaultCenter postNotificationName:FISSION_SDK_CONNECTBINGSTATE object:@(CONNECTBINGSTATE_COMPLETE)];
                    }
                }];
            } else {
                [FBBluetoothManager.sharedInstance disconnectPeripheral];
            }
        }
    }];
}


#pragma mark - 同步时间｜Synchronization Time
- (void)SynchronizationTime {
    /**
     // Time
     [FBAtCommand.sharedInstance fbSynchronizeUTCTimeWithBlock:^(NSError * _Nullable error) {
         if (error) {
             // error...
         }
     }];

     // Time zone
     NSTimeZone *systemZone = [NSTimeZone systemTimeZone];
     NSInteger minute = systemZone.secondsFromGMT/60;
     [FBAtCommand.sharedInstance fbUpTimezoneMinuteData:minute withBlock:^(NSError * _Nullable error) {
         if (error) {
             // error...
         }
     }];
     */
    
    // Time and Time zone
    [FBAtCommand.sharedInstance fbAutomaticallySynchronizeSystemTimeWithBlock:^(NSError * _Nullable error) {
        if (error) {
            // error...
        }
    }];
}


#pragma mark - 同步时间显示格式｜Set time display mode
- (void)SetTimeDisplayMode {
    // 24 H
    [FBAtCommand.sharedInstance fbUpTimeModeData:FB_TimeDisplayMode24Hours withBlock:^(NSError * _Nullable error) {
        if (error) {
            // error...
        }
    }];
}


#pragma mark - 同步设备语言｜Set device language
- (void)SetDeviceLanguage {
    // 如果默认跟随系统语言｜If follow system language by default
    FB_LANGUAGES language =  FBBluetoothManager.sharedInstance.SDK_Language;
    
    [FBAtCommand.sharedInstance fbUpLanguageData:language withBlock:^(NSError * _Nullable error) {
        if (error) {
            // error...
        }
    }];
}

@end
