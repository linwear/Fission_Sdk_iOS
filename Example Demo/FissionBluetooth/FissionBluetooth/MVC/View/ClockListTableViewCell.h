//
//  ClockListTableViewCell.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/4/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClockListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *week;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UISwitch *swi;
- (void)cellModel:(id)model isSchedule:(BOOL)isSchedule;

@end

NS_ASSUME_NONNULL_END
