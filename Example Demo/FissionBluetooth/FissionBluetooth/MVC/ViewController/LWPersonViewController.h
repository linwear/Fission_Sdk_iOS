//
//  LWPersonViewController.h
//  LinWear
//
//  Created by 裂变智能 on 2021/12/18.
//  Copyright © 2021 lw. All rights reserved.
//

#import "LWBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWPersonViewController : LWBaseViewController

- (instancetype)initWithFrequentContacts:(BOOL)isFav max:(int)max;

@end

NS_ASSUME_NONNULL_END
