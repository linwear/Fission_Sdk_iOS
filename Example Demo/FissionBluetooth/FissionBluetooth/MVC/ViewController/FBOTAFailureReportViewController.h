//
//  FBOTAFailureReportViewController.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-11-04.
//

#import "LWBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class FBAutomaticOTAFailureModel;

@interface FBOTAFailureReportViewController : LWBaseViewController

@property (nonatomic, strong) NSArray <FBAutomaticOTAFailureModel *> *failureSource;

@end


@interface FBAutomaticOTAFailureModel : NSObject

@property (nonatomic, assign) NSInteger errorCode;
@property (nonatomic, copy) NSString *errorString;
@property (nonatomic, assign) NSInteger errorCount;

@end

NS_ASSUME_NONNULL_END
