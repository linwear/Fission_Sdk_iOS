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

@end
