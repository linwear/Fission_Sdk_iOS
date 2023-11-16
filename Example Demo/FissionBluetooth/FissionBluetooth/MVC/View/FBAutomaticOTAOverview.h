//
//  FBAutomaticOTAOverview.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-11-02.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^FBAutomaticOTAOverviewBlock)(void);

@interface FBAutomaticOTAOverview : UIView

- (instancetype)initWithFrame:(CGRect)frame overviewBlock:(FBAutomaticOTAOverviewBlock)overviewBlock;

@property (nonatomic, strong) UILabel *NG;
@property (nonatomic, strong) UILabel *ALL;
@property (nonatomic, strong) UILabel *OK;

@property (nonatomic, copy) FBAutomaticOTAOverviewBlock overviewBlock;

@end

NS_ASSUME_NONNULL_END
