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

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray <FBCustomDialListModel *> *list;  // 列表数据

@property (nonatomic, strong) FBCustomDialHeadView *customDialHeadView; // 表盘预览

@property (nonatomic, strong) FBCustomDialSelectModel *selectModel; // 已选择

@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, strong) NSMutableArray *listContentViewArray;

@end

@implementation FBCustomDialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WeakSelf(self);
    self.navigationItem.title = LWLocalizbleString(@"Custom Dial");
    
    NSString *filePath = [NSBundle.mainBundle pathForResource:@"WatchUIResource" ofType:@"zip"];
    [FBCustomDialObject.sharedInstance UnzipFormFilePath:filePath block:^(NSArray<FBCustomDialListModel *> * _Nullable list, NSError * _Nullable error) {
        if (error) {
            [NSObject showHUDText:error.localizedDescription];
            GCD_AFTER(2, ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }
        else {
            weakSelf.list = list;
        }
    }];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithImage:UIImageMake(@"ic_device_resetting") style:UIBarButtonItemStylePlain target:self action:@selector(resetting)];
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
    mainButton.titleLabel.font = [NSObject themePingFangSCMediumFont:18];
    mainButton.cornerRadius = 24;
    [tool addSubview:mainButton];
    [mainButton addTarget:self action:@selector(butClick) forControlEvents:UIControlEventTouchUpInside];
    mainButton.sd_layout.leftSpaceToView(tool, 60).rightSpaceToView(tool, 60).heightIs(48).centerYEqualToView(tool);
    
    
    // 预览图
    FBCustomDialHeadView *customDialHeadView = [[FBCustomDialHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.0)]; // 内自算高度
    customDialHeadView.backgroundColor = self.view.backgroundColor;
    [scrollView addSubview:customDialHeadView];
    self.customDialHeadView = customDialHeadView;
    
    self.selectModel = FBCustomDialSelectModel.new;
    [self.customDialHeadView reloadWithModel:self.selectModel]; // 初始化
    
    
    // list
    NSArray *titleArray = @[LWLocalizbleString(@"背景"), LWLocalizbleString(@"表盘"), LWLocalizbleString(@"组件"), LWLocalizbleString(@"颜色")];
    
    self.listContentViewArray = NSMutableArray.array;
    for (int index = 0; index < titleArray.count; index++) {
        [self.listContentViewArray addObject:NSNull.null];
    }
    

    JXCategoryTitleView *categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(customDialHeadView.frame), SCREEN_WIDTH, 60)];
    categoryView.backgroundColor = self.view.backgroundColor;
    categoryView.titleLabelZoomEnabled = YES;
    categoryView.titles = titleArray;
    categoryView.titleFont = [NSObject themePingFangSCMediumFont:16];
    categoryView.titleColor = UIColorGray;
    categoryView.titleSelectedColor = UIColorBlack;
    categoryView.titleLabelZoomScrollGradientEnabled = NO;
    categoryView.titleColorGradientEnabled = YES;
    categoryView.cellSpacing = 16;
    categoryView.averageCellSpacingEnabled = NO;
    [scrollView addSubview:categoryView];

    CGFloat listContainerViewHeight = 600;
    JXCategoryListContainerView *listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    listContainerView.frame = CGRectMake(0, CGRectGetMaxY(categoryView.frame), SCREEN_WIDTH, listContainerViewHeight);
    [scrollView addSubview:listContainerView];
    self.listContainerView = listContainerView;
    //关联到categoryView
    categoryView.listContainer = listContainerView;
    
    // scrollView区域自适应
    [scrollView setupAutoContentSizeWithBottomView:listContainerView bottomMargin:0];
}

- (void)resetting {
    NSLog(@"恢复默认");
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
    
    FBCustomDialListModel *listModel = self.list[index];
    WeakSelf(self);
    FBCustomDialListContentView *listContentView = [[FBCustomDialListContentView alloc] initWithDialItem:listModel selectModel:self.selectModel block:^(FBCustomDialListItemsEvent listItemsEvent, CGFloat height, UIImage * _Nullable selectImage, NSInteger selectIndex) {
        
        if (listItemsEvent == FBCustomDialListItemsEvent_UpdateHeight)
        {
            weakSelf.listContainerView.height = height;
            // 更新scrollView内容高度
            [weakSelf.scrollView setupAutoContentSizeWithBottomView:weakSelf.listContainerView bottomMargin:0.0];
        }
        else
        {
            BOOL isNeedUpDateHeight = NO;
            
            if (listItemsEvent == FBCustomDialListItemsEvent_BackgroundImage) {
                weakSelf.selectModel.selectBackgroundImage = selectImage;
            }
            else if (listItemsEvent == FBCustomDialListItemsEvent_DialTypeText) {
                isNeedUpDateHeight = YES;
                weakSelf.selectModel.selectDialType = (FBCustomDialType)selectIndex;
            }
            else if (listItemsEvent == FBCustomDialListItemsEvent_PointerImage) {
                weakSelf.selectModel.selectPointerImage = selectImage;
            }
            else if (listItemsEvent == FBCustomDialListItemsEvent_ScaleImage) {
                weakSelf.selectModel.selectScaleImage = selectImage;
            }
            
            // 刷新预览图
            [weakSelf.customDialHeadView reloadWithModel:weakSelf.selectModel];
            
            // 刷新列表
            id object = nil;
            if (index < weakSelf.listContentViewArray.count) {
                object = weakSelf.listContentViewArray[index];
                if ([object isKindOfClass:FBCustomDialListContentView.class]) {
                    FBCustomDialListContentView *listContainerView = (FBCustomDialListContentView *)object;
                    [listContainerView reloadCollectionView:weakSelf.selectModel];
                    
                    if (isNeedUpDateHeight) {
                        [listContainerView listDidAppear];
                    }
                }
            }
        }
    }];
    
    [self.listContentViewArray replaceObjectAtIndex:index withObject:listContentView];
    
    return listContentView;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.list.count;
}

#pragma mark - Synchronize
- (void)butClick {
    NSLog(@"同步");
}

@end
