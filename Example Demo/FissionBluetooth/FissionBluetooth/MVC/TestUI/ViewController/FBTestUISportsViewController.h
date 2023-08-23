//
//  FBTestUISportsViewController.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-05-30.
//

#import "LWBaseViewController.h"

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
