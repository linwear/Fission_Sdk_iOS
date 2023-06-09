//
//  FBClockDialCategoryViewController.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/3/6.
//

#import "LWBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FBClockDialCategoryViewController : LWBaseViewController

@end


@interface FBClockDialCategoryModel : NSObject
@property (nonatomic, assign) NSInteger plateClassify;
@property (nonatomic, copy) NSString *plateClassifyName;
@end

NS_ASSUME_NONNULL_END
