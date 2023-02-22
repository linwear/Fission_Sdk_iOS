//
//  LWPersonModel.h
//  LinWear
//
//  Created by 裂变智能 on 2021/12/20.
//  Copyright © 2021 lw. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWPersonModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *phoneNumber;

@property (nonatomic, assign) BOOL isSelect;

@end

NS_ASSUME_NONNULL_END
