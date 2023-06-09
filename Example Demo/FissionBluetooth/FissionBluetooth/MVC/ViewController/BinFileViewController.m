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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadList];
}

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
}

- (void)reloadList{
    [self.arrayData removeAllObjects];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
    NSString *s = [NSString stringWithFormat:@"%@/firmwares", paths[0]];
    NSError *err;
    [self.arrayData addObjectsFromArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:s error:&err]];
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
        [NSObject showHUDText:error.domain];
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
        [sectionButton setTitle:LWLocalizbleString(@"⚠️ You can also import the local bin file to test the OTA function of the firmware, the specific tutorial poke~👉") forState:UIControlStateNormal];
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
    WeakSelf(self);
    NSString *fileNamePaths = self.arrayData[indexPath.row];
    if ([fileNamePaths containsString:@"https://"]) {
        
        [self downloadOTA:fileNamePaths]; // 下载
        
    } else {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
        NSString *fileName = [NSString stringWithFormat:@"%@/firmwares/%@", paths[0], fileNamePaths];
        NSData *binFile = [NSData dataWithContentsOfFile:fileName];
        
        [NSObject showLoading:LWLocalizbleString(@"Loading...")];
        [weakSelf binFileData:binFile];
    }
}

- (void)showTitle:(NSString *)title forMessage:(NSString *)message{
    
    [UIAlertObject presentAlertTitle:title message:message cancel:nil sure:LWLocalizbleString(@"OK") block:^(AlertClickType clickType) {
        
    }];
}

- (void)binFileData:(NSData *)binFile{
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
    [LWNetworkingManager requestDownloadURL:url success:^(NSDictionary *result) {
        
        NSString *filePath = result[@"filePath"];
        NSData *binFile = [NSData dataWithContentsOfFile:filePath];
        if (binFile.length) {
            [weakSelf binFileData:binFile];
        }
    } failure:^(NSError * _Nonnull error, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        [NSObject showHUDText:error.localizedDescription];
    }];
}

// 组头点击 - 教程
- (void)sectionButtonClick {
    FBTutorialViewController *vc = FBTutorialViewController.new;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
