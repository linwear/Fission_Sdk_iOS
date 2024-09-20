//
//  FBBaiduCloudKit.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2024-05-09.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBBaiduCloudKit : NSObject

/**
 请求打开JS百度导航应用｜Request to open JS Baidu navigation application
 @param     callback    结果回调｜Result callback
 */
+ (void)requestOpenJsBaiduNaviAppWithCallback:(void(^)(NSError * _Nullable error))callback;


/**
 请求同步JS百度导航数据｜Request synchronization of JS Baidu navigation data
 @param     model       导航诱导数据｜Navigation guidance data
 @param     callback    结果回调｜Result callback
 */
+ (void)requestSyncJsBaiduNaviInfo:(FBBaiduNaviModel * _Nonnull)model callback:(void(^)(NSError * _Nullable error))callback;


/**
 请求同步JS文心一言数据(问)｜Request to synchronize JS ERNIE Bot data (Question)
 @param     questiont   问题内容｜Question content
 @param     callback    结果回调｜Result callback
 */
+ (void)requestSyncJsERNIE_BoWithQuestiont:(NSString * _Nonnull)questiont callback:(void(^)(NSError * _Nullable error))callback;


/**
 请求同步JS文心一言数据(答)｜Request to synchronize JS ERNIE Bot data (Answer)
 @param     answer      回答内容｜Answer content
 @param     callback    结果回调｜Result callback
 */
+ (void)requestSyncJsERNIE_BoWithAnswer:(NSString * _Nonnull)answer callback:(void(^)(NSError * _Nullable error))callback;


/**
 设备录音开始回调｜Device recording starts callback
 */
+ (void)deviceRecordingStartsWithCallback:(void(^)(void))callback;


/**
 设备录音PCM数据回调｜Device recording PCM data callback
 */
+ (void)deviceRecordingPcmDataWithCallback:(void(^)(NSData * _Nullable pcmData))callback;


/**
 设备录音结束回调｜Device recording ends callback
 */
+ (void)deviceRecordingEndsWithCallback:(void(^)(FB_ENDRECORDINGTYPE endType))callback;

@end

NS_ASSUME_NONNULL_END
