//
//  LWMotionPushCell.h
//  LinWear
//
//  Created by 裂变智能 on 2021/11/1.
//  Copyright © 2021 lw. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWMotionPushCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@end

NS_ASSUME_NONNULL_END
