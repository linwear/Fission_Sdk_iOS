//
//  AppDelegate+Ai.m
//  FissionBluetooth
//
//  Created by LINWEAR on 2025-05-16.
//

#import "AppDelegate+Ai.h"
#import <NativeLib/NativeLib.h>
#import "FBAudioRecorder.h"

@interface AppDelegate ()

/// 手表语音pcm数据流
@property (nonatomic, strong) NSMutableData *pcmData;

/// 手表mac地址
@property (nonatomic, copy) NSString *mac;

/// 输入的语种，这里只为演示，从而取当前手机语言，实际需要根据自身业务调整
@property (nonatomic, copy) NSString *language;

/// 麦克风
@property (nonatomic, strong) FBAudioRecorder *audioRecorder;

/// 应用类型
@property (nonatomic, assign) FB_JSAPPLICATIONTYPE appType;

@end

@implementation AppDelegate (Ai)

- (NSMutableData *)pcmData {
    return objc_getAssociatedObject(self, @selector(pcmData));
}

- (void)setPcmData:(NSMutableData *)pcmData {
    objc_setAssociatedObject(self, @selector(pcmData), pcmData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)mac {
    return objc_getAssociatedObject(self, @selector(mac));
}
- (void)setMac:(NSString *)mac {
    objc_setAssociatedObject(self, @selector(mac), mac, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)language {
    return objc_getAssociatedObject(self, @selector(language));
}
- (void)setLanguage:(NSString *)language {
    objc_setAssociatedObject(self, @selector(language), language, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (FBAudioRecorder *)audioRecorder {
    return objc_getAssociatedObject(self, @selector(audioRecorder));
}
- (void)setAudioRecorder:(FBAudioRecorder *)audioRecorder {
    objc_setAssociatedObject(self, @selector(audioRecorder), audioRecorder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (FB_JSAPPLICATIONTYPE)appType {
    return [objc_getAssociatedObject(self, @selector(appType)) integerValue];
}
- (void)setAppType:(FB_JSAPPLICATIONTYPE)appType {
    objc_setAssociatedObject(self, @selector(appType), @(appType), OBJC_ASSOCIATION_ASSIGN);
}


#pragma mark - 用户唯一ID，这里只为演示，实际应该保持唯一｜User unique ID, this is just for demonstration, it should be unique in practice
- (NSString *)uuid
{
    return @"123456";
}


#pragma mark - 唯一请求ID，需要保持唯一｜Unique request ID, needs to remain unique
- (NSString *)requestId
{
    return [NSString stringWithFormat:@"%@_%ld", self.uuid, (NSUInteger)NSDate.date.timeIntervalSince1970*1000];
}


#pragma mark - 注册手表相关AI回调｜Register watch-related AI callbacks
- (void)ai_registerCallbacks
{
    WeakSelf(self);
    self.pcmData = NSMutableData.data;
    
    self.language = NSLocale.currentLocale.languageCode;
    
    /** Ai Chat 流程
     1.监听手表录音pcm数据回调 (FBBaiduCloudKit)deviceRecordingPcmDataWithCallback:
     2.监听设备动作类型回调 (FBBaiduCloudKit)deviceActionTypeWithCallback:
     3.录音结束后，将获得的pcm数据转为问题文本，将获得的问题文本发送手表 (FBBaiduCloudKit)requestSyncType:result:text:isEnd:callback:
     4.将获得的答案文本发送手表 (FBBaiduCloudKit)requestSyncType:result:text:isEnd:callback:
     */
    
    
    // 1.监听手表录音pcm数据回调 (FBBaiduCloudKit)deviceRecordingPcmDataWithCallback:
    // 设备录音pcm数据回调｜Device recording pcm data callback
    [FBBaiduCloudKit deviceRecordingPcmDataWithCallback:^(NSData * _Nullable pcmData)
     {
        if (pcmData.length) {
            [weakSelf.pcmData appendData:pcmData];
        }
    }];
    
    // 初始化手机麦克风
    self.audioRecorder = [[FBAudioRecorder alloc] initWithCallback:^(NSData * _Nullable audioData, NSError * _Nullable error)
                          {
        if (error) {
            NSLog(@"手机麦克风初始化失败 %@", error);
        }
        else {
            if (audioData.length) {
                [weakSelf.pcmData appendData:audioData];
                
                [weakSelf ai_speechToText:weakSelf.appType];
            }
        }
    }];
    
    // 2.监听设备动作类型回调 (FBBaiduCloudKit)deviceActionTypeWithCallback:
    // 设备动作类型回调｜Device action type callback
    [FBBaiduCloudKit deviceActionTypeWithCallback:^(FB_DEVICEACTIONTYPE actionType, FB_JSAPPLICATIONTYPE appType, NSString * _Nonnull content)
     {
        // 由表侧录音
        if (actionType == FB_DEVICEACTIONTYPE_STARTRECORDING_WATCH)//手表开始录音
        {
            [weakSelf.pcmData setLength:0];
        }
        else if (actionType == FB_DEVICEACTIONTYPE_ENDRECORDING_WATCH)//手表结束录音
        {
            // 语音转文字
            [weakSelf ai_speechToText:appType];
        }
        
        // 由手机侧录音
        else if (actionType == FB_DEVICEACTIONTYPE_STARTRECORDING_PHONE)//手机开始录音
        {
            [weakSelf.pcmData setLength:0];
            
            // 启动麦克风录音
            [weakSelf.audioRecorder startRecording:^(BOOL autorisieren, BOOL success) {
                if (!autorisieren) {
                    NSLog(@"麦克风权限未授权");
                }
                else if (!success) { // 录音失败
                    NSLog(@"麦克风录音失败");
                }
            } allowFirst:YES];
        }
        else if (actionType == FB_DEVICEACTIONTYPE_ENDRECORDING_PHONE)//手机结束录音
        {
            weakSelf.appType = appType;
            
            // 关闭麦克风录音
            [weakSelf.audioRecorder finishRecording];
        }
        
        else if (actionType == FB_DEVICEACTIONTYPE_CHECK)
        {
            //通知手表APP前后台状态、网络状态变更｜Notify the watch of changes in APP foreground and background status and network status
            [FBBaiduCloudKit notifyAppStatusWithCallback:^(NSError * _Nullable error) {
                
            }];
        }
    }];
}


#pragma mark - 初始化AI服务｜Initialize AI service
- (void)ai_initialize:(NSString *)mac
{
    self.mac = mac;
    WatchInfo *watchInfo = [[WatchInfo alloc] initWithPayModel:PaymentModelLICENSE_PAY wid:mac];
    watchInfo.language = self.language;
    
    [[AFlash shared] initializeWithWatchInfos:@[watchInfo]
                                    onSuccess:^(NSArray<WatchInfo *> * _Nonnull watchInfos) {
        
        NSLog(@"AI初始化成功 %@", watchInfos);
        
    } onFailure:^(ErrorCode * _Nonnull error) {
        
        NSLog(@"AI初始化失败 %@", error);
    }];
}


#pragma mark - 语音转文字｜Speech to Text
- (void)ai_speechToText:(FB_JSAPPLICATIONTYPE)appType
{
    /// 这里只简易演示流程，实际业务需根据自身出来｜Here we only demonstrate the process briefly. The actual business needs to be based on your own
    WeakSelf(self);
    
    [[AFlash shared] speechToTextWithRequestId:[self requestId]
                                           wid:self.mac
                                     thirdUuid:[self uuid]
                                          data:self.pcmData
                                    fileFormat:@"pcm"
                                      language:self.language
                                     onSuccess:^(NSString * _Nonnull requestId, NSString * _Nonnull text)
     {
        NSLog(@"语音转文字成功 %@", text);
        
        // ChatGPT
        if (appType == FB_JSAPPLICATIONTYPE_CHATGPT)
        {
            // 3.录音结束后，将获得的pcm数据转为问题文本，将获得的问题文本发送手表 (FBBaiduCloudKit)requestSyncType:result:text:isEnd:callback:
            [FBBaiduCloudKit requestSyncType:appType
                                      result:FB_JSAPPLICATIONRESULTS_QUESTION
                                        text:text
                                       isEnd:YES
                                    callback:^(NSError * _Nullable error)
             {
                if (error)
                {
                    NSLog(@"问题文字发送失败 %@", error);
                }
                else
                {
                    NSLog(@"问题文字发送成功");
                    // 请求回答
                    [weakSelf ai_chatText:appType ask:text];
                }
            }];
        }
        // AI Dial
        else if (appType == FB_JSAPPLICATIONTYPE_AIDIAL)
        {
            // 请求画图
            [weakSelf ai_drawingText:appType ask:text];
        }
        
    } onFailure:^(NSString * _Nonnull requestId, ErrorCode * _Nonnull error)
     {
        NSLog(@"语音转文字失败 %@", error);
    }];
}


#pragma mark - 文字聊天｜Text Chat
- (void)ai_chatText:(FB_JSAPPLICATIONTYPE)appType ask:(NSString *)ask
{
    [[AFlash shared] textChatWithRequestId:[self requestId]
                                       wid:self.mac
                                 thirdUuid:[self uuid]
                              inputContent:ask
                                 contentId:@"" //上下文id，不传则每次都是新的chat
                                  language:[self language]
                                 onSuccess:^(NSString * _Nonnull requestId, NSString * _Nonnull sendTextContent, NSString * _Nonnull answerTextContent, NSString * _Nonnull contentId, SubscriptionInfo * _Nullable subscriptionInfo)
     {
        NSLog(@"文字聊天成功 %@", answerTextContent);
        
        // 4.将获得的答案文本发送手表 (FBBaiduCloudKit)requestSyncType:result:text:isEnd:callback:
        [FBBaiduCloudKit requestSyncType:appType
                                  result:FB_JSAPPLICATIONRESULTS_ANSWERS_OR_DIALSRATUS
                                    text:answerTextContent
                                   isEnd:YES
                                callback:^(NSError * _Nullable error)
         {
            //something...
        }];
        
    } onFailure:^(NSString * _Nonnull requestId, ErrorCode * _Nonnull error)
     {
        NSLog(@"文字聊天失败 %@", error);
    }];
}


#pragma mark - 文字画图｜Text drawing
- (void)ai_drawingText:(FB_JSAPPLICATIONTYPE)appType ask:(NSString *)ask
{
    [[AFlash shared] textDrawingToDataWithRequestId:[self requestId]
                                                wid:self.mac
                                          thirdUuid:[self uuid]
                                       inputContent:ask
                                          imgFormat:@"jpeg"
                                              style:1
                                           language:self.language
                                          onSuccess:^(NSString * _Nonnull requestId, NSString * _Nonnull sendTextContent, NSData * _Nonnull imgData, NSData * _Nullable thuImgData, SubscriptionInfo * _Nullable subscriptionInfo)
     {
        UIImage *img = [UIImage imageWithData:imgData];
        NSLog(@"文字画图成功 %@", img);
        
        // text内容，Ai表盘生成状态(1成功，2失败)
        [FBBaiduCloudKit requestSyncType:appType result:FB_JSAPPLICATIONRESULTS_ANSWERS_OR_DIALSRATUS text:@"1" isEnd:YES callback:^(NSError * _Nullable error) {
            //something...
        }];
        
        // 4.将获得的图片制作成自定义表盘，发送给手表...
        // 参考自定义表盘
        // (FBCustomDataTools)fbGenerateCustomDialBinFileDataWithDialModel:
        // (FBBluetoothOTA)fbStartCheckingOTAWithBinFileData:withOTAType:withBlock:
        
    } onFailure:^(NSString * _Nonnull requestId, ErrorCode * _Nonnull error)
     {
        NSLog(@"文字画图失败 %@", error);
    }];
}

@end
