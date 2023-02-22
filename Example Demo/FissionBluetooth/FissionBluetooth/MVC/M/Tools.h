//
//  Tools.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/9/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Tools : NSObject

+ (BOOL)getShapeOFTheWatchCurrentlyConnectedIsRound;

/** 按条件集合分割字符串 */
+ (NSArray *)componentsSeparatedBySetCharacters:(NSString *)setSep withString:(NSString *)string;

/** 每隔2个字符添加一个 : 符号 */
+ (NSString *)insertColonEveryTwoCharactersWithString:(NSString *)string;

/// app名称
+ (NSString *)appName;

/// app 图标
+ (UIImage *)appIcon;

/// 设置是否 常亮 不锁屏...
+ (void)idleTimerDisabled:(BOOL)always;

@end

NS_ASSUME_NONNULL_END
