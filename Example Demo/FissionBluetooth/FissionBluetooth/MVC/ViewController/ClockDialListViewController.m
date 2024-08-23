//
//  ClockDialListViewController.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/4/16.
//


#import "ClockDialListViewController.h"
#import "MotionPushCollectionViewCell.h"
#import "LWCustomDialViewController.h"
#import "DialListModel.h"

@interface ClockDialListViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (nonatomic, assign) NSInteger plateClassify;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *arrayData;
@property (nonatomic, assign) BOOL isBreak;
@end

@implementation ClockDialListViewController

- (instancetype)initWithPlateClassify:(NSInteger)plateClassify {
    if (self = [super init]) {
        
        self.plateClassify = plateClassify;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
        
    if (!self.isBreak) {
        self.isBreak = YES;
        
        NSDictionary *param = @{@"adaptNum" : StringHandle(FBAllConfigObject.firmwareConfig.fitNumber),
                                @"classifyType" : @(self.plateClassify), // 1表示最新的表盘分类 暂定
                                @"page" : @(1),
                                @"pageSize" : @(1000)
        };
        
        WeakSelf(self);
        [LWNetworkingManager requestURL:@"api/v2/plate/classify" httpMethod:POST params:param success:^(NSDictionary *result) {
            if ([result[@"code"] integerValue] == 200) {
                [weakSelf.arrayData removeAllObjects];
                NSArray *ary = result[@"data"][@"list"];
                for (NSDictionary *dict in ary) {
                    DialListModel *model = [DialListModel new];
                    [model mj_setKeyValues:dict];
                    [weakSelf.arrayData addObject:model];
                }
                [weakSelf.collectionView reloadData];
            }
        } failure:^(NSError * _Nonnull error, id  _Nullable responseObject) {
            [NSObject showHUDText:error.localizedDescription];
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.arrayData = [NSMutableArray array];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat w = (SCREEN_WIDTH-20)/3;
    
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    layout.itemSize = CGSizeMake(w, w+45);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerNib:[UINib nibWithNibName:@"MotionPushCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MotionPushCollectionViewCell"];
    [self.view addSubview:collectionView];
    collectionView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    self.collectionView = collectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrayData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MotionPushCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MotionPushCollectionViewCell" forIndexPath:indexPath];
    cell.qmui_selectedBackgroundColor = UIColorTestGreen;
    if (self.arrayData.count > indexPath.row) {
        DialListModel *model = self.arrayData[indexPath.row];
        [cell.ima sd_setImageWithURL:[NSURL URLWithString:model.plateUrl] placeholderImage:IMAGE_NAME(@"pic_home")];
        cell.tit.text = [NSString stringWithFormat:@"🆔 %ld", model.plateId];
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DialListModel *model = self.arrayData[indexPath.row];
    
    WeakSelf(self);
    FBLog(@"请确认是否同步表盘?");
    NSString *message = LWLocalizbleString(@"Please confirm whether the watch face is synchronized");
    
    [UIAlertObject presentAlertTitle:LWLocalizbleString(@"Tip") message:message cancel:LWLocalizbleString(@"Cancel") sure:LWLocalizbleString(@"OK") block:^(AlertClickType clickType) {
        
        if (clickType == AlertClickType_Sure) {
            [weakSelf downloadOTA:model.plateZip plateId:model.plateId];
        }
    }];
}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
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
- (void)downloadOTA:(NSString *)url plateId:(NSInteger)plate {
    [NSObject showLoading:LWLocalizbleString(@"Loading...")];
    WeakSelf(self);
    [LWNetworkingManager requestDownloadURL:url namePrefix:@"FBOnlineDial" success:^(NSDictionary *result) {
        
        NSString *filePath = result[@"filePath"];
        
        FB_OTANOTIFICATION OTAType = FB_OTANotification_ClockDial;
        
        NSData *binFile = [NSData dataWithContentsOfFile:filePath];
        
        if (FBAllConfigObject.firmwareConfig.chipManufacturer == FB_CHIPMANUFACTURERTYPE_HISI) {
            // 海思的需要先合并一个文件信息
            // Dial_online_L******_xxxxxxxxxx_AAAA.bin（其中******为文件大小，xxxxxxxxxx为时间戳，AAAA为唯一ID｜Where ****** is the file size, xxxxxxxxxx is the timestamp, and AAAA is the unique ID）
            NSString *nameString = [NSString stringWithFormat:@"Dial_online_L%ld_%ld_%ld.bin", binFile.length, (NSInteger)NSDate.date.timeIntervalSince1970, plate];
            binFile = [FBCustomDataTools createFileName:nameString withFileData:binFile withOTAType:OTAType];
        }
        
        FBBluetoothOTA.sharedInstance.isCheckPower = NO;
        
        FBBluetoothOTA.sharedInstance.sendTimerOut = 30;
        
        [FBBluetoothOTA.sharedInstance fbStartCheckingOTAWithBinFileData:binFile withOTAType:OTAType withBlock:^(FB_RET_CMD status, FBProgressModel * _Nullable progress, FBOTADoneModel * _Nullable responseObject, NSError * _Nullable error) {
            if (error) {
                [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
            }
            else if (status==FB_INDATATRANSMISSION) {
                [NSObject showProgress:progress.totalPackageProgress/100.0 status:[NSString stringWithFormat:@"%@ %ld%%", LWLocalizbleString(@"Synchronize"), progress.totalPackageProgress]];
            }
            else if (status==FB_DATATRANSMISSIONDONE) {
                [SVProgressHUD dismiss];
                NSString *str = [NSString stringWithFormat:@"%@", responseObject.mj_keyValues];
                [weakSelf showTitle:LWLocalizbleString(@"Success") forMessage:str];
            }
        }];
    } failure:^(NSError * _Nonnull error, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
    }];
}

- (void)showTitle:(NSString *)title forMessage:(NSString *)message{
    
    [UIAlertObject presentAlertTitle:title message:message cancel:nil sure:LWLocalizbleString(@"OK") block:^(AlertClickType clickType) {
        
    }];
}

@end
