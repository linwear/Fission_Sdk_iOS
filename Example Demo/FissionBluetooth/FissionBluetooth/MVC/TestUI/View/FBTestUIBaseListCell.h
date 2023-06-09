//
//  FBTestUIBaseListCell.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-06-06.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBTestUIBaseListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *valueLab;

@end

NS_ASSUME_NONNULL_END
