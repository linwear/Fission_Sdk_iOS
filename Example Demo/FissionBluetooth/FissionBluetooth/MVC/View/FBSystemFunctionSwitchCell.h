//
//  FBSystemFunctionSwitchCell.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-07-07.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBSystemFunctionSwitchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *select;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UISwitch *swi;

- (void)callBack:(void(^)(BOOL enable))block;

@end

NS_ASSUME_NONNULL_END
