//
//  FBTestUITodayDataCell.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/5/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBTestUITodayDataCell : UICollectionViewCell

- (void)step:(NSInteger)step calories:(NSInteger)calories distance:(NSInteger)distance;

- (void)reloadCellModel:(FBLocalHistoricalModel *)model click:(void(^)(FBTestUIDataType dataType))block;

@end

NS_ASSUME_NONNULL_END
