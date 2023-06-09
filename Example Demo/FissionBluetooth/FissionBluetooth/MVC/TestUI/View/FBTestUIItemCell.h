//
//  FBTestUIItemCell.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/5/5.
//

#import <UIKit/UIKit.h>
#import "FBTestUIItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FBTestUIItemCell : UICollectionViewCell

- (void)reloadItem:(FBTestUIItemModel *)item;

@end

NS_ASSUME_NONNULL_END
