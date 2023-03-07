//
//  LWMotionPushDownloadObject.m
//  LinWear
//
//  Created by 裂变智能 on 2023/2/28.
//  Copyright © 2023 lw. All rights reserved.
//

#import "LWMotionPushDownloadObject.h"

@implementation LWMotionPushDownloadObject


+ (LWMotionPushDownloadObject *)sharedInstance {
    static LWMotionPushDownloadObject *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = LWMotionPushDownloadObject.new;
    });
    return manager;
}


#pragma mark - 请求运动推送数据包
- (void)requestMotionPushPacketWithArray:(NSArray<LWMotionPushModel *> *)array
                                tryCount:(int)tryCount
                                 success:(void (^)(NSArray<NSData *> * _Nonnull))successful
                                 failure:(void (^)(NSError * _Nonnull))failure {
    
    tryCount --;
    FBLog(@"💁请求运动推送数据包, %d次", tryCount);
    NSMutableArray *sportIds = NSMutableArray.array;
    for (LWMotionPushModel *model in array) {
        [sportIds addObject:@(model.sportId)];
    }
    
    WeakSelf(self);
    [LWNetworkingManager requestURL:@"api/v2/sportPush/classify/download" httpMethod:POST params:@{@"sportIds" : sportIds} success:^(id  _Nonnull result) {

        if ([result[@"code"] integerValue] == 200 && [result[@"data"] isKindOfClass:NSDictionary.class]) {

            NSInteger processStatus = [result[@"data"][@"processStatus"] integerValue];

            if (processStatus == 2) { // 处理完成

                NSString *dataFileUrl = result[@"data"][@"dataFileUrl"];

                if (StringIsEmpty(dataFileUrl)) {

                    FBLog(@"💁处理完成，文件URL为nil了～");
                    GCD_MAIN_QUEUE(^{
                        if (failure) {
                            failure(LWMotionPushDownloadObject.error);
                        }
                    });

                } else {

                    // 下载URL全部数据zip文件
                    [weakSelf DownloadFile:dataFileUrl array:array success:successful failure:failure];
                }
            } else {

                if (tryCount <= 0) {

                    FBLog(@"💁超次数，不试啦～");
                    GCD_MAIN_QUEUE(^{
                        if (failure) {
                            failure(LWMotionPushDownloadObject.error);
                        }
                    });

                } else {

                    GCD_AFTER(3.0, ^{ // 重试
                        [weakSelf requestMotionPushPacketWithArray:array tryCount:tryCount success:successful failure:failure];
                    });
                }
            }
        } else {

            GCD_MAIN_QUEUE(^{
                NSError *err = [NSError errorWithDomain:NSCocoaErrorDomain code:500 userInfo:@{NSLocalizedDescriptionKey:result[@"msg"]}];
                if (failure) {
                    failure(err);
                }
            });
        }
    } failure:^(NSError * _Nonnull error, id  _Nullable responseObject) {

        if (responseObject && [responseObject isKindOfClass:NSDictionary.class] &&
            [responseObject[@"code"] integerValue] == 21002) { // Token过期
            GCD_AFTER(3.0, ^{ // 重试
                [weakSelf requestMotionPushPacketWithArray:array tryCount:tryCount success:successful failure:failure];
            });
        } else {
            GCD_MAIN_QUEUE(^{
                if (failure) {
                    failure(error);
                }
            });
        }
    }];
}


#pragma mark - 下载 - 下载URL全部数据zip文件
- (void)DownloadFile:(NSString *)dataFileUrl
           array:(NSArray<LWMotionPushModel *> *)array
             success:(void(^)(NSArray <NSData *> *result))successful
             failure:(void(^)(NSError *error))failure {

    FBLog(@"💁下载全部数据zip文件 %@", dataFileUrl);

    WeakSelf(self);
    [LWNetworkingManager requestDownloadURL:dataFileUrl success:^(id  _Nonnull result) {

        FBLog(@"💁下载成功的zip包在本地的地址 %@", StringHandle(result[@"filePath"]));
        // 源文件路径
        NSString *sourceFilePath = result[@"filePath"];
        FBLog(@"💁要解压的文件路径:%@", sourceFilePath);

        // 解压后的文件路径
        NSString *unzipPath = [NSString stringWithFormat:@"%@/%@", NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0], @"LWMotionPushDataList"];
        NSURL *url = [NSURL fileURLWithPath:unzipPath];

        // 创建解压文件夹
        NSError *pathError = nil;
        [[NSFileManager defaultManager] createDirectoryAtURL:url withIntermediateDirectories:YES attributes:nil error:&pathError];
        FBLog(@"💁解压到路径: %@", unzipPath);

        if ([SSZipArchive unzipFileAtPath:sourceFilePath toDestination:unzipPath delegate:self]) {

            //目的文件路径
            NSArray *cachesPathArr = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *allDatePath = [[cachesPathArr lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"LWMotionPushDataList"]];

            FBLog(@"💁解压成功: %@", allDatePath);

            // 数据解析
            [weakSelf AnalysisOfZipFileData:allDatePath array:array success:successful failure:failure];

        } else {

            FBLog(@"💁解压失败～");
            GCD_MAIN_QUEUE(^{
                if (failure) {
                    failure(LWMotionPushDownloadObject.error);
                }
            });
        }

    } failure:^(NSError * _Nonnull error, id  _Nullable responseObject) {

        GCD_MAIN_QUEUE(^{
            if (failure) {
                failure(error);
            }
        });
    }];
}


#pragma mark - 下载 - zip文件数据解析
- (void)AnalysisOfZipFileData:(NSString *)allDatePath
                    array:(NSArray<LWMotionPushModel *> *)array
                      success:(void(^)(NSArray <NSData *> *result))successful
                      failure:(void(^)(NSError *error))failure {

    NSMutableArray *dataArray = NSMutableArray.array;
    
    for (LWMotionPushModel *model in array) {
        
        NSString *filePath = [NSString stringWithFormat:@"%@/%ld.bin", allDatePath, model.sportId];
        NSData *binFile = [NSData dataWithContentsOfFile:filePath];
        
        [dataArray addObject:binFile];
    }
    FBLog(@"💁服务器返回的运动推送数据共有%lu组", dataArray.count);
    
    if (successful) {
        successful(dataArray);
    }
}

+ (NSError *)error {
    NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:500 userInfo:@{NSLocalizedDescriptionKey:LWLocalizbleString(@"同步失败")}];
    return error;
}

+ (NSError *)uploadError:(NSString *)errorStr {
    NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:500 userInfo:@{NSLocalizedDescriptionKey:StringHandle(errorStr)}];
    return error;
}

#pragma mark - SSZipArchiveDelegate
- (void)zipArchiveWillUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo {
    FBLog(@"将要解压 %@", path);
}

- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo unzippedPath:(NSString *)unzippedPat uniqueId:(NSString *)uniqueId {
    FBLog(@"解压完成 %@ - %@", path, unzippedPat);
}

@end
