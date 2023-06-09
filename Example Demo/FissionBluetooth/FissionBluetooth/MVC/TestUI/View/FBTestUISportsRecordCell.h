//
//  FBTestUISportsRecordCell.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/5/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBTestUISportsRecordCell : UICollectionViewCell

- (void)reloadCellModel:(RLMSportsModel *)sportsModel;

@end

NS_ASSUME_NONNULL_END
