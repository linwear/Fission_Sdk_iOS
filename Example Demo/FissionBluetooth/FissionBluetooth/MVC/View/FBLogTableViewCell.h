//
//  FBLogTableViewCell.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/1/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBLogTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *detailLab;

@end

NS_ASSUME_NONNULL_END
