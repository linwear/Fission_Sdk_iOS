//
//  FBClockDialCategoryViewController.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/3/6.
//

#import "FBClockDialCategoryViewController.h"
#import "ClockDialListViewController.h"
#import "LWCustomDialViewController.h"

@interface FBClockDialCategoryViewController () <JXCategoryListContainerViewDelegate>

@property (nonatomic, strong) NSMutableArray <FBClockDialCategoryModel *> *arrayData; // 标题数据

@property (nonatomic, strong) JXCategoryTitleView *categoryView; // 标题view

@property (nonatomic, strong) JXCategoryListContainerView *listContainerView; //listView

@end

@implementation FBClockDialCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Custom⌚️" style:UIBarButtonItemStylePlain target:self action:@selector(customWatchFcae)];
    [self.navigationItem setRightBarButtonItem:item];
    
    self.arrayData = NSMutableArray.array;
    
    JXCategoryTitleView *categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, 50)];
    categoryView.backgroundColor = COLOR_HEX(0xE6E6FA, 1);
    categoryView.titleColor = UIColorBlack;
    categoryView.titleSelectedColor = UIColorBlue;
    categoryView.titleFont = FONT(16);
    categoryView.titleSelectedFont = [NSObject themePingFangSCMediumFont:16];
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
    
    // 请求表盘分类
    [self requestNetworking];
}

#pragma mark - 请求表盘分类
- (void)requestNetworking {
    
    NSDictionary *param = @{@"adaptNum" : StringHandle(FBAllConfigObject.firmwareConfig.fitNumber)};
    
    [SVProgressHUD showWithStatus:LWLocalizbleString(@"Loading...")];
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
    LWCustomDialViewController *vc = [LWCustomDialViewController new];
    [self.navigationController pushViewController:vc animated:YES];
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

@end


@implementation FBClockDialCategoryModel

@end
