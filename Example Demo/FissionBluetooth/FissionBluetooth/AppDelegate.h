//
//  AppDelegate.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/1/5.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow * window;

/// 重新绑定弹窗是否正在显示
@property (nonatomic, assign) BOOL rebindShowing;

@end

