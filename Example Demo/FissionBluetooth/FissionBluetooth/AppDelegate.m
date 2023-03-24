//
//  AppDelegate.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/1/5.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "AppDelegate+FissionSDK.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 初始化日志记录功能｜Initialize the logging function
    [FBLogManager sharedInstance];
    
    // 初始化裂变SDK｜FissionSDK initialization
    [self FissionSDK_Initialization];
    
    BuglyConfig *config = [BuglyConfig new];
    config.debugMode = YES;
    config.blockMonitorEnable = YES;
    config.blockMonitorTimeout = 2;
    config.unexpectedTerminatingDetectionEnable = YES;
    config.reportLogLevel = BuglyLogLevelWarn;
    [Bugly startWithAppId:@"c7e22878ff" developmentDevice:YES config:config];
    
    [SVProgressHUD setBackgroundColor:UIColorBlack];
    [SVProgressHUD setForegroundColor:UIColorWhite];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0f];
    [SVProgressHUD setMaximumDismissTimeInterval:3.0f];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = UIColorWhite;
    FBBaseNavigationController *naviBar = [[FBBaseNavigationController alloc] initWithRootViewController:ViewController.new];
    self.window.rootViewController = naviBar;
    [self.window makeKeyAndVisible];
    self.window.clipsToBounds = YES;
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.enableAutoToolbar = NO;
    
    if (@available(ios 11.0,*)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
    }
    
    if (@available(iOS 15.0, *)) {
        UITableView.appearance.sectionHeaderTopPadding = 0;
    }
    
    
    // token
    NSString *string = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [LWNetworkingManager requestURL:@"api/v1/base/login/local" httpMethod:POST params:@{@"userIdentify" : string} success:^(id  _Nonnull result) {
        
        if ([result[@"code"] integerValue] == 200) {
            NSString *token = result[@"data"][@"xtoken"];
            [NSUserDefaults.standardUserDefaults setObject: token forKey: @"LW_TOKEN"];
        }
    } failure:^(NSError * _Nonnull error, id  _Nullable responseObject) {
        FBLog(@"%@",error);
    }];
    
    return YES;
}

@end
