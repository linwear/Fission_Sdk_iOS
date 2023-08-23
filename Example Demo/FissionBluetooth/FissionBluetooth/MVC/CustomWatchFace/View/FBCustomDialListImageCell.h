//
//  FBCustomDialListImageCell.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-06-01.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBCustomDialListImageCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@property (weak, nonatomic) IBOutlet UIImageView *markImage;

// 上下左右 边距
@property (nonatomic, assign) CGFloat edgeInsets;

@end

NS_ASSUME_NONNULL_END
