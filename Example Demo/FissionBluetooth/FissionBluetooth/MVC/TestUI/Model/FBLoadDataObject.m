//
//  FBLoadDataObject.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/5/8.
//

#import "FBLoadDataObject.h"


#define x_Categories_1 @[@" ", @"02:00", @"03:00", @"04:00", @"05:00", @"06:00", @"07:00", @"08:00", @"09:00", @"10:00", @"11:00", @"12:00", @"13:00", @"14:00", @"15:00", @"16:00", @"17:00", @"18:00", @"19:00", @"20:00", @"21:00", @"22:00", @"23:00", @"24:00"]

#define x_Categories_2 \
({\
NSMutableArray *x_arr = NSMutableArray.array;\
NSInteger Time_00 = NSDate.date.Time_01-1;\
for (int index = 0; index < array.count; index++) {\
    NSInteger begin = Time_00 + index*600;\
    [x_arr addObject: index==0 ? @" " : [NSDate timeStamp:begin dateFormat:FBDateFormatHm]];\
}\
x_arr;\
})\

#define x_Minute \
({\
NSMutableArray *x_arr = NSMutableArray.array;\
NSInteger Time_00 = NSDate.date.Time_01-1;\
for (int index = 1; index <= series.count; index++) {\
    NSInteger begin = Time_00 + index*600;\
    [x_arr addObject:[NSDate timeStamp:begin dateFormat:FBDateFormatHm]];\
}\
x_arr;\
})\


@implementation FBLoadDataObject

#pragma mark - 请求历史数据（保存至数据库）｜Request Historical Data (Save to database)
/* 请求历史数据（保存至数据库）｜Request Historical Data (Save to database)
 * currentStep、currentCalories、currentDistance 今日实时数据（步数、卡路里、距离）
 * errorString    失败信息，为nil表示全部类型请求成功
 */
+ (void)requestHistoricalDataWithBlock:(void (^)(NSInteger, NSInteger, NSInteger, NSString * _Nullable))block {
    
    FBFirmwareVersionObject *object = FBAllConfigObject.firmwareConfig;
    
    /// 要查询的数据类型集合
    FB_MULTIPLERECORDREPORTS options = FB_CurrentDayActivityData | // 今日实时数据
    FB_HeartRateRecording | // 心率记录
    FB_StepCountRecord | // 步数记录
    FB_BloodOxygenRecording; // 血氧记录
    
    if (object.supportBloodPressure) {
        options = options | FB_BloodPressureRecording; // 血压记录
    }
    
    if (object.supportMentalStress) {
        options = options | FB_StressRecording; // 精神压力记录
    }
    
    options = options |
    FB_SleepStateRecording | // 睡眠记录
    FB_CurrentSleepStateRecording | // 实时睡眠记录（正在进行中的睡眠，已结束的睡眠会在通过 FB_SleepStateRecording 返回）
    FB_Sports_Statistics_Details_Report | // 运动记录
    FB_ManualMeasurementData; // 手动测量记录
    
    NSInteger staTime = [FBLoadDataObject getMinimumTime]; // 起始查询时间
    NSInteger endTime = NSDate.date.timeIntervalSince1970; // 结束查询时间
    
    __block NSMutableString *errorString = [NSMutableString stringWithString:@"🙅ERROR:"];
    __block NSInteger currentStep = 0;      // 当前累计步数｜Current cumulative steps
    __block NSInteger currentCalories = 0;  // 当前累计消耗卡路里（千卡）｜Current cumulative calories consumed (kcal)
    __block NSInteger currentDistance = 0;  // 当前累计行程（米）｜Current cumulative travel (m)
        
    [FBBgCommand.sharedInstance fbGetSpecialRecordsAndReportsDataWithType:options startTime:staTime forEndTime:endTime withBlock:^(FB_RET_CMD status, FB_MULTIPLERECORDREPORTS recordType, float progress, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (options == recordType && error) // 失败了
        {
            if (block) {
                [errorString appendFormat:@"\n%@", error.localizedDescription];
                block (0, 0, 0, errorString);
            }
        }
        
        else if (recordType == FB_CurrentDayActivityData) // 今日实时数据
        {
            if (error) { // 请求失败
                [errorString appendFormat:@"\nFB_CurrentDayActivityData: %@", error.localizedDescription];
                FBLog(@"今日实时数据请求失败: %@", error.localizedDescription);
            } else if (status == FB_DATATRANSMISSIONDONE) { // 请求成功
                FBCurrentDataModel *currentDataModel = (FBCurrentDataModel *)responseObject;
                
                // 今日实时数据（步数、卡路里、距离）
                currentStep = currentDataModel.currentStep;
                currentCalories = currentDataModel.currentCalories;
                currentDistance = currentDataModel.currentDistance;
            }
        }
        
        else if (recordType == FB_HeartRateRecording) // 心率记录
        {
            if (error) { // 请求失败
                [errorString appendFormat:@"\nFB_HeartRateRecording: %@", error.localizedDescription];
                FBLog(@"心率记录请求失败: %@", error.localizedDescription);
            } else if (status == FB_DATATRANSMISSIONDONE) { // 请求成功
                NSArray <FBTypeRecordModel *> *heartRateArray = (NSArray <FBTypeRecordModel *> *)responseObject;
                
                [FBLoadDataObject SaveHeartRateRecords:heartRateArray];
            }
        }
        
        else if (recordType == FB_StepCountRecord) // 步数记录
        {
            if (error) { // 请求失败
                [errorString appendFormat:@"\nFB_StepCountRecord: %@", error.localizedDescription];
                FBLog(@"步数记录请求失败: %@", error.localizedDescription);
            } else if (status == FB_DATATRANSMISSIONDONE) { // 请求成功
                NSArray <FBTypeRecordModel *> *stepArray = (NSArray <FBTypeRecordModel *> *)responseObject;
                
                [FBLoadDataObject SaveStepRecords:stepArray];
            }
        }
        
        else if (recordType == FB_BloodOxygenRecording) // 血氧记录
        {
            if (error) { // 请求失败
                [errorString appendFormat:@"\nFB_BloodOxygenRecording: %@", error.localizedDescription];
                FBLog(@"血氧记录请求失败: %@", error.localizedDescription);
            } else if (status == FB_DATATRANSMISSIONDONE) { // 请求成功
                NSArray <FBTypeRecordModel *> *bloodOxygenArray = (NSArray <FBTypeRecordModel *> *)responseObject;
                
                [FBLoadDataObject SaveBloodOxygenRecords:bloodOxygenArray];
            }
        }
        
        else if (recordType == FB_BloodPressureRecording) // 血压记录
        {
            if (error) { // 请求失败
                [errorString appendFormat:@"\nFB_BloodPressureRecording: %@", error.localizedDescription];
                FBLog(@"血压记录请求失败: %@", error.localizedDescription);
            } else if (status == FB_DATATRANSMISSIONDONE) { // 请求成功
                NSArray <FBTypeRecordModel *> *bloodPressureArray = (NSArray <FBTypeRecordModel *> *)responseObject;
                
                [FBLoadDataObject SaveBloodPressureRecords:bloodPressureArray];
            }
        }
        
        else if (recordType == FB_StressRecording) // 精神压力记录
        {
            if (error) { // 请求失败
                [errorString appendFormat:@"\nFB_StressRecording: %@", error.localizedDescription];
                FBLog(@"精神压力记录请求失败: %@", error.localizedDescription);
            } else if (status == FB_DATATRANSMISSIONDONE) { // 请求成功
                NSArray <FBTypeRecordModel *> *stressArray = (NSArray <FBTypeRecordModel *> *)responseObject;
                
                [FBLoadDataObject SaveStressRecords:stressArray];
            }
        }
        
        else if (recordType == FB_SleepStateRecording) // 睡眠记录
        {
            if (error) { // 请求失败
                [errorString appendFormat:@"\nFB_SleepStateRecording: %@", error.localizedDescription];
                FBLog(@"睡眠记录请求失败: %@", error.localizedDescription);
            } else if (status == FB_DATATRANSMISSIONDONE) { // 请求成功
                NSArray <FBSleepStatusRecordModel *> *sleepArray = (NSArray <FBSleepStatusRecordModel *> *)responseObject;
                
                [FBLoadDataObject SaveSleepRecords:sleepArray];
            }
        }
        
        else if (recordType == FB_CurrentSleepStateRecording) // // 实时睡眠记录（正在进行中的睡眠，已结束的睡眠会在通过 FB_SleepStateRecording 返回）
        {
            if (error) { // 请求失败
                [errorString appendFormat:@"\nFB_CurrentSleepStateRecording: %@", error.localizedDescription];
                FBLog(@"实时睡眠记录请求失败: %@", error.localizedDescription);
            } else if (status == FB_DATATRANSMISSIONDONE) { // 请求成功
                NSArray <FBSleepStatusRecordModel *> *sleepArray = (NSArray <FBSleepStatusRecordModel *> *)responseObject;

                [FBLoadDataObject SaveSleepRecords:sleepArray];
            }
        }
        
        else if (recordType == FB_Sports_Statistics_Details_Report) // 运动记录
        {
            if (error) { // 请求失败
                [errorString appendFormat:@"\nFB_Sports_Statistics_Details_Report: %@", error.localizedDescription];
                FBLog(@"运动记录请求失败: %@", error.localizedDescription);
            } else if (status == FB_DATATRANSMISSIONDONE) { // 请求成功
                NSArray <FBSportsStatisticsDetailsRecordModel *> *sportsArray = (NSArray <FBSportsStatisticsDetailsRecordModel *> *)responseObject;
                
                [FBLoadDataObject SaveSportsRecords:sportsArray];
            }
        }
        
        else if (recordType == FB_ManualMeasurementData) // 手动测量记录
        {
            if (error) { // 请求失败
                [errorString appendFormat:@"\nFB_ManualMeasurementData: %@", error.localizedDescription];
                FBLog(@"手动测量记录请求失败: %@", error.localizedDescription);
            } else if (status == FB_DATATRANSMISSIONDONE) { // 请求成功
                NSArray <FBManualMeasureDataModel *> *manualMeasureArray = (NSArray <FBManualMeasureDataModel *> *)responseObject;
                
                [FBLoadDataObject SaveManualMeasureRecords:manualMeasureArray];
            }
            
            if (error || status == FB_DATATRANSMISSIONDONE) { // 所有请求完成，结果回调
                
                if (block) {
                    block (currentStep, currentCalories, currentDistance, [errorString isEqualToString:@"🙅ERROR:"] ? nil : errorString);
                }
            }
        }
    }];
}

/// 最小时间
+ (NSInteger)getMinimumTime
 {
     FBFirmwareVersionObject *object = FBAllConfigObject.firmwareConfig;
     
     // 未避免重复请求，可以设置本地数据最小时间为起始时间
     NSMutableArray <NSNumber *> *begin = NSMutableArray.array;
     NSString *SQL = [FBLoadDataObject SQL_CurrentDevice_All];
     
     // 心率
     RLMHeartRateModel *hr = [[RLMHeartRateModel objectsWhere:SQL] sortedResultsUsingKeyPath:@"begin" ascending:YES].lastObject;
     [begin addObject:@(hr.begin)]; // 由小到大排序，最新一条数据
     
     // 计步
     RLMStepModel *step = [[RLMStepModel objectsWhere:SQL] sortedResultsUsingKeyPath:@"begin" ascending:YES].lastObject;
     [begin addObject:@(step.begin)]; // 由小到大排序，最新一条数据
     
     // 血氧
     RLMBloodOxygenModel *spo2 = [[RLMBloodOxygenModel objectsWhere:SQL] sortedResultsUsingKeyPath:@"begin" ascending:YES].lastObject;
     [begin addObject:@(spo2.begin)]; // 由小到大排序，最新一条数据
     
     // 血压
     if (object.supportBloodPressure) {
         RLMBloodPressureModel *bp = [[RLMBloodPressureModel objectsWhere:SQL] sortedResultsUsingKeyPath:@"begin" ascending:YES].lastObject; // 由小到大排序，最新一条数据
         [begin addObject:@(bp.begin)];
     }
     
     // 精神压力
     if (object.supportMentalStress) {
         RLMStressModel *stress = [[RLMStressModel objectsWhere:SQL] sortedResultsUsingKeyPath:@"begin" ascending:YES].lastObject;
         [begin addObject:@(stress.begin)]; // 由小到大排序，最新一条数据
     }
     
     // 睡眠
     RLMSleepModel *sleep = [[RLMSleepModel objectsWhere:SQL] sortedResultsUsingKeyPath:@"begin" ascending:YES].lastObject;
     [begin addObject:@(sleep.begin)]; // 由小到大排序，最新一条数据
     
     // 运动
     RLMSportsModel *sports = [[RLMSportsModel objectsWhere:SQL] sortedResultsUsingKeyPath:@"begin" ascending:YES].lastObject;
     [begin addObject:@(sports.begin)]; // 由小到大排序，最新一条数据
     
     // 手动测量
     RLMManualMeasureModel *manual = [[RLMManualMeasureModel objectsWhere:SQL] sortedResultsUsingKeyPath:@"begin" ascending:YES].lastObject; // 由小到大排序，最新一条数据
     [begin addObject:@(manual.begin)];
     
     // 取最小时间
     NSInteger staTime = [[begin valueForKeyPath:@"@min.floatValue"] floatValue];
     
     return staTime;
}


#pragma mark - ✅ 保存心率记录｜Save heart rate records
+ (void)SaveHeartRateRecords:(NSArray <FBTypeRecordModel *> *)heartRateArray {
    
    // 获取Realm对象
    RLMRealm *realm = [RLMRealm defaultRealm];
    // 开始写入事务
    [realm beginWriteTransaction];
    
    /* - - - ⬇️ - - - - - - - - - - - - - - - - - - - - - - - - 保存数据 - - - - - - - - - - - - - - - - - - - - - - - - ⬇️ - - - */
    for (FBTypeRecordModel *recordModel in heartRateArray) {
        
        if (recordModel.RecordType == FB_HeartRecord) {
            
            for (FBRecordDetailsModel *detailsModel in recordModel.recordArray) {
                
                if (detailsModel.hr > 0) {
                    
                    RLMHeartRateModel *item = RLMHeartRateModel.new;
                    item.begin = detailsModel.GMTtimeInterval;
                    item.heartRate = detailsModel.hr;
                    [item QuickSetup];
                    
                    [realm addOrUpdateObject:item];
                }
            }
        }
    }
    /* - - - ⬆️ - - - - - - - - - - - - - - - - - - - - - - - - 保存数据 - - - - - - - - - - - - - - - - - - - - - - - - ⬆️ - - - */
    
    //提交写入事务
    [realm commitWriteTransaction];
}


#pragma mark - ✅ 保存步数记录｜Save step count records
+ (void)SaveStepRecords:(NSArray <FBTypeRecordModel *> *)stepArray {
    
    // 获取Realm对象
    RLMRealm *realm = [RLMRealm defaultRealm];
    // 开始写入事务
    [realm beginWriteTransaction];
    
    /* - - - ⬇️ - - - - - - - - - - - - - - - - - - - - - - - - 保存数据 - - - - - - - - - - - - - - - - - - - - - - - - ⬇️ - - - */
    for (FBTypeRecordModel *recordModel in stepArray) {
        
        if (recordModel.RecordType == FB_StepRecord) {
            
            for (FBRecordDetailsModel *detailsModel in recordModel.recordArray) {
                
                if (detailsModel.step > 0) {
                    
                    RLMStepModel *item = RLMStepModel.new;
                    item.begin = detailsModel.GMTtimeInterval;
                    item.step = detailsModel.step;
                    [item QuickSetup];
                    
                    [realm addOrUpdateObject:item];
                }
            }
        }
    }
    /* - - - ⬆️ - - - - - - - - - - - - - - - - - - - - - - - - 保存数据 - - - - - - - - - - - - - - - - - - - - - - - - ⬆️ - - - */
    
    //提交写入事务
    [realm commitWriteTransaction];
}


#pragma mark - ✅ 保存血氧记录｜Save blood oxygen records
+ (void)SaveBloodOxygenRecords:(NSArray <FBTypeRecordModel *> *)bloodOxygenArray {
    
    // 获取Realm对象
    RLMRealm *realm = [RLMRealm defaultRealm];
    // 开始写入事务
    [realm beginWriteTransaction];
    
    /* - - - ⬇️ - - - - - - - - - - - - - - - - - - - - - - - - 保存数据 - - - - - - - - - - - - - - - - - - - - - - - - ⬇️ - - - */
    for (FBTypeRecordModel *recordModel in bloodOxygenArray) {
        
        if (recordModel.RecordType == FB_BloodOxyRecord) {
            
            for (FBRecordDetailsModel *detailsModel in recordModel.recordArray) {
                
                if (detailsModel.Sp02 > 0) {
                    
                    RLMBloodOxygenModel *item = RLMBloodOxygenModel.new;
                    item.begin = detailsModel.GMTtimeInterval;
                    item.bloodOxygen = detailsModel.Sp02;
                    [item QuickSetup];
                    
                    [realm addOrUpdateObject:item];
                }
            }
        }
    }
    /* - - - ⬆️ - - - - - - - - - - - - - - - - - - - - - - - - 保存数据 - - - - - - - - - - - - - - - - - - - - - - - - ⬆️ - - - */
    
    //提交写入事务
    [realm commitWriteTransaction];
}


#pragma mark - ✅ 保存血压记录｜Save blood pressure records
+ (void)SaveBloodPressureRecords:(NSArray <FBTypeRecordModel *> *)bloodPressureArray {
    
    // 获取Realm对象
    RLMRealm *realm = [RLMRealm defaultRealm];
    // 开始写入事务
    [realm beginWriteTransaction];
    
    /* - - - ⬇️ - - - - - - - - - - - - - - - - - - - - - - - - 保存数据 - - - - - - - - - - - - - - - - - - - - - - - - ⬇️ - - - */
    for (FBTypeRecordModel *recordModel in bloodPressureArray) {
        
        if (recordModel.RecordType == FB_BloodPreRecord) {
            
            for (FBRecordDetailsModel *detailsModel in recordModel.recordArray) {
                
                if (detailsModel.pb_max > 0 && detailsModel.pb_min > 0) {
                    
                    RLMBloodPressureModel *item = RLMBloodPressureModel.new;
                    item.begin = detailsModel.GMTtimeInterval;
                    item.systolic = detailsModel.pb_max;
                    item.diastolic = detailsModel.pb_min;
                    [item QuickSetup];
                    
                    [realm addOrUpdateObject:item];
                }
            }
        }
    }
    /* - - - ⬆️ - - - - - - - - - - - - - - - - - - - - - - - - 保存数据 - - - - - - - - - - - - - - - - - - - - - - - - ⬆️ - - - */
    
    //提交写入事务
    [realm commitWriteTransaction];
}


#pragma mark - ✅ 保存精神压力记录｜Keep a record of mental stress
+ (void)SaveStressRecords:(NSArray <FBTypeRecordModel *> *)stressArray {
    
    // 获取Realm对象
    RLMRealm *realm = [RLMRealm defaultRealm];
    // 开始写入事务
    [realm beginWriteTransaction];
    
    /* - - - ⬇️ - - - - - - - - - - - - - - - - - - - - - - - - 保存数据 - - - - - - - - - - - - - - - - - - - - - - - - ⬇️ - - - */
    for (FBTypeRecordModel *recordModel in stressArray) {
        
        if (recordModel.RecordType == FB_StressRecord) {
            
            for (FBRecordDetailsModel *detailsModel in recordModel.recordArray) {
                
                if (detailsModel.stress > 0) {
                    
                    RLMStressModel *item = RLMStressModel.new;
                    item.begin = detailsModel.GMTtimeInterval;
                    item.stress = detailsModel.stress;
                    item.StressRange = detailsModel.StressRange;
                    [item QuickSetup];
                    
                    [realm addOrUpdateObject:item];
                }
            }
        }
    }
    /* - - - ⬆️ - - - - - - - - - - - - - - - - - - - - - - - - 保存数据 - - - - - - - - - - - - - - - - - - - - - - - - ⬆️ - - - */
    
    //提交写入事务
    [realm commitWriteTransaction];
}


#pragma mark - ✅ 保存睡眠记录｜Save Sleep Record
+ (void)SaveSleepRecords:(NSArray <FBSleepStatusRecordModel *> *)sleepArray {
    
    // 获取Realm对象
    RLMRealm *realm = [RLMRealm defaultRealm];
    // 开始写入事务
    [realm beginWriteTransaction];
    
    /* - - - ⬇️ - - - - - - - - - - - - - - - - - - - - - - - - 保存数据 - - - - - - - - - - - - - - - - - - - - - - - - ⬇️ - - - */
    for (FBSleepStatusRecordModel *recordModel in sleepArray) {
        
        // 夜间睡眠
        for (FBSleepStateModel *nightSleepModel in recordModel.sleepStateArray) {
            
            if (nightSleepModel.durationSleepTime > 0) {
                
                RLMSleepModel *item = RLMSleepModel.new;
                item.begin = nightSleepModel.startStatusGMT;
                item.end = nightSleepModel.endStatusGMT;
                item.duration = nightSleepModel.durationSleepTime;
                item.SleepState = (RLMSLEEPSTATE)nightSleepModel.SleepStatus;
                [item QuickSetup];
                
                [realm addOrUpdateObject:item];
            }
        }
        
        // 零星小睡
        for (FBSleepStateModel *napSleepModel in recordModel.napStateArray) {
            
            if (napSleepModel.durationSleepTime > 0) {
                
                RLMSleepModel *item = RLMSleepModel.new;
                item.begin = napSleepModel.startStatusGMT;
                item.end = napSleepModel.endStatusGMT;
                item.duration = napSleepModel.durationSleepTime;
                [item QuickSetup];
                
                if (napSleepModel.SleepStatus == Awake_state) {
                    item.SleepState = RLM_Nap_Awake; // 零星小睡 (清醒)
                } else {
                    item.SleepState = RLM_Nap; // 零星小睡
                }
                
                [realm addOrUpdateObject:item];
            }
        }
    }
    /* - - - ⬆️ - - - - - - - - - - - - - - - - - - - - - - - - 保存数据 - - - - - - - - - - - - - - - - - - - - - - - - ⬆️ - - - */
    
    //提交写入事务
    [realm commitWriteTransaction];
}


#pragma mark - ✅ 保存运动记录｜Save exercise records
+ (void)SaveSportsRecords:(NSArray <FBSportsStatisticsDetailsRecordModel *> *)sportsArray {
    
    // 获取Realm对象
    RLMRealm *realm = [RLMRealm defaultRealm];
    // 开始写入事务
    [realm beginWriteTransaction];
    
    /* - - - ⬇️ - - - - - - - - - - - - - - - - - - - - - - - - 保存数据 - - - - - - - - - - - - - - - - - - - - - - - - ⬇️ - - - */
    for (FBSportsStatisticsDetailsRecordModel *recordModel in sportsArray) {
        
        FBSportCaculateModel *caculateModel = recordModel.sportsStatisticsRecord;
        
        RLMSportsModel *model = RLMSportsModel.new;
        model.begin = caculateModel.startSportTime;
        model.end = caculateModel.endSportTime;
        model.duration = caculateModel.totalSportTime;
        model.step = caculateModel.totalSteps;
        model.calorie = caculateModel.totalCalories;
        model.distance = caculateModel.totalDistance;
        model.MotionMode = caculateModel.MotionMode;
        model.maxHeartRate = caculateModel.maxHeartRate;
        model.minHeartRate = caculateModel.minHeartRate;
        model.avgHeartRate = caculateModel.avgHeartRate;
        model.maxStride = caculateModel.maxStride;
        model.avgStride = caculateModel.avgStride;
        
        model.heartRate_level_1 = caculateModel.heartRate_level_1;
        model.heartRate_level_2 = caculateModel.heartRate_level_2;
        model.heartRate_level_3 = caculateModel.heartRate_level_3;
        model.heartRate_level_4 = caculateModel.heartRate_level_4;
        model.heartRate_level_5 = caculateModel.heartRate_level_5;
        
        for (FBRecordDetailsModel *detailsModel in recordModel.sportsDetailsRecord) { // 详细
            
            RLMSportsItemModel *item = RLMSportsItemModel.new;
            item.begin = detailsModel.GMTtimeInterval;
            item.step = detailsModel.stepFrequency;
            item.distance = detailsModel.distance;
            item.calorie = detailsModel.calories;
            item.pace = detailsModel.pace;
            item.heartRate = detailsModel.heartRate;
            if (detailsModel.recordDefinition == 0) {
                // NSInteger stamina;
                // BOOL isSuspend;
            } else if (detailsModel.recordDefinition==1) {
                item.KilometerPace = detailsModel.KilometerPace;
                item.MilePace = detailsModel.MilePace;
            }
            
            [model.items addObject:item];
        }
        
        [model QuickSetup];
        [realm addOrUpdateObject:model];
    }
    /* - - - ⬆️ - - - - - - - - - - - - - - - - - - - - - - - - 保存数据 - - - - - - - - - - - - - - - - - - - - - - - - ⬆️ - - - */
    
    //提交写入事务
    [realm commitWriteTransaction];
}


#pragma mark - ✅ 保存手动测量记录｜Save manual measurement records
+ (void)SaveManualMeasureRecords:(NSArray <FBManualMeasureDataModel *> *)manualMeasureArray {
    
    // 获取Realm对象
    RLMRealm *realm = [RLMRealm defaultRealm];
    // 开始写入事务
    [realm beginWriteTransaction];
    
    /* - - - ⬇️ - - - - - - - - - - - - - - - - - - - - - - - - 保存数据 - - - - - - - - - - - - - - - - - - - - - - - - ⬇️ - - - */
    for (FBManualMeasureDataModel *recordModel in manualMeasureArray) {
        
        RLMManualMeasureModel *item = RLMManualMeasureModel.new;
        item.begin = recordModel.GMTtimeInterval;
        item.hr = recordModel.hr;
        item.Sp02 = recordModel.Sp02;
        item.systolic = recordModel.pb_max;
        item.diastolic = recordModel.pb_min;
        item.stress = recordModel.stress;
        item.StressRange = recordModel.StressRange;
        [item QuickSetup];
        
        [realm addOrUpdateObject:item];
    }
    /* - - - ⬆️ - - - - - - - - - - - - - - - - - - - - - - - - 保存数据 - - - - - - - - - - - - - - - - - - - - - - - - ⬆️ - - - */
    
    //提交写入事务
    [realm commitWriteTransaction];
}


#pragma mark - 数据库查询条件 - 指定起始/结束/设备名称/设备mac地址
+ (NSString *)SQL_StaTime:(NSInteger)staTime endTime:(NSInteger)endTime deviceName:(NSString *)deviceName deviceMAC:(NSString *)deviceMAC {
    
    NSString *SQL = [NSString stringWithFormat:@"begin >= %zd AND begin <= %zd AND deviceName = '%@' AND deviceMAC = '%@'", staTime, endTime, deviceName, deviceMAC];
    
    return SQL;
}


#pragma mark - 数据库查询条件 - 指定当前设备名称/当前设备mac地址
+ (NSString *)SQL_CurrentDevice_All {
    
    FBFirmwareVersionObject *object = FBAllConfigObject.firmwareConfig;

    NSString *SQL = [NSString stringWithFormat:@"deviceName = '%@' AND deviceMAC = '%@'", object.deviceName, object.mac];
    
    return SQL;
}


#pragma mark - ❌ 查询所有数据的日期，日历事件着色用
+ (NSArray <NSString *>  * _Nullable)QueryAllRecordWithDataType:(FBTestUIDataType)dataType dateFormat:(FBDateFormat)dateFormat deviceName:(NSString *)deviceName deviceMAC:(NSString *)deviceMAC {
    
    NSMutableArray <NSString *> *dataStringArray = NSMutableArray.array;
    NSString *SQL = [NSString stringWithFormat:@"deviceName = '%@' AND deviceMAC = '%@'", deviceName, deviceMAC];
    
    if (dataType == FBTestUIDataType_Step) { // 步数
        
        RLMResults *results = [RLMStepModel objectsWhere:SQL];
        for (RLMStepModel *model in results) {
            if (model.step > 0) {
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.begin];
                NSInteger begin = date.Time_01-1 == model.begin ? model.begin-1 : model.begin; // 00:00整点的数据为昨天的
                [dataStringArray addObject:[NSDate timeStamp:begin dateFormat:dateFormat]];
            }
        }
    }
    else if (dataType == FBTestUIDataType_HeartRate) { // 心率
        
        // 自动数据
        RLMResults *results = [RLMHeartRateModel objectsWhere:SQL];
        for (RLMHeartRateModel *model in results) {
            if (model.heartRate > 0) {
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.begin];
                NSInteger begin = date.Time_01-1 == model.begin ? model.begin-1 : model.begin; // 00:00整点的数据为昨天的
                [dataStringArray addObject:[NSDate timeStamp:begin dateFormat:dateFormat]];
            }
        }
        
        // 手动测量数据
        RLMResults *m_Results = [FBLoadDataObject QueryManualMeasurementRecordWithDate:nil dataType:FBTestUIDataType_HeartRate deviceName:deviceName deviceMAC:deviceMAC];
        for (RLMManualMeasureModel *model in m_Results) {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.begin];
            NSInteger begin = date.Time_01-1 == model.begin ? model.begin-1 : model.begin; // 00:00整点的数据为昨天的
            [dataStringArray addObject:[NSDate timeStamp:begin dateFormat:dateFormat]];
        }
    }
    else if (dataType == FBTestUIDataType_BloodOxygen) { // 血氧
        
        // 自动数据
        RLMResults *results = [RLMBloodOxygenModel objectsWhere:SQL];
        for (RLMBloodOxygenModel *model in results) {
            if (model.bloodOxygen > 0) {
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.begin];
                NSInteger begin = date.Time_01-1 == model.begin ? model.begin-1 : model.begin; // 00:00整点的数据为昨天的
                [dataStringArray addObject:[NSDate timeStamp:begin dateFormat:dateFormat]];
            }
        }
        
        // 手动测量数据
        RLMResults *m_Results = [FBLoadDataObject QueryManualMeasurementRecordWithDate:nil dataType:FBTestUIDataType_BloodOxygen deviceName:deviceName deviceMAC:deviceMAC];
        for (RLMManualMeasureModel *model in m_Results) {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.begin];
            NSInteger begin = date.Time_01-1 == model.begin ? model.begin-1 : model.begin; // 00:00整点的数据为昨天的
            [dataStringArray addObject:[NSDate timeStamp:begin dateFormat:dateFormat]];
        }
    }
    else if (dataType == FBTestUIDataType_BloodPressure) { // 血压
        
        // 自动数据
        RLMResults *results = [RLMBloodPressureModel objectsWhere:SQL];
        for (RLMBloodPressureModel *model in results) {
            if (model.systolic > 0 && model.diastolic > 0) {
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.begin];
                NSInteger begin = date.Time_01-1 == model.begin ? model.begin-1 : model.begin; // 00:00整点的数据为昨天的
                [dataStringArray addObject:[NSDate timeStamp:begin dateFormat:dateFormat]];
            }
        }
        
        // 手动测量数据
        RLMResults *m_Results = [FBLoadDataObject QueryManualMeasurementRecordWithDate:nil dataType:FBTestUIDataType_BloodPressure deviceName:deviceName deviceMAC:deviceMAC];
        for (RLMManualMeasureModel *model in m_Results) {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.begin];
            NSInteger begin = date.Time_01-1 == model.begin ? model.begin-1 : model.begin; // 00:00整点的数据为昨天的
            [dataStringArray addObject:[NSDate timeStamp:begin dateFormat:dateFormat]];
        }
    }
    else if (dataType == FBTestUIDataType_Stress) { // 精神压力
        
        // 自动数据
        RLMResults *results = [RLMStressModel objectsWhere:SQL];
        for (RLMStressModel *model in results) {
            if (model.stress > 0) {
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.begin];
                NSInteger begin = date.Time_01-1 == model.begin ? model.begin-1 : model.begin; // 00:00整点的数据为昨天的
                [dataStringArray addObject:[NSDate timeStamp:begin dateFormat:dateFormat]];
            }
        }
        
        // 手动测量数据
        RLMResults *m_Results = [FBLoadDataObject QueryManualMeasurementRecordWithDate:nil dataType:FBTestUIDataType_Stress deviceName:deviceName deviceMAC:deviceMAC];
        for (RLMManualMeasureModel *model in m_Results) {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.begin];
            NSInteger begin = date.Time_01-1 == model.begin ? model.begin-1 : model.begin; // 00:00整点的数据为昨天的
            [dataStringArray addObject:[NSDate timeStamp:begin dateFormat:dateFormat]];
        }
    }
    else if (dataType == FBTestUIDataType_Sleep) { // 睡眠
        
        RLMResults *results = [RLMSleepModel objectsWhere:SQL];
        for (RLMSleepModel *model in results) {
            if (model.SleepState != RLM_Awake && model.SleepState != RLM_Nap_Awake) {
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.begin];
                // 比如 2023-05-12 21:30 至 2023-05-13 21:29 的数据，它是属于 2023-05-13 的睡眠数据
                // 所以这里 2023-05-12 21:30 至 2023-05-13 00:00 之间的睡眠时间，都算是隔天的睡眠数据
                if (model.begin >= (date.Time_24-2.5*3600) && model.begin < date.Time_24) {
                    date = [NSDate dateWithTimeIntervalSince1970:(date.Time_24+2)];
                }
                [dataStringArray addObject:[NSDate timeStamp:date.timeIntervalSince1970 dateFormat:dateFormat]];
            }
        }
    }
    else if (dataType == FBTestUIDataType_Sports) { // 运动
        
        RLMResults *results = [RLMSportsModel objectsWhere:SQL];
        for (RLMSportsModel *model in results) {
            [dataStringArray addObject:[NSDate timeStamp:model.begin dateFormat:dateFormat]];
        }
    }
    
    // 多个相同元素的合并为一个
    NSArray *array = [dataStringArray valueForKeyPath:@"@distinctUnionOfObjects.self"];
    
    return array;
}


#pragma mark - ❌ 查询某一数据类型、某一天的数据｜Query data of a certain data type and day
+ (FBTestUIBaseListModel *)QueryAllDataWithDate:(NSDate *)queryDate dataType:(FBTestUIDataType)dataType deviceName:(NSString *)deviceName deviceMAC:(NSString *)deviceMAC {
    
    FBTestUIBaseListModel *baseListModel = FBTestUIBaseListModel.new;
    baseListModel.dataType = dataType;
    
    if (dataType == FBTestUIDataType_Step) { // 步数
        
        NSArray <NSNumber *> *array = [FBLoadDataObject QueryStepCountRecordWithDate:queryDate deviceName:deviceName deviceMAC:deviceMAC];
        
        AAChartModel *aaChartModel = [FBLoadDataObject step_aaChartModel:array];
        AAOptions *aaOptions = [FBLoadDataObject step_aaOptions:aaChartModel series:array];
        
        baseListModel.aaChartModel = aaChartModel;
        baseListModel.aaOptions = aaOptions;
    }
    
    else if (dataType == FBTestUIDataType_HeartRate) { // 心率
        
        NSArray <NSNumber *> *array = [FBLoadDataObject QueryHeartRateCountRecordWithDate:queryDate deviceName:deviceName deviceMAC:deviceMAC];
        
        NSMutableArray <FBTestUIBaseListSection *> *sectionArray = NSMutableArray.array;
        
        // 概览
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSNumber * _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            return (evaluatedObject.integerValue != 0);
        }];
        NSArray *filteredArray = [array filteredArrayUsingPredicate:predicate]; // 过滤0
        NSInteger avg = [Tools ConvertValues:[[filteredArray valueForKeyPath:@"@avg.floatValue"] floatValue] scale:0 rounding:YES].integerValue; // 平均
        NSInteger max = [[filteredArray valueForKeyPath:@"@max.floatValue"] integerValue]; // 最大
        NSInteger min = [[filteredArray valueForKeyPath:@"@min.floatValue"] integerValue]; // 最小
        if (filteredArray.count) {
            FBTestUIBaseListSection *section = FBTestUIBaseListSection.new;
            section.title = LWLocalizbleString(@"Today's Overview");
            section.overviewArray = @[
                [[FBTestUIOverviewModel alloc] initWithTitle:LWLocalizbleString(@"Average Heart Rate") value:[Tools stringValue:avg]],
                [[FBTestUIOverviewModel alloc] initWithTitle:LWLocalizbleString(@"Maximum Heart Rate") value:[Tools stringValue:max]],
                [[FBTestUIOverviewModel alloc] initWithTitle:LWLocalizbleString(@"Minimum Heart Rate") value:[Tools stringValue:min]]
            ];
            [sectionArray addObject:section];
        }
        
        // 手动数据
        NSMutableArray *manualOverviewArray = NSMutableArray.array;
        RLMResults <RLMManualMeasureModel *> *m_Results = [FBLoadDataObject QueryManualMeasurementRecordWithDate:queryDate dataType:FBTestUIDataType_HeartRate deviceName:deviceName deviceMAC:deviceMAC];
        for (RLMManualMeasureModel *item in m_Results) {
            FBTestUIOverviewModel *overviewModel = [[FBTestUIOverviewModel alloc] initWithTitle:[NSDate timeStamp:item.begin dateFormat:FBDateFormatHm] value:[Tools stringValue:item.hr]];
            [manualOverviewArray addObject:overviewModel];
        }
        if (manualOverviewArray.count) {
            FBTestUIBaseListSection *section = FBTestUIBaseListSection.new;
            section.title = LWLocalizbleString(@"Manual Measurement Data");
            section.overviewArray = manualOverviewArray;
            
            [sectionArray addObject:section];
        }
        
        // 自动数据
        AAChartModel *aaChartModel = [FBLoadDataObject heartRate_aaChartModel:array];
        AAOptions *aaOptions = [FBLoadDataObject heartRate_aaOptions:aaChartModel series:array];
        
        baseListModel.aaChartModel = aaChartModel;
        baseListModel.aaOptions = aaOptions;
        baseListModel.section = sectionArray;
    }
    
    else if (dataType == FBTestUIDataType_BloodOxygen) { // 血氧
        
        NSArray <NSNumber *> *array = [FBLoadDataObject QueryBloodOxygenCountRecordWithDate:queryDate deviceName:deviceName deviceMAC:deviceMAC];
        
        NSMutableArray <FBTestUIBaseListSection *> *sectionArray = NSMutableArray.array;
        
        // 概览
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSNumber * _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            return (evaluatedObject.integerValue != 0);
        }];
        NSArray *filteredArray = [array filteredArrayUsingPredicate:predicate]; // 过滤0
        NSInteger avg = [Tools ConvertValues:[[filteredArray valueForKeyPath:@"@avg.floatValue"] floatValue] scale:0 rounding:YES].integerValue; // 平均
        NSInteger max = [[filteredArray valueForKeyPath:@"@max.floatValue"] integerValue]; // 最大
        NSInteger min = [[filteredArray valueForKeyPath:@"@min.floatValue"] integerValue]; // 最小
        if (filteredArray.count) {
            FBTestUIBaseListSection *section = FBTestUIBaseListSection.new;
            section.title = LWLocalizbleString(@"Today's Overview");
            section.overviewArray = @[
                [[FBTestUIOverviewModel alloc] initWithTitle:LWLocalizbleString(@"Average Blood Oxygen") value:[Tools stringValue:avg]],
                [[FBTestUIOverviewModel alloc] initWithTitle:LWLocalizbleString(@"Maximum Blood Oxygen") value:[Tools stringValue:max]],
                [[FBTestUIOverviewModel alloc] initWithTitle:LWLocalizbleString(@"Minimum Blood Oxygen") value:[Tools stringValue:min]]
            ];
            [sectionArray addObject:section];
        }
        
        // 手动数据
        NSMutableArray *manualOverviewArray = NSMutableArray.array;
        RLMResults <RLMManualMeasureModel *> *m_Results = [FBLoadDataObject QueryManualMeasurementRecordWithDate:queryDate dataType:FBTestUIDataType_BloodOxygen deviceName:deviceName deviceMAC:deviceMAC];
        for (RLMManualMeasureModel *item in m_Results) {
            FBTestUIOverviewModel *overviewModel = [[FBTestUIOverviewModel alloc] initWithTitle:[NSDate timeStamp:item.begin dateFormat:FBDateFormatHm] value:[Tools stringValue:item.Sp02]];
            [manualOverviewArray addObject:overviewModel];
        }
        if (manualOverviewArray.count) {
            FBTestUIBaseListSection *section = FBTestUIBaseListSection.new;
            section.title = LWLocalizbleString(@"Manual Measurement Data");
            section.overviewArray = manualOverviewArray;
            
            [sectionArray addObject:section];
        }
        
        // 自动数据
        AAChartModel *aaChartModel = [FBLoadDataObject bloodOxygen_aaChartModel:array];
        AAOptions *aaOptions = [FBLoadDataObject bloodOxygen_aaOptions:aaChartModel series:array];
        
        baseListModel.aaChartModel = aaChartModel;
        baseListModel.aaOptions = aaOptions;
        baseListModel.section = sectionArray;
    }
    
    else if (dataType == FBTestUIDataType_Stress) { // 压力
        
        NSArray <FBStressItem *> *array = [FBLoadDataObject QueryMentalStressCountRecordWithDate:queryDate deviceName:deviceName deviceMAC:deviceMAC];
        
        NSMutableArray <FBTestUIBaseListSection *> *sectionArray = NSMutableArray.array;
        
        // 概览
        NSMutableArray <NSNumber *> *filteredArray = NSMutableArray.array;
        for (FBStressItem *item in array) {
            if (item.stress > 0) {
                [filteredArray addObject:@(item.stress)];
            }
        }
        NSInteger avg = [Tools ConvertValues:[[filteredArray valueForKeyPath:@"@avg.floatValue"] floatValue] scale:0 rounding:YES].integerValue; // 平均
        NSInteger max = [[filteredArray valueForKeyPath:@"@max.floatValue"] integerValue]; // 最大
        NSInteger min = [[filteredArray valueForKeyPath:@"@min.floatValue"] integerValue]; // 最小
        if (filteredArray.count) {
            FBTestUIBaseListSection *section = FBTestUIBaseListSection.new;
            section.title = LWLocalizbleString(@"Today's Overview");
            section.overviewArray = @[
                [[FBTestUIOverviewModel alloc] initWithTitle:LWLocalizbleString(@"Average Stress") value:[Tools stringValue:avg]],
                [[FBTestUIOverviewModel alloc] initWithTitle:LWLocalizbleString(@"Maximum Stress") value:[Tools stringValue:max]],
                [[FBTestUIOverviewModel alloc] initWithTitle:LWLocalizbleString(@"Minimum Stress") value:[Tools stringValue:min]]
            ];
            [sectionArray addObject:section];
        }
        
        // 手动数据
        NSMutableArray *manualOverviewArray = NSMutableArray.array;
        RLMResults <RLMManualMeasureModel *> *m_Results = [FBLoadDataObject QueryManualMeasurementRecordWithDate:queryDate dataType:FBTestUIDataType_Stress deviceName:deviceName deviceMAC:deviceMAC];
        for (RLMManualMeasureModel *item in m_Results) {
            FBTestUIOverviewModel *overviewModel = [[FBTestUIOverviewModel alloc] initWithTitle:[NSDate timeStamp:item.begin dateFormat:FBDateFormatHm] value:[Tools stringValue:item.stress]];
            [manualOverviewArray addObject:overviewModel];
        }
        if (manualOverviewArray.count) {
            FBTestUIBaseListSection *section = FBTestUIBaseListSection.new;
            section.title = LWLocalizbleString(@"Manual Measurement Data");
            section.overviewArray = manualOverviewArray;
            
            [sectionArray addObject:section];
        }
        
        // 自动数据
        AAChartModel *aaChartModel = [FBLoadDataObject mentalStress_aaChartModel:array];
        AAOptions *aaOptions = [FBLoadDataObject mentalStress_aaOptions:aaChartModel series:array];
        
        baseListModel.aaChartModel = aaChartModel;
        baseListModel.aaOptions = aaOptions;
        baseListModel.section = sectionArray;
    }
    
    else if (dataType == FBTestUIDataType_Sleep) { // 睡眠
        
        NSArray <FBSleepItem *> *array = [FBLoadDataObject QuerySleepCountRecordWithDate:queryDate deviceName:deviceName deviceMAC:deviceMAC];
        
        NSMutableArray <FBTestUIBaseListSection *> *sectionArray = NSMutableArray.array;
        
        // 概览
        NSInteger totalSleep = 0; // 睡眠总时长
        NSInteger deepSleep  = 0; // 深睡时长
        NSInteger lightSleep = 0; // 浅睡时长
        NSInteger REMSleep   = 0; // 眼动时长
        NSInteger awakeSleep = 0; // 清醒时长
        NSInteger napSleep   = 0; // 小睡时长
        for (FBSleepItem *item in array) {
            if (item.SleepState == RLM_Awake) {
                awakeSleep += item.duration;
            }
            else if (item.SleepState == RLM_Shallow) {
                lightSleep += item.duration;
            }
            else if (item.SleepState == RLM_Deep) {
                deepSleep += item.duration;
            }
            else if (item.SleepState == RLM_REM) {
                REMSleep += item.duration;
            }
            else if (item.SleepState == RLM_Nap) {
                napSleep += item.duration;
            }
            
            if (item.SleepState != RLM_Awake && item.SleepState != RLM_Nap_Awake) {
                totalSleep += item.duration;
            }
        }
        
        if (totalSleep > 0) {
            FBTestUIBaseListSection *section = FBTestUIBaseListSection.new;
            section.title = LWLocalizbleString(@"Today's Overview");
            section.overviewArray = @[
                [[FBTestUIOverviewModel alloc] initWithTitle:LWLocalizbleString(@"Total Sleep Time") value:[Tools HM:totalSleep*60]],
                [[FBTestUIOverviewModel alloc] initWithTitle:LWLocalizbleString(@"Deep Sleep") value:[Tools HM:deepSleep*60]],
                [[FBTestUIOverviewModel alloc] initWithTitle:LWLocalizbleString(@"Light Sleep") value:[Tools HM:lightSleep*60]],
                [[FBTestUIOverviewModel alloc] initWithTitle:LWLocalizbleString(@"REM") value:[Tools HM:REMSleep*60]],
                [[FBTestUIOverviewModel alloc] initWithTitle:LWLocalizbleString(@"Awake") value:[Tools HM:awakeSleep*60]],
                [[FBTestUIOverviewModel alloc] initWithTitle:LWLocalizbleString(@"Nap") value:[Tools HM:napSleep*60]]
            ];
            [sectionArray addObject:section];
        }
        
        // 自动数据
        AAChartModel *aaChartModel = [FBLoadDataObject sleep_aaChartModel:array];
        AAOptions *aaOptions = [FBLoadDataObject sleep_aaOptions:aaChartModel series:array];
        
        baseListModel.aaChartModel = aaChartModel;
        baseListModel.aaOptions = aaOptions;
        baseListModel.section = sectionArray;
    }
    
    else if (dataType == FBTestUIDataType_BloodPressure) { // 血压
        
        NSArray <FBBpItem *> *array = [FBLoadDataObject QueryBloodPressureCountRecordWithDate:queryDate deviceName:deviceName deviceMAC:deviceMAC];
        
        NSMutableArray <FBTestUIBaseListSection *> *sectionArray = NSMutableArray.array;
        
        // 概览
        NSMutableArray <NSNumber *> *filteredArray_s = NSMutableArray.array;
        NSMutableArray <NSNumber *> *filteredArray_d = NSMutableArray.array;
        for (FBBpItem *item in array) {
            if (item.bp_s > 0 && item.bp_d > 0) {
                [filteredArray_s addObject:@(item.bp_s)];
                [filteredArray_d addObject:@(item.bp_d)];
            }
        }
        NSInteger avg_s = [Tools ConvertValues:[[filteredArray_s valueForKeyPath:@"@avg.floatValue"] floatValue] scale:0 rounding:YES].integerValue; // 平均
        NSInteger avg_d = [Tools ConvertValues:[[filteredArray_d valueForKeyPath:@"@avg.floatValue"] floatValue] scale:0 rounding:YES].integerValue; // 平均
        NSInteger max_index = [filteredArray_s indexOfObject:[filteredArray_s valueForKeyPath:@"@max.floatValue"]];
        NSInteger min_index = [filteredArray_s indexOfObject:[filteredArray_s valueForKeyPath:@"@min.floatValue"]];

        if (filteredArray_s.count && filteredArray_d.count) {
            FBTestUIBaseListSection *section = FBTestUIBaseListSection.new;
            section.title = LWLocalizbleString(@"Today's Overview");
            section.overviewArray = @[
                [[FBTestUIOverviewModel alloc] initWithTitle:LWLocalizbleString(@"Average Blood Pressure") value:[NSString stringWithFormat:@"%@/%@", [Tools stringValue:avg_s], [Tools stringValue:avg_d]]],
                [[FBTestUIOverviewModel alloc] initWithTitle:LWLocalizbleString(@"Highest Blood Pressure") value:[NSString stringWithFormat:@"%@/%@", [Tools stringValue:filteredArray_s[max_index].integerValue], [Tools stringValue:filteredArray_d[max_index].integerValue]]],
                [[FBTestUIOverviewModel alloc] initWithTitle:LWLocalizbleString(@"Minimum Blood Pressure") value:[NSString stringWithFormat:@"%@/%@", [Tools stringValue:filteredArray_s[min_index].integerValue], [Tools stringValue:filteredArray_d[min_index].integerValue]]]
            ];
            [sectionArray addObject:section];
        }
        
        // 手动数据
        NSMutableArray *manualOverviewArray = NSMutableArray.array;
        RLMResults <RLMManualMeasureModel *> *m_Results = [FBLoadDataObject QueryManualMeasurementRecordWithDate:queryDate dataType:FBTestUIDataType_BloodPressure deviceName:deviceName deviceMAC:deviceMAC];
        for (RLMManualMeasureModel *item in m_Results) {
            FBTestUIOverviewModel *overviewModel = [[FBTestUIOverviewModel alloc] initWithTitle:[NSDate timeStamp:item.begin dateFormat:FBDateFormatHm] value:[NSString stringWithFormat:@"%@/%@", [Tools stringValue:item.systolic], [Tools stringValue:item.diastolic]]];
            [manualOverviewArray addObject:overviewModel];
        }
        if (manualOverviewArray.count) {
            FBTestUIBaseListSection *section = FBTestUIBaseListSection.new;
            section.title = LWLocalizbleString(@"Manual Measurement Data");
            section.overviewArray = manualOverviewArray;
            
            [sectionArray addObject:section];
        }
        
        // 自动数据
        AAChartModel *aaChartModel = [FBLoadDataObject bloodPressure_aaChartModel:array];
        AAOptions *aaOptions = [FBLoadDataObject bloodPressure_aaOptions:aaChartModel series:array];
        
        baseListModel.aaChartModel = aaChartModel;
        baseListModel.aaOptions = aaOptions;
        baseListModel.section = sectionArray;
    }
    
    else if (dataType == FBTestUIDataType_Sports) { // 运动
        NSArray <RLMSportsModel *> *array = [FBLoadDataObject QueryExerciseRecordWithDate:queryDate deviceName:deviceName deviceMAC:deviceMAC];
        
        baseListModel.sportsArray = array;
    }
    
    return baseListModel;
}


#pragma mark - ❌ 查询某一天的步数记录｜Query the step count record of a certain day
+ (NSArray <NSNumber *> *)QueryStepCountRecordWithDate:(NSDate *)queryDate deviceName:(NSString *)deviceName deviceMAC:(NSString *)deviceMAC {
    
    NSInteger staTime = queryDate.Time_01;
    NSInteger endTime = queryDate.Time_24;
    
    NSString *SQL = [FBLoadDataObject SQL_StaTime:staTime endTime:endTime deviceName:deviceName deviceMAC:deviceMAC];
    
    RLMResults *stepArray = [[RLMStepModel objectsWhere:SQL] sortedResultsUsingKeyPath:@"begin" ascending:YES]; // 对查询结果排序
    
    NSMutableArray <FBStepItem *> *allArray = NSMutableArray.array;
    NSInteger totalSteps = 0;
    for (RLMStepModel *stepModel in stepArray) {

        // 由于是步数累加数据，这里需要计算步数差，得到每个时间段产生的步数
        NSInteger steps = totalSteps==0 ? stepModel.step : (stepModel.step - totalSteps);

        if (steps > 0) {
            totalSteps += steps;
            
            FBStepItem *model = FBStepItem.new;
            model.begin = stepModel.begin;
            model.step = steps;

            [allArray addObject:model];
        }
    }

    NSMutableArray <NSNumber *> *array = NSMutableArray.array;

    for (NSInteger time = (staTime-1); time < endTime; time+=3600) { // 24小时，一小时一笔数据

        // 构建 00:00-01:00、01:00-02:00、02:00-03:00 ... 每个小时的步数
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"begin > %ld && begin <= %ld", time, time+3600];
        NSArray <FBStepItem *> *hourArray = [allArray filteredArrayUsingPredicate:predicate];

        NSInteger step = 0;
        for (FBStepItem *itemModel in hourArray) {
            step += itemModel.step;
        }

        [array addObject:@(step)];
    }

    return array;
}

+ (AAChartModel *)step_aaChartModel:(NSArray <NSNumber *> *)array {
    
    NSInteger step = 0;
    NSMutableArray *dataSet = NSMutableArray.array;
    for (NSNumber *number in array) {
        [dataSet addObject:number.integerValue<=0 ? [NSNull null] : number];
        step += number.integerValue;
    }
        
    AAChartModel *aaChartModel = AAChartModel.new
        .chartTypeSet(AAChartTypeColumn)
        .animationTypeSet(AAChartAnimationBounce)
        .stackingSet(AAChartStackingTypeNormal)
        .tooltipSharedSet(YES)
        .titleSet([NSString stringWithFormat:@"%ld", step])
        .titleStyleSet(AAStyle.new
                       .colorSet(AAColor.blackColor)
                       .fontSizeSet(@"30")
                       .fontWeightSet(@"bold"))
        .yAxisGridLineStyleSet([AALineStyle styleWithColor:AAColor.lightGrayColor dashStyle:AAChartLineDashStyleTypeLongDashDot])
        .subtitleSet(LWLocalizbleString(@"Total Steps"))
        .colorsThemeSet(@[HEX_STR_COLOR(BlueColor)])
        .xAxisTickIntervalSet(@4)
        .categoriesSet(x_Categories_1)
        .seriesSet(@[
            AASeriesElement.new
                .nameSet(LWLocalizbleString(@"Step"))
                .borderRadiusTopLeftSet((id)@"50%")
                .borderRadiusTopRightSet((id)@"50%")
                .dataSet(dataSet)
        ]);
    if (step == 0) {
        aaChartModel.yAxisMaxSet(@200);
    }
    
    return aaChartModel;
}

+ (AAOptions *)step_aaOptions:(AAChartModel *)aaChartModel series:(NSArray *)series {
            
    NSArray *arr = @[LWLocalizbleString(@"Step")];
    
    NSString *x_JS = [x_Hour aa_toJSArray];
    NSString *y_JS = [series aa_toJSArray];
    NSString *unit_JS = [arr aa_toJSArray];
    
    NSString *jsFormatterStr = [NSString stringWithFormat:@AAJSFunc(
                                                                    function () {
                                                                        const x_JS_Array = %@;
                                                                        const y_JS_Array = %@;
                                                                        const unit = %@;
                                                                        //‼️以 this.point.index 这种方式获取选中的点的索引必须设置 tooltip 的 shared 为 false
                                                                        //‼️共享时是 this.points (由多个 point 组成的 points 数组)
                                                                        //‼️非共享时是 this.point 单个 point 对象
                                                                        const selectedSeries = this.points[0];
                                                                        const pointIndex = selectedSeries.point.index;
                                                                        const time = x_JS_Array[pointIndex] + "&nbsp";
                                                                        const step = unit + "&nbsp" + y_JS_Array[pointIndex];
                                                                        
                                                                        const wholeContentStr =  time + step;
                                                                        
                                                                        return wholeContentStr;
                                                                    }), x_JS, y_JS, unit_JS];
    
    AAOptions *aaOptions = aaChartModel.aa_toAAOptions;
    AATooltip *tooltip = aaOptions.tooltip;
    tooltip
        .sharedSet(true)
        .useHTMLSet(true)
        .formatterSet(jsFormatterStr)
        .backgroundColorSet(AAColor.whiteColor)
        .borderColorSet(HEX_STR_COLOR(BlueColor))//边缘颜色
        .styleSet(AAStyleColor(HEX_STR_COLOR(BlueColor)))//文字颜色
    ;
        
    aaOptions.chart
        .eventsSet(AAChartEvents.new
            .loadSet(@AAJSFunc(function () {
                const chart = this;
                Highcharts.addEvent(
                    chart.tooltip,
                    'refresh',
                    function () {
                        //设置 tooltip 自动隐藏的时间
                        chart.tooltip.hide(5000);
                });
            })));
    
    return aaOptions;
}


#pragma mark - ❌ 查询某一天的心率记录｜Query the step count record of a certain day
+ (NSArray <NSNumber *> *)QueryHeartRateCountRecordWithDate:(NSDate *)queryDate deviceName:(NSString *)deviceName deviceMAC:(NSString *)deviceMAC {
    
    NSInteger staTime = queryDate.Time_01;
    NSInteger endTime = queryDate.Time_24;
    
    NSString *SQL = [FBLoadDataObject SQL_StaTime:staTime endTime:endTime deviceName:deviceName deviceMAC:deviceMAC];
    
    RLMResults *heartRateArray = [[RLMHeartRateModel objectsWhere:SQL] sortedResultsUsingKeyPath:@"begin" ascending:YES]; // 对查询结果排序
    
    NSMutableArray <FBHrItem *> *allArray = NSMutableArray.array;
    for (RLMHeartRateModel *hrModel in heartRateArray) {

        if (hrModel.heartRate > 0) {
            
            FBHrItem *model = FBHrItem.new;
            model.begin = hrModel.begin;
            model.hr = hrModel.heartRate;

            [allArray addObject:model];
        }
    }

    NSMutableArray <NSNumber *> *array = NSMutableArray.array;

    for (NSInteger time = (staTime-1); time < endTime; time+=600) { // 24小时，10分钟一笔数据

        // 构建 00:00-00:10、00:10-00:20、00:20-00:30 ... 10分钟最新一条心率
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"begin > %ld && begin <= %ld", time, time+600];
        NSArray <FBHrItem *> *minuteArray = [allArray filteredArrayUsingPredicate:predicate];

        FBHrItem *lastItem = minuteArray.lastObject;

        [array addObject:@(lastItem.hr)];
    }

    return array;
}

+ (AAChartModel *)heartRate_aaChartModel:(NSArray <NSNumber *> *)array {
    
    NSNumber *lastHr = @0;
    for (NSNumber *number in array) {
        if (number.integerValue > 0) lastHr = number;
    }
            
    AAChartModel *aaChartModel = AAChartModel.new
        .chartTypeSet(AAChartTypeAreaspline)
        .animationTypeSet(AAChartAnimationBounce)
        .stackingSet(AAChartStackingTypeNormal)
        .markerRadiusSet(@0)
        .tooltipSharedSet(YES)
        .yAxisMaxSet(@200)
        .yAxisMinSet(@1)
        .titleSet([NSString stringWithFormat:@"%@ bpm", lastHr.integerValue == 0 ? @"- -" : lastHr])
        .titleStyleSet(AAStyle.new
                       .colorSet(AAColor.blackColor)
                       .fontSizeSet(@"30")
                       .fontWeightSet(@"bold"))
        .yAxisGridLineStyleSet([AALineStyle styleWithColor:AAColor.lightGrayColor dashStyle:AAChartLineDashStyleTypeLongDashDot])
        .subtitleSet(LWLocalizbleString(@"Last Heart Rate"))
        .colorsThemeSet(@[HEX_STR_COLOR(Color_Hr.qmui_colorWithoutAlpha)])
        .xAxisTickIntervalSet(@18)
        .categoriesSet(x_Categories_2)
        .seriesSet(@[
            AASeriesElement.new
                .nameSet(LWLocalizbleString(@"Heart Rate"))
                .dataSet(array)
        ]);
    
    return aaChartModel;
}

+ (AAOptions *)heartRate_aaOptions:(AAChartModel *)aaChartModel series:(NSArray *)series {
            
    NSArray *arr = @[LWLocalizbleString(@"Heart Rate")];
    
    NSString *x_JS = [x_Minute aa_toJSArray];
    NSString *y_JS = [series aa_toJSArray];
    NSString *unit_JS = [arr aa_toJSArray];
    
    NSString *jsFormatterStr = [NSString stringWithFormat:@AAJSFunc(
                                                                    function () {
                                                                        const x_JS_Array = %@;
                                                                        const y_JS_Array = %@;
                                                                        const unit = %@;
                                                                        //‼️以 this.point.index 这种方式获取选中的点的索引必须设置 tooltip 的 shared 为 false
                                                                        //‼️共享时是 this.points (由多个 point 组成的 points 数组)
                                                                        //‼️非共享时是 this.point 单个 point 对象
                                                                        const selectedSeries = this.points[0];
                                                                        const pointIndex = selectedSeries.point.index;
                                                                        const time = x_JS_Array[pointIndex] + "&nbsp";
                                                                        const data = unit + "&nbsp" + y_JS_Array[pointIndex] + "&nbsp" + "bpm";
                                                                        
                                                                        const wholeContentStr =  time + data;
                                                                        
                                                                        return wholeContentStr;
                                                                    }), x_JS, y_JS, unit_JS];
    
    AAOptions *aaOptions = aaChartModel.aa_toAAOptions;
    AATooltip *tooltip = aaOptions.tooltip;
    tooltip
        .sharedSet(true)
        .useHTMLSet(true)
        .formatterSet(jsFormatterStr)
        .backgroundColorSet(AAColor.whiteColor)
        .borderColorSet(HEX_STR_COLOR(Color_Hr.qmui_colorWithoutAlpha))//边缘颜色
        .styleSet(AAStyleColor(HEX_STR_COLOR(Color_Hr.qmui_colorWithoutAlpha)))//文字颜色
    ;
        
    aaOptions.chart
        .eventsSet(AAChartEvents.new
            .loadSet(@AAJSFunc(function () {
                const chart = this;
                Highcharts.addEvent(
                    chart.tooltip,
                    'refresh',
                    function () {
                        //设置 tooltip 自动隐藏的时间
                        chart.tooltip.hide(5000);
                });
            })));
    
    return aaOptions;
}


#pragma mark - ❌ 查询某一天的血氧记录｜Query the blood oxygen records of a certain day
+ (NSArray <NSNumber *> *)QueryBloodOxygenCountRecordWithDate:(NSDate *)queryDate deviceName:(NSString *)deviceName deviceMAC:(NSString *)deviceMAC {
    
    NSInteger staTime = queryDate.Time_01;
    NSInteger endTime = queryDate.Time_24;
    
    NSString *SQL = [FBLoadDataObject SQL_StaTime:staTime endTime:endTime deviceName:deviceName deviceMAC:deviceMAC];
    
    RLMResults *bloodOxygenArray = [[RLMBloodOxygenModel objectsWhere:SQL] sortedResultsUsingKeyPath:@"begin" ascending:YES]; // 对查询结果排序
    
    NSMutableArray <FBSpo2Item *> *allArray = NSMutableArray.array;
    for (RLMBloodOxygenModel *spo2Model in bloodOxygenArray) {

        if (spo2Model.bloodOxygen > 0) {
            
            FBSpo2Item *model = FBSpo2Item.new;
            model.begin = spo2Model.begin;
            model.spo2 = spo2Model.bloodOxygen;

            [allArray addObject:model];
        }
    }

    NSMutableArray <NSNumber *> *array = NSMutableArray.array;

    for (NSInteger time = (staTime-1); time < endTime; time+=600) { // 24小时，10分钟一笔数据

        // 构建 00:00-00:10、00:10-00:20、00:20-00:30 ... 10分钟最新一条血氧
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"begin > %ld && begin <= %ld", time, time+600];
        NSArray <FBSpo2Item *> *minuteArray = [allArray filteredArrayUsingPredicate:predicate];

        FBSpo2Item *lastItem = minuteArray.lastObject;

        [array addObject:@(lastItem.spo2)];
    }

    return array;
}

+ (AAChartModel *)bloodOxygen_aaChartModel:(NSArray <NSNumber *> *)array {
    
    NSNumber *lastSpo2 = @0;
    for (NSNumber *number in array) {
        if (number.integerValue > 0) lastSpo2 = number;
    }
                
    AAChartModel *aaChartModel = AAChartModel.new
        .chartTypeSet(AAChartTypeScatter)
        .animationTypeSet(AAChartAnimationBounce)
        .stackingSet(AAChartStackingTypeNormal)
        .tooltipSharedSet(YES)
        .yAxisMaxSet(@100)
        .yAxisMinSet(@80)
        .titleSet([NSString stringWithFormat:@"%@ %%", lastSpo2.integerValue == 0 ? @"- -" : lastSpo2])
        .titleStyleSet(AAStyle.new
                       .colorSet(AAColor.blackColor)
                       .fontSizeSet(@"30")
                       .fontWeightSet(@"bold"))
        .yAxisGridLineStyleSet([AALineStyle styleWithColor:AAColor.lightGrayColor dashStyle:AAChartLineDashStyleTypeLongDashDot])
        .subtitleSet(LWLocalizbleString(@"Last Blood Oxygen"))
        .colorsThemeSet(@[HEX_STR_COLOR(Color_Spo2.qmui_colorWithoutAlpha)])
        .xAxisTickIntervalSet(@18)
        .categoriesSet(x_Categories_2)
        .seriesSet(@[
            AASeriesElement.new
                .nameSet(LWLocalizbleString(@"Blood Oxygen"))
                .dataSet(array)
        ]);
    
    return aaChartModel;
}

+ (AAOptions *)bloodOxygen_aaOptions:(AAChartModel *)aaChartModel series:(NSArray *)series {
    
    NSArray *arr = @[LWLocalizbleString(@"Blood Oxygen")];
        
    NSString *x_JS = [x_Minute aa_toJSArray];
    NSString *y_JS = [series aa_toJSArray];
    NSString *unit_JS = [arr aa_toJSArray];
    
    NSString *jsFormatterStr = [NSString stringWithFormat:@AAJSFunc(
                                                                    function () {
                                                                        const x_JS_Array = %@;
                                                                        const y_JS_Array = %@;
                                                                        const unit = %@;
                                                                        //‼️以 this.point.index 这种方式获取选中的点的索引必须设置 tooltip 的 shared 为 false
                                                                        //‼️共享时是 this.points (由多个 point 组成的 points 数组)
                                                                        //‼️非共享时是 this.point 单个 point 对象
                                                                        const selectedSeries = this.points[0];
                                                                        const pointIndex = selectedSeries.point.index;
                                                                        const time = x_JS_Array[pointIndex] + "&nbsp";
                                                                        const data = unit + "&nbsp" + y_JS_Array[pointIndex] + "&nbsp" + "%%";
                                                                        
                                                                        const wholeContentStr =  time + data;
                                                                        
                                                                        return wholeContentStr;
                                                                    }), x_JS, y_JS, unit_JS];
    
    AAOptions *aaOptions = aaChartModel.aa_toAAOptions;
    AATooltip *tooltip = aaOptions.tooltip;
    tooltip
        .sharedSet(true)
        .useHTMLSet(true)
//        .formatterSet(jsFormatterStr)
        .backgroundColorSet(AAColor.whiteColor)
        .borderColorSet(HEX_STR_COLOR(Color_Spo2.qmui_colorWithoutAlpha))//边缘颜色
        .styleSet(AAStyleColor(HEX_STR_COLOR(Color_Spo2.qmui_colorWithoutAlpha)))//文字颜色
    ;
        
    aaOptions.chart
        .eventsSet(AAChartEvents.new
            .loadSet(@AAJSFunc(function () {
                const chart = this;
                Highcharts.addEvent(
                    chart.tooltip,
                    'refresh',
                    function () {
                        //设置 tooltip 自动隐藏的时间
                        chart.tooltip.hide(5000);
                });
            })));
    
    return aaOptions;
}


#pragma mark - ❌ 查询某一天的血压记录｜Query the blood pressure records of a certain day
+ (NSArray <FBBpItem *> *)QueryBloodPressureCountRecordWithDate:(NSDate *)queryDate deviceName:(NSString *)deviceName deviceMAC:(NSString *)deviceMAC {
    
    NSInteger staTime = queryDate.Time_01;
    NSInteger endTime = queryDate.Time_24;
    
    NSString *SQL = [FBLoadDataObject SQL_StaTime:staTime endTime:endTime deviceName:deviceName deviceMAC:deviceMAC];
    
    RLMResults *bloodPressureArray = [[RLMBloodPressureModel objectsWhere:SQL] sortedResultsUsingKeyPath:@"begin" ascending:YES]; // 对查询结果排序
    
    NSMutableArray <FBBpItem *> *allArray = NSMutableArray.array;
    for (RLMBloodPressureModel *bpModel in bloodPressureArray) {

        if (bpModel.systolic > 0 && bpModel.diastolic > 0) {
            
            FBBpItem *model = FBBpItem.new;
            model.begin = bpModel.begin;
            model.bp_s = bpModel.systolic;
            model.bp_d = bpModel.diastolic;

            [allArray addObject:model];
        }
    }

    NSMutableArray <FBBpItem *> *array = NSMutableArray.array;

    for (NSInteger time = (staTime-1); time < endTime; time+=600) { // 24小时，10分钟一笔数据

        // 构建 00:00-00:10、00:10-00:20、00:20-00:30 ... 10分钟最新一条血压
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"begin > %ld && begin <= %ld", time, time+600];
        NSArray <FBBpItem *> *minuteArray = [allArray filteredArrayUsingPredicate:predicate];

        FBBpItem *lastItem = minuteArray.lastObject;

        [array addObject:!lastItem ? FBBpItem.new : lastItem];
    }

    return array;
}

+ (AAChartModel *)bloodPressure_aaChartModel:(NSArray <FBBpItem *> *)array {
    
    FBBpItem *lastBp = nil;
    NSMutableArray *diastolicArray = NSMutableArray.array;
    NSMutableArray *systolicArray = NSMutableArray.array;
    for (FBBpItem *bpItem in array) {
        if (bpItem.bp_s > 0 && bpItem.bp_d > 0) lastBp = bpItem;
        
        [diastolicArray addObject:bpItem.bp_d>0 ? @(bpItem.bp_d) : NSNull.null];
        [systolicArray addObject:bpItem.bp_s>0 ? @(bpItem.bp_s) : NSNull.null];
    }
            
    AAChartModel *aaChartModel = AAChartModel.new
        .chartTypeSet(AAChartTypeLine)
        .animationTypeSet(AAChartAnimationBounce)
        .stackingSet(AAChartStackingTypeFalse)
        .markerRadiusSet(@2.3)
        .tooltipSharedSet(YES)
        .yAxisMaxSet(@180)
        .yAxisMinSet(@0)
        .titleSet([NSString stringWithFormat:@"%@/%@ mmHg", lastBp.bp_s<=0 ? @"- -" : @(lastBp.bp_s), lastBp.bp_d<=0 ? @"- -" : @(lastBp.bp_d)])
        .titleStyleSet(AAStyle.new
                       .colorSet(AAColor.blackColor)
                       .fontSizeSet(@"30")
                       .fontWeightSet(@"bold"))
        .yAxisGridLineStyleSet([AALineStyle styleWithColor:AAColor.lightGrayColor dashStyle:AAChartLineDashStyleTypeLongDashDot])
        .subtitleSet(LWLocalizbleString(@"Last Blood Pressure"))
        .colorsThemeSet(@[HEX_STR_COLOR(Color_Bp_s.qmui_colorWithoutAlpha), HEX_STR_COLOR(Color_Bp_d.qmui_colorWithoutAlpha)])
        .xAxisTickIntervalSet(@18)
        .categoriesSet(x_Categories_2)
        .seriesSet(@[
            AASeriesElement.new
                .nameSet(LWLocalizbleString(@"Systolic (high pressure)"))
                .connectNullsSet(@NO)
                .dataSet(systolicArray),
            AASeriesElement.new
                .nameSet(LWLocalizbleString(@"Diastolic (low pressure)"))
                .connectNullsSet(@NO)
                .dataSet(diastolicArray)
        ]);

    return aaChartModel;
}

+ (AAOptions *)bloodPressure_aaOptions:(AAChartModel *)aaChartModel series:(NSArray <FBBpItem *> *)series {
                
    NSArray *arr = @[LWLocalizbleString(@"Blood Pressure")];
    
    NSMutableArray *diastolic_systolic_Array = NSMutableArray.array;
    for (FBBpItem *bpItem in series) {
        
        [diastolic_systolic_Array addObject:(bpItem.bp_s>0 && bpItem.bp_d>0) ? [NSString stringWithFormat:@"%@/%@ mmHg", @(bpItem.bp_s), @(bpItem.bp_d)] : NSNull.null];
    }
    
    NSString *x_JS = [x_Minute aa_toJSArray];
    NSString *y_JS = [diastolic_systolic_Array aa_toJSArray];
    NSString *unit_JS = [arr aa_toJSArray];
    
    NSString *jsFormatterStr = [NSString stringWithFormat:@AAJSFunc(
                                                                    function () {
                                                                        const x_JS_Array = %@;
                                                                        const y_JS_Array = %@;
                                                                        const unit = %@;
                                                                        //‼️以 this.point.index 这种方式获取选中的点的索引必须设置 tooltip 的 shared 为 false
                                                                        //‼️共享时是 this.points (由多个 point 组成的 points 数组)
                                                                        //‼️非共享时是 this.point 单个 point 对象
                                                                        const selectedSeries = this.points[0];
                                                                        const pointIndex = selectedSeries.point.index;
                                                                        const time = x_JS_Array[pointIndex] + "&nbsp";
                                                                        const data = unit + "&nbsp" + y_JS_Array[pointIndex];
                                                                        
                                                                        const wholeContentStr =  time + data;
                                                                        
                                                                        return wholeContentStr;
                                                                    }), x_JS, y_JS, unit_JS];
    
    AAOptions *aaOptions = aaChartModel.aa_toAAOptions;
    AATooltip *tooltip = aaOptions.tooltip;
    tooltip
        .sharedSet(true)
        .useHTMLSet(true)
        .formatterSet(jsFormatterStr)
        .backgroundColorSet(AAColor.whiteColor)
        .borderColorSet(HEX_STR_COLOR(Color_Bp_s.qmui_colorWithoutAlpha))//边缘颜色
        .styleSet(AAStyleColor(HEX_STR_COLOR(Color_Bp_s.qmui_colorWithoutAlpha)))//文字颜色
    ;
        
    aaOptions.chart
        .eventsSet(AAChartEvents.new
            .loadSet(@AAJSFunc(function () {
                const chart = this;
                Highcharts.addEvent(
                    chart.tooltip,
                    'refresh',
                    function () {
                        //设置 tooltip 自动隐藏的时间
                        chart.tooltip.hide(5000);
                });
            })));
    
    NSArray *aaPlotBandsArr = @[
        AAPlotBandsElement.new
        .fromSet(@0)//值域颜色带Y轴起始值
        .toSet(@90)//值域颜色带Y轴结束值
        .colorSet(@"#F0FFFF")//值域颜色带填充色
        .zIndexSet(0),//层叠,标示线在图表中显示的层叠级别，值越大，显示越向前
        AAPlotBandsElement.new
        .fromSet(@90)
        .toSet(@180)
        .colorSet(@"#FAF5EB")
        .zIndexSet(1),
    ];
    
    NSArray *aaPlotLinesArr = @[
        AAPlotLinesElement.new
            .colorSet(AAColor.redColor)//颜色值(16进制)
            .dashStyleSet(AAChartLineDashStyleTypeLongDashDot)//样式：Dash,Dot,Solid等,默认Solid
            .widthSet(@1) //标示线粗细
            .valueSet(@90) //所在位置
            .zIndexSet(@2) //层叠,标示线在图表中显示的层叠级别，值越大，显示越向前
            .labelSet(AALabel.new
            .useHTMLSet(true)
            .textSet(@"90")
            .styleSet(AAStyle.new
                        .colorSet(AAColor.redColor)
                        .backgroundColorSet(AAColor.clearColor)
                        )
        )];
    
    AAYAxis *aaYAxis = aaOptions.yAxis;
    aaYAxis.plotBands = aaPlotBandsArr;
    aaYAxis.plotLines = aaPlotLinesArr;
    
    return aaOptions;
}


#pragma mark - ❌ 查询某一天的精神压力记录｜Query the mental stress records of a certain day
+ (NSArray <FBStressItem *> *)QueryMentalStressCountRecordWithDate:(NSDate *)queryDate deviceName:(NSString *)deviceName deviceMAC:(NSString *)deviceMAC {
    
    NSInteger staTime = queryDate.Time_01;
    NSInteger endTime = queryDate.Time_24;
    
    NSString *SQL = [FBLoadDataObject SQL_StaTime:staTime endTime:endTime deviceName:deviceName deviceMAC:deviceMAC];
    
    RLMResults *stressArray = [[RLMStressModel objectsWhere:SQL] sortedResultsUsingKeyPath:@"begin" ascending:YES]; // 对查询结果排序
    
    NSMutableArray <FBStressItem *> *allArray = NSMutableArray.array;
    for (RLMStressModel *stressModel in stressArray) {

        if (stressModel.stress > 0) {
            
            FBStressItem *model = FBStressItem.new;
            model.begin = stressModel.begin;
            model.stress = stressModel.stress;
            model.StressRange = stressModel.StressRange;

            [allArray addObject:model];
        }
    }

    NSMutableArray <FBStressItem *> *array = NSMutableArray.array;

    for (NSInteger time = (staTime-1); time < endTime; time+=600) { // 24小时，10分钟一笔数据

        // 构建 00:00-00:10、00:10-00:20、00:20-00:30 ... 10分钟最新一条精神压力
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"begin > %ld && begin <= %ld", time, time+600];
        NSArray <FBStressItem *> *minuteArray = [allArray filteredArrayUsingPredicate:predicate];

        FBStressItem *lastItem = minuteArray.lastObject;

        [array addObject:!lastItem ? FBStressItem.new : lastItem];
    }

    return array;
}

+ (AAChartModel *)mentalStress_aaChartModel:(NSArray <FBStressItem *> *)array {
    
    FBStressItem *lastStress = nil;
    
    NSMutableArray *stressArray = NSMutableArray.array;
    for (FBStressItem *stressItem in array) {
        if (stressItem.stress > 0) lastStress = stressItem;
        
        [stressArray addObject:@(stressItem.stress)];
    }
            
    AAChartModel *aaChartModel = AAChartModel.new
        .chartTypeSet(AAChartTypeAreaspline)
        .animationTypeSet(AAChartAnimationBounce)
        .stackingSet(AAChartStackingTypeNormal)
        .markerRadiusSet(@0)
        .tooltipSharedSet(YES)
        .yAxisMaxSet(@100)
        .yAxisMinSet(@1)
        .titleSet([NSString stringWithFormat:@"%@ %@", lastStress.stress > 0 ? @(lastStress.stress) : @"- -", [FBLoadDataObject stress:lastStress.stress range:lastStress.StressRange]])
        .titleStyleSet(AAStyle.new
                       .colorSet(AAColor.blackColor)
                       .fontSizeSet(@"30")
                       .fontWeightSet(@"bold"))
        .yAxisGridLineStyleSet([AALineStyle styleWithColor:AAColor.lightGrayColor dashStyle:AAChartLineDashStyleTypeLongDashDot])
        .subtitleSet(LWLocalizbleString(@"Last Mental Stress"))
        .colorsThemeSet(@[HEX_STR_COLOR(Color_Stre.qmui_colorWithoutAlpha)])
        .xAxisTickIntervalSet(@18)
        .categoriesSet(x_Categories_2)
        .seriesSet(@[
            AASeriesElement.new
                .nameSet(LWLocalizbleString(@"Mental Stress"))
                .dataSet(stressArray)
                .zIndexSet(@0)
                .zonesSet(@[
                    AAZonesElement.new
                    .valueSet(@25)
                    .colorSet(@"#90EE90"),
                    AAZonesElement.new
                    .valueSet(@50)
                    .colorSet(HEX_STR_COLOR(Color_Stre.qmui_colorWithoutAlpha)),
                    AAZonesElement.new
                    .valueSet(@75)
                    .colorSet(@"#FFA500"),
                    AAZonesElement.new
                    .valueSet(@100)
                    .colorSet(@"#FF6347"),
                ])
        ])
        .yAxisPlotLinesSet(@[
            AAPlotLinesElement.new
            .colorSet(AAColor.redColor) //颜色值(16进制)
            .dashStyleSet(AAChartLineDashStyleTypeLongDashDot) //样式：Dash,Dot,Solid等,默认Solid
            .valueSet(@75) //所在位置
            .zIndexSet(@10000) //层叠,标示线在图表中显示的层叠级别，值越大，显示越向前
            .labelSet(AALabel.new
                      .textSet(LWLocalizbleString(@"High"))
                      .styleSet(AAStyleColor(AAColor.redColor)))
            ,
            AAPlotLinesElement.new
            .colorSet(AAColor.orangeColor)
            .dashStyleSet(AAChartLineDashStyleTypeLongDashDot)
            .valueSet(@50)
            .zIndexSet(@20000)
            .labelSet(AALabel.new
                      .textSet(LWLocalizbleString(@"Medium"))
                      .styleSet(AAStyleColor(AAColor.orangeColor)))
            ,
            AAPlotLinesElement.new
            .colorSet(AAColor.blueColor)
            .dashStyleSet(AAChartLineDashStyleTypeLongDashDot)
            .valueSet(@25)
            .zIndexSet(@30000)
            .labelSet(AALabel.new
                      .textSet(LWLocalizbleString(@"Normal"))
                      .styleSet(AAStyleColor(AAColor.blueColor)))
            ,
            AAPlotLinesElement.new
            .colorSet(AAColor.greenColor)
            .dashStyleSet(AAChartLineDashStyleTypeLongDashDot)
            .valueSet(@1)
            .zIndexSet(@40000)
            .labelSet(AALabel.new
                      .textSet(LWLocalizbleString(@"Relax"))
                      .styleSet(AAStyleColor(AAColor.greenColor)))
        ]);
    
    return aaChartModel;
}

+ (AAOptions *)mentalStress_aaOptions:(AAChartModel *)aaChartModel series:(NSArray <FBStressItem *> *)series {
            
    NSArray *arr = @[LWLocalizbleString(@"Mental Stress")];
    
    NSMutableArray *stress_Array = NSMutableArray.array;
    for (FBStressItem *stressItem in series) {
        
        [stress_Array addObject:stressItem.stress>0 ? [NSString stringWithFormat:@"%@ %@", @(stressItem.stress), [FBLoadDataObject stress:stressItem.stress range:stressItem.StressRange]] : NSNull.null];
    }
    
    NSString *x_JS = [x_Minute aa_toJSArray];
    NSString *y_JS = [stress_Array aa_toJSArray];
    NSString *unit_JS = [arr aa_toJSArray];
    
    NSString *jsFormatterStr = [NSString stringWithFormat:@AAJSFunc(
                                                                    function () {
                                                                        const x_JS_Array = %@;
                                                                        const y_JS_Array = %@;
                                                                        const unit = %@;
                                                                        //‼️以 this.point.index 这种方式获取选中的点的索引必须设置 tooltip 的 shared 为 false
                                                                        //‼️共享时是 this.points (由多个 point 组成的 points 数组)
                                                                        //‼️非共享时是 this.point 单个 point 对象
                                                                        const selectedSeries = this.points[0];
                                                                        const pointIndex = selectedSeries.point.index;
                                                                        const time = x_JS_Array[pointIndex] + "&nbsp";
                                                                        const data = unit + "&nbsp" + y_JS_Array[pointIndex];
                                                                        
                                                                        const wholeContentStr =  time + data;
                                                                        
                                                                        return wholeContentStr;
                                                                    }), x_JS, y_JS, unit_JS];
    
    AAOptions *aaOptions = aaChartModel.aa_toAAOptions;
    AATooltip *tooltip = aaOptions.tooltip;
    tooltip
        .sharedSet(true)
        .useHTMLSet(true)
        .formatterSet(jsFormatterStr)
        .backgroundColorSet(AAColor.whiteColor)
        .borderColorSet(HEX_STR_COLOR(Color_Stre.qmui_colorWithoutAlpha))//边缘颜色
        .styleSet(AAStyleColor(HEX_STR_COLOR(Color_Stre.qmui_colorWithoutAlpha)))//文字颜色
    ;
        
    aaOptions.chart
        .eventsSet(AAChartEvents.new
            .loadSet(@AAJSFunc(function () {
                const chart = this;
                Highcharts.addEvent(
                    chart.tooltip,
                    'refresh',
                    function () {
                        //设置 tooltip 自动隐藏的时间
                        chart.tooltip.hide(5000);
                });
            })));
    
    return aaOptions;
}


+ (NSString *)stress:(NSInteger)stress range:(FB_CURRENTSTRESSRANGE)StressRange {
    if (StressRange == FB_STRESS_HIGN) {
        return LWLocalizbleString(@"High");
    } else if (StressRange == FB_STRESS_SECONDARY) {
        return LWLocalizbleString(@"Medium");
    } else if (StressRange == FB_STRESS_NORMAL) {
        return LWLocalizbleString(@"Normal");
    } else if (StressRange == FB_STRESS_RELAX) {
        return stress==0 ? @"xx" : LWLocalizbleString(@"Relax");
    }
    return @"xx";
}


#pragma mark - ❌ 查询某一天的睡眠记录｜Query the sleep record of a certain day
+ (NSArray <FBSleepItem *> *)QuerySleepCountRecordWithDate:(NSDate *)queryDate deviceName:(NSString *)deviceName deviceMAC:(NSString *)deviceMAC {
    
    NSInteger staTime = queryDate.Time_01-1 - 2.5*3600;
    NSInteger endTime = queryDate.Time_24-1 - 2.5*3600;
    
    NSString *SQL = [FBLoadDataObject SQL_StaTime:staTime endTime:endTime deviceName:deviceName deviceMAC:deviceMAC];
    
    RLMResults *sleepArray = [[RLMSleepModel objectsWhere:SQL] sortedResultsUsingKeyPath:@"begin" ascending:YES]; // 对查询结果排序
    
    NSMutableArray <FBSleepItem *> *allArray = NSMutableArray.array;
    for (RLMSleepModel *sleepModel in sleepArray) {

        if (sleepModel.duration > 0) {
            
            FBSleepItem *model = FBSleepItem.new;
            model.begin = sleepModel.begin;
            model.end = sleepModel.end;
            model.duration = sleepModel.duration;
            model.SleepState = sleepModel.SleepState;

            [allArray addObject:model];
        }
    }

    return allArray;
}

+ (AAChartModel *)sleep_aaChartModel:(NSArray <FBSleepItem *> *)array {

    NSInteger sleepTime = 0;
    
    NSMutableArray *arrayDeep = NSMutableArray.array;
    
    NSMutableArray *arrayShallow = NSMutableArray.array;
    
    NSMutableArray *arrayREM = NSMutableArray.array;
    
    NSMutableArray *arrayAwake = NSMutableArray.array;
        
    NSMutableArray *arrayNap = NSMutableArray.array;
    
    NSMutableArray *categories = NSMutableArray.array;
    
    CGFloat offset = -0.01; // 细微偏移，这里只为处理图表显示，不要用于其他用途
    
    for (FBSleepItem *sleepItem in array) {
        // 睡眠总时长（清醒状态的时长不计入）
        if (sleepItem.SleepState != RLM_Awake && sleepItem.SleepState != RLM_Nap_Awake) {
            sleepTime += sleepItem.duration;
        }
        
        [categories addObject:[NSDate timeStamp:sleepItem.begin dateFormat:FBDateFormatHm]];
        [categories addObject:[NSDate timeStamp:sleepItem.end dateFormat:FBDateFormatHm]];
        
        // 深睡
        if (sleepItem.SleepState == RLM_Deep) {
            [arrayDeep addObject:@[@(sleepItem.begin), @0, @1]];
            [arrayDeep addObject:@[@(sleepItem.end + offset), @0, @1]];
            
            [arrayShallow addObject:@[@(sleepItem.begin), [NSNull null], [NSNull null]]];
            [arrayShallow addObject:@[@(sleepItem.end), [NSNull null], [NSNull null]]];
            [arrayREM addObject:@[@(sleepItem.begin), [NSNull null], [NSNull null]]];
            [arrayREM addObject:@[@(sleepItem.end), [NSNull null], [NSNull null]]];
            [arrayAwake addObject:@[@(sleepItem.begin), [NSNull null], [NSNull null]]];
            [arrayAwake addObject:@[@(sleepItem.end), [NSNull null], [NSNull null]]];
            [arrayNap addObject:@[@(sleepItem.begin), [NSNull null], [NSNull null]]];
            [arrayNap addObject:@[@(sleepItem.end), [NSNull null], [NSNull null]]];
        }
        // 浅睡
        else if (sleepItem.SleepState == RLM_Shallow) {
            [arrayShallow addObject:@[@(sleepItem.begin), @1, @2]];
            [arrayShallow addObject:@[@(sleepItem.end + offset), @1, @2]];
            
            [arrayDeep addObject:@[@(sleepItem.begin), [NSNull null], [NSNull null]]];
            [arrayDeep addObject:@[@(sleepItem.end), [NSNull null], [NSNull null]]];
            [arrayREM addObject:@[@(sleepItem.begin), [NSNull null], [NSNull null]]];
            [arrayREM addObject:@[@(sleepItem.end), [NSNull null], [NSNull null]]];
            [arrayAwake addObject:@[@(sleepItem.begin), [NSNull null], [NSNull null]]];
            [arrayAwake addObject:@[@(sleepItem.end), [NSNull null], [NSNull null]]];
            [arrayNap addObject:@[@(sleepItem.begin), [NSNull null], [NSNull null]]];
            [arrayNap addObject:@[@(sleepItem.end), [NSNull null], [NSNull null]]];
        }
        
        // 眼动
        else if (sleepItem.SleepState == RLM_REM) {
            [arrayREM addObject:@[@(sleepItem.begin), @2, @3]];
            [arrayREM addObject:@[@(sleepItem.end + offset), @2, @3]];
            
            [arrayDeep addObject:@[@(sleepItem.begin), [NSNull null], [NSNull null]]];
            [arrayDeep addObject:@[@(sleepItem.end), [NSNull null], [NSNull null]]];
            [arrayShallow addObject:@[@(sleepItem.begin), [NSNull null], [NSNull null]]];
            [arrayShallow addObject:@[@(sleepItem.end), [NSNull null], [NSNull null]]];
            [arrayAwake addObject:@[@(sleepItem.begin), [NSNull null], [NSNull null]]];
            [arrayAwake addObject:@[@(sleepItem.end), [NSNull null], [NSNull null]]];
            [arrayNap addObject:@[@(sleepItem.begin), [NSNull null], [NSNull null]]];
            [arrayNap addObject:@[@(sleepItem.end), [NSNull null], [NSNull null]]];
        }
        // 清醒
        if (sleepItem.SleepState == RLM_Awake) {
            [arrayAwake addObject:@[@(sleepItem.begin), @3, @4]];
            [arrayAwake addObject:@[@(sleepItem.end + offset), @3, @4]];
            
            [arrayDeep addObject:@[@(sleepItem.begin), [NSNull null], [NSNull null]]];
            [arrayDeep addObject:@[@(sleepItem.end), [NSNull null], [NSNull null]]];
            [arrayShallow addObject:@[@(sleepItem.begin), [NSNull null], [NSNull null]]];
            [arrayShallow addObject:@[@(sleepItem.end), [NSNull null], [NSNull null]]];
            [arrayREM addObject:@[@(sleepItem.begin), [NSNull null], [NSNull null]]];
            [arrayREM addObject:@[@(sleepItem.end), [NSNull null], [NSNull null]]];
            [arrayNap addObject:@[@(sleepItem.begin), [NSNull null], [NSNull null]]];
            [arrayNap addObject:@[@(sleepItem.end), [NSNull null], [NSNull null]]];
        }
        // 小睡
        else if (sleepItem.SleepState == RLM_Nap) {
            [arrayNap addObject:@[@(sleepItem.begin), @0, @2]];
            [arrayNap addObject:@[@(sleepItem.end + offset), @0, @2]];
            
            [arrayDeep addObject:@[@(sleepItem.begin), [NSNull null], [NSNull null]]];
            [arrayDeep addObject:@[@(sleepItem.end), [NSNull null], [NSNull null]]];
            [arrayShallow addObject:@[@(sleepItem.begin), [NSNull null], [NSNull null]]];
            [arrayShallow addObject:@[@(sleepItem.end), [NSNull null], [NSNull null]]];
            [arrayAwake addObject:@[@(sleepItem.begin), [NSNull null], [NSNull null]]];
            [arrayAwake addObject:@[@(sleepItem.end), [NSNull null], [NSNull null]]];
            [arrayREM addObject:@[@(sleepItem.begin), [NSNull null], [NSNull null]]];
            [arrayREM addObject:@[@(sleepItem.end), [NSNull null], [NSNull null]]];
        }
        // 小睡-清醒
        else if (sleepItem.SleepState == RLM_Nap_Awake) {
            [arrayDeep addObject:@[@(sleepItem.begin), [NSNull null], [NSNull null]]];
            [arrayDeep addObject:@[@(sleepItem.end), [NSNull null], [NSNull null]]];
            [arrayShallow addObject:@[@(sleepItem.begin), [NSNull null], [NSNull null]]];
            [arrayShallow addObject:@[@(sleepItem.end), [NSNull null], [NSNull null]]];
            [arrayAwake addObject:@[@(sleepItem.begin), [NSNull null], [NSNull null]]];
            [arrayAwake addObject:@[@(sleepItem.end), [NSNull null], [NSNull null]]];
            [arrayREM addObject:@[@(sleepItem.begin), [NSNull null], [NSNull null]]];
            [arrayREM addObject:@[@(sleepItem.end), [NSNull null], [NSNull null]]];
            [arrayNap addObject:@[@(sleepItem.begin), [NSNull null], [NSNull null]]];
            [arrayNap addObject:@[@(sleepItem.end), [NSNull null], [NSNull null]]];
        }
    }
            
    AAChartModel *aaChartModel = AAChartModel.new
        .chartTypeSet(AAChartTypeArearange)
        .markerRadiusSet(@0)
        .tooltipSharedSet(YES)
        .yAxisVisibleSet(NO)
        .xAxisVisibleSet(NO)
        .yAxisMaxSet(@4)
        .yAxisMinSet(@0)
        .titleSet([Tools HM:sleepTime*60])
        .titleStyleSet(AAStyle.new
                       .colorSet(AAColor.blackColor)
                       .fontSizeSet(@"30")
                       .fontWeightSet(@"bold"))
        .subtitleSet([NSString stringWithFormat:@"%@ (%@ - %@)", LWLocalizbleString(@"Total Sleep Time"), StringIsEmpty(categories.firstObject) ? @"xx" : categories.firstObject, StringIsEmpty(categories.lastObject) ? @"xx" : categories.lastObject])
        .colorsThemeSet(@[HEX_STR_COLOR(Color_DeepS.qmui_colorWithoutAlpha), HEX_STR_COLOR(Color_LightS.qmui_colorWithoutAlpha), HEX_STR_COLOR(Color_REMS.qmui_colorWithoutAlpha), HEX_STR_COLOR(Color_AwakeS.qmui_colorWithoutAlpha), HEX_STR_COLOR(Color_NapS.qmui_colorWithoutAlpha)])
        .seriesSet(@[
            AASeriesElement.new
                .nameSet(LWLocalizbleString(@"Deep Sleep"))
                .typeSet(AAChartTypeArearange)
                .colorSet(HEX_STR_COLOR(Color_DeepS.qmui_colorWithoutAlpha))
                .fillColorSet((id)AAGradientColor.new
                              .directionSet(AALinearGradientDirectionToBottom)
                              .stopsArraySet(@[
                                @[@1.0, HEX_STR_COLOR(Color_DeepS.qmui_colorWithoutAlpha)],
                                @[@1.0, HEX_STR_COLOR(Color_DeepS.qmui_colorWithoutAlpha)]
                                             ]))
                .dataSet(arrayDeep),

            AASeriesElement.new
                .nameSet(LWLocalizbleString(@"Light Sleep"))
                .typeSet(AAChartTypeArearange)
                .colorSet(HEX_STR_COLOR(Color_LightS.qmui_colorWithoutAlpha))
                .fillColorSet((id)AAGradientColor.new
                              .directionSet(AALinearGradientDirectionToBottom)
                              .stopsArraySet(@[
                                @[@1.0, HEX_STR_COLOR(Color_LightS.qmui_colorWithoutAlpha)],
                                @[@1.0, HEX_STR_COLOR(Color_LightS.qmui_colorWithoutAlpha)]
                                             ]))
                .dataSet(arrayShallow),

            AASeriesElement.new
                .nameSet(LWLocalizbleString(@"REM"))
                .typeSet(AAChartTypeArearange)
                .colorSet(HEX_STR_COLOR(Color_REMS.qmui_colorWithoutAlpha))
                .fillColorSet((id)AAGradientColor.new
                              .directionSet(AALinearGradientDirectionToBottom)
                              .stopsArraySet(@[
                                @[@1.0, HEX_STR_COLOR(Color_REMS.qmui_colorWithoutAlpha)],
                                @[@1.0, HEX_STR_COLOR(Color_REMS.qmui_colorWithoutAlpha)]
                                             ]))
                .dataSet(arrayREM),

            AASeriesElement.new
                .nameSet(LWLocalizbleString(@"Awake"))
                .typeSet(AAChartTypeArearange)
                .colorSet(HEX_STR_COLOR(Color_AwakeS.qmui_colorWithoutAlpha))
                .fillColorSet((id)AAGradientColor.new
                              .directionSet(AALinearGradientDirectionToBottom)
                              .stopsArraySet(@[
                                @[@1.0, HEX_STR_COLOR(Color_AwakeS.qmui_colorWithoutAlpha)],
                                @[@1.0, HEX_STR_COLOR(Color_AwakeS.qmui_colorWithoutAlpha)]
                                             ]))
                .dataSet(arrayAwake),

            AASeriesElement.new
                .nameSet(LWLocalizbleString(@"Nap"))
                .typeSet(AAChartTypeArearange)
                .colorSet(HEX_STR_COLOR(Color_NapS.qmui_colorWithoutAlpha))
                .fillColorSet((id)AAGradientColor.new
                              .directionSet(AALinearGradientDirectionToBottom)
                              .stopsArraySet(@[
                                @[@1.0, HEX_STR_COLOR(Color_NapS.qmui_colorWithoutAlpha)],
                                @[@1.0, HEX_STR_COLOR(Color_NapS.qmui_colorWithoutAlpha)]
                                             ]))
                .dataSet(arrayNap)
        ]);
    
    return aaChartModel;
}

+ (AAOptions *)sleep_aaOptions:(AAChartModel *)aaChartModel series:(NSArray <FBSleepItem *> *)series {
                
    NSMutableArray *y_Array = NSMutableArray.array;
    
    NSMutableArray *categories = NSMutableArray.array;
    
    [series enumerateObjectsUsingBlock:^(FBSleepItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // sta点的描述
        [categories addObject:[NSString stringWithFormat:@"%@ - %@", [NSDate timeStamp:obj.begin dateFormat:FBDateFormatHm], [NSDate timeStamp:obj.end dateFormat:FBDateFormatHm]]];
        [y_Array addObject:[FBLoadDataObject sleep:obj.SleepState duration:obj.duration*60]];
        
        // end点的描述
        [categories addObject:[NSString stringWithFormat:@"%@ - %@", [NSDate timeStamp:obj.begin dateFormat:FBDateFormatHm], [NSDate timeStamp:obj.end dateFormat:FBDateFormatHm]]];
        [y_Array addObject:[FBLoadDataObject sleep:obj.SleepState duration:obj.duration*60]];
    }];
    
    NSString *x_JS = [categories aa_toJSArray];
    NSString *y_JS = [y_Array aa_toJSArray];
    
    NSString *jsFormatterStr = [NSString stringWithFormat:@AAJSFunc(
                                                                    function () {
                                                                        const x_JS_Array = %@;
                                                                        const y_JS_Array = %@;
                                                                        //‼️以 this.point.index 这种方式获取选中的点的索引必须设置 tooltip 的 shared 为 false
                                                                        //‼️共享时是 this.points (由多个 point 组成的 points 数组)
                                                                        //‼️非共享时是 this.point 单个 point 对象
                                                                        const selectedSeries = this.points[0];
                                                                        const pointIndex = selectedSeries.point.index;
                                                                        const time = x_JS_Array[pointIndex] + "&nbsp";
                                                                        const data = "&nbsp" + y_JS_Array[pointIndex];
                                                                        
                                                                        const wholeContentStr =  time + data;
                                                                        
                                                                        return wholeContentStr;
                                                                    }), x_JS, y_JS];
    
    AAOptions *aaOptions = aaChartModel.aa_toAAOptions;
    AATooltip *tooltip = aaOptions.tooltip;
    tooltip
        .sharedSet(true)
        .useHTMLSet(true)
        .formatterSet(jsFormatterStr)
//        .backgroundColorSet(AAColor.whiteColor)
//        .borderColorSet(HEX_STR_COLOR(Color_Stre.qmui_colorWithoutAlpha))//边缘颜色
//        .styleSet(AAStyleColor(HEX_STR_COLOR(Color_Stre.qmui_colorWithoutAlpha)))//文字颜色
    ;

    aaOptions.chart
        .eventsSet(AAChartEvents.new
            .loadSet(@AAJSFunc(function () {
                const chart = this;
                Highcharts.addEvent(
                    chart.tooltip,
                    'refresh',
                    function () {
                        //设置 tooltip 自动隐藏的时间
                        chart.tooltip.hide(5000);
                });
            })));
    
    return aaOptions;
}


+ (NSString *)sleep:(RLMSLEEPSTATE)SleepState duration:(NSInteger)duration {
    NSMutableString *string = NSMutableString.string;
    if (SleepState == RLM_Deep) {
        [string appendString:LWLocalizbleString(@"Deep Sleep")];
    } else if (SleepState == RLM_Shallow) {
        [string appendString:LWLocalizbleString(@"Light Sleep")];
    } else if (SleepState == RLM_REM) {
        [string appendString:LWLocalizbleString(@"REM")];
    } else if (SleepState == RLM_Awake) {
        [string appendString:LWLocalizbleString(@"Awake")];
    } else if (SleepState == RLM_Nap) {
        [string appendString:LWLocalizbleString(@"Nap")];
    } else if (SleepState == RLM_Nap_Awake) {
        [string appendString:LWLocalizbleString(@"Nap (Awake)")];
    }
    
    [string appendFormat:@" %@", [Tools HM:duration]];
    
    return string;
}


#pragma mark - ❌ 查询某一天的运动记录｜Query exercise records for a certain day
+ (NSArray <RLMSportsModel *> *)QueryExerciseRecordWithDate:(NSDate *)queryDate deviceName:(NSString *)deviceName deviceMAC:(NSString *)deviceMAC {
    
    NSInteger staTime = queryDate.Time_01;
    NSInteger endTime = queryDate.Time_24;
    
    NSString *SQL = [FBLoadDataObject SQL_StaTime:staTime endTime:endTime deviceName:deviceName deviceMAC:deviceMAC];
    
    RLMResults *sportsArray = [[RLMSportsModel objectsWhere:SQL] sortedResultsUsingKeyPath:@"begin" ascending:YES]; // 对查询结果排序
    
    NSMutableArray <RLMSportsModel *> *allArray = NSMutableArray.array;
    for (RLMSportsModel *sportsModel in sportsArray) {

        [allArray addObject:sportsModel];
    }
    
    return allArray;
}

/// 该运动是卡路里运动吗
+ (BOOL)isCalorie:(RLMSportsModel *)sportsModel {
    
    if (sportsModel.step > 0 && sportsModel.distance > 0) {
        return NO;
    } else {
        return YES;
    }
}

/// 运动名称
+ (NSString *)sportName:(FB_MOTIONMODE)MotionMode {
    
    switch (MotionMode) {
            
// 1 - 10
        case FBRunning:
            return LWLocalizbleString(@"Running"); //跑步｜Running
            break;
        case FBMountaineering:
            return LWLocalizbleString(@"Mountaineering"); //登山｜Mountaineering
            break;
        case FBCycling:
            return LWLocalizbleString(@"Cycling"); //骑行｜Cycling
            break;
        case FBFootball:
            return LWLocalizbleString(@"Football"); //足球｜Football
            break;
        case FBSwimming:
            return LWLocalizbleString(@"Swimming"); //游泳｜Swimming
            break;
        case FBBasketball:
            return LWLocalizbleString(@"Basketball"); //篮球｜Basketball
            break;
        case FBNo_designation:
            return LWLocalizbleString(@"No designation"); //无指定｜No designation
            break;
        case FBOutdoor_running:
            return LWLocalizbleString(@"Outdoor running"); //户外跑步｜Outdoor running
            break;
        case FBIndoor_running:
            return LWLocalizbleString(@"Indoor running"); //室内跑步｜Indoor running
            break;
        case FBFat_reduction_running:
            return LWLocalizbleString(@"Fat reduction running"); //减脂跑步｜Fat reduction running
            break;
            
// 11 - 20
        case FBOutdoor_walking:
            return LWLocalizbleString(@"Outdoor walking"); //户外健走｜Outdoor walking
            break;
        case FBIndoor_walking:
            return LWLocalizbleString(@"Indoor walking"); //室内健走｜Indoor walking
            break;
        case FBOutdoor_cycling:
            return LWLocalizbleString(@"Outdoor cycling"); //户外骑行｜Outdoor cycling
            break;
        case FBIndoor_cycling:
            return LWLocalizbleString(@"Indoor cycling"); //室内骑行｜Indoor cycling
            break;
        case FBFree_training:
            return LWLocalizbleString(@"Free training"); //自由训练｜Free training
            break;
        case FBFitness_training:
            return LWLocalizbleString(@"Fitness training"); //健身训练｜Fitness training
            break;
        case FBBadminton:
            return LWLocalizbleString(@"Badminton"); //羽毛球｜Badminton
            break;
        case FBVolleyball:
            return LWLocalizbleString(@"Volleyball"); //排球｜Volleyball
            break;
        case FBTable_Tennis:
            return LWLocalizbleString(@"Table Tennis"); //乒乓球｜Table Tennis
            break;
        case FBElliptical_machine:
            return LWLocalizbleString(@"Elliptical machine"); //椭圆机｜Elliptical machine
            break;

// 21 - 30
        case FBRowing_machine:
            return LWLocalizbleString(@"Rowing machine"); //划船机｜Rowing machine
            break;
        case FBYoga_training:
            return LWLocalizbleString(@"Yoga"); //瑜伽｜Yoga
            break;
        case FBStrength_training:
            return LWLocalizbleString(@"Strength training (weightlifting)"); //力量训练（举重）｜Strength training (weightlifting)
            break;
        case FBCricket:
            return LWLocalizbleString(@"Cricket"); //板球｜Cricket
            break;
        case FBRope_skipping:
            return LWLocalizbleString(@"Rope skipping"); //跳绳｜Rope skipping
            break;
        case FBAerobic_exercise:
            return LWLocalizbleString(@"Aerobic exercise"); //有氧运动｜Aerobic exercise
            break;
        case FBAerobic_dancing:
            return LWLocalizbleString(@"Aerobic dancing"); //健身舞｜Aerobic dancing
            break;
        case FBTaiji_boxing:
            return LWLocalizbleString(@"Tai Chi"); //太极｜Tai Chi
            break;
        case FBAuto_runing:
            return LWLocalizbleString(@"Automatically recognize running"); //自动识别跑步运动｜Automatically recognize running
            break;
        case FBAuto_walking:
            return LWLocalizbleString(@"Automatic recognition of walking movement"); //自动识别健走运动｜Automatic recognition of walking movement
            break;
            
// 31 - 40
        case FBWALK:
            return LWLocalizbleString(@"Indoor walking"); //室内步行｜Indoor walking
            break;
        case FBSTEP_TRAINING:
            return LWLocalizbleString(@"Step training"); //踏步｜Step training
            break;
        case FBHORSE_RIDING:
            return LWLocalizbleString(@"Ride a horse"); //骑马｜Ride a horse
            break;
        case FBHOCKEY:
            return LWLocalizbleString(@"Hockey"); //曲棍球｜Hockey
            break;
        case FBINDOOR_CYCLE:
            return LWLocalizbleString(@"Aerodyne bike"); //室内单车｜Aerodyne bike
            break;
        case FBSHUTTLECOCK:
            return LWLocalizbleString(@"Shuttlecock"); //毽球｜Shuttlecock
            break;
        case FBBOXING:
            return LWLocalizbleString(@"Boxing"); //拳击｜Boxing
            break;
        case FBOUTDOOR_WALK:
            return LWLocalizbleString(@"Outdoor walk"); //户外走｜Outdoor walk
            break;
        case FBTRAIL_RUNNING:
            return LWLocalizbleString(@"Cross country running"); //越野跑｜Cross country running
            break;
        case FBSKIING:
            return LWLocalizbleString(@"Skiing"); //滑雪｜Skiing
            break;
            
// 41 - 50
        case FBGYMNASTICS:
            return LWLocalizbleString(@"Artistic Gymnastics"); //体操｜Artistic Gymnastics
            break;
        case FBICE_HOCKEY:
            return LWLocalizbleString(@"Ice hockey"); //冰球｜Ice hockey
            break;
        case FBTAEKWONDO:
            return LWLocalizbleString(@"Taekwondo"); //跆拳道｜Taekwondo
            break;
        case FBVO2MAX_TEST:
            return LWLocalizbleString(@"Aerobic exercise"); //有氧运动｜Aerobic exercise
            break;
        case FBAIR_WALKER:
            return LWLocalizbleString(@"Walking machine"); //漫步机｜Walking machine
            break;
        case FBHIKING:
            return LWLocalizbleString(@"On foot"); //徒步｜On foot
            break;
        case FBTENNIS:
            return LWLocalizbleString(@"Tennis"); //网球｜Tennis
            break;
        case FBDANCE:
            return LWLocalizbleString(@"Dance"); //跳舞｜Dance
            break;
        case FBTRACK_FIELD:
            return LWLocalizbleString(@"Athletics"); //田径｜Athletics
            break;
        case FBABDOMINAL_TRAINING:
            return LWLocalizbleString(@"Lumbar abdominal movement"); //腰腹运动｜Lumbar abdominal movement
            break;

// 51 - 60
        case FBKARATE:
            return LWLocalizbleString(@"Karate"); //空手道｜Karate
            break;
        case FBCOOLDOWN:
            return LWLocalizbleString(@"Organize and relax"); //整理放松｜Organize and relax
            break;
        case FBCROSS_TRAINING:
            return LWLocalizbleString(@"Cross training"); //交叉训练｜Cross training
            break;
        case FBPILATES:
            return LWLocalizbleString(@"Pilates"); //普拉提｜Pilates
            break;
        case FBCROSS_FIT:
            return LWLocalizbleString(@"Cross fit"); //交叉配合｜Cross fit
            break;
        case FBUNCTIONAL_TRAINING:
            return LWLocalizbleString(@"Functional training"); //功能性训练｜Functional training
            break;
        case FBPHYSICAL_TRAINING:
            return LWLocalizbleString(@"Physical training"); //体能训练｜Physical training
            break;
        case FBARCHERY:
            return LWLocalizbleString(@"Archery"); //射箭｜Archery
            break;
        case FBFLEXIBILITY:
            return LWLocalizbleString(@"Flexibility"); //柔韧度｜Flexibility
            break;
        case FBMIXED_CARDIO:
            return LWLocalizbleString(@"Mixed aerobic"); //混合有氧｜Mixed aerobic
            break;
            
// 61 - 70
        case FBLATIN_DANCE:
            return LWLocalizbleString(@"Hip hop"); //拉丁舞｜Hip hop
            break;
        case FBSTREET_DANCE:
            return LWLocalizbleString(@"Hip hop"); //街舞｜Hip hop
            break;
        case FBKICKBOXING:
            return LWLocalizbleString(@"Free fight"); //自由搏击｜Free fight
            break;
        case FBBARRE:
            return LWLocalizbleString(@"Ballet"); //芭蕾舞｜Ballet
            break;
        case FBAUSTRALIAN_FOOTBALL:
            return LWLocalizbleString(@"Australian football"); //澳式足球｜Australian football
            break;
        case FBMARTIAL_ARTS:
            return LWLocalizbleString(@"Martial arts"); //武术｜Martial arts
            break;
        case FBSTAIRS:
            return LWLocalizbleString(@"Climb a building"); //爬楼｜Climb a building
            break;
        case FBHANDBALL:
            return LWLocalizbleString(@"Handball"); //手球｜Handball
            break;
        case FBBASEBALL:
            return LWLocalizbleString(@"Baseball"); //棒球｜Baseball
            break;
        case FBBOWLING:
            return LWLocalizbleString(@"Bowling"); //保龄球｜Bowling
            break;
            
// 71 - 80
        case FBRACQUETBALL:
            return LWLocalizbleString(@"Squash"); //壁球｜Squash
            break;
        case FBCURLING:
            return LWLocalizbleString(@"Curling"); //冰壶｜Curling
            break;
        case FBHUNTING:
            return LWLocalizbleString(@"Go hunting"); //打猎｜Go hunting
            break;
        case FBSNOWBOARDING:
            return LWLocalizbleString(@"Snowboarding"); //单板滑雪｜Snowboarding
            break;
        case FBPLAY:
            return LWLocalizbleString(@"Leisure sports"); //休闲运动｜Leisure sports
            break;
        case FBAMERICAN_FOOTBALL:
            return LWLocalizbleString(@"American football"); //美式橄榄球｜American football
            break;
        case FBHAND_CYCLING:
            return LWLocalizbleString(@"Handcart"); //手摇车｜Handcart
            break;
        case FBFISHING:
            return LWLocalizbleString(@"Go fishing"); //钓鱼｜Go fishing
            break;
        case FBDISC_SPORTS:
            return LWLocalizbleString(@"Frisbee"); //飞盘｜Frisbee
            break;
        case FBRUGBY:
            return LWLocalizbleString(@"Rugby"); //橄榄球｜Rugby
            break;

// 81 - 90
        case FBGOLF:
            return LWLocalizbleString(@"Golf"); //高尔夫｜Golf
            break;
        case FBFOLK_DANCE:
            return LWLocalizbleString(@"Folk dance"); //民族舞｜Folk dance
            break;
        case FBDOWNHILL_SKIING:
            return LWLocalizbleString(@"Alpine skiing"); //高山滑雪｜Alpine skiing
            break;
        case FBSNOW_SPORTS:
            return LWLocalizbleString(@"Snow Sports"); //雪上运动｜Snow Sports
            break;
        case FBMIND_BODY:
            return LWLocalizbleString(@"Soothing meditation exercise"); //舒缓冥想类运动｜Soothing meditation exercise
            break;
        case FBCORE_TRAINING:
            return LWLocalizbleString(@"Core training"); //核心训练｜Core training
            break;
        case FBSKATING:
            return LWLocalizbleString(@"Core training"); //滑冰｜Core training
            break;
        case FBFITNESS_GAMING:
            return LWLocalizbleString(@"Fitness games"); //健身游戏｜Fitness games
            break;
        case FBAEROBICS:
            return LWLocalizbleString(@"Aerobics"); //健身操｜Aerobics
            break;
        case FBGROUP_TRAINING:
            return LWLocalizbleString(@"Group Gymnastics"); //团体操｜Group Gymnastics
            break;

// 91 - 100
        case FBKENDO:
            return LWLocalizbleString(@"Kickboxing"); //搏击操｜Kickboxing
            break;
        case FBLACROSSE:
            return LWLocalizbleString(@"Lacrosse"); //长曲棍球｜Lacrosse
            break;
        case FBROLLING:
            return LWLocalizbleString(@"Foam shaft fascia relax"); //泡沫轴筋膜放松｜Foam shaft fascia relax
            break;
        case FBWRESTLING:
            return LWLocalizbleString(@"Wrestling"); //摔跤｜Wrestling
            break;
        case FBFENCING:
            return LWLocalizbleString(@"Fencing"); //击剑｜Fencing
            break;
        case FBSOFTBALL:
            return LWLocalizbleString(@"Softball"); //垒球｜Softball
            break;
        case FBSINGLE_BAR:
            return LWLocalizbleString(@"Horizontal bar"); //单杠｜Horizontal bar
            break;
        case FBPARALLEL_BARS:
            return LWLocalizbleString(@"Parallel bars"); //双杠｜Parallel bars
            break;
        case FBROLLER_SKATING:
            return LWLocalizbleString(@"Roller-skating"); //轮滑｜Roller-skating
            break;
        case FBHULA_HOOP:
            return LWLocalizbleString(@"Hu la hoop"); //呼啦圈｜Hu la hoop
            break;
            
// 101 - 110
        case FBDARTS:
            return LWLocalizbleString(@"Darts"); //飞镖｜Darts
            break;
        case FBPICKLEBALL:
            return LWLocalizbleString(@"Pickleball"); //匹克球｜Pickleball
            break;
        case FBSIT_UP:
            return LWLocalizbleString(@"Abdominal curl"); //仰卧起坐｜Abdominal curl
            break;
        case FBHIIT:
            return LWLocalizbleString(@"HIIT"); //HIIT｜HIIT
            break;
        case FBWAIST_TRAINING:
            return LWLocalizbleString(@"Waist and abdomen training"); //腰腹训练｜Waist and abdomen training
            break;
        case FBTREADMILL:
            return LWLocalizbleString(@"Treadmill"); //跑步机｜Treadmill
            break;
        case FBBOATING:
            return LWLocalizbleString(@"Rowing"); //划船｜Rowing
            break;
        case FBJUDO:
            return LWLocalizbleString(@"Judo"); //柔道｜Judo
            break;
        case FBTRAMPOLINE:
            return LWLocalizbleString(@"Trampoline"); //蹦床｜Trampoline
            break;
        case FBSKATEBOARDING:
            return LWLocalizbleString(@"Skate"); //滑板｜Skate
            break;

// 111 - 120
        case FBHOVERBOARD:
            return LWLocalizbleString(@"Balance car"); //平衡车｜Balance car
            break;
        case FBBLADING:
            return LWLocalizbleString(@"Roller skating"); //溜旱冰｜Roller skating
            break;
        case FBPARKOUR:
            return LWLocalizbleString(@"Parkour"); //跑酷｜Parkour
            break;
        case FBDIVING:
            return LWLocalizbleString(@"Diving"); //跳水｜Diving
            break;
        case FBSURFING:
            return LWLocalizbleString(@"Surfing"); //冲浪｜Surfing
            break;
        case FBSNORKELING:
            return LWLocalizbleString(@"Snorkeling"); //浮潜｜Snorkeling
            break;
        case FBPULL_UP:
            return LWLocalizbleString(@"Pull up"); //引体向上｜Pull up
            break;
        case FBPUSH_UP:
            return LWLocalizbleString(@"Push up"); //俯卧撑｜Push up
            break;
        case FBPLANKING:
            return LWLocalizbleString(@"Plate support"); //平板支撑｜Plate support
            break;
        case FBROCK_CLIMBING:
            return LWLocalizbleString(@"Rock Climbing"); //攀岩｜Rock Climbing
            break;

// 121 - 130
        case FBHIGHTJUMP:
            return LWLocalizbleString(@"High jump"); //跳高｜High jump
            break;
        case FBBUNGEE_JUMPING:
            return LWLocalizbleString(@"Bungee jumping"); //蹦极｜Bungee jumping
            break;
        case FBLONGJUMP:
            return LWLocalizbleString(@"Long jump"); //跳远｜Long jump
            break;
        case FBSHOOTING:
            return LWLocalizbleString(@"Shooting"); //射击｜Shooting
            break;
        case FBMARATHON:
            return LWLocalizbleString(@"Marathon"); //马拉松｜Marathon
            break;
        case FBVO2MAXTEST:
            return LWLocalizbleString(@"VO2max test"); //最大摄氧量测试｜VO2max test
            break;
        case FBKITE_FLYING:
            return LWLocalizbleString(@"Kite Flying"); //放风筝｜Kite Flying
            break;
        case FBBILLIARDS:
            return LWLocalizbleString(@"Billiards"); //台球｜Billiards
            break;
        case FBCARDIO_CRUISER:
            return LWLocalizbleString(@"Cardio Cruiser"); //有氧运动巡洋舰｜Cardio Cruiser
            break;
        case FBTUGOFWAR:
            return LWLocalizbleString(@"Tug of war"); //拔河比赛｜Tug of war
            break;
            
// 131 - 139
        case FBFREESPARRING:
            return LWLocalizbleString(@"Free Sparring"); //免费的陪练｜Free Sparring
            break;
        case FBRAFTING:
            return LWLocalizbleString(@"Rafting"); //漂流｜Rafting
            break;
        case FBSPINNING:
            return LWLocalizbleString(@"Spinning"); //旋转｜Spinning
            break;
        case FBBMX:
            return LWLocalizbleString(@"BMX"); //BMX｜BMX
            break;
        case FBATV:
            return LWLocalizbleString(@"ATV"); //ATV｜ATV
            break;
        case FBDUMBBELL:
            return LWLocalizbleString(@"Dumbbell"); //哑铃｜Dumbbell
            break;
        case FBBEACHFOOTBALL:
            return LWLocalizbleString(@"Beach Football"); //沙滩足球｜Beach Football
            break;
        case FBKAYAKING:
            return LWLocalizbleString(@"Kayaking"); //皮划艇｜Kayaking
            break;
        case FBSAVATE:
            return LWLocalizbleString(@"Savate"); //法国式拳击｜Savate
            break;
            
        default:
            return @"x x x x x"; // 未知/新增
            break;
    }
}


#pragma mark - ❌ 查询某一天 某一类型的手动测量记录｜Query a certain day, a certain type of manual measurement records
/// queryDate为nil 即 查所有
+ (RLMResults <RLMManualMeasureModel *> *)QueryManualMeasurementRecordWithDate:(NSDate * _Nullable)queryDate dataType:(FBTestUIDataType)dataType deviceName:(NSString *)deviceName deviceMAC:(NSString *)deviceMAC {
    
    NSString *SQL = nil;
    if (queryDate) {
        SQL = [FBLoadDataObject SQL_StaTime:queryDate.Time_01 endTime:queryDate.Time_24 deviceName:deviceName deviceMAC:deviceMAC];
    } else {
        SQL = [FBLoadDataObject SQL_StaTime:0 endTime:NSDate.date.timeIntervalSince1970 deviceName:deviceName deviceMAC:deviceMAC];
    }
    
    NSString *SQL_Manual = nil;
    if (dataType == FBTestUIDataType_HeartRate) {
        SQL_Manual = [NSString stringWithFormat:@"%@ AND hr > 0", SQL];
    } else if (dataType == FBTestUIDataType_BloodOxygen) {
        SQL_Manual = [NSString stringWithFormat:@"%@ AND Sp02 > 0", SQL];
    } else if (dataType == FBTestUIDataType_BloodPressure) {
        SQL_Manual = [NSString stringWithFormat:@"%@ AND systolic > 0 AND diastolic > 0", SQL];
    } else if (dataType == FBTestUIDataType_Stress) {
        SQL_Manual = [NSString stringWithFormat:@"%@ AND stress > 0", SQL];
    }
    
    if (StringIsEmpty(SQL_Manual)) return nil;
    
    RLMResults <RLMManualMeasureModel *> *m_Results = [[RLMManualMeasureModel objectsWhere:SQL_Manual] sortedResultsUsingKeyPath:@"begin" ascending:YES];
    return m_Results;
}


#pragma mark - 查询本地历史数据（查询数据库）｜Query local historical data (Query Database)
/// 查询本地历史数据（查询数据库）｜Query local historical data (Query Database)
+ (void)QueryLocalHistoricalDataWithBlock:(void (^)(FBLocalHistoricalModel * _Nonnull))block {
    
    FBLocalHistoricalModel *historicalModel = FBLocalHistoricalModel.new;
    
    FBFirmwareVersionObject *object = FBAllConfigObject.firmwareConfig;
    
    NSString *SQL = FBLoadDataObject.SQL_CurrentDevice_All;
    
    
    // 今日24小时步数记录
    historicalModel.stepsArray = [FBLoadDataObject QueryStepCountRecordWithDate:NSDate.date deviceName:object.deviceName deviceMAC:object.mac];

    
    // 最近一条运动记录
    historicalModel.sportsModel = [[RLMSportsModel objectsWhere:FBLoadDataObject.SQL_CurrentDevice_All] sortedResultsUsingKeyPath:@"begin" ascending:YES].lastObject;
    historicalModel.sportsBegin = historicalModel.sportsModel.begin;
    
    
    // 心率
    // 自动数据
    RLMHeartRateModel *lastHr = [[RLMHeartRateModel objectsWhere:SQL] sortedResultsUsingKeyPath:@"begin" ascending:YES].lastObject;
    
    // 手动测量数据
    RLMManualMeasureModel *lastHr_M = [FBLoadDataObject QueryManualMeasurementRecordWithDate:nil dataType:FBTestUIDataType_HeartRate deviceName:object.deviceName deviceMAC:object.mac].lastObject;
    
    NSInteger hrBegin = lastHr.begin > lastHr_M.begin ? lastHr.begin : lastHr_M.begin;
    historicalModel.hrBegin = hrBegin;
    historicalModel.hr = hrBegin>0 ? [NSString stringWithFormat:@"%ld bpm", hrBegin==lastHr.begin ? lastHr.heartRate : lastHr_M.hr] : LWLocalizbleString(@"No Data");
    
    
    // 血氧
    // 自动数据
    RLMBloodOxygenModel *lastSpo2 = [[RLMBloodOxygenModel objectsWhere:SQL] sortedResultsUsingKeyPath:@"begin" ascending:YES].lastObject;
    
    // 手动测量数据
    RLMManualMeasureModel *lastSpo2_M = [FBLoadDataObject QueryManualMeasurementRecordWithDate:nil dataType:FBTestUIDataType_BloodOxygen deviceName:object.deviceName deviceMAC:object.mac].lastObject;
    
    NSInteger spo2Begin = lastSpo2.begin > lastSpo2_M.begin ? lastSpo2.begin : lastSpo2_M.begin;
    historicalModel.spo2Begin = spo2Begin;
    historicalModel.spo2 = spo2Begin>0 ? [NSString stringWithFormat:@"%ld%%", spo2Begin==lastSpo2.begin ? lastSpo2.bloodOxygen : lastSpo2_M.Sp02] : LWLocalizbleString(@"No Data");
    
    
    // 血压
    // 自动数据
    RLMBloodPressureModel *lastBp = [[RLMBloodPressureModel objectsWhere:SQL] sortedResultsUsingKeyPath:@"begin" ascending:YES].lastObject;
    
    // 手动测量数据
    RLMManualMeasureModel *lastBp_M = [FBLoadDataObject QueryManualMeasurementRecordWithDate:nil dataType:FBTestUIDataType_BloodPressure deviceName:object.deviceName deviceMAC:object.mac].lastObject;
    
    NSInteger bpBegin = lastBp.begin > lastBp_M.begin ? lastBp.begin : lastBp_M.begin;
    historicalModel.bpBegin = bpBegin;
    historicalModel.bp = bpBegin>0 ? [NSString stringWithFormat:@"%@ mmHg", bpBegin==lastBp.begin ? [NSString stringWithFormat:@"%ld/%ld", lastBp.systolic, lastBp.diastolic] : [NSString stringWithFormat:@"%ld/%ld", lastBp_M.systolic, lastBp_M.diastolic]] : LWLocalizbleString(@"No Data");

    
    // 精神压力
    // 自动数据
    RLMStressModel *lastStress = [[RLMStressModel objectsWhere:SQL] sortedResultsUsingKeyPath:@"begin" ascending:YES].lastObject;
    
    // 手动测量数据
    RLMManualMeasureModel *lastStress_M = [FBLoadDataObject QueryManualMeasurementRecordWithDate:nil dataType:FBTestUIDataType_Stress deviceName:object.deviceName deviceMAC:object.mac].lastObject;
    
    NSInteger stressBegin =  lastStress.begin > lastStress_M.begin ? lastStress.begin : lastStress_M.begin;
    historicalModel.stressBegin = stressBegin;
    historicalModel.stress = stressBegin>0 ? (stressBegin==lastStress.begin ? [NSString stringWithFormat:@"%ld %@", lastStress.stress, [FBLoadDataObject stress:lastStress.stress range:lastStress.StressRange]] : [NSString stringWithFormat:@"%ld %@", lastStress_M.stress, [FBLoadDataObject stress:lastStress_M.stress range:lastStress_M.StressRange]]) : LWLocalizbleString(@"No Data");
    
    // 睡眠
    NSInteger sleepBegin = 0;
    NSString *SQL_Sleep = [NSString stringWithFormat:@"%@ AND SleepState != %d AND SleepState != %d", SQL, RLM_Awake, RLM_Nap_Awake];
    RLMSleepModel *lastSleep = [[RLMSleepModel objectsWhere:SQL_Sleep] sortedResultsUsingKeyPath:@"begin" ascending:YES].lastObject;
    if (lastSleep) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:lastSleep.begin];
        // 比如 2023-05-12 21:30 至 2023-05-13 21:29 的数据，它是属于 2023-05-13 的睡眠数据
        // 所以这里 2023-05-12 21:30 至 2023-05-13 00:00 之间的睡眠时间，都算是隔天的睡眠数据
        if (lastSleep.begin >= (date.Time_24-2.5*3600) && lastSleep.begin < date.Time_24) {
            date = [NSDate dateWithTimeIntervalSince1970:(date.Time_24+2)];
        }
        sleepBegin = date.timeIntervalSince1970;
    }
    historicalModel.sleepBegin = sleepBegin;
    
    if (sleepBegin > 0) {
        
        NSArray <FBSleepItem *> *array = [FBLoadDataObject QuerySleepCountRecordWithDate:[NSDate dateWithTimeIntervalSince1970:sleepBegin] deviceName:object.deviceName deviceMAC:object.mac];
                
        NSInteger totalSleep = 0; // 睡眠总时长
        for (FBSleepItem *item in array) {
            if (item.SleepState != RLM_Awake && item.SleepState != RLM_Nap_Awake) {
                totalSleep += item.duration;
            }
        }
        historicalModel.sleep = [Tools HM: totalSleep * 60];
        
    } else {
        historicalModel.sleep = LWLocalizbleString(@"No Data");
    }
    
    if (block) {
        block(historicalModel);
    }
}

@end


@implementation FBTestUIBaseListModel
@end

@implementation FBTestUIBaseListSection
@end

@implementation FBStepItem
@end

@implementation FBHrItem
@end

@implementation FBSpo2Item
@end

@implementation FBBpItem
@end

@implementation FBStressItem
@end

@implementation FBSleepItem
@end
