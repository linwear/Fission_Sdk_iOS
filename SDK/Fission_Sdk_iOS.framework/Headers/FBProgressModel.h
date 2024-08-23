//
//  FBProgressModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/3/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 FB蓝牙OTA进度模型 | FB Bluetooth OTA progress model
*/
@interface FBProgressModel : NSObject

/**
 当前正在执行第N个文件｜The Nth file is currently being executed
 */
@property (nonatomic, assign) NSInteger currentPackage;

/**
 当前总文件数｜Current total number of files
 */
@property (nonatomic, assign) NSInteger totalPackage;

/**
 当前第N个文件的进度 0～100｜The progress of the current Nth file 0～100
 */
@property (nonatomic, assign) NSInteger currentPackageProgress;

/**
 当前总进度 0～100｜Current total progress 0～100
 */
@property (nonatomic, assign) NSInteger totalPackageProgress;

@end

NS_ASSUME_NONNULL_END
