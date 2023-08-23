//
//  FBTestUISportsPaceRatioCell.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-08-07.
//

#import <UIKit/UIKit.h>

@class FBTestUISportsPaceRatioModel;

NS_ASSUME_NONNULL_BEGIN

@interface FBTestUISportsPaceRatioCell : UITableViewCell

@property (nonatomic, strong) FBTestUISportsPaceRatioModel *paceRatioModel;

@end

@interface FBTestUISportsPaceRatioModel : NSObject
@property (nonatomic, assign) int index;
@property (nonatomic, assign) NSInteger pace;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat ratio;
@property (nonatomic, copy) NSString *text;
@end

NS_ASSUME_NONNULL_END
