//
//  MotionPushCollectionViewCell.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/2/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MotionPushCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet SDAnimatedImageView *ima;
@property (weak, nonatomic) IBOutlet UILabel *tit;

@end

NS_ASSUME_NONNULL_END
