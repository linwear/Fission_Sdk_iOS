//
//  RTKPackageIDGenerator.h
//  RTKLEFoundation
//
//  Created by jerome_gu on 2019/1/11.
//  Copyright (c) 2019, Realtek Semiconductor Corporation. All rights reserved.
//
//  SPDX-License-Identifier: LicenseRef-Realtek-5-Clause
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RTKPackageIDGenerator<NSObject>
- (void)reset;
- (NSInteger)nextID;
@end

@interface RTKIncrementalGenerator : NSObject <RTKPackageIDGenerator>

@property (readonly) NSInteger minID;
@property (readonly) NSInteger maxID;
@property (readonly) NSInteger curID;

+ (instancetype)sharedGenerator;

- (instancetype)initWithMinID:(NSInteger)min maxID:(NSInteger)max;

@end

NS_ASSUME_NONNULL_END
