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
    
    [Tools idleTimerDisabled:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [Tools idleTimerDisabled:NO];
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
        [NSObject showHUDText:error.domain];
    }];
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
        cell.tit.text = [NSString stringWithFormat:@"🆔 %@", model.plateId];
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DialListModel *model = self.arrayData[indexPath.row];
    
    FBLog(@"请确认是否同步表盘?");
    NSString *message = LWLocalizbleString(@"Please confirm whether the watch face is synchronized");

    WeakSelf(self);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    NSMutableAttributedString *attributedMessage = [[NSMutableAttributedString alloc] initWithString:message attributes: @{NSFontAttributeName: [NSObject themePingFangSCMediumFont:14], NSForegroundColorAttributeName: [UIColor blackColor]}];
    [alert setValue:attributedMessage forKey:@"attributedMessage"];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [cancel setValue:GreenColor forKey:@"_titleTextColor"];
    [alert addAction:cancel];
    
    UIAlertAction *sure = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

        [weakSelf downloadOTA:model.plateZip];
    }];
    [sure setValue:GreenColor forKey:@"_titleTextColor"];
    [alert addAction:sure];
    
    [self presentViewController:alert animated:YES completion:nil];
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
- (void)downloadOTA:(NSString *)url {
    [SVProgressHUD showWithStatus:LWLocalizbleString(@"Loading...")];
    WeakSelf(self);
    [LWNetworkingManager requestDownloadURL:url success:^(NSDictionary *result) {
        
        NSString *filePath = result[@"filePath"];
        
        NSData *binFile = [NSData dataWithContentsOfFile:filePath];
        
        FBBluetoothOTA.sharedInstance.isCheckPower = NO;
        
        [FBBluetoothOTA.sharedInstance fbStartCheckingOTAWithBinFileData:binFile withOTAType:FB_OTANotification_ClockDial withBlock:^(FB_RET_CMD status, FBProgressModel * _Nullable progress, FBOTADoneModel * _Nullable responseObject, NSError * _Nullable error) {
            if (error) {
                [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
            }
            else if (status==FB_INDATATRANSMISSION) {
                [SVProgressHUD showProgress:progress.totalPackageProgress/100.0 status:[NSString stringWithFormat:@"%@ %ld%%", LWLocalizbleString(@"Synchronize"), progress.totalPackageProgress]];
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
    UIAlertController *alt = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *act = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alt addAction:act];
    [self presentViewController:alt animated:YES completion:nil];
}

@end
