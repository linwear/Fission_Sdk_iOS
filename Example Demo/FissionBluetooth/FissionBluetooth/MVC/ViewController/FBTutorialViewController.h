//
//  FBTutorialViewController.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/3/10.
//

#import "LWBaseViewController.h"

typedef NS_ENUM(NSInteger, FBTutorialType) {
    FBTutorialType_Firmware,
    FBTutorialType_AutomaticOTA,
    FBTutorialType_JSApp,
};

NS_ASSUME_NONNULL_BEGIN

@interface FBTutorialViewController : LWBaseViewController

@property (nonatomic, assign) FBTutorialType tutorialType;

@end

@interface FBTutorialItemModel : NSObject

@property (nonatomic, copy) NSString *imageName;

@property (nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
