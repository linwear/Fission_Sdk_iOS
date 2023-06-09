//
//  LWMotionPushDownloadObject.h
//  LinWear
//
//  Created by 裂变智能 on 2023/2/28.
//  Copyright © 2023 lw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LWMotionPushClassifyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWMotionPushDownloadObject : NSObject <SSZipArchiveDelegate>

+ (LWMotionPushDownloadObject *)sharedInstance;

/// 请求运动推送数据包
- (void)requestMotionPushPacketWithArray:(NSArray <LWMotionPushModel *> *)array
                                tryCount:(int)tryCount
                                 success:(void(^)(NSArray <NSData *> *result))successful
                                 failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
