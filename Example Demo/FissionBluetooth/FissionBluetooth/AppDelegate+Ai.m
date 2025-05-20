//
//  AppDelegate+Ai.m
//  FissionBluetooth
//
//  Created by LINWEAR on 2025-05-16.
//

#import "AppDelegate+Ai.h"

@interface AppDelegate ()

@property (nonatomic, strong) NSMutableData *pcmData; //手表语音pcm数据流

@end

@implementation AppDelegate (Ai)

- (NSMutableData *)pcmData {
    return objc_getAssociatedObject(self, @selector(pcmData));
}

- (void)setPcmData:(NSMutableData *)pcmData {
    objc_setAssociatedObject(self, @selector(pcmData), pcmData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)ai_registerCallbacks
{
    WeakSelf(self);
    self.pcmData = NSMutableData.data;
    
    /** Ai Chat 流程
     1.监听手表录音pcm数据回调 (FBBaiduCloudKit)deviceRecordingPcmDataWithCallback:
     2.监听设备动作类型回调 (FBBaiduCloudKit)deviceActionTypeWithCallback:
     3.录音结束后，将获得的pcm数据转为问题文本，将获得的问题文本发送手表 (FBBaiduCloudKit)requestSyncType:result:text:isEnd:callback:
     4.将获得的答案文本发送手表 (FBBaiduCloudKit)requestSyncType:result:text:isEnd:callback:
     */
    
    
    // 1.监听手表录音pcm数据回调 (FBBaiduCloudKit)deviceRecordingPcmDataWithCallback:
    // 设备录音pcm数据回调｜Device recording pcm data callback
    [FBBaiduCloudKit deviceRecordingPcmDataWithCallback:^(NSData * _Nullable pcmData) {
        if (pcmData.length) {
            [weakSelf.pcmData appendData:pcmData];
        }
    }];
    
    // 2.监听设备动作类型回调 (FBBaiduCloudKit)deviceActionTypeWithCallback:
    // 设备动作类型回调｜Device action type callback
    [FBBaiduCloudKit deviceActionTypeWithCallback:^(FB_DEVICEACTIONTYPE actionType, FB_JSAPPLICATIONTYPE appType, NSString * _Nonnull content) {
        
        if (actionType == FB_DEVICEACTIONTYPE_STARTRECORDING_WATCH) {
            [weakSelf.pcmData setLength:0];
        }
        else if (actionType == FB_DEVICEACTIONTYPE_ENDRECORDING_WATCH) {
            
            // 3.录音结束后，将获得的pcm数据转为问题文本，将获得的问题文本发送手表 (FBBaiduCloudKit)requestSyncType:result:text:isEnd:callback:
            [FBBaiduCloudKit requestSyncType:appType result:FB_JSAPPLICATIONRESULTS_QUESTION text:@"How was steel tempered?" isEnd:YES callback:^(NSError * _Nullable error) {
                                
                if (!error)
                {
                    // 4.将获得的答案文本发送手表 (FBBaiduCloudKit)requestSyncType:result:text:isEnd:callback:
                    [FBBaiduCloudKit requestSyncType:appType result:FB_JSAPPLICATIONRESULTS_ANSWERS_OR_DIALSRATUS text:@"How the Steel Was Tempered is a novel written by Soviet writer Nikolai Ostrovsky, telling the story of the protagonist Pavel Korchagin growing into a steel warrior in the revolution and construction. The \"steel\" in the title symbolizes the indomitable revolutionary will and the spirit of tenacious struggle." isEnd:YES callback:^(NSError * _Nullable error) {
                        
                    }];
                }
            }];
        }
        else if (actionType == FB_DEVICEACTIONTYPE_CHECK)
        {
            //通知手表APP前后台状态、网络状态变更｜Notify the watch of changes in APP foreground and background status and network status
            [FBBaiduCloudKit notifyAppStatusWithCallback:^(NSError * _Nullable error) {
                
            }];
        }
    }];
}

@end
