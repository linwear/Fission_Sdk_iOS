//
//  FBLogManager.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/1/6.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

//声明外部变量
extern DDLogLevel ddLogLevel;
#define DDLog(frmt, ...)     DDLogVerbose(frmt, ##__VA_ARGS__)


NS_ASSUME_NONNULL_BEGIN

@class FBFileManager;

@interface FBLogManager : NSObject

+ (FBLogManager *)sharedInstance;

- (NSArray *)allLogNames;

- (NSArray *)allLogPaths;

@end

@interface FBFileManager : DDLogFileManagerDefault

@end

NS_ASSUME_NONNULL_END
