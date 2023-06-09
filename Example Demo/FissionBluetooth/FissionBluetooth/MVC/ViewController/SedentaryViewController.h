//
//  SedentaryViewController.h
//  WP-810-Dome2
//
//  Created by ChenFan on 2019/3/27.
//  Copyright © 2019年 steven. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SedentaryViewController : LWBaseViewController

@end

@interface SedentaryCellOne : UITableViewCell
@property (nonatomic,strong) UILabel * titelLab;
@property (nonatomic,strong) UISwitch * swtch;
@property (nonatomic,copy) void(^swtchBlock)(BOOL ret);

@end

@interface SedentaryCellTwo : UITableViewCell
@property (nonatomic,strong) UILabel * titelLab;
@property (nonatomic,strong) UITextField * textField;
@property (nonatomic,strong) UILabel * unitLab;

@end

@interface SedentaryCellThree : UITableViewCell
@property (nonatomic,strong) UILabel *titelLab;
@property (nonatomic,strong) UITextField * textField1;
@property (nonatomic,strong) UITextField * textField2;
@property (nonatomic,strong) UILabel * centerLab;

@end

NS_ASSUME_NONNULL_END
