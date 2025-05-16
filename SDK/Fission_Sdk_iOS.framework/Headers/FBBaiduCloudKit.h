//
//  FBBaiduCloudKit.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2024-05-09.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBBaiduCloudKit : NSObject
/// 初始化单例
+ (FBBaiduCloudKit *)sharedInstance;

/// 是否支持通过流式方式回复，仅外部只读
@property (nonatomic, assign) BOOL allowStreamReply;

/// 是否支持通过JSI命令回复，仅外部只读
@property (nonatomic, assign) BOOL allowJSICommand;

/// 是否支持通过opus格式音频，仅外部只读
@property (nonatomic, assign) BOOL allowOpus;



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
 设备录音PCM数据回调｜Device recording PCM data callback
 */
+ (void)deviceRecordingPcmDataWithCallback:(void(^)(NSData * _Nullable pcmData))callback;


/**
 设备动作类型回调｜Device action type callback
 */
+ (void)deviceActionTypeWithCallback:(void(^)(FB_DEVICEACTIONTYPE actionType, FB_JSAPPLICATIONTYPE appType, NSString *content))callback;


/**
 通知手表APP前后台状态、网络状态变更｜Notify the watch of changes in APP foreground and background status and network status
 @param     callback    结果回调｜Result callback
 */
+ (void)notifyAppStatusWithCallback:(void(^)(NSError * _Nullable error))callback;


/**
 请求同步数据至设备｜Request to sync data to device
 @param     appType     JS类型｜JS Type
 @param     result      结果类型｜Result Type
 @param     text        文字内容｜Text Content
 @param     isEnd       文字是否结束｜Is the text finished?
 @param     callback    结果回调｜Result callback
 */
+ (void)requestSyncType:(FB_JSAPPLICATIONTYPE)appType result:(FB_JSAPPLICATIONRESULTS)result text:(NSString * _Nullable)text isEnd:(BOOL)isEnd callback:(void(^)(NSError * _Nullable error))callback;


@end

NS_ASSUME_NONNULL_END
