//
//  FBClockDialCategoryViewController.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/3/6.
//

#import "FBClockDialCategoryViewController.h"
#import "ClockDialListViewController.h"
#import "LWCustomDialViewController.h"
#import "FBCustomDialViewController.h"

@interface FBClockDialCategoryViewController () <JXCategoryListContainerViewDelegate>

@property (nonatomic, strong) NSMutableArray <FBClockDialCategoryModel *> *arrayData; // 标题数据

@property (nonatomic, strong) JXCategoryTitleView *categoryView; // 标题view

@property (nonatomic, strong) JXCategoryListContainerView *listContainerView; //listView

@property (nonatomic, assign) BOOL isBreak;

@end

@implementation FBClockDialCategoryViewController


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [Tools idleTimerDisabled:YES];
    
    if (!self.isBreak) {
        self.isBreak = YES;
        
        // 请求表盘分类
        [self requestNetworking];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [Tools idleTimerDisabled:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:LWLocalizbleString(@"Custom⌚️") style:UIBarButtonItemStylePlain target:self action:@selector(customWatchFcae)];
    [self.navigationItem setRightBarButtonItem:item];
    
    self.arrayData = NSMutableArray.array;
    
    JXCategoryTitleView *categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, 50)];
    categoryView.backgroundColor = COLOR_HEX(0xE6E6FA, 1);
    categoryView.titleColor = UIColorBlack;
    categoryView.titleSelectedColor = UIColorBlue;
    categoryView.titleFont = FONT(16);
    categoryView.titleSelectedFont = [NSObject BahnschriftFont:16];
    categoryView.titleColorGradientEnabled = YES;
    categoryView.cellSpacing = 10;
    categoryView.averageCellSpacingEnabled = NO;
    [self.view addSubview:categoryView];
    self.categoryView = categoryView;

    JXCategoryIndicatorLineView *lineView = JXCategoryIndicatorLineView.new;
    lineView.lineStyle = JXCategoryIndicatorLineStyle_Lengthen;
    lineView.indicatorWidth = JXCategoryViewAutomaticDimension;
    lineView.scrollStyle = JXCategoryIndicatorScrollStyleSimple;
    lineView.indicatorColor = UIColorBlue;
    lineView.indicatorWidthIncrement = 0;
    lineView.indicatorHeight = 6;
    self.categoryView.indicators = @[lineView];

    JXCategoryListContainerView *listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    listContainerView.frame = CGRectMake(0, NavigationContentTop + 50, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationContentTop - 50);
    [self.view addSubview:listContainerView];
    self.listContainerView = listContainerView;
    
    //关联到categoryView
    self.categoryView.listContainer = self.listContainerView;
}


#pragma mark - 请求表盘分类
- (void)requestNetworking {
    
    NSDictionary *param = @{@"adaptNum" : StringHandle(FBAllConfigObject.firmwareConfig.fitNumber)};
    
    [NSObject showLoading:LWLocalizbleString(@"Loading...")];
    WeakSelf(self);
    [LWNetworkingManager requestURL:@"api/v2/plate/classifyTotal" httpMethod:POST params:param success:^(NSDictionary *result) {
        [SVProgressHUD dismiss];
        
        if ([result[@"code"] integerValue] == 200) {
                  
            if ([result[@"data"][@"list"] isKindOfClass:NSArray.class]) {
                NSArray *array = result[@"data"][@"list"];
                
                NSMutableArray *titleData = NSMutableArray.array;
                
                for (NSDictionary *dict in array) {
                    if ([dict[@"plateList"] count] && [dict[@"plateClassify"] integerValue]>0) {
                        
                        FBClockDialCategoryModel *model = FBClockDialCategoryModel.new;
                        [model mj_setKeyValues:dict];
                        
                        [titleData addObject:model.plateClassifyName];
                        [weakSelf.arrayData addObject:model];
                    }
                }
                weakSelf.categoryView.titles = titleData;
                [weakSelf.categoryView reloadData];
                [weakSelf.listContainerView reloadData];
            }
        } else {
            [NSObject showHUDText:result[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        
        [NSObject showHUDText:error.localizedDescription];
    }];
}


- (void)customWatchFcae {
    
#ifdef FBINTERNAL
    
    FBFirmwareVersionObject *object = FBAllConfigObject.firmwareConfig;
    
    if (object.supportAntiAliasing && object.chipManufacturer!=FB_CHIPMANUFACTURERTYPE_HISI) {
        WeakSelf(self);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LWLocalizbleString(@"Custom Dial") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *action_A = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@-A", LWLocalizbleString(@"Custom⌚️")] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
            
            LWCustomDialViewController *vc = LWCustomDialViewController.new;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        [alertController addAction: action_A];
            
        UIAlertAction *action_B = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@-B", LWLocalizbleString(@"Custom⌚️")] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
            [weakSelf requestCustomBinPack];
        }];
        [alertController addAction:action_B];

        UIAlertAction *cancel = [UIAlertAction actionWithTitle:LWLocalizbleString(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
            FBLog(@"UIAlertActionStyleCancel");
        }];
        [alertController addAction:cancel];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else {
        LWCustomDialViewController *vc = LWCustomDialViewController.new;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
#else
    
    LWCustomDialViewController *vc = LWCustomDialViewController.new;
    [self.navigationController pushViewController:vc animated:YES];
    
#endif
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - JXCategoryListContainerViewDelegate
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {

    if (index < self.arrayData.count) {
        FBClockDialCategoryModel *model = self.arrayData[index];
        
        ClockDialListViewController *vc = [[ClockDialListViewController alloc] initWithPlateClassify:model.plateClassify];
        return vc;
    }
    
    return nil;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.arrayData.count;
}

#pragma mark - Networking
- (void)requestCustomBinPack {
    
    FBFirmwareVersionObject *object = FBAllConfigObject.firmwareConfig;
    NSDictionary *param = @{@"dpiWidth" : @(object.watchDisplayWide),
                            @"dpiHeight" : @(object.watchDisplayHigh),
                            @"version" : @"1.0",
                            @"sdkType" : @(2),
                            @"shapeType" : @(object.shape==1 ? 1 : 2)
    };
                            
    WeakSelf(self);
    [NSObject showLoading:LWLocalizbleString(@"Loading...")];
    
    [LWNetworkingManager requestURL:@"api/v2/dial/custom" httpMethod:GET params:param success:^(id  _Nonnull result) {
        
        [NSObject dismiss];
        
        if ([result[@"code"] integerValue] == 200) {
                        
            NSArray <NSDictionary *> *list = result[@"data"][@"list"];
            
            NSString *zipUrl = list.firstObject[@"zipUrl"];
            
            if (StringIsEmpty(zipUrl)) {
                [NSObject showHUDText:LWLocalizbleString(@"Fail")];
            } else {
                [weakSelf downloadZipUrl:zipUrl];
            }
        } else {
            [NSObject showHUDText:result[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error, id  _Nullable responseObject) {
        [NSObject dismiss];
        [NSObject showHUDText:error.localizedDescription];
    }];
}

- (void)downloadZipUrl:(NSString *)zipUrl {
    
    WeakSelf(self);
    [NSObject showLoading:LWLocalizbleString(@"Loading...")];
    
    [LWNetworkingManager requestDownloadURL:zipUrl namePrefix:@"FBCustomDialPackage" success:^(NSDictionary *result) {
        
        [NSObject dismiss];
        
        NSString *filePath = result[@"filePath"];
        
        if (StringIsEmpty(filePath)) {
            [NSObject showHUDText:LWLocalizbleString(@"Fail")];
        } else {
            GCD_MAIN_QUEUE(^{
                FBCustomDialViewController *vc = [[FBCustomDialViewController alloc] initWithResource:filePath];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            });
        }
        
    } failure:^(NSError * _Nonnull error, id  _Nullable responseObject) {
        [NSObject dismiss];
        [NSObject showHUDText:error.localizedDescription];
    }];
}

@end


@implementation FBClockDialCategoryModel

@end
