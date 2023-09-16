//
//  FBSportsStatisticsDetailsRecordModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/1/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 运动统计报告+运动详情纪录｜Sports Statistics Report + Sports Details Record
 */
@interface FBSportsStatisticsDetailsRecordModel : NSObject

/**
 运动统计报告｜Sports Statistics Report
*/
@property (nonatomic, strong) FBSportCaculateModel *sportsStatisticsRecord;

/**
 运动详情纪录｜Sports Details Record
*/
@property (nonatomic, strong) NSArray <FBRecordDetailsModel *> *sportsDetailsRecord;

@end

NS_ASSUME_NONNULL_END
