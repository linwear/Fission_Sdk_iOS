//
//  FBBatteryView.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/3/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBBatteryView : UIView

/// 电量
@property (nonatomic, assign) NSInteger battery;

/// 电池状态
@property (nonatomic, assign) FB_BATTERYLEVEL level;

/// 刷新电量
- (void)reloadBattery:(NSInteger)battery state:(FB_BATTERYLEVEL)level;

@end

NS_ASSUME_NONNULL_END
