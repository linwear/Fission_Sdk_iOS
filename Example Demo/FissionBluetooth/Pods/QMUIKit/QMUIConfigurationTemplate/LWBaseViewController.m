//
//  LWBaseViewController.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2022/12/7.
//

#import "LWBaseViewController.h"

@interface LWBaseViewController ()

@end

@implementation LWBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorWhite;
    
    self.pageIndex = 1;
    self.pageSize = 10;
}

/// 导航栏透明度
- (void)navigationBarAlpha:(CGFloat)alpha {
    self.navigationController.navigationBar.qmui_backgroundView.alpha = alpha;
}

/// 拦截系统返回事件，外部可重写此方法
- (BOOL)shouldPopViewControllerByBackButtonOrPopGesture:(BOOL)byPopGesture {
    return YES;
}

/// 状态栏颜色-白
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - 添加下拉刷新功能
- (void)addHeaderView:(UIScrollView *)scrollView refresh:(void(^)(void))headerViewRefresh {
    WeakSelf(self);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageIndex = 1;
        if (headerViewRefresh) {
            headerViewRefresh();
        }
    }];
    header.stateLabel.textColor = BlueColor;
    header.lastUpdatedTimeLabel.textColor = BlueColor;
    scrollView.mj_header = header;
}

#pragma mark - 添加上提加载下一页功能
- (void)addFooterView:(UIScrollView *)scrollView refresh:(void(^)(void))footerViewRefresh {
    WeakSelf(self);
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageIndex ++;
        if (footerViewRefresh) {
            footerViewRefresh();
        }
    }];
    footer.stateLabel.textColor = BlueColor;
    [footer setTitle:LWLocalizbleString(@"No More Data") forState:MJRefreshStateNoMoreData];
    scrollView.mj_footer = footer;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    FBLog(@"🔥%@ - - - dealloc", NSStringFromClass(self.class));
}

@end
