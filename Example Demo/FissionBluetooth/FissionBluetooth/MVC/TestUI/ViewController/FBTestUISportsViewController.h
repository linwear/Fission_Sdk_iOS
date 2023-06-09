//
//  FBTestUISportsViewController.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-05-30.
//

#import "LWBaseViewController.h"

typedef enum {
    FBSportsListType_SportsDetails,         // 运动详情
    FBSportsListType_SportsHrRange,         // 运动心率区间
    FBSportsListType_SportsHeartRate,       // 运动心率
    FBSportsListType_SportsStepFrequency,   // 运动步频
    FBSportsListType_SportsCalorie,         // 运动卡路里
    FBSportsListType_SportsDistance,        // 运动距离
    FBSportsListType_SportsPace,            // 运动配速
}FBSportsListType;

@class FBTestUISportsSectionModel;

NS_ASSUME_NONNULL_BEGIN

@interface FBTestUISportsViewController : LWBaseViewController

@property (nonatomic, strong) RLMSportsModel *sportsModel;

@end



@interface FBTestUISportsSectionModel : NSObject

@property (nonatomic, copy, nullable) NSString *sectionTitle;

@property (nonatomic, assign) FBSportsListType listType;

@property (nonatomic, strong) NSArray *rowArray;

@end


@interface FBTestUISportsChartOverviewModel : NSObject

@property (nonatomic, strong) AAChartModel *aaChartModel;

@property (nonatomic, strong) NSArray <FBTestUIOverviewModel *> *overviewArray;

@end

NS_ASSUME_NONNULL_END
