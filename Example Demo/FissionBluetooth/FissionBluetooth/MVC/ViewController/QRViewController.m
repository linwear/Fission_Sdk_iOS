//
//  QRViewController.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/7/23.
//

#import "QRViewController.h"
#import "FBConnectViewController.h"

@interface QRViewController () <SGScanCodeDelegate>

@property (nonatomic, retain) SGScanCode *scanCode;
@property (nonatomic, strong) SGScanView *scanView;

@property (nonatomic, copy) NSString *mac;

@end

@implementation QRViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 扫描到设备｜Scan to device
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(ScanToDevice:) name:FISSION_SDK_SCANTODEVICENOTICE object:nil];
    
    // Start scanning device
    [self startScanCode];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [self stopScanCode];
    
    // Stop scanning peripherals
    [FBBluetoothManager.sharedInstance cancelScan];
    
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = LWLocalizbleString(@"QR code scanning");
    
    UIBarButtonItem *reloadItem = [[UIBarButtonItem alloc] initWithImage:IMAGE_NAME(@"ic_linear_refresh") style:UIBarButtonItemStylePlain target:self action:@selector(startScanCode)];
    [self.navigationItem setRightBarButtonItem:reloadItem];
    
    /// 创建二维码扫描类
    SGScanCode *scanCode = [SGScanCode scanCode];
    scanCode.preview = self.view;
    scanCode.delegate = self;
    self.scanCode = scanCode;
    
    /// UI
    [self.view addSubview:self.scanView];
}

- (SGScanView *)scanView {
    if (!_scanView) {
        SGScanViewConfigure *configure = [SGScanViewConfigure configure];
        configure.isShowBorder = YES;
        configure.isFromTop = YES;
        configure.color = UIColorClear;
        configure.borderColor = GreenColor;
        configure.borderWidth = 1;
        configure.cornerColor = BlueColor;
        configure.cornerLocation = SGCornerLoactionOutside;
        configure.cornerWidth = 5;
        configure.cornerLength = 30;
        configure.scanline = [NSString stringWithFormat:@"%@/scan_scanline_qq", self.scanCodeBundle.resourcePath];
        
        _scanView = [[SGScanView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) configure:configure];
        _scanView.scanFrame = _scanView.borderFrame;
    }
    return _scanView;
}

- (void)startScanCode {
    if (FBBluetoothManager.sharedInstance.getFBCentralManagerDidUpdateState != CBManagerStatePoweredOn) {
        [NSObject showHUDText:LWLocalizbleString(@"Bluetooth is not turned on or not supported")];
    } else {
        WeakSelf(self);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [weakSelf.scanCode startRunning];
        });
        [self.scanView startScanning];
    }
}

- (void)stopScanCode {
    [self.scanCode stopRunning];
    [self.scanView stopScanning];
}

- (NSBundle *)scanCodeBundle {
    NSURL *url = [[NSBundle bundleForClass:[SGScanViewConfigure class]] URLForResource:@"SGQRCode" withExtension:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:url];
    return bundle;
}

- (void)scanCode:(SGScanCode *)scanCode result:(NSString *)result {
    
    [self stopScanCode];
    
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    
    FBLog(@"%@", result);
    WeakSelf(self);
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

- (void)ScanToDevice:(NSNotification *)obj {
    
    if ([obj.object isKindOfClass:FBPeripheralModel.class]) {
        
        FBPeripheralModel *model = obj.object;
        
        if ([self.mac isEqualToString:model.mac_Address]) {
            
            [FBBluetoothManager.sharedInstance cancelScan];
            [SVProgressHUD dismiss];
            
            FBConnectViewController *vc = FBConnectViewController.new;
            vc.peripheralModel = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

@end
