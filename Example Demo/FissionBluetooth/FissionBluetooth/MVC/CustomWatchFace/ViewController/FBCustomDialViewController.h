//
//  FBCustomDialViewController.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-05-30.
//

#import "LWBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FBCustomDialViewController : LWBaseViewController <JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>

- (instancetype)initWithResource:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
