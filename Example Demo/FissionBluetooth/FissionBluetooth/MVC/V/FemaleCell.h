//
//  FemaleCell.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/6/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^FemaleCellBlock)(NSInteger type);

@interface FemaleCell : UITableViewCell

@property (nonatomic, copy) FemaleCellBlock femaleCellBlock;

@property (nonatomic, retain) FBFemalePhysiologyModel *model;

@property (weak, nonatomic) IBOutlet UIButton *but1;

@property (weak, nonatomic) IBOutlet UIButton *but2;

@property (weak, nonatomic) IBOutlet UIButton *but3;

@property (weak, nonatomic) IBOutlet UIButton *but4;

@property (weak, nonatomic) IBOutlet UIButton *but5;

@property (weak, nonatomic) IBOutlet UIButton *but6;

@property (weak, nonatomic) IBOutlet UIButton *but7;

@property (weak, nonatomic) IBOutlet UISwitch *swi;

@end

NS_ASSUME_NONNULL_END
