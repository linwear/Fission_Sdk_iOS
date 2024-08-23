//
//  FBAuthorityObject.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-06-01.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    FBAuthorityType_Album,          // 相册
    FBAuthorityType_Camera_Album,   // 相机+相册
}FBAuthorityType;

/// 选择结果id类型 image 或 FBCustomDialVideoModel
typedef void(^FBAuthorityObjectBlock)(id _Nullable results);

@interface FBAuthorityObject : NSObject

+ (FBAuthorityObject *)sharedInstance;

- (void)present:(UIViewController *)presentViewController requestImageWithBlock:(FBAuthorityObjectBlock)block;

- (void)accessType:(FBAuthorityType)type block:(FBAuthorityObjectBlock)block;

@end

NS_ASSUME_NONNULL_END
