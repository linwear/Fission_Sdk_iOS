//
//  FBTestUITodayDataCell.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/5/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBTestUITodayDataCell : UICollectionViewCell

- (void)realTimeDataStreamWithStep:(NSInteger)currentStep calories:(NSInteger)currentCalories distance:(NSInteger)currentDistance;

- (void)reloadCellModel:(FBLocalHistoricalModel *)model click:(void(^)(FBTestUIDataType dataType))block;

@end

NS_ASSUME_NONNULL_END
