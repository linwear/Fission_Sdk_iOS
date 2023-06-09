//
//  FBCustomDialObject.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-06-01.
//

#import <Foundation/Foundation.h>
#import "FBAuthorityObject.h"
#import "FBCustomDialListModel.h"

typedef enum {
    FBCustomDialType_None = 0,      // 无
    FBCustomDialType_Number,        // 数字表盘
    FBCustomDialType_Pointer,       // 指针表盘
    FBCustomDialType_Number_Pointer // 数字 + 指针
}FBCustomDialType;


NS_ASSUME_NONNULL_BEGIN

@interface FBCustomDialObject : NSObject

/// 单例
+ (FBCustomDialObject *)sharedInstance;

/// 文件解压
- (void)UnzipFormFilePath:(NSString *)filePath block:(void(^)(NSArray<FBCustomDialListModel *> * _Nullable list, NSError * _Nullable error))block;

/* 解析得到的 packet.bin */
@property (nonatomic, strong, nullable) NSData *packet_bin;

@end

NS_ASSUME_NONNULL_END
