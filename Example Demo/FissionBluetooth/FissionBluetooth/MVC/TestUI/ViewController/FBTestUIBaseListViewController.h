//
//  FBTestUIBaseListViewController.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/5/12.
//

#import "LWBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FBTestUIBaseListViewController : LWBaseViewController

- (instancetype)initWithDataType:(FBTestUIDataType)dataType queryDate:(NSDate *)queryDate title:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
