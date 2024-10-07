//
//  FBRingtoneInfoModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2024-09-24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 铃声信息｜Ringtone information
*/
@interface FBRingtoneInfoModel : NSObject

/**
 铃声类型｜Ringtone types
 */
@property (nonatomic, assign) FB_RINGTONETYPE ringtoneType;

/**
 闹钟ID，当铃声类型为闹钟时必填｜Alarm ID, required when the ringtone type is alarm
 */
@property (nonatomic, assign) NSInteger uid;

/**
 列表文件信息｜List file information
 */
@property (nonatomic, strong) FBListFileInfoModel *fileModel;

@end

NS_ASSUME_NONNULL_END
