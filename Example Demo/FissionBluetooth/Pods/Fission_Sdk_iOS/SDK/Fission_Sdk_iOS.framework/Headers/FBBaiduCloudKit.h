//
//  FBBaiduCloudKit.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2024-05-09.
//

#import <Foundation/Foundation.h>

@class FBBaiduSpeechRecognitionModel;
@class FBBaiduTranslationModel;
@class FBBaiduERNIE_BotModel;
@class FBBaiduContextModel;

NS_ASSUME_NONNULL_BEGIN

@interface FBBaiduCloudKit : NSObject

/**
 请求语音识别(转文本，⚠️传入完整的音频PCM文件数据)｜Request speech recognition (convert to text, ⚠️input complete audio PCM file data)
 @param     completeAudioData       完整的音频PCM文件数据｜Complete audio PCM file data
 @param     callback                结果回调｜Result callback
 
 @note      要求: 音频文件数据PCM格式 采样率16000｜Requirements: Audio file data PCM format sampling rate 16000
 */
+ (void)requestSpeechRecognitionWithCompleteAudioData:(NSData * _Nonnull)completeAudioData callback:(void(^)(FBBaiduSpeechRecognitionModel * _Nullable model, NSError * _Nullable error))callback;


/**
 请求实时语音识别(转文本，⚠️传入音频流PCM数据)｜Request real-time speech recognition (convert to text, ⚠️incoming audio stream PCM data)
 @param     audioStreamingData      实时音频流PCM数据｜Live audio streaming PCM data
 @param     callback                结果回调｜Result callback
 
 @note      要求: 音频流PCM格式 采样率16000，缓冲区大小1600；结束需要主动调用 @c stopSpeechRecognitionRequest: 以停止语音识别请求｜Requirements: Audio stream PCM format, sampling rate 16000, buffer size 1600; to end, you need to actively call @c stopSpeechRecognitionRequest: to stop the speech recognition request
 */
+ (void)requestSpeechRecognitionWithAudioStreamingData:(NSData * _Nonnull)audioStreamingData callback:(void(^)(FBBaiduSpeechRecognitionModel * _Nullable model, NSError * _Nullable error))callback;


/**
 停止语音识别请求｜Stop speech recognition request
 */
+ (void)stopSpeechRecognitionRequest;


/**
 请求文本翻译｜Request text translation
 @param     text        待翻译的文本｜Audio file path
 @param     form        翻译源语言，可设置为auto｜Translation source language, can be set to auto
 @param     to          翻译目标语言，不可设置为auto｜Translation target language, cannot be set to auto
 @param     callback    结果回调｜Result callback
 */
+ (void)requestTranslationWithText:(NSString * _Nonnull)text form:(FB_TRANSLATIONLANGUAGE)form to:(FB_TRANSLATIONLANGUAGE)to callback:(void(^)(FBBaiduTranslationModel * _Nullable model, NSError * _Nullable error))callback;


/**
 请求文心一言(文本意图)｜Request ERNIE Bot(Textual intent)
 @param     newText             新文本｜New Text
 @param     historyContext      历史上下文｜Historical context
 @param     callback            结果回调｜Result callback
 */
+ (void)requestERNIE_BotWithNewText:(NSString * _Nonnull)newText historyContext:(NSArray <FBBaiduContextModel *> * _Nullable)historyContext callback:(void(^)(FBBaiduERNIE_BotModel * _Nullable model, NSError * _Nullable error))callback;


/**
 请求短文本合成语音｜Request short text to synthesize speech
 @param     text        待合成的短文本｜Short text to be synthesized
 @param     callback    结果回调｜Result callback
 
 @note      建议文本不超过120GBK字节，即60个汉字或者字母数字。最长1024GBK字节，文字越长耗时越长｜It is recommended that the text does not exceed 120GBK bytes, that is, 60 Chinese characters or alphanumeric characters. The maximum length is 1024GBK bytes. The longer the text, the longer it will take.
 */
+ (void)requestSynthesisSpeechWithText:(NSString * _Nonnull)text callback:(void(^)(NSURL * _Nullable audioURL, NSError * _Nullable error))callback;


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



/// 语音识别结果模型｜Speech recognition result model
@interface FBBaiduSpeechRecognitionModel : NSObject
/// 语音识别状态｜Speech recognition status
@property (nonatomic, assign) FB_SPEECHRECOGNITIONSTATUS status;
/// 语音识别结果｜Speech recognition results
@property (nonatomic, copy) NSString *results;
@end



/// 翻译结果模型｜Translation result model
@interface FBBaiduTranslationModel : NSObject
/// 原文语种｜Original language
@property (nonatomic, assign) FB_TRANSLATIONLANGUAGE form;
/// 译文语种｜Translation language
@property (nonatomic, assign) FB_TRANSLATIONLANGUAGE to;
/// 原文｜Original
@property (nonatomic, copy) NSString *original;
/// 译文｜Translation
@property (nonatomic, copy) NSString *translation;
@end



/// 文心一言结果模型｜ERNIE Bot result model
@interface FBBaiduERNIE_BotModel : NSObject
/// 是否回答结束｜End of answer or not
@property (nonatomic, assign) BOOL ended;
/// 回答结果｜Answer result
@property (nonatomic, copy) NSString *results;
@end



/// 文心一言上下文内容模型｜ERNIE Bot Context Content Model
@interface FBBaiduContextModel : NSObject
- (instancetype)initWithRole:(FB_CONTEXTROLE)role content:(NSString *)content;
/// 角色｜Role
@property (nonatomic, assign) FB_CONTEXTROLE role;
/// 内容｜Content
@property (nonatomic, copy) NSString *content;
@end


NS_ASSUME_NONNULL_END
