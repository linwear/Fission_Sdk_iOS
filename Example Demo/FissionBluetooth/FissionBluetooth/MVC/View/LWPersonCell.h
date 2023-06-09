//
//  LWPersonCell.h
//  LinWear
//
//  Created by 裂变智能 on 2021/12/20.
//  Copyright © 2021 lw. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWPersonCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *tel;

@property (weak, nonatomic) IBOutlet UIImageView *choice;
@property (weak, nonatomic) IBOutlet UIView *line;

@end

NS_ASSUME_NONNULL_END
