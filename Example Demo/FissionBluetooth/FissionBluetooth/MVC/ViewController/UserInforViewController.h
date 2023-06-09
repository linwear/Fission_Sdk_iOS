//
//  UserInforViewController.h
//  WP-810-Dome2
//
//  Created by ChenFan on 2019/3/27.
//  Copyright © 2019年 steven. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInforViewController : LWBaseViewController
@property (nonatomic,strong) FBUserInforModel * userInfoModel;

@end

@interface UserInforViewCell : UITableViewCell
@property (nonatomic,strong) UILabel * titelLab;
@property (nonatomic,strong) UITextField * textField;
@property (nonatomic,strong) UIButton * leftBtn;
@property (nonatomic,strong) UIButton * rightBtn;
@property (nonatomic,assign) BOOL  isFemale;

@property (nonatomic,strong) NSIndexPath * indexPath;
@property (nonatomic,strong) FBUserInforModel * userInfoModel;
@property (nonatomic,copy) void(^sexBlock)(int sex);

@end

NS_ASSUME_NONNULL_END
