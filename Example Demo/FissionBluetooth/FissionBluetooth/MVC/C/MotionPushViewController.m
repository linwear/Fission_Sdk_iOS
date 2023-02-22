//
//  MotionPushViewController.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/11/12.
//

#import "MotionPushViewController.h"
#import "MotionPushCollectionViewCell.h"

@interface MotionPushViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *arrayData;
@end

@implementation MotionPushViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self NetworkRequest];
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
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat w = (SCREEN_WIDTH-20)/3;
    
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    layout.itemSize = CGSizeMake(w, w);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationContentTop) collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerNib:[UINib nibWithNibName:@"MotionPushCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MotionPushCollectionViewCell"];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    self.arrayData = NSMutableArray.array;
}

- (void)NetworkRequest {
    
    NSDictionary *param = @{@"adaptNum" : StringHandle(FBAllConfigObject.firmwareConfig.fitNumber),
                            @"page" : @(1),
                            @"pageSize" : @(10000)
    };
    
    WeakSelf(self);
    [LWNetworkingManager requestURL:@"api/v2/sportPush/list" httpMethod:POST params:param success:^(NSDictionary *result) {
        
        if ([result[@"code"] integerValue] == 200) {
            
            NSArray *ary = result[@"data"][@"list"];
                        
            [weakSelf.arrayData removeAllObjects];

            for (NSDictionary *dict in ary) {
                
                [weakSelf.arrayData addObject:dict];
            }

            [weakSelf.collectionView reloadData];
        }
        
    } failure:^(NSError * _Nonnull error, id  _Nullable responseObject) {
                        
    }];
}

- (void)reloadList{
//    [self.arrayData removeAllObjects];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
//    NSString *s = [NSString stringWithFormat:@"%@/motionPush", paths[0]];
//    NSError *err;
//    [self.arrayData addObjectsFromArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:s error:&err]];
//    [self.tableView reloadData];
    [self NetworkRequest];
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
        NSDictionary *dic = self.arrayData[indexPath.row];
        cell.tit.text = dic[@"sportName"];
        [cell.ima sd_setImageWithURL:[NSURL URLWithString:dic[@"appIconUrl"]] placeholderImage:IMAGE_NAME(@"pic_home")];
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSString *fileNamePaths = self.arrayData[indexPath.row];
//
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
//    NSString *fileName = [NSString stringWithFormat:@"%@/motionPush/%@", paths[0], fileNamePaths];
//    NSData *binFile = [NSData dataWithContentsOfFile:fileName];
    
//    [self binFileData:binFile];
    
    NSDictionary *dic = self.arrayData[indexPath.row];
    NSString *url =  dic[@"binUrl"];
    [self downloadOTA:url];
}

// 下载OTA包
- (void)downloadOTA:(NSString *)url {
    [SVProgressHUD showWithStatus:@"Loading..."];
    WeakSelf(self);
    [LWNetworkingManager requestDownloadURL:url success:^(NSDictionary *result) {
        
        NSString *filePath = result[@"filePath"];
        
        NSData *binFile = [NSData dataWithContentsOfFile:filePath];
        
        [weakSelf binFileData:binFile];
        
    } failure:^(NSError * _Nonnull error, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
    }];
}

- (void)binFileData:(NSData *)binFile {
    WeakSelf(self);
    [SVProgressHUD showWithStatus:@"Loading..."];
    
    FBBluetoothOTA.sharedInstance.isCheckPower = NO;
    
    [FBBluetoothOTA.sharedInstance fbStartCheckingOTAWithBinFileData:binFile withOTAType:FB_OTANotification_Motion withBlock:^(FB_RET_CMD status, float progress, FBOTADoneModel * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [SVProgressHUD dismiss];
            [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
        }
        else if (status==FB_INDATATRANSMISSION) {
            [SVProgressHUD showProgress:progress status:[NSString stringWithFormat:@"Loading %.f%%",progress*100]];
        }
        else if (status==FB_DATATRANSMISSIONDONE) {
            [SVProgressHUD dismiss];
            NSString *str = [NSString stringWithFormat:@"%@", responseObject.mj_keyValues];
            UIAlertController *alt = [UIAlertController alertControllerWithTitle:LWLocalizbleString(@"Success") message:str preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *act = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alt addAction:act];
            [weakSelf presentViewController:alt animated:YES completion:nil];
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

@end
