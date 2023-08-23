//
//  FBLogManager.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/1/6.
//

#import "FBLogManager.h"

DDLogLevel ddLogLevel = DDLogLevelVerbose;

@interface FBLogManager ()

@property (nonatomic, strong) DDFileLogger *fileLogger;//控制台logger
@property (nonatomic, strong) DDOSLogger *osLogger;//文件写入Logger

@end

@implementation FBLogManager

+ (FBLogManager *)sharedInstance {
    static FBLogManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        
        // 控制台logger
        DDOSLogger *osLogger = DDOSLogger.sharedInstance;
        self.osLogger = osLogger;
        
        // 文件写入Logger
        FBFileManager *fileManager = FBFileManager.new;
        DDFileLogger *fileLogger = [[DDFileLogger alloc] initWithLogFileManager:fileManager];
        // 每次app启动的时候创建一个新的log文件
        fileLogger.doNotReuseLogFiles = YES;
        // log文件在24小时内有效，超过时间创建新log文件(默认值是24小时)
        fileLogger.rollingFrequency = 60*60*24;
        // log文件的最大30M(默认值1M)
        fileLogger.maximumFileSize = 1024*1024*30;
        // 最多保存30个log文件(默认值是5)，设置0可关闭此项
        fileLogger.logFileManager.maximumNumberOfLogFiles = 30;
        // log文件夹最多保存900M(默认值是20M)，设置0可关闭此项
        fileLogger.logFileManager.logFilesDiskQuota = 900 * 1024 * 1024;
        self.fileLogger = fileLogger;
        
        [DDLog addLogger:self.osLogger];
        [DDLog addLogger:self.fileLogger];
    }
    return self;
}

- (NSArray <DDLogFileInfo *> *)allLogFileInfo {
    NSArray <DDLogFileInfo *> *allLogFileInfo = self.fileLogger.logFileManager.sortedLogFileInfos;
    return allLogFileInfo;
}

@end

@implementation FBFileManager // 默认log的存储路径，在iPhone上，它位于“~/Library/Caches/Logs”中。

//重写方法(log文件名生成规则)
- (NSString *)newLogFileName {
    
    NSString *dateString = [NSDate br_stringFromDate:NSDate.date dateFormat:@"yyyy-MM-dd_HH_mm_ss" timeZone:nil language:@"zh-Hans-CN"];
    NSString *logFileName = [NSString stringWithFormat:@"%@.log", dateString];

    return logFileName;
}

//重写方法(是否是log文件)
- (BOOL)isLogFile:(NSString *)fileName {
    
    BOOL hasProperSuffix = [fileName hasSuffix:@".log"];
    
    return hasProperSuffix;
}

@end
