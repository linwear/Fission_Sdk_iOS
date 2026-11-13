//
//  AppDelegate.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/1/5.
//

#import "AppDelegate.h"
#import "AppDelegate+FissionSDK.h"

@interface AppDelegate () <JJExceptionHandle>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // APP异常闪退保护
    [JJException configExceptionCategory:JJExceptionGuardAll];
    [JJException startGuardException];
    [JJException registerExceptionHandle:self];
    
    // 初始化日志记录功能｜Initialize the logging function
    [FBLogManager sharedInstance];
    
    // 初始化裂变SDK｜FissionSDK initialization
    [self FissionSDK_Initialization];
    
    // HUD
    [SVProgressHUD setBackgroundColor:UIColorBlack];
    [SVProgressHUD setForegroundColor:UIColorWhite];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0f];
    [SVProgressHUD setMaximumDismissTimeInterval:3.0f];
    
    // 数据库
    RLMRealmConfiguration *configuration = RLMRealmConfiguration.defaultConfiguration;
    // 设置新的架构版本。必须大于之前所使用的版本
    configuration.schemaVersion = 9;
    // 通知 Realm 为默认的 Realm 数据库使用这个新的配置对象
    [RLMRealmConfiguration setDefaultConfiguration:configuration];
    // 现在我们已经通知了 Realm 如何处理架构变化，
    // 打开文件将会自动执行迁移
    [RLMRealm defaultRealm];
    
    // 键盘管理
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.enableAutoToolbar = NO;
    
    if (@available(ios 11.0,*)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
        QMUISearchBar.appearance.qmui_centerPlaceholder = YES;
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

#pragma mark - UIScene lifecycle

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}

#pragma mark - JJExceptionHandle 监听闪退
- (void)handleCrashException:(NSString*)exceptionMessage extraInfo:(nullable NSDictionary*)info
{
    FBLog(@"闪退保护💥异常消息:%@ 额外信息:%@", exceptionMessage, info);
    
    [UIAlertObject presentAlertTitle:@"闪退保护" message:@"发生闪退了，触发程序保护(程序可正常运行)" cancel:nil sure:LWLocalizbleString(@"OK") block:^(AlertClickType clickType) {
        // more...
    }];
}

@end
