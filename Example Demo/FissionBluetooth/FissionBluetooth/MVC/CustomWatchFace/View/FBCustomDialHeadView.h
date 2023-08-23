//
//  FBCustomDialHeadView.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-05-30.
//

#import <UIKit/UIKit.h>

@class FBCustomDialPointModel;

NS_ASSUME_NONNULL_BEGIN

@interface FBCustomDialHeadView : UIView

/// 刷新
- (void)reloadWithSoures:(NSArray <FBCustomDialSoures *> *)selectSoures withColor:(UIColor *)color firstTime:(BOOL)isFirstTime;

/// 生成自定义表盘数据
- (FBMultipleCustomDialsModel *)generateCustomWatchFaceData;

@end


@interface FBCustomDialPointModel : NSObject

@property (nonatomic, assign) FBCustomDialListItemsEvent itemEvent;

@property (nonatomic, assign) BOOL isModule; // 电池电量、蓝牙为NO

@property (nonatomic, assign) CGPoint point;

@end

NS_ASSUME_NONNULL_END
