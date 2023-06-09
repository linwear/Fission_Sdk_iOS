//
//  FBTestUIOverviewCell.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-06-05.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBTestUIOverviewCell : UITableViewCell

- (void)reloadOverviewModel:(NSArray <FBTestUIOverviewModel *> *)overviewArray;

@end

NS_ASSUME_NONNULL_END
