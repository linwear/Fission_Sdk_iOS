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

/// 当前设备语言是中文吗
+ (BOOL)isChinese;

/// 当前手机系统时间格式是否是12小时制
+ (BOOL)is12Hour;

/// 设置是否 常亮 不锁屏...
+ (void)idleTimerDisabled:(BOOL)always;

/// 图片颜色转换
+ (UIImage *)maskWithImage:(UIImage *)maskImage withColor:(UIColor *)color;

/// 颜色转16进制字符串
+ (NSString *)hexStringForColor:(UIColor *)color;

/// 富文本，NSArray数组个数要一致
+ (void)setUILabel:(UILabel *)label setDataArr:(NSArray<NSString *> *)setString setColorArr:(NSArray<UIColor *> *)color setFontArr:(NSArray<UIFont *> *)font;

/// 时分秒
+ (NSString *)HMS:(NSInteger)duration;

/// 时分
+ (NSString *)HM:(NSInteger)duration;

/// 运动类型转换：手表->服务器
+ (LWSportType)convertType:(FB_MOTIONMODE)mode;

/// 当前绑定状态（是否是第一次绑定）
+ (void)saveIsFirstBinding:(BOOL)isFirst;

/// 是否是第一次绑定
+ (BOOL)isFirstBinding;

/// 保存最近绑定的设备名称
+ (void)saveRecentlyDeviceName:(NSString *)deviceName;

/// 最近绑定的设备名称
+ (NSString * _Nullable)RecentlyDeviceName;

/// 保存最近绑定的设备MAC地址
+ (void)saveRecentlyDeviceMAC:(NSString *)deviceMAC;

/// 最近绑定的设备MAC地址
+ (NSString * _Nullable)RecentlyDeviceMAC;

/// 保存了解GPS运动轨迹按钮时间
+ (void)saveReadGPSButton:(NSInteger)time;

/// 是否已阅GPS运动轨迹按钮
+ (BOOL)isReadGPSButton;

/// 保存了解切换设备数据按钮时间
+ (void)saveReadSwitchDeviceDataButton:(NSInteger)time;

/// 是否已阅切换设备数据
+ (BOOL)isReadSwitchDeviceDataButton;

/// 记录当前实时数据流开启状态
+ (void)saveIsStreamOpen:(BOOL)isOpen;

/// 当前实时数据流是否开启
+ (BOOL)isStreamOpen;

/// 记录当前单位是公制吗
+ (void)saveIsMetric:(BOOL)isMetric;

/// 当前单位是公制吗
+ (BOOL)isMetric;

/// 距离单位（千米级）
+ (NSString *)distanceUnit;

/// 距离单位（米级）
+ (NSString *)distanceUnit_metre;

/// 距离+单位（千米级 公英制）distance单位为米m，space是否需要空格间隔
+ (NSString *)distanceConvert:(NSInteger)distance space:(BOOL)space;

/// 距离（米级 公英制）distance单位为米m
+ (CGFloat)distance_metre_Convert:(CGFloat)distance;

/// 平均配速（公英制）distance单位为米m
+ (NSInteger)averageSpeedWithDistance:(CGFloat)distance duration:(NSInteger)duration;

/// 平均配速 unit是否加上单位
+ (NSString *)averageSpeed:(NSInteger)averageSpeed unit:(BOOL)unit;

/// 配速转换（公制s/km --> 英制s/mi）
+ (NSInteger)paceSwitch:(NSInteger)pace;

/// 保留精度小数点后几位 是否四舍五入
+ (NSString *)ConvertValues:(CGFloat)value scale:(int)scale rounding:(BOOL)rounding;

/// 整型转化字符串 0 转为 - -
+ (NSString *)stringValue:(NSInteger)value unit:(NSString * _Nullable)unit space:(BOOL)space;

@end

NS_ASSUME_NONNULL_END
