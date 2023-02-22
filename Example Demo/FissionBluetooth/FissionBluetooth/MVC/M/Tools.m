//
//  Tools.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/9/4.
//

#import "Tools.h"

@implementation Tools

+ (BOOL)getShapeOFTheWatchCurrentlyConnectedIsRound {

    return FBAllConfigObject.firmwareConfig.shape==1;
}

/** 按条件集合分割字符串 */
+ (NSArray *)componentsSeparatedBySetCharacters:(NSString *)setSep withString:(NSString *)string {
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[string componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:setSep]]];
    return [NSArray arrayWithArray:tempArray];
}

/** 每隔2个字符添加一个 : 符号 */
+ (NSString *)insertColonEveryTwoCharactersWithString:(NSString *)string {
    NSString *doneTitle = @"";
    int count = 0;
    for (int i = 0; i < string.length; i++) {
        count++;
        doneTitle = [doneTitle stringByAppendingString:[string substringWithRange:NSMakeRange(i, 1)]];
        if (count == 2 && (i != (string.length - 1))) {
            doneTitle = [NSString stringWithFormat:@"%@:", doneTitle];
            count = 0;
        }
    }
    return doneTitle;
}

/// app名称
+ (NSString *)appName {
    NSDictionary *infoDictionary = [NSBundle.mainBundle infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleName"];
    return app_Name;
}

/// app 图标
+ (UIImage *)appIcon {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *icon_str = [[infoDictionary valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    UIImage *app_Icon = [UIImage imageNamed:icon_str];
    return app_Icon;
}

/// 设置是否 常亮 不锁屏...
+ (void)idleTimerDisabled:(BOOL)always {
    // 设置是否 常亮 不锁屏...
    [UIApplication.sharedApplication setIdleTimerDisabled:always];
}

@end
