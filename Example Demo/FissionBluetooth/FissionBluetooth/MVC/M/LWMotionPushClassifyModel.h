//
//  LWMotionPushClassifyModel.h
//  LinWear
//
//  Created by 裂变智能 on 2023/2/27.
//  Copyright © 2023 lw. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LWMotionPushModel;
@class LWMotionPushSectionModel;
@class LWMotionPushCellModel;

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    LWHeadTitleClick,   // 组头
    LWCellSelectClick,  // 选择/取消
    LWCellDeleteClick,  // 删除
    LWCellAddClick,     // 添加
    LWCellMoveClick     // 移动
}LWMotionPushClickType;

typedef void(^LWMotionPushSelectBlock)(LWMotionPushClickType clickType, id result);

@interface LWMotionPushClassifyModel : NSObject

@property (nonatomic, assign) BOOL isShow;

@property (nonatomic, assign) NSInteger sportClassifyType;

@property (nonatomic, copy) NSString *sportClassifyName;

@property (nonatomic, strong) NSArray <LWMotionPushModel *> *sportList;

@end



@interface LWMotionPushModel : NSObject

@property (nonatomic, assign) BOOL isShow;

@property (nonatomic, assign) NSInteger sportId;

@property (nonatomic, copy) NSString *sportName;

@property (nonatomic, assign) NSInteger sportType;

@property (nonatomic, copy) NSString *appIconUrl;

@property (nonatomic, copy) NSString *binUrl;

@end



@interface LWMotionPushSectionModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *detail;

@end



@interface LWMotionPushCellModel : NSObject

@property (nonatomic, assign) CGSize itemSize;

@property (nonatomic, assign) UIEdgeInsets sectionInset;

@property (nonatomic, assign) CGFloat minimumLineSpacing;

@property (nonatomic, assign) CGFloat minimumInteritemSpacing;

@end

NS_ASSUME_NONNULL_END
