//
//  FBCustomDialViewController.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-05-30.
//

#import "FBCustomDialViewController.h"
#import "FBCustomDialListContentView.h"
#import "FBCustomDialHeadView.h"

@interface FBCustomDialViewController ()

@property (nonatomic, copy) NSString *filePath;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray <FBCustomDialListModel *> *list;  // 列表数据

@property (nonatomic, strong) FBCustomDialHeadView *customDialHeadView; // 表盘预览

@property (nonatomic, strong) NSMutableArray <FBCustomDialSoures *> *selectSoures; // 已选择
@property (nonatomic, strong) UIColor *selectColor; // 选择的颜色

@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, strong) NSMutableArray *listContentViewArray;

@property (nonatomic, assign) FBCustomDialListType selectListType;

@end

@implementation FBCustomDialViewController

- (instancetype)initWithResource:(NSString *)filePath {
    if (self = [super init]) {
        self.filePath = filePath;
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
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = LWLocalizbleString(@"Custom Dial");
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithImage:UIImageMake(@"ic_linear_refresh") style:UIBarButtonItemStylePlain target:self action:@selector(resetting)];
    [self.navigationItem setRightBarButtonItem:rightBar animated:YES];

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationContentTop-100)];
    scrollView.backgroundColor = UIColorClear;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIView *tool = UIView.new;
    tool.backgroundColor = UIColorClear;
    [self.view addSubview:tool];
    tool.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).bottomEqualToView(self.view).heightIs(100);
    
    // 同步
    QMUIButton *mainButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [mainButton setBackgroundColor:BlueColor];
    [mainButton setTitleColor:UIColorWhite forState:UIControlStateNormal];
    [mainButton setTitle:LWLocalizbleString(@"Synchronize") forState:UIControlStateNormal];
    mainButton.titleLabel.font = [NSObject BahnschriftFont:18];
    mainButton.cornerRadius = 24;
    [tool addSubview:mainButton];
    [mainButton addTarget:self action:@selector(butClick) forControlEvents:UIControlEventTouchUpInside];
    mainButton.sd_layout.leftSpaceToView(tool, 60).rightSpaceToView(tool, 60).heightIs(48).centerYEqualToView(tool);
    
    
    // 预览图
    FBCustomDialHeadView *customDialHeadView = [[FBCustomDialHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.0)]; // 内自算高度
    customDialHeadView.backgroundColor = self.view.backgroundColor;
    [scrollView addSubview:customDialHeadView];
    self.customDialHeadView = customDialHeadView;
        
    self.selectSoures = NSMutableArray.array;
    [self LoadData]; // 加载数据
    
    // list
    NSMutableArray *titleArray = NSMutableArray.array;
    self.listContentViewArray = NSMutableArray.array;
    for (FBCustomDialListModel *list in self.list) {
        if (list.listType == FBCustomDialListType_Background) {
            [titleArray addObject:LWLocalizbleString(@"Background")];
        } else if (list.listType == FBCustomDialListType_DialType) {
            [titleArray addObject:LWLocalizbleString(@"Dial")];
        } else if (list.listType == FBCustomDialListType_Module) {
            [titleArray addObject:LWLocalizbleString(@"Module")];
        } else if (list.listType == FBCustomDialListType_Colour) {
            [titleArray addObject:LWLocalizbleString(@"Color")];
        }
        [self.listContentViewArray addObject:NSNull.null];
    }
    

    JXCategoryTitleView *categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(customDialHeadView.frame), SCREEN_WIDTH, 60)];
    categoryView.backgroundColor = self.view.backgroundColor;
    categoryView.titleLabelZoomEnabled = YES;
    categoryView.titles = titleArray;
    categoryView.titleFont = [NSObject BahnschriftFont:16];
    categoryView.titleColor = UIColorGray;
    categoryView.titleSelectedColor = UIColorBlack;
    categoryView.titleLabelZoomScrollGradientEnabled = NO;
    categoryView.titleColorGradientEnabled = YES;
    categoryView.cellSpacing = 16;
    categoryView.averageCellSpacingEnabled = NO;
    categoryView.delegate = self;
    [scrollView addSubview:categoryView];

    JXCategoryListContainerView *listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_CollectionView delegate:self];
    listContainerView.frame = CGRectMake(0, CGRectGetMaxY(categoryView.frame), SCREEN_WIDTH, 200);
    [scrollView addSubview:listContainerView];
    self.listContainerView = listContainerView;
    //关联到categoryView
    categoryView.listContainer = listContainerView;
    
    // scrollView区域自适应
    [scrollView setupAutoContentSizeWithBottomView:listContainerView bottomMargin:0];
}

#pragma mark - 是否恢复默认
- (void)resetting {
    
    NSString *message = LWLocalizbleString(@"Please confirm whether to restore the default settings?");
    WeakSelf(self);
    [UIAlertObject presentAlertTitle:LWLocalizbleString(@"Tip") message:message cancel:LWLocalizbleString(@"Cancel") sure:LWLocalizbleString(@"OK") block:^(AlertClickType clickType) {
        
        if (clickType == AlertClickType_Sure) {
            [weakSelf LoadData];
        }
    }];
}

#pragma mark - 加载数据
- (void)LoadData {
    
    [self.selectSoures removeAllObjects];
        
    WeakSelf(self);
    [FBCustomDialObject.sharedInstance UnzipFormFilePath:self.filePath block:^(NSArray<FBCustomDialListModel *> * _Nullable list, NSError * _Nullable error) {
                
        if (error) {
            [NSObject showHUDText:error.localizedDescription];
            GCD_AFTER(2, ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }
        else {
            weakSelf.list = [NSMutableArray arrayWithArray:list];
            
            for (FBCustomDialListModel *listModel in list) {
                for (FBCustomDialItems *soures in listModel.list) {
                    if (soures.souresType == FBCustomDialListSouresType_Image) {
                        for (NSArray <FBCustomDialSoures *> *dialSoures in soures.items) {
                            for (FBCustomDialSoures *item in dialSoures) {
                                if (item.isSelect) {
                                    [weakSelf.selectSoures addObject:item]; // 更新预览数据
                                }
                            }
                        }
                    } else if (soures.souresType == FBCustomDialListSouresType_Color) {
                        for (NSArray <FBCustomDialSoures *> *dialSoures in soures.items) {
                            for (FBCustomDialSoures *item in dialSoures) {
                                if (item.isSelect) {
                                    weakSelf.selectColor = item.color; // 更新预览颜色
                                }
                            }
                        }
                    }
                }
            }
            
            for (int k = 0; k < weakSelf.listContentViewArray.count; k++) {
                id object = weakSelf.listContentViewArray[k];
                // 刷新列表
                if ([object isKindOfClass:FBCustomDialListContentView.class] && k < weakSelf.list.count) {
                    FBCustomDialListContentView *listContainerView = (FBCustomDialListContentView *)object;
                    [listContainerView reloadCollectionView:weakSelf.list[k] soures:weakSelf.selectSoures]; // 列表内容更新 - - 刷新
                }
            }
            
            [weakSelf.customDialHeadView reloadWithSoures:weakSelf.selectSoures withColor:weakSelf.selectColor firstTime:YES]; // 刷新预览图
            
            [weakSelf.customDialHeadView reloadWithDynamicSelection:FBCustomDialDynamicSelection_Reset soures:nil]; // 重置：刷新空间占用数量
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

#pragma mark - JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    
    if (index < self.list.count) {
        FBCustomDialListModel *model = self.list[index];
        self.selectListType = model.listType;
    }
}

#pragma mark - JXCategoryListContainerViewDelegate
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    
    WeakSelf(self);
    FBCustomDialListContentView *listContentView = [[FBCustomDialListContentView alloc] initWithListContentBlock:^(FBCustomDialListModel * _Nonnull dialList, FBCustomDialSoures * _Nonnull item, NSIndexPath * _Nonnull indexPath) { // 列表内容更新事件
                
        if (item.image || item.color) {
            
            if (item.color) { // 更新的是color
                weakSelf.selectColor = item.color; // 更新预览颜色
            }
            else { // 更新的是image
                
                NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(FBCustomDialSoures * _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
                    return (evaluatedObject.itemEvent == item.itemEvent);
                }];
                
                NSMutableArray <FBCustomDialSoures *> *selectSoures = [NSMutableArray arrayWithArray:weakSelf.selectSoures];
                                
                // 该组是否已选择过
                FBCustomDialSoures *soures = [selectSoures filteredArrayUsingPredicate:predicate].firstObject; // 当前组已选中的个数
                if (soures) { // 已存在
                    if (item.isSelect) { // 当前选中（替换）
                        NSUInteger index = [selectSoures indexOfObject:soures];
                        [selectSoures replaceObjectAtIndex:index withObject:item];
                    } else { // 取消
                        [selectSoures removeObject:soures];
                    }
                } else {
                    // 新增
                    [selectSoures addObject:item];
                }
                
                // 更新已选择的数据源
                [weakSelf.selectSoures removeAllObjects];
                [weakSelf.selectSoures addObjectsFromArray:selectSoures];
            }
            
            [weakSelf.customDialHeadView reloadWithSoures:weakSelf.selectSoures withColor:weakSelf.selectColor firstTime:NO]; // 刷新预览图
        }
        
        // 刷新列表
        if (index < weakSelf.listContentViewArray.count && index < weakSelf.list.count) {
            [weakSelf.list replaceObjectAtIndex:index withObject:dialList]; // 替换更新数据源
            id object = weakSelf.listContentViewArray[index];
            if ([object isKindOfClass:FBCustomDialListContentView.class]) {
                FBCustomDialListContentView *listContainerView = (FBCustomDialListContentView *)object;
                [listContainerView reloadCollectionView:weakSelf.list[index] soures:weakSelf.selectSoures]; // 列表内容更新 - - 刷新
            }
        }
                
    } heightUpdateBlock:^(FBCustomDialListType listType, CGFloat updateHeight) {
        if (weakSelf.selectListType != listType || updateHeight <= 0) return;
        
        // 更新scrollView内容高度
        weakSelf.listContainerView.height = updateHeight;
        [weakSelf.scrollView setupAutoContentSizeWithBottomView:weakSelf.listContainerView bottomMargin:0.0];
    } dynamicSelectionBlock:^(FBCustomDialDynamicSelection dynamicSelection, FBCustomDialSoures * _Nonnull item) {
        
        // 刷新空间占用数量
        [weakSelf.customDialHeadView reloadWithDynamicSelection:dynamicSelection soures:item];
    }];
    
    FBCustomDialListModel *listModel = self.list[index];
    self.selectListType = listModel.listType;
    [listContentView reloadCollectionView:listModel soures:self.selectSoures]; // 列表内容更新 - - 初始化

    [self.listContentViewArray replaceObjectAtIndex:index withObject:listContentView]; // 对象存储更新，后续用于刷新对应index索引listContentView内容
    
    return listContentView;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.list.count;
}

#pragma mark - Synchronize
- (void)butClick {
    
    WeakSelf(self);
    NSString *message = LWLocalizbleString(@"Please confirm whether the watch face is synchronized");
    
    [UIAlertObject presentAlertTitle:LWLocalizbleString(@"Tip") message:message cancel:LWLocalizbleString(@"Cancel") sure:LWLocalizbleString(@"OK") block:^(AlertClickType clickType) {
        
        if (clickType == AlertClickType_Sure) {
            [weakSelf Synchronize];
        }
    }];
}

- (void)Synchronize {
    
#ifdef FBINTERNAL
    
    FBMultipleCustomDialsModel *dialsModel =  [self.customDialHeadView generateCustomWatchFaceData];
    NSData *binFile = [FBCustomDataTools.sharedInstance fbGenerateMultiProjectCustomDialBinFileDataWithDialsModel:dialsModel];
    
    
    [NSObject showLoading:LWLocalizbleString(@"Loading...")];

    FBBluetoothOTA.sharedInstance.isCheckPower = NO;

    FBBluetoothOTA.sharedInstance.sendTimerOut = 30;

    [FBBluetoothOTA.sharedInstance fbStartCheckingOTAWithBinFileData:binFile withOTAType:FB_OTANotification_CustomClockDial withBlock:^(FB_RET_CMD status, FBProgressModel * _Nullable progress, FBOTADoneModel * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
        }
        else if (status==FB_INDATATRANSMISSION) {
            [NSObject showProgress:progress.totalPackageProgress/100.0 status:[NSString stringWithFormat:@"%@ %ld%%", LWLocalizbleString(@"Synchronize"), progress.totalPackageProgress]];
        }
        else if (status==FB_DATATRANSMISSIONDONE) {
            [SVProgressHUD dismiss];
            NSString *message = [NSString stringWithFormat:@"%@",responseObject.mj_keyValues];

            [UIAlertObject presentAlertTitle:LWLocalizbleString(@"Success") message:message cancel:nil sure:LWLocalizbleString(@"OK") block:^(AlertClickType clickType) {

            }];
            
            
            // 缓存起来，调试用
            NSString *FileName=[FBDocumentDirectory(FBCustomDialFile) stringByAppendingPathComponent:[NSString stringWithFormat:@"FBCustomDial_Advanced_%ld.bin", (NSInteger)NSDate.date.timeIntervalSince1970]];
            [binFile writeToFile:FileName atomically:YES];//将NSData类型对象data写入文件，文件名为FileName
        }
    }];
    
#endif
    
}

@end
