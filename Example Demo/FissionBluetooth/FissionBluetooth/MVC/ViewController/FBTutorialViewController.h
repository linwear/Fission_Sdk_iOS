//
//  FBTutorialViewController.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/3/10.
//

#import "LWBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FBTutorialViewController : LWBaseViewController

@property (nonatomic, assign) BOOL isFirmware;

@end

@interface FBTutorialItemModel : NSObject

@property (nonatomic, copy) NSString *imageName;

@property (nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
