//
//  SceneDelegate.m
//  FissionBluetooth
//

#import "SceneDelegate.h"
#import "MainViewController.h"

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    if (![scene isKindOfClass:[UIWindowScene class]]) {
        return;
    }
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
    self.window.backgroundColor = UIColorWhite;
    FBBaseNavigationController *naviBar = [[FBBaseNavigationController alloc] initWithRootViewController:MainViewController.new];
    self.window.rootViewController = naviBar;
    self.window.clipsToBounds = YES;
    [self.window makeKeyAndVisible];
}

@end
