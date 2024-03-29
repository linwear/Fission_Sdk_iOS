//
//  FBLocalHistoricalModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-06-05.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBLocalHistoricalModel : NSObject

/// 当前累计步数｜Current cumulative steps
@property (nonatomic, assign) NSInteger currentStep;

/// 当前累计消耗卡路里（千卡）｜Current cumulative calories consumed (kcal)
@property (nonatomic, assign) NSInteger currentCalories;

/// 当前累计行程（米）｜Current cumulative travel (m)
@property (nonatomic, assign) NSInteger currentDistance;

/// 今天24小时步数记录｜Today's 24-hour step count record
@property (nonatomic, strong) NSArray <NSNumber *> *stepsArray;

/// 最近一次运动记录｜Last Exercise Record
@property (nonatomic, strong) RLMSportsModel *sportsModel;
@property (nonatomic, assign) NSInteger sportsBegin;

/// 最近一次心率记录｜Last Heart Rate Record
@property (nonatomic, assign) NSInteger hrBegin;
@property (nonatomic, copy) NSString *hr;

/// 最近一次血氧记录｜Last blood oxygen record
@property (nonatomic, assign) NSInteger spo2Begin;
@property (nonatomic, copy) NSString *spo2;

/// 最近一次血压记录｜Last blood pressure record
@property (nonatomic, assign) NSInteger bpBegin;
@property (nonatomic, copy) NSString *bp;

/// 最近一次压力记录｜Last Stress Record
@property (nonatomic, assign) NSInteger stressBegin;
@property (nonatomic, copy) NSString *stress;

/// 最近一次睡眠记录｜Last Sleep Record
@property (nonatomic, assign) NSInteger sleepBegin;
@property (nonatomic, copy) NSString *sleep;

/// 最近一次女性健康记录｜Latest women's health records
@property (nonatomic, assign) NSInteger womenHealthBegin;
@property (nonatomic, copy) NSString *womenHealth;

@end

NS_ASSUME_NONNULL_END
