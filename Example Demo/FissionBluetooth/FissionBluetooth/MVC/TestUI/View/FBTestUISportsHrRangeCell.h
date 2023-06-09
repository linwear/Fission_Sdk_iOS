//
//  FBTestUISportsHrRangeCell.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-06-02.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FBTestUISportsHrRangeModel;

@interface FBTestUISportsHrRangeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet QMUIPieProgressView *progress;
@property (weak, nonatomic) IBOutlet UILabel *point;

@property (nonatomic, strong) FBTestUISportsHrRangeModel *hrRangeModel;

@end

@interface FBTestUISportsHrRangeModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) UIColor *color;

@end

NS_ASSUME_NONNULL_END
