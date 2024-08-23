//
//  LWContactViewController.h
//  LinWear
//
//  Created by 裂变智能 on 2022/11/11.
//  Copyright © 2022 lw. All rights reserved.
//

#import "LWBaseViewController.h"
#import <Contacts/Contacts.h>
#import "LWPersonModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LWSelectedPersonBlock)(NSArray <LWPersonModel *> * _Nullable selectedArray);

@interface LWContactViewController : LWBaseViewController

- (instancetype)initWithSelectedArray:(NSArray <LWPersonModel *> * _Nullable)selectedArray max:(int)max withBlock:(LWSelectedPersonBlock)selectedPersonBlock;

@end

NS_ASSUME_NONNULL_END
