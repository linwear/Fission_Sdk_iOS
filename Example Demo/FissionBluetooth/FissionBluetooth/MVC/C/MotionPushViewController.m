//
//  MotionPushViewController.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/11/12.
//

#import "MotionPushViewController.h"
#import "LWMotionPushSelectCell.h"
#import "LWMotionPushDataCell.h"

#import "LWMotionPushDownloadObject.h"

@interface MotionPushViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray <LWMotionPushClassifyModel *> *dataAry; // 元数据

@property (nonatomic, strong) NSMutableArray <LWMotionPushSectionModel *> *sectionAry; // 组头描述数据

@property (nonatomic, strong) NSMutableArray <LWMotionPushModel *> *selectAry; // 已选择数据

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, assign) BOOL isTwoGroups; // 两组吗

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
        
    self.isTwoGroups = (FBAllConfigObject.firmwareConfig.supportMultipleSports && FBAllConfigObject.firmwareConfig.supportMultipleSportsCount>0);
    
    self.dataAry = NSMutableArray.array;
    self.sectionAry = NSMutableArray.array;
    self.selectAry = NSMutableArray.array;
    
    if (self.isTwoGroups) {
        
        LWMotionPushSectionModel *model1 = LWMotionPushSectionModel.new;
        model1.title = LWLocalizbleString(@"Watch Movement");
        model1.detail = LWLocalizbleString(@"Press and hold the module and drag to adjust the display order");
    
        [self.sectionAry addObject:model1];
    }

    LWMotionPushSectionModel *model2 = LWMotionPushSectionModel.new;
    model2.title = LWLocalizbleString(@"Add Movement");
    model2.detail = @"";
    
    [self.sectionAry addObject:model2];
        

    QMUIButton *mainButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [mainButton setBackgroundColor:BlueColor];
    [mainButton setTitleColor:UIColorWhite forState:UIControlStateNormal];
    [mainButton setTitle:LWLocalizbleString(@"Synchronize") forState:UIControlStateNormal];
    mainButton.titleLabel.font = [NSObject themePingFangSCMediumFont:18];
    mainButton.cornerRadius = 24;
    [mainButton addTarget:self action:@selector(butClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:mainButton];
    mainButton.sd_layout.leftSpaceToView(self.view, 60).rightSpaceToView(self.view, 60).heightIs(48).bottomSpaceToView(self.view, 30);
    self.button = mainButton;
    self.button.hidden = YES;
    self.button.enabled = NO;

    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = COLOR_HEX(0xE6E6FA, 1);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    [tableView registerClass:LWMotionPushSelectCell.class forCellReuseIdentifier:@"LWMotionPushSelectCell"];
    [tableView registerClass:LWMotionPushDataCell.class forCellReuseIdentifier:@"LWMotionPushDataCell"];
    self.tableView = tableView;
    self.tableView.sd_layout.topSpaceToView(self.view, NavigationContentTop).leftEqualToView(self.view).rightEqualToView(self.view).bottomSpaceToView(self.button, 15);
}

- (void)butClick {
    if (self.selectAry.count) {
        
        [self confirmWithArray:self.selectAry];
    }
}

// 确认？
- (void)confirmWithArray:(NSArray <LWMotionPushModel *> *)array {
    FBLog(@"请确认是否推送运动?");
    NSString *message = LWLocalizbleString(@"Please confirm whether to push sports");

    WeakSelf(self);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    NSMutableAttributedString *attributedMessage = [[NSMutableAttributedString alloc] initWithString:message attributes: @{NSFontAttributeName: [NSObject themePingFangSCMediumFont:14], NSForegroundColorAttributeName: [UIColor blackColor]}];
    [alert setValue:attributedMessage forKey:@"attributedMessage"];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [cancel setValue:GreenColor forKey:@"_titleTextColor"];
    [alert addAction:cancel];
    
    UIAlertAction *sure = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

        [weakSelf downloadProcessingWithArray:array];
    }];
    [sure setValue:GreenColor forKey:@"_titleTextColor"];
    [alert addAction:sure];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)NetworkRequest {
    
    [SVProgressHUD showWithStatus:LWLocalizbleString(@"Loading...")];
    
    WeakSelf(self);
    [LWNetworkingManager requestURL:@"api/v2/sportPush/classify/list" httpMethod:GET params:@{} success:^(NSDictionary *result) {
        [SVProgressHUD dismiss];
        
        if ([result[@"code"] integerValue] == 200) {
            
            NSArray *array = result[@"data"][@"list"];
    
            [weakSelf.dataAry removeAllObjects];
            
            BOOL isShow = YES;  // 默认第一个展开

            for (NSDictionary *dict in array) {
                
                LWMotionPushClassifyModel *classifyModel = LWMotionPushClassifyModel.new;
                if (isShow) {
                    classifyModel.isShow = YES;
                    isShow = NO;
                }
                [classifyModel mj_setKeyValues:dict];
                
                NSArray *sportList = dict[@"sportList"];
                NSMutableArray <LWMotionPushModel *> *list = NSMutableArray.array;
                for (NSDictionary *listDict in sportList) {
                    LWMotionPushModel *model = LWMotionPushModel.new;
                    [model mj_setKeyValues:listDict];
                    [list addObject:model];
                }
                classifyModel.sportList = list;
                
                [weakSelf.dataAry addObject:classifyModel];
            }

            [weakSelf.tableView reloadData];
        } else {
            [NSObject showHUDText:result[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        [NSObject showHUDText:error.localizedDescription];
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

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    self.button.hidden = !self.dataAry.count;
    self.button.enabled = self.selectAry.count;
    
    if (self.isTwoGroups) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.isTwoGroups && section == 0) {
        return 1;
    } else {
        return self.dataAry.count;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section < self.sectionAry.count) {
        LWMotionPushSectionModel *model = self.sectionAry[section];
        
        if ([model.title containsString:LWLocalizbleString(@"Watch Movement")]) {
            model.title = [NSString stringWithFormat:@"%@ (%ld/%ld)", LWLocalizbleString(@"Watch Movement"), self.selectAry.count, FBAllConfigObject.firmwareConfig.supportMultipleSportsCount];
        }
        
        UIView *sectionView = [self creatVisibleSectionHeaderViewWithTitle:model.title withDetail:model.detail];
        
        return sectionView;
    }
    
    return nil;
}

- (UIView *)creatVisibleSectionHeaderViewWithTitle:(NSString *)title withDetail:(NSString *)detail {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)]; // 随便给个高度
    headerView.backgroundColor = COLOR_HEX(0xE6E6FA, 1);
    
    QMUILabel *titleLabel = [[QMUILabel alloc] qmui_initWithFont:[NSObject themePingFangSCMediumFont:18] textColor:UIColorBlack];
    titleLabel.text = title;
    titleLabel.numberOfLines = 0;
    [headerView addSubview:titleLabel];
    
    if (StringIsEmpty(detail)) {
        titleLabel.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 20, 0, 20));
        [titleLabel updateLayout];
        
        CGFloat h = CGRectGetMaxY(titleLabel.frame);
        
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, h>60 ? h : 60); // 更新高度
        
    } else {
        titleLabel.sd_layout.leftSpaceToView(headerView, 20).topSpaceToView(headerView, 10).rightSpaceToView(headerView, 20).autoHeightRatio(0);
        
        QMUILabel *detailLabel = [[QMUILabel alloc] qmui_initWithFont:FONT(14) textColor:UIColorGrayLighten];
        detailLabel.numberOfLines = 0;
        [headerView addSubview:detailLabel];
        detailLabel.sd_layout.leftEqualToView(titleLabel).rightEqualToView(titleLabel).topSpaceToView(titleLabel, 5).autoHeightRatio(0);
        
        detailLabel.text = detail;
        
        [detailLabel updateLayout];
        
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(detailLabel.frame)+10); // 更新高度
    }
        
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isTwoGroups && indexPath.section == 0) {
        
        NSInteger totalRow = 1;
        if (self.selectAry.count < FBAllConfigObject.firmwareConfig.supportMultipleSportsCount) {
            totalRow = self.selectAry.count + 1; // +1 添加item
        } else {
            totalRow = self.selectAry.count;
        }
        
        NSInteger row = ceil(totalRow/4.0);
        LWMotionPushCellModel *model = LWMotionPushCellModel.new;
        
        CGFloat h =
        (row * model.itemSize.height) +
        model.sectionInset.top +
        model.sectionInset.bottom +
        ((row-1)*model.minimumLineSpacing);

        return h;
        
    } else {
        if (indexPath.row < self.dataAry.count) {
            LWMotionPushClassifyModel *model = self.dataAry[indexPath.row];

            if (model.isShow) {
                NSInteger row = ceil(model.sportList.count/4.0);
                LWMotionPushCellModel *model = LWMotionPushCellModel.new;

                CGFloat h =
                60 +
                (row * model.itemSize.height) +
                model.sectionInset.top +
                model.sectionInset.bottom +
                ((row-1)*model.minimumLineSpacing);

                return h;
            }
        }
    }
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    UIView *sectionView = [self tableView:tableView viewForHeaderInSection:section];
    
    return sectionView.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LWMotionPushSelectCell *selectCell = [tableView dequeueReusableCellWithIdentifier:@"LWMotionPushSelectCell"];
    LWMotionPushDataCell *dataCell = [tableView dequeueReusableCellWithIdentifier:@"LWMotionPushDataCell"];
    
    WeakSelf(self);
    if (self.isTwoGroups && indexPath.section == 0) {
        
        [selectCell reload:self.selectAry block:^(LWMotionPushClickType clickType, id  _Nonnull result) {
            
            if (clickType == LWCellDeleteClick) { // 删除
                
                LWMotionPushModel *selectModel = (LWMotionPushModel *)result;
                
                // 第一组（已选择）赋值，刷新
                [weakSelf.selectAry enumerateObjectsUsingBlock:^(LWMotionPushModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.sportType == selectModel.sportType && selectModel.isShow) {
                        
                        [weakSelf.selectAry removeObject:obj]; // 原本已选择、现在第二次 取消选择

                        [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone]; // 刷新
                        *stop = YES;
                    }
                }];
                
                // 第二组赋值，刷新
                [weakSelf.dataAry enumerateObjectsUsingBlock:^(LWMotionPushClassifyModel * _Nonnull obj, NSUInteger row, BOOL * _Nonnull stop) {
                                 
                    [obj.sportList enumerateObjectsUsingBlock:^(LWMotionPushModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (obj.sportType == selectModel.sportType) {
                            
                            obj.isShow = !selectModel.isShow; // 更新数据源

                            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone]; // 刷新
                            *stop = YES;
                        }
                    }];

                }];
                
            }
            else if (clickType == LWCellAddClick) { // 添加
                
                CGPoint origin = [weakSelf.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]].origin;
                [weakSelf.tableView setContentOffset:origin]; // 添加 滚动到第二组第一行

            }
            else if (clickType == LWCellMoveClick) { // 移动
                NSArray *array = (NSArray <LWMotionPushModel *> *)result;
                if (array.count) {
                    weakSelf.selectAry = [NSMutableArray arrayWithArray:array];
                    [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone]; // 刷新
                }
                
            }
        }];
        
        return selectCell;
        
    } else {
        
        if (indexPath.row < self.dataAry.count) {
            __block LWMotionPushClassifyModel *model = self.dataAry[indexPath.row];
            
            // 第二组赋值，刷新
            [dataCell reload:model isFirst:indexPath.row==0 isLast:indexPath.row==self.dataAry.count-1 block:^(LWMotionPushClickType clickType, id  _Nonnull result) {
                
                if (clickType == LWHeadTitleClick) { // 头部点击
                    model.isShow = (BOOL)[result intValue]; // 更新数据源
                    
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade]; // 刷新
                    
                }
                else if (clickType == LWCellSelectClick) { // cell选择
                    
                    LWMotionPushModel *selectModel = (LWMotionPushModel *)result;
                    
                    if (weakSelf.isTwoGroups) { // 多选
                        
                        if (!selectModel.isShow && weakSelf.selectAry.count==FBAllConfigObject.firmwareConfig.supportMultipleSportsCount) return; // 超过支持数，不接受...
                        
                        [weakSelf.dataAry enumerateObjectsUsingBlock:^(LWMotionPushClassifyModel * _Nonnull obj, NSUInteger row, BOOL * _Nonnull stop) {
                                         
                            [obj.sportList enumerateObjectsUsingBlock:^(LWMotionPushModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                if (obj.sportType == selectModel.sportType) {
                                    
                                    obj.isShow = !selectModel.isShow; // 更新数据源
                                    
                                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone]; // 刷新
                                    *stop = YES;
                                }
                            }];

                        }];
                        
                        __block BOOL isAdd = YES;
                        // 第一组（已选择）赋值，刷新
                        [weakSelf.selectAry enumerateObjectsUsingBlock:^(LWMotionPushModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if (obj.sportType == selectModel.sportType && !selectModel.isShow) {
                                
                                [weakSelf.selectAry removeObject:obj]; // 原本已选择、现在第二次 取消选择
                                
                                isAdd = NO;
                                *stop = YES;
                            }
                        }];
                        if (isAdd) {
                            [weakSelf.selectAry addObject:selectModel]; // 第一次 选择
                        }
                        if (weakSelf.isTwoGroups) { // 如果有多组，刷新第一组
                            
                            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone]; // 刷新
                        }
                    }
                    else { // 单选
                        
                        [weakSelf.selectAry removeAllObjects];
                        
                        [weakSelf.dataAry enumerateObjectsUsingBlock:^(LWMotionPushClassifyModel * _Nonnull obj, NSUInteger row, BOOL * _Nonnull stop) {
                                         
                            [obj.sportList enumerateObjectsUsingBlock:^(LWMotionPushModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                if (obj.sportType == selectModel.sportType) {
                                    
                                    obj.isShow = !selectModel.isShow; // 更新数据源
                                    
                                    if (obj.isShow) {
                                        [self.selectAry addObject:obj];
                                    }
                                    
                                } else {
                                    obj.isShow = NO;
                                }
                            }];
                            
                        }];
                        
                        [weakSelf.tableView reloadData]; // 刷新
                    }
                }
            }];
        }
        return dataCell;
    }
}

#pragma mark - 下载OTA包
- (void)downloadProcessingWithArray:(NSArray <LWMotionPushModel *> *)array {
    
    [SVProgressHUD showWithStatus:LWLocalizbleString(@"Loading...")];
    if (self.isTwoGroups && array.count>=2) { // 支持多个且已选择2及以上
        
        FBLog(@"正在下载多个运动推送包...");
        WeakSelf(self);
        [LWMotionPushDownloadObject.sharedInstance requestMotionPushPacketWithArray:array tryCount:10 success:^(NSArray<NSData *> * _Nonnull result) {
            
            FBLog(@"多个运动推送包下载成功的bin包 %@", result);
            [weakSelf binFileData:result];
            
        } failure:^(NSError * _Nonnull error) {
            
            FBLog(@"多个运动推送包下载bin包失败 %@", error);
            [SVProgressHUD dismiss];
            [NSObject showHUDText:error.localizedDescription];
        }];
        
    } else {
        LWMotionPushModel *model = array.firstObject;
        [self downloadOTAWithUrl:model.binUrl];
    }
}

// 直接下载单个
- (void)downloadOTAWithUrl:(NSString *)url {
    
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

- (void)binFileData:(id)binFile {
    WeakSelf(self);
    
    NSData *binFileData;
    FB_OTANOTIFICATION OTANOTIFICATION = FB_OTANotification_Multi_Sport; // 多运动｜Multi-sport
    
    if ([binFile isKindOfClass:NSArray.class]) // 手表支持多运动，需要合并bin文件｜The watch supports multi-sports, and the bin file needs to be merged
    {
        binFileData = [FBCustomDataTools.sharedInstance fbGenerateCustomMultipleMotionBinFileDataWithItems:binFile];
    }
    else
    {
        if (self.isTwoGroups) { // 手表支持多运动，需要合并bin文件｜The watch supports multi-sports, and the bin file needs to be merged
            binFileData = [FBCustomDataTools.sharedInstance fbGenerateCustomMultipleMotionBinFileDataWithItems:@[binFileData]];
        } else {
            binFileData = binFile;
            OTANOTIFICATION = FB_OTANotification_Motion; // 单运动｜Single-sport
        }
    }
    
    FBBluetoothOTA.sharedInstance.isCheckPower = NO;
    
    [FBBluetoothOTA.sharedInstance fbStartCheckingOTAWithBinFileData:binFileData withOTAType:OTANOTIFICATION withBlock:^(FB_RET_CMD status, FBProgressModel * _Nullable progress, FBOTADoneModel * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [SVProgressHUD dismiss];
            [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
        }
        else if (status==FB_INDATATRANSMISSION) {
            [SVProgressHUD showProgress:progress.totalPackageProgress/100.0 status:[NSString stringWithFormat:@"%@ %ld%%", LWLocalizbleString(@"Synchronize"), progress.totalPackageProgress]];
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
