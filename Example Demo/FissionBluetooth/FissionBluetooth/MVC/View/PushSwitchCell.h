//
//  PushSwitchCell.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/1/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^PushSwitchStaBlock)(BOOL isOn);
@interface PushSwitchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellLab;
@property (weak, nonatomic) IBOutlet UISwitch *cellSwi;
@property (nonatomic, copy) PushSwitchStaBlock pushSwitchStaBlock;
@end

NS_ASSUME_NONNULL_END
