//
//  FBCustomDialObject.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-06-01.
//

#import <Foundation/Foundation.h>
#import "FBCustomDialListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FBCustomDialObject : NSObject

/// 单例
+ (FBCustomDialObject *)sharedInstance;

/// 文件解压
- (void)UnzipFormFilePath:(NSString *)filePath block:(void(^)(NSArray<FBCustomDialListModel *> * _Nullable list, NSError * _Nullable error))block;

/* 解析得到的 packet.bin（最后传给SDK）*/
@property (nonatomic, strong, readonly) NSData *packet_bin;

/* 解析得到的 info_png.bin（最后传给SDK）*/
@property (nonatomic, strong, readonly) NSDictionary *info_png;

/* 解析得到的 电池电量图标（不带文字，FBCustomDialHeadView用）*/
@property (nonatomic, strong, readonly) NSMutableArray <FBCustomDialSoures *> *batterySoures;

@end

NS_ASSUME_NONNULL_END
