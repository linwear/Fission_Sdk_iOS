//
//  NSDate+Date.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/5/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    FBDateFormatHm = 0,
    FBDateFormatYMD,        // 兼容中英格式yyyy-MM-dd、dd-MMM-yyyy
    FBDateFormatYMDHm,      // 兼容中英格式yyyy-MM-dd HH:mm、dd-MMM-yyyy HH:mm
    FBDateFormatYMDHms,     // 兼容中英格式yyyy-MM-dd HH:mm:ss、dd-MMM-yyyy HH:mm:ss
}FBDateFormat;

@interface NSDate (Date)

/// 当天00点0分01秒
- (NSInteger)Time_01;

/// 当天24点0分00秒
- (NSInteger)Time_24;

/// 时间戳按指定日期格式转换为字符串
+ (NSString *)timeStamp:(NSInteger)time dateFormat:(FBDateFormat)dateFormat;

@end

NS_ASSUME_NONNULL_END
