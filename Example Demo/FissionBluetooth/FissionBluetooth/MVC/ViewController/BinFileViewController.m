//
//  BinFileViewController.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/3/25.
//

#import "BinFileViewController.h"
#import "BinFileTableViewCell.h"
#import "FBTutorialViewController.h"

@interface BinFileViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrayData;
@end

@implementation BinFileViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [Tools idleTimerDisabled:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [Tools idleTimerDisabled:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:IMAGE_NAME(@"ic_linear_refresh") style:UIBarButtonItemStylePlain target:self action:@selector(reloadList)];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,NavigationContentTop,SCREEN_WIDTH, SCREEN_HEIGHT-NavigationContentTop)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:BinFileTableViewCell.class forCellReuseIdentifier:@"BinFileTableViewCell"];
    [self.tableView registerClass:UITableViewHeaderFooterView.class forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
    [self.view addSubview:self.tableView];
    
    self.arrayData = [NSMutableArray array];
    
    [self reloadList];
}

- (void)reloadList{
    [self.arrayData removeAllObjects];
    
    NSString *filePath = FBDocumentDirectory(FBFirmwareFile);
    NSArray *fileArray = [NSFileManager.defaultManager contentsOfDirectoryAtPath:filePath error:nil];
    if (fileArray.count) {
        [self.arrayData addObjectsFromArray:fileArray];
    }
    
    [self.tableView reloadData];
        
    NSDictionary *param = @{@"adaptNum" : StringHandle(FBAllConfigObject.firmwareConfig.fitNumber),
                            @"version" : StringHandle(FBAllConfigObject.firmwareConfig.firmwareVersion)};
    WeakSelf(self);
    [LWNetworkingManager requestURL:@"api/v2/ota" httpMethod:POST params:param success:^(NSDictionary *result) {
        if ([result[@"code"] integerValue] == 200) {
            NSString *otaUrl = result[@"data"][@"otaUrl"];
            if (otaUrl.length) {
                
                if (![otaUrl containsString:@"https://"]) {
                    otaUrl = [NSString stringWithFormat:@"https://%@", otaUrl];
                }
                
                [weakSelf.arrayData addObject:otaUrl];
                [weakSelf.tableView reloadData];
            }
        }
    } failure:^(NSError * _Nonnull error, id  _Nullable responseObject) {
        [NSObject showHUDText:error.localizedDescription];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *sectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    sectionView.contentView.backgroundColor = COLOR_HEX(0xFAFAD2, 1);
    
    NSMutableArray *class = NSMutableArray.array;
    for (UIView *subview in sectionView.subviews) {
        [class addObject:NSStringFromClass(subview.class)];
    }
    
    if (![class containsObject:NSStringFromClass(QMUIButton.class)]) {
        QMUIButton *sectionButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [sectionButton setTitleColor:UIColorBlack forState:UIControlStateNormal];
        [sectionButton setTitle:[NSString stringWithFormat:@"%@【%@】%@ 👈", LWLocalizbleString(@"⚠️How to import local .Bin file for testing OTA function, click here for detailed tutorial~👉"), FBFirmwareFile, LWLocalizbleString(@"Folder")] forState:UIControlStateNormal];
        sectionButton.titleLabel.font = FONT(13);
        sectionButton.titleLabel.numberOfLines = 0;
        [sectionView addSubview:sectionButton];
        [sectionButton addTarget:self action:@selector(sectionButtonClick) forControlEvents:UIControlEventTouchUpInside];
        sectionButton.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 12, 0, 12));
    }
    
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:SCREEN_WIDTH tableView:tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BinFileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BinFileTableViewCell"];
    
    if (indexPath.row < self.arrayData.count) {
        
        NSString *path = self.arrayData[indexPath.row];
        
        [cell reloadTitle:path];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *fileNamePath = self.arrayData[indexPath.row];
    
    // 服务器文件
    if ([fileNamePath containsString:@"https://"]) {
        [self downloadOTA:fileNamePath]; // 下载
    }
    // 本地文件
    else {
        NSString *file = [FBDocumentDirectory(FBFirmwareFile) stringByAppendingPathComponent:fileNamePath];
        NSData *binFile = [NSData dataWithContentsOfFile:file];
        
        [NSObject showLoading:LWLocalizbleString(@"Loading...")];
        [self StartOtaUpgradeWithData:binFile];
    }
}

- (void)showTitle:(NSString *)title forMessage:(NSString *)message{
    
    [UIAlertObject presentAlertTitle:title message:message cancel:nil sure:LWLocalizbleString(@"OK") block:^(AlertClickType clickType) {
        
    }];
}

#pragma mark - 启动OTA升级｜Start Ota Upgrade
- (void)StartOtaUpgradeWithData:(NSData *)binFile {
    WeakSelf(self);
    
    FBBluetoothOTA.sharedInstance.isCheckPower = NO;
    
    FBBluetoothOTA.sharedInstance.sendTimerOut = 90;
    
    [FBBluetoothOTA.sharedInstance fbStartCheckingOTAWithBinFileData:binFile withOTAType:FB_OTANotification_Firmware withBlock:^(FB_RET_CMD status, FBProgressModel * _Nullable progress, FBOTADoneModel * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
        }
        else if (status==FB_INDATATRANSMISSION) {
            [NSObject showProgress:progress.totalPackageProgress/100.0 status:[NSString stringWithFormat:@"%@ %ld%% (%ld%% %ld/%ld)", LWLocalizbleString(@"Synchronize"), progress.totalPackageProgress, progress.currentPackageProgress, progress.currentPackage, progress.totalPackage]];
        }
        else if (status==FB_DATATRANSMISSIONDONE) {
            [SVProgressHUD dismiss];
            NSString *str = [NSString stringWithFormat:@"%@", responseObject.mj_keyValues];
            [weakSelf showTitle:LWLocalizbleString(@"Success") forMessage:str];
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
// 下载OTA包
- (void)downloadOTA:(NSString *)url {
    [NSObject showLoading:LWLocalizbleString(@"Loading...")];
    WeakSelf(self);
    [LWNetworkingManager requestDownloadURL:url namePrefix:@"FBFirmware" success:^(NSDictionary *result) {
        
        NSString *filePath = result[@"filePath"];
        NSData *binFile = [NSData dataWithContentsOfFile:filePath];
        if (binFile.length) {
            [weakSelf StartOtaUpgradeWithData:binFile];
        }
    } failure:^(NSError * _Nonnull error, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        [NSObject showHUDText:error.localizedDescription];
    }];
}

// 组头点击 - 教程
- (void)sectionButtonClick {
    FBTutorialViewController *vc = FBTutorialViewController.new;
    vc.isFirmware = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
