//
//  NSDate+Date.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/5/12.
//

#import "NSDate+Date.h"

@implementation NSDate (Date)

/// 当天00点0分01秒
- (NSInteger)Time_01 {
    NSInteger Time_01 = [NSDate br_setYear:self.br_year month:self.br_month day:self.br_day hour:0 minute:0 second:1].timeIntervalSince1970;
    
    return Time_01;
}

/// 当天24点0分00秒
- (NSInteger)Time_24 {
    NSInteger time_24 = [NSDate br_setYear:self.br_year month:self.br_month day:self.br_day hour:24 minute:0 second:0].timeIntervalSince1970;
    
    return time_24;
}

/// 时间戳按指定日期格式转换为字符串
+ (NSString *)timeStamp:(NSInteger)time dateFormat:(FBDateFormat)dateFormat {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSString *formatString = nil;
    if (dateFormat == FBDateFormatHm) {
        formatString = @"HH:mm";
    }
    else if (dateFormat == FBDateFormatYMD) {
        if (Tools.isChinese) {
            formatString = @"YYYY-MM-dd";
        } else {
            formatString = @"dd-MMMM-YYYY";
        }
    }
    else if (dateFormat == FBDateFormatYMDHm) {
        if (Tools.isChinese) {
            formatString = @"YYYY-MM-dd  HH:mm";
        } else {
            formatString = @"dd-MMMM-YYYY  HH:mm";
        }
    }
    else if (dateFormat == FBDateFormatYMDHms) {
        if (Tools.isChinese) {
            formatString = @"YYYY-MM-dd  HH:mm:ss";
        } else {
            formatString = @"dd-MMMM-YYYY  HH:mm:ss";
        }
    }
    
    NSString *string = [NSDate br_stringFromDate:date dateFormat:formatString];
    
    return string;
}

@end
