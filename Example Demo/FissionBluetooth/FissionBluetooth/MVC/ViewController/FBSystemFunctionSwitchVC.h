//
//  FBSystemFunctionSwitchVC.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-07-07.
//

#import "LWBaseViewController.h"

@class FBSFSwitchModel;

NS_ASSUME_NONNULL_BEGIN

@interface FBSystemFunctionSwitchVC : LWBaseViewController

@end

@interface FBSFSwitchModel : NSObject

/// 是否被选中
@property (nonatomic, assign) BOOL isSelect;

/// 显示名称
@property (nonatomic, copy) NSString *title;

/// 类型
@property (nonatomic, assign) FB_CUSTOMSETTINGSWITCHTYPE switchType;

/// 开关
@property (nonatomic, assign) BOOL enable;

@end

NS_ASSUME_NONNULL_END
