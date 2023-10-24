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

/// 当前设备语言是中文吗
+ (BOOL)isChinese {
    NSString *systemLanguage = [NSLocale preferredLanguages].firstObject; // 系统当前语言
    if ([systemLanguage hasPrefix:@"zh"]) {      // 中文
        return YES;
    } else {
        return NO;
    }
}

/// 当前手机系统时间格式是否是12小时制
+ (BOOL)is12Hour {
    NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    NSRange containsA = [formatStringForHours rangeOfString:@"a"];
    BOOL hasAMPM = containsA.location != NSNotFound;
    return hasAMPM;
}

/// 设置是否 常亮 不锁屏...
+ (void)idleTimerDisabled:(BOOL)always {
    // 设置是否 常亮 不锁屏...
    [UIApplication.sharedApplication setIdleTimerDisabled:always];
}

/// 图片颜色转换
+ (UIImage *)maskWithImage:(UIImage *)maskImage withColor:(UIColor *)color {
    if (!color) {
        return maskImage;
    }
    
    CGRect imageRect = CGRectMake(0.0f, 0.0f, maskImage.size.width, maskImage.size.height);
    UIImage *newImage = nil;

    UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, maskImage.scale);
    {
        CGContextRef context = UIGraphicsGetCurrentContext();

        CGContextScaleCTM(context, 1.0f, -1.0f);
        CGContextTranslateCTM(context, 0.0f, -(imageRect.size.height));

        CGContextClipToMask(context, imageRect, maskImage.CGImage);
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, imageRect);

        newImage = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return newImage;
}

/// 颜色转16进制字符串
+ (NSString *)hexStringForColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    NSString *hexString=[NSString stringWithFormat:@"#%02X%02X%02X", (int)(r * 255), (int)(g * 255), (int)(b * 255)];
    return hexString;
}

/// 富文本，NSArray数组个数要一致
+ (void)setUILabel:(UILabel *)label setDataArr:(NSArray<NSString *> *)setString setColorArr:(NSArray<UIColor *> *)color setFontArr:(NSArray<UIFont *> *)font {
    
    if (!label.text.length || (setString.count != color.count) || (setString.count != font.count)) return;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:label.text];
    
    for (int k = 0; k < setString.count; k++) {
        NSRange range = [label.text rangeOfString:setString[k]];
        
        if (range.location != NSNotFound) {
            [attributedString addAttribute:NSForegroundColorAttributeName value:color[k] range:range]; // 设置字体颜色
            [attributedString addAttribute:NSFontAttributeName value:font[k] range:range]; // 设置字体样式
        }
    }
    label.attributedText = attributedString;
}

/// 时分秒
+ (NSString *)HMS:(NSInteger)duration {
        
    NSInteger h = duration/3600;

    NSInteger m = (duration - h*3600)/60;
    
    NSInteger s = duration - h*3600 - m*60;
    
    NSString *hms = [NSString stringWithFormat:@"%02zd:%02zd:%02zd", h, m, s];
    
    return hms;
}

/// 时分
+ (NSString *)HM:(NSInteger)duration {

    NSInteger h  = duration/3600;
    
    NSInteger m = (duration - 3600*h)/60;
    
    NSString *hm = [NSString stringWithFormat:@"%02zdh%02zdm", h, m];
    
    return hm;
}

/// 运动类型转换：手表->服务器
+ (LWSportType)convertType:(FB_MOTIONMODE)mode {
    
    LWSportType sportType;
    
    switch (mode) {
        case FBOutdoor_running:
            sportType = LWSportOutdoorRun;
            break;
        case FBWALK:
            sportType = LWSportIndoorWalk;
            break;
        case FBOutdoor_cycling:
            sportType = LWSportOutdoorCycle;
            break;
        case FBIndoor_running:
            sportType = LWSportIndoorRun;
            break;
        case FBStrength_training:
            sportType = LWSportStrengthTraining;
            break;
        case FBFootball:
            sportType = LWSportFootball;
            break;
        case FBSTEP_TRAINING:
            sportType = LWSportStepTraining;
            break;
        case FBHORSE_RIDING:
            sportType = LWSportHorseRiding;
            break;
        case FBHOCKEY:
            sportType = LWSportHockey;
            break;
        case FBTable_Tennis:
            sportType = LWSportTableTennis;
            break;
        case FBBadminton:
            sportType = LWSportBadminton;
            break;
        case FBINDOOR_CYCLE:
            sportType = LWSportIndoorCycle;
            break;
        case FBElliptical_machine:
            sportType = LWSportEllipticaltrainer;
            break;
        case FBYoga_training:
            sportType = LWSportYoga;
            break;
        case FBCricket:
            sportType = LWSportCricket;
            break;
        case FBTaiji_boxing:
            sportType = LWSportTaiChi;
            break;
        case FBSHUTTLECOCK:
            sportType = LWSportShuttlecock;
            break;
        case FBBOXING:
            sportType = LWSportBoxing;
            break;
        case FBBasketball:
            sportType = LWSportBasketball;
            break;
        case FBOUTDOOR_WALK:
            sportType = LWSportOutdoorWalk;
            break;
        case FBOutdoor_walking:
            sportType = LWSportOutdoorWalk;
            break;
        case FBMountaineering:
            sportType = LWSportMountaineering;
            break;
        case FBTRAIL_RUNNING:
            sportType = LWSportTrailRunning;
            break;
        case FBSKIING:
            sportType = LWSportSkiing;
            break;
        case FBFree_training:
            sportType = LWSportFreeTraining;
            break;
        case FBGYMNASTICS:
            sportType = LWSportGymnastics;
            break;
        case FBICE_HOCKEY:
            sportType = LWSportIceHockey;
            break;
        case FBTAEKWONDO:
            sportType = LWSportTaekwondo;
            break;
        case FBVO2MAX_TEST:
            sportType = LWSportVO2maxTest;
            break;
        case FBRowing_machine:
            sportType = LWSportRowingMaching;
            break;
        case FBAIR_WALKER:
            sportType = LWSportAirWalker;
            break;
        case FBHIKING:
            sportType = LWSportHiking;
            break;
        case FBTENNIS:
            sportType = LWSportTennis;
            break;
        case FBDANCE:
            sportType = LWSportDance;
            break;
        case FBTRACK_FIELD:
            sportType = LWSportAthletics;
            break;
        case FBABDOMINAL_TRAINING:
            sportType = LWSportWaisttraining;
            break;
        case FBKARATE:
            sportType = LWSportKarate;
            break;
        case FBCOOLDOWN:
            sportType = LWSportCooldown;
            break;
        case FBCROSS_TRAINING:
            sportType = LWSportCrossTraining;
            break;
        case FBPILATES:
            sportType = LWSportPilates;
            break;
        case FBCROSS_FIT:
            sportType = LWSportCrossFit;
            break;
        case FBUNCTIONAL_TRAINING:
            sportType = LWSportFunctionalTraining;
            break;
        case FBPHYSICAL_TRAINING:
            sportType = LWSportPhysicalTraining;
            break;
        case FBRope_skipping:
            sportType = LWSportJumpRope;
            break;
        case FBARCHERY:
            sportType = LWSportArchery;
            break;
        case FBFLEXIBILITY:
            sportType = LWSportFlexibility;
            break;
        case FBMIXED_CARDIO:
            sportType = LWSportMixedCardio;
            break;
        case FBLATIN_DANCE:
            sportType = LWSportLatinDance;
            break;
        case FBSTREET_DANCE:
            sportType = LWSportStreetDance;
            break;
        case FBKICKBOXING:
            sportType = LWSportKickboxing;
            break;
        case FBBARRE:
            sportType = LWSportBarre;
            break;
        case FBAUSTRALIAN_FOOTBALL:
            sportType = LWSportAustralianFootball;
            break;
        case FBMARTIAL_ARTS:
            sportType = LWSportMartialArts;
            break;
        case FBSTAIRS:
            sportType = LWSportStairs;
            break;
        case FBHANDBALL:
            sportType = LWSportHandball;
            break;
        case FBBASEBALL:
            sportType = LWSportBaseball;
            break;
        case FBBOWLING:
            sportType = LWSportBowling;
            break;
        case FBRACQUETBALL:
            sportType = LWSportRacquetball;
            break;
        case FBCURLING:
            sportType = LWSportCurling;
            break;
        case FBHUNTING:
            sportType = LWSportHunting;
            break;
        case FBSNOWBOARDING:
            sportType = LWSportSnowboarding;
            break;
        case FBPLAY:
            sportType = LWSportPlay;
            break;
        case FBAMERICAN_FOOTBALL:
            sportType = LWSportAmericanFootball;
            break;
        case FBHAND_CYCLING:
            sportType = LWSportHandCycling;
            break;
        case FBFISHING:
            sportType = LWSportFishing;
            break;
        case FBDISC_SPORTS:
            sportType = LWSportDiscSports;
            break;
        case FBRUGBY:
            sportType = LWSportRugby;
            break;
        case FBGOLF:
            sportType = LWSportGolf;
            break;
        case FBFOLK_DANCE:
            sportType = LWSportFolkDance;
            break;
        case FBDOWNHILL_SKIING:
            sportType = LWSportDownhillSkiing;
            break;
        case FBSNOW_SPORTS:
            sportType = LWSportSnowSports;
            break;
        case FBVolleyball:
            sportType = LWSportVolleyball;
            break;
        case FBMIND_BODY:
            sportType = LWSportMind_Body;
            break;
        case FBCORE_TRAINING:
            sportType = LWSportCoreTraining;
            break;
        case FBSKATING:
            sportType = LWSportSkating;
            break;
        case FBFITNESS_GAMING:
            sportType = LWSportFitnessGaming;
            break;
        case FBAEROBICS:
            sportType = LWSportAerobics;
            break;
        case FBGROUP_TRAINING:
            sportType = LWSportGroupTraining;
            break;
        case FBKENDO:
            sportType = LWSportKendo;
            break;
        case FBLACROSSE:
            sportType = LWSportLacrosse;
            break;
        case FBROLLING:
            sportType = LWSportRolling;
            break;
        case FBWRESTLING:
            sportType = LWSportWrestling;
            break;
        case FBFENCING:
            sportType = LWSportFencing;
            break;
        case FBSOFTBALL:
            sportType = LWSportSoftball;
            break;
        case FBSINGLE_BAR:
            sportType = LWSportSingleBar;
            break;
        case FBPARALLEL_BARS:
            sportType = LWSportParallelBars;
            break;
        case FBROLLER_SKATING:
            sportType = LWSportRollerSkating;
            break;
        case FBHULA_HOOP:
            sportType = LWSportHulaHoop;
            break;
        case FBDARTS:
            sportType = LWSportDarts;
            break;
        case FBPICKLEBALL:
            sportType = LWSportPickleball;
            break;
        case FBSIT_UP:
            sportType = LWSportSitup;
            break;
        case FBHIIT:
            sportType = LWSportHIIT;
            break;
        case FBSwimming:
            sportType = LWSportswim;
            break;
        case FBTREADMILL:
            sportType = LWSportTreadmill;
            break;
        case FBBOATING:
            sportType = LWSportBoating;
            break;
        case FBSHOOTING:
            sportType = LWSportShooting;
            break;
        case FBJUDO:
            sportType = LWSportJudo;
            break;
        case FBTRAMPOLINE:
            sportType = LWSportTrampoline;
            break;
        case FBSKATEBOARDING:
            sportType = LWSportSkateboarding;
            break;
        case FBHOVERBOARD:
            sportType = LWSportHoverboard;
            break;
        case FBBLADING:
            sportType = LWSportBlading;
            break;
        case FBPARKOUR:
            sportType = LWSportParkour;
            break;
        case FBDIVING:
            sportType = LWSportDiving;
            break;
        case FBSURFING:
            sportType = LWSportSurfing;
            break;
        case FBSNORKELING:
            sportType = LWSportSnorkeling;
            break;
        case FBPULL_UP:
            sportType = LWSportPull_up;
            break;
        case FBPUSH_UP:
            sportType = LWSportPush_up;
            break;
        case FBPLANKING:
            sportType = LWSportPlanking;
            break;
        case FBROCK_CLIMBING:
            sportType = LWSportRockClimbing;
            break;
        case FBHIGHTJUMP:
            sportType = LWSportHightjump;
            break;
        case FBBUNGEE_JUMPING:
            sportType = LWSportBungeeJumping;
            break;
        case FBLONGJUMP:
            sportType = LWSportLongjump;
            break;
        case FBMARATHON:
            sportType = LWSportMarathon;
            break;
        case FBRunning:
            sportType = LWSportOutdoorRun;
            break;
        case FBCycling:
            sportType = LWSportOutdoorCycle;
            break;
        case FBKITE_FLYING:
            sportType = LWKiteFlying;
            break;
        case FBBILLIARDS:
            sportType = LWBilliards;
            break;
        case FBCARDIO_CRUISER:
            sportType = LWCardioCruiser;
            break;
        case FBTUGOFWAR:
            sportType = LWTugOfWar;
            break;
        case FBFREESPARRING:
            sportType = LWFreeSparring;
            break;
        case FBRAFTING:
            sportType = LWRafting;
            break;
        case FBSPINNING:
            sportType = LWSpinning;
            break;
        case FBBMX:
            sportType = LWBMX;
            break;
        case FBATV:
            sportType = LWATV;
            break;
        case FBDUMBBELL:
            sportType = LWDumbbell;
            break;
        case FBBEACHFOOTBALL:
            sportType = LWBeachFootball;
            break;
        case FBKAYAKING:
            sportType = LWKayaking;
            break;
        case FBSAVATE:
            sportType = LWSavate;
            break;
        case FBBEACHVOLLEYBALL:
            sportType = LWBeachVolleyball;
            break;
            
        default:
            sportType = LWSportFreeTraining;
            break;
    }
    
    return sportType;
}

/// 当前绑定状态（是否是第一次绑定）
+ (void)saveIsFirstBinding:(BOOL)isFirst {
    [NSUserDefaults.standardUserDefaults setBool:isFirst forKey:@"FB_isFirstBinding"];
}

/// 是否是第一次绑定
+ (BOOL)isFirstBinding {
    BOOL isFirstBinding = [NSUserDefaults.standardUserDefaults boolForKey:@"FB_isFirstBinding"];
    return isFirstBinding;
}

/// 记录当前实时数据流开启状态
+ (void)saveIsStreamOpen:(BOOL)isOpen {
    [NSUserDefaults.standardUserDefaults setBool:isOpen forKey:@"FB_isStreamOpen"];
}

/// 当前实时数据流是否开启
+ (BOOL)isStreamOpen {
    BOOL isStreamOpen = [NSUserDefaults.standardUserDefaults boolForKey:@"FB_isStreamOpen"];
    return isStreamOpen;
}

/// 记录当前单位是公制吗
+ (void)saveIsMetric:(BOOL)isMetric {
    [NSUserDefaults.standardUserDefaults setBool:isMetric forKey:@"FB_isMetric"];
}

/// 当前单位是公制吗
+ (BOOL)isMetric {
    BOOL isMetric = [NSUserDefaults.standardUserDefaults boolForKey:@"FB_isMetric"];
    return isMetric;
}

/// 距离单位
+ (NSString *)distanceUnit {
    return Tools.isMetric ? @"km" : @"mi";
}

/// 距离单位（米级）
+ (NSString *)distanceUnit_metre {
    return Tools.isMetric ? @"m" : @"yd";
}

/// 距离+单位（公英制）distance单位为米m，space是否需要空格间隔
+ (NSString *)distanceConvert:(NSInteger)distance space:(BOOL)space {
    
    CGFloat dis =  distance/1000.0;
    if (!Tools.isMetric) {
        dis *= 0.62137;
    }
    
    NSString *string = [NSString stringWithFormat:@"%@%@%@", [Tools ConvertValues:dis scale:2 rounding:NO], space?@" ":@"", Tools.distanceUnit];
    
    return string;
}

/// 距离（米级 公英制）distance单位为米m
+ (CGFloat)distance_metre_Convert:(CGFloat)distance {
    if (Tools.isMetric) {
        return distance;
    } else {
        NSString *string = [Tools ConvertValues:distance *= 1.0936133 scale:2 rounding:NO];
        return string.doubleValue;
    }
}

/// 平均配速（公英制）distance单位为米m
+ (NSInteger)averageSpeedWithDistance:(CGFloat)distance duration:(NSInteger)duration {
    CGFloat dis =  distance/1000.0;
    if (!Tools.isMetric) {
        dis *= 0.62137;
    }
    double averageSpeed = (duration / dis);
    NSInteger averageSpeedTime = [[Tools ConvertValues:averageSpeed scale:0 rounding:NO] integerValue];
    if (averageSpeedTime > 99*60+59 || averageSpeedTime <= 0) {
        averageSpeedTime = 99*60+59; // 最大显示99'59"
    }
    return averageSpeedTime;
}

/// 平均配速+单位
+ (NSString *)averageSpeed:(NSInteger)averageSpeed unit:(BOOL)unit {
    NSString *string = nil;
    if (unit) {
        string = [NSString stringWithFormat:@"%.02ld'%.02ld''/%@", averageSpeed/60, averageSpeed%60, Tools.distanceUnit];
    } else {
        string = [NSString stringWithFormat:@"%.02ld'%.02ld''", averageSpeed/60, averageSpeed%60];
    }
    return string;
}

/// 配速转换（公制s/km --> 英制s/mi）
+ (NSInteger)paceSwitch:(NSInteger)pace {
    if (Tools.isMetric) {
        return pace;
    } else {
        pace *= 1.609344;
    }
    NSInteger paceTime = [[Tools ConvertValues:pace scale:0 rounding:NO] integerValue];
    if (paceTime > 99*60+59 || paceTime <= 0) {
        paceTime = 99*60+59; // 最大显示99'59"
    }
    return paceTime;
}

/// 保留精度小数点后几位 是否四舍五入
+ (NSString *)ConvertValues:(CGFloat)value scale:(int)scale rounding:(BOOL)rounding {
    
    NSString *number = [NSString stringWithFormat:@"%.5f", IS_NAN(value)]; // 真实精度丢失时，例如18.299999，.5以内可以还原成19.30000
    
    NSRoundingMode RoundingMode = rounding ? NSRoundPlain : NSRoundDown;
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:RoundingMode
                                                                                                      scale:scale
                                                                                           raiseOnExactness:NO
                                                                                            raiseOnOverflow:NO
                                                                                           raiseOnUnderflow:NO
                                                                                        raiseOnDivideByZero:NO];
    NSDecimalNumber *aDN = [[NSDecimalNumber alloc] initWithString:number];
    NSDecimalNumber *resultDN = [aDN decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    NSString *string = resultDN.stringValue;
    
    if (scale != 0 && ![string containsString:@"."]) { // 需要小数点，结果为整数时，补位0
        NSMutableString *mutString = [NSMutableString stringWithFormat:@"%@.", string];
        for (int k = 0; k < scale; k++) {
            [mutString appendString:@"0"];
        }
        string = mutString;
    }
    else if (scale != 0 && [string containsString:@"."]) { // 需要小数点，结果小数位数不够 补位0
        NSArray <NSString *> *array = [string componentsSeparatedByString:@"."];
        if (array.lastObject.length < scale) {
            NSMutableString *mutString = [NSMutableString stringWithString:string];
            for (int k = 0; k < scale-array.lastObject.length; k++) {
                [mutString appendString:@"0"];
            }
            string = mutString;
        }
    }
    
    return string;
}

/// 整型转化字符串 0 转为 - -
+ (NSString *)stringValue:(NSInteger)value unit:(NSString *)unit space:(BOOL)space {
    if (value == 0) {
        if (StringIsEmpty(unit)) {
            return @"- -";
        } else {
            return [NSString stringWithFormat:@"- -%@%@", space?@" ":@"", unit];
        }
    } else {
        if (StringIsEmpty(unit)) {
            return @(value).stringValue;
        } else {
            return [NSString stringWithFormat:@"%@%@%@", @(value), space?@" ":@"", unit];
        }
    }
}

@end
