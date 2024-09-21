//
//  LWBaseViewController.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2022/12/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWBaseViewController : UIViewController <QMUINavigationControllerDelegate>

/// 导航栏透明度
- (void)navigationBarAlpha:(CGFloat)alpha;

/// 拦截系统返回事件，外部可重写此方法
- (BOOL)shouldPopViewControllerByBackButtonOrPopGesture:(BOOL)byPopGesture;

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageSize;

/**
 添加下拉刷新功能
 @param scrollView 该功能需要添加在该滚动视图
 @param headerViewRefresh 回调函数
 */
- (void)addHeaderView:(UIScrollView *)scrollView refresh:(void(^)(void))headerViewRefresh;
/// 更新下拉刷新中的状态文字
- (void)updateHeaderViewStateLabelWithText:(NSString *)text;

/**
 添加上提加载下一页功能
 @param scrollView 该功能需要添加在该滚动视图
 @param footerViewRefresh 回调函数
*/
- (void)addFooterView:(UIScrollView *)scrollView refresh:(void(^)(void))footerViewRefresh;

@end

NS_ASSUME_NONNULL_END
