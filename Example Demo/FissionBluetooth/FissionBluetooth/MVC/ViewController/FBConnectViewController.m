//
//  FBConnectViewController.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-08-01.
//

#import "FBConnectViewController.h"

typedef enum {
    FBConnectionStatus_Connecting,
    FBConnectionStatus_Success,
    FBConnectionStatus_Failure,
}FBConnectionStatus;

@interface FBConnectViewController ()
@property (weak, nonatomic) IBOutlet UILabel *AdapNumber;
@property (weak, nonatomic) IBOutlet UILabel *macAddress;
@property (weak, nonatomic) IBOutlet UIView *HUD_view;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;

@property (nonatomic, assign) FBConnectionStatus connectionStatus;

@end

@implementation FBConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = self.peripheralModel.device_Name;
    
    // result
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(result:) name:FISSION_SDK_CONNECTBINGSTATE object:nil];
    
    self.AdapNumber.text = [NSString stringWithFormat:@"%@: %@", LWLocalizbleString(@"Project Number"), self.peripheralModel.adapt_Number];
    self.macAddress.text = [NSString stringWithFormat:@"%@  %@", LWLocalizbleString(@"Mac Address"), self.peripheralModel.mac_Address];
    
    self.HUD_view.backgroundColor = UIColorClear;
    
    self.button.backgroundColor = BlueColor;
    
    [self connect];
}

- (void)result:(NSNotification *)obj {
    
    WeakSelf(self);
    GCD_MAIN_QUEUE((^{
        if ([obj.object isKindOfClass:NSNumber.class]) {
            
            CONNECTBINGSTATE state = (CONNECTBINGSTATE)[obj.object integerValue];
            NSString *errorString = obj.userInfo[@"ERROR"];
            
            if (state == CONNECTBINGSTATE_DISCONNECT) { // 连接断开｜Disconnect
                [weakSelf showError:errorString isShowAlert:NO];
            }
            else if (state == CONNECTBINGSTATE_ERROR) { // 连接失败｜Connection failed
                [weakSelf showError:errorString isShowAlert:NO];
            }
            else if (state == CONNECTBINGSTATE_BINDING) { // 连接成功，绑定中｜The connection is successful, binding
                weakSelf.stateLabel.text = [NSString stringWithFormat:LWLocalizbleString(@"The connection is successful, please confirm the binding operation on %@"), self.peripheralModel.device_Name];
            }
            else if (state == CONNECTBINGSTATE_BINDING_FAILED) { // 绑定失败｜Binding failed
                [weakSelf showError:errorString isShowAlert:YES];
            }
            else if (state == CONNECTBINGSTATE_GETDEVICEINFO) { // 绑定成功，获取设备信息中｜The binding is successful, and the device information is being obtained
                weakSelf.stateLabel.text = LWLocalizbleString(@"The binding is successful, and the device information is being obtained");
            }
            else if (state == CONNECTBINGSTATE_GETDEVICEINFO_FAILED) { // 获取设备信息失败｜Failed to get device information
                [weakSelf showError:errorString isShowAlert:NO];
            }
            else if (state == CONNECTBINGSTATE_COMPLETE) { // 设备信息获取成功，完成｜The device information is obtained successfully, complete
                [weakSelf showSuccess];
            }
        }
    }));
}

- (void)connect {
    
    self.connectionStatus = FBConnectionStatus_Connecting;
    
    if (FBBluetoothManager.sharedInstance.getFBCentralManagerDidUpdateState == CBManagerStatePoweredOn) {
                
        self.stateLabel.text = LWLocalizbleString(@"Connecting");
        self.stateLabel.textColor = UIColorBlack;
        [FBHUD showLoading:self.HUD_view];
        
        self.button.hidden = YES;
        
        // 发起连接
        [FBBluetoothManager.sharedInstance connectToPeripheral:self.peripheralModel.peripheral];
    } else {
        [self showError:LWLocalizbleString(@"Bluetooth is not turned on or not supported") isShowAlert:NO];
    }
}

- (void)showError:(NSString *)errorString isShowAlert:(BOOL)isShowAlert {
    
    self.connectionStatus = FBConnectionStatus_Failure;
        
    [FBHUD showFailure:self.HUD_view];
    self.stateLabel.text = errorString;
    self.stateLabel.textColor = UIColorRed;
    
    self.button.hidden = NO;
    [self.button setTitle:LWLocalizbleString(@"Rebind") forState:UIControlStateNormal];
    
    if (isShowAlert) { // show alert
        GCD_AFTER(1, ^{
            [UIAlertObject presentAlertTitle:LWLocalizbleString(@"Tip") message:errorString cancel:nil sure:LWLocalizbleString(@"OK") block:^(AlertClickType clickType) {
                // something...
            }];
        });
    }
}

- (void)showSuccess {
    
    RLMDeviceListModel *model = RLMDeviceListModel.new;
    model.begin = NSDate.date.timeIntervalSince1970;
    [model QuickSetup];
    
    // 保存绑定的设备记录
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm addOrUpdateObject:model];
    }];
    
    [Tools saveRecentlyDeviceName:model.deviceName];
    [Tools saveRecentlyDeviceMAC:model.deviceMAC];
    
    self.connectionStatus = FBConnectionStatus_Success;
    
    [FBHUD showSuccess:self.HUD_view];
    self.stateLabel.text = LWLocalizbleString(@"Bind Successfully");
    self.stateLabel.textColor = GreenColor;
    
    self.button.hidden = NO;
    [self.button setTitle:LWLocalizbleString(@"Bind Successfully") forState:UIControlStateNormal];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)buttonClick:(id)sender {
    
    if (self.connectionStatus == FBConnectionStatus_Success) {
        [self.navigationController popToRootViewControllerAnimated:YES]; // 直接pop到root控制器
    } else {
        [self connect];
    }
}

/// 拦截系统返回事件，外部可重写此方法
- (BOOL)shouldPopViewControllerByBackButtonOrPopGesture:(BOOL)byPopGesture {
    
    BOOL pop = NO; // 是否允许pop到上一页
    
    if (byPopGesture) { // 侧滑返回
        pop = self.connectionStatus == FBConnectionStatus_Failure; // 只有失败才允许侧滑pop
        if (self.connectionStatus == FBConnectionStatus_Success) {
            [self.navigationController popToRootViewControllerAnimated:YES]; // 直接pop到root控制器
        }
    }
    else // 点击返回
    {
        if (self.connectionStatus == FBConnectionStatus_Success) {
            pop = NO;
            [self.navigationController popToRootViewControllerAnimated:YES]; // 直接pop到root控制器
        }
        else if (self.connectionStatus == FBConnectionStatus_Failure) {
            pop = YES; // 失败，允许pop
        }
    }
    
    return pop;
}

@end
