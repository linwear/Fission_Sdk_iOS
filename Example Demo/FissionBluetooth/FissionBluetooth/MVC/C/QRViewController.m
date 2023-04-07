//
//  QRViewController.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/7/23.
//

#import "QRViewController.h"

@interface QRViewController ()

@property (nonatomic, retain) SGScanCode *scanCode;

@property (nonatomic, copy) NSString *mac;

@end

@implementation QRViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // result
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(result:) name:FISSION_SDK_CONNECTBINGSTATE object:nil];
    
    // Start scanning device
    [self startScan];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [self.scanCode stopRunning];
    
    // Stop scanning peripherals
    [FBBluetoothManager.sharedInstance cancelScan];
    
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = LWLocalizbleString(@"QR code scanning");
    
    UIBarButtonItem *reloadItem = [[UIBarButtonItem alloc] initWithImage:IMAGE_NAME(@"ic_linear_refresh") style:UIBarButtonItemStylePlain target:self action:@selector(startScan)];
    [self.navigationItem setRightBarButtonItem:reloadItem];
    
    WeakSelf(self);
    /// 创建二维码扫描类
    self.scanCode = [SGScanCode scanCode];
    /// 二维码扫描回调方法
    [self.scanCode scanWithController:self resultBlock:^(SGScanCode *scanCode, NSString *result) {
        
        [weakSelf.scanCode stopRunning];
        
        FBLog(@"%@", result);
        
        [UIAlertObject presentAlertTitle:LWLocalizbleString(@"Scan Result") message:result cancel:LWLocalizbleString(@"Cancel") sure:LWLocalizbleString(@"Connect") block:^(AlertClickType clickType) {
            
            if (clickType == AlertClickType_Sure) {
                NSArray *array = [Tools componentsSeparatedBySetCharacters:@"& " withString:result]; // 用&符号和空格 分割
                NSString *tempStr = nil;
                for (NSString *arrStr in array) {
                    if ([arrStr containsString:@"MAC="] || [arrStr containsString:@"MAC:"]) {
                        tempStr = arrStr;
                    }
                }
                
                NSRange range = [tempStr rangeOfString:@"MAC="]; // Subscript obtained by matching
                if (range.location == NSNotFound) {
                    // If the above does not match, find the following
                    range = [tempStr rangeOfString:@"MAC:"]; // Subscript obtained by matching
                }
                
                if (StringIsEmpty(tempStr) || range.location == NSNotFound) {
                    // No match
                    NSString *message = LWLocalizbleString(@"This type of QR code is not supported");
                    
                    [NSObject showHUDText:message];
                    
                    return;
                }
                tempStr = [tempStr substringFromIndex:range.location + range.length];//截取范围类的字符串
                if (![tempStr containsString:@":"]) { // 规范mac地址格式，转大写加:符号
                    tempStr = [tempStr uppercaseString];
                    tempStr = [Tools insertColonEveryTwoCharactersWithString:tempStr];
                }
                
                [weakSelf mac:tempStr];
            }
        }];
    }];
}

- (void)startScan{
    
    if (FBBluetoothManager.sharedInstance.getFBCentralManagerDidUpdateState != CBManagerStatePoweredOn) {
        
        [NSObject showHUDText:LWLocalizbleString(@"Bluetooth is not turned on or not supported")];
    } else {
        [self.scanCode startRunningWithBefore:^{
        } completion:^{
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)mac:(NSString *)mac {
    
    [NSObject showLoading:LWLocalizbleString(@"Searching for connection")];
    
    self.mac = mac;
    
    [FBBluetoothManager.sharedInstance scanForPeripherals];
}

- (void)result:(NSNotification *)obj {
    
    if ([obj.object isKindOfClass:NSNumber.class]) {
        
        CONNECTBINGSTATE state = (CONNECTBINGSTATE)[obj.object integerValue];
        if (state == CONNECTBINGSTATE_COMPLETE) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    else if ([obj.object isKindOfClass:FBPeripheralModel.class]) {
        
        FBPeripheralModel *model = obj.object;
        
        if ([self.mac isEqualToString:model.mac_Address]) {
            
            [FBBluetoothManager.sharedInstance cancelScan];
            
            [SVProgressHUD dismiss];
            [NSObject showLoading:LWLocalizbleString(@"Connecting")];
            
            [FBBluetoothManager.sharedInstance connectToPeripheral:model.peripheral];
        }
    }
}

@end
