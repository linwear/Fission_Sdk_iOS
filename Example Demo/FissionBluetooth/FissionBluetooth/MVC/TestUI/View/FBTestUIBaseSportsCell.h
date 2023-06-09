//
//  FBTestUIBaseSportsCell.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-05-29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBTestUIBaseSportsCell : UITableViewCell

- (void)refreshModel:(RLMSportsModel *)sportsModel hiddenLine:(BOOL)isHidden;

@end

NS_ASSUME_NONNULL_END
