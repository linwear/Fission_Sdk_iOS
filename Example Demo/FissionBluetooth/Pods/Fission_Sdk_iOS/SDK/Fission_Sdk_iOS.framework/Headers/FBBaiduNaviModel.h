//
//  FBBaiduNaviModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2024-06-14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 百度导航诱导信息｜Baidu navigation misleading information
*/
@interface FBBaiduNaviModel : NSObject

/** 1:导航中，0:结束导航｜1: Navigation in progress, 0: End navigation */
@property (nonatomic, assign) int status;

/** 0:驾车导航，1:步行导航，2:骑行导航｜0: Driving navigation, 1: Walking navigation, 2: Cycling navigation */
@property (nonatomic, assign) int type;

/** 转向标图片名称，需要拼接前缀'bsdk_drawable_rg_ic_'｜The name of the turn sign image, needs to be prefixed with 'bsdk_drawable_rg_ic_' */
@property (nonatomic, copy) NSString *turnIconName;

/** 导航信息，举例:沿民塘路直行92米｜Navigation information, example: Go straight along Mintang Road for 92 meters */
@property (nonatomic, copy) NSString *bNaviInfo;

/** 距离(米)，驾车导航字段｜Distance (meters), driving navigation field */
@property (nonatomic, assign) NSInteger distance;

/** 道路名称，驾车导航字段｜Road name, driving navigation field */
@property (nonatomic, copy) NSString *roadName;

/** 剩余时间，骑行导航&步行导航字段｜Remaining time, cycling navigation & walking navigation fields */
@property (nonatomic, copy) NSString *remainTime;

/** 剩余距离，骑行导航&步行导航字段｜Remaining distance, cycling navigation & walking navigation fields */
@property (nonatomic, copy) NSString *remainDistance;

/** GPS状态｜GPS Status */
@property (nonatomic, copy) NSString *gpsText;

@end

NS_ASSUME_NONNULL_END
