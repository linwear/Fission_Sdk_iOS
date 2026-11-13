//
//  RTKAsynchronousInvocation.h
//  RTKLEFoundation
//
//  Created by Jerome Gu on 2024/5/15.
//  Copyright (c) 2024, Realtek Semiconductor Corporation. All rights reserved.
//
//  SPDX-License-Identifier: LicenseRef-Realtek-5-Clause
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// APIs can be used to customize asynchronous dispatch behaviour.
@interface RTKAsynchronousInvocation : NSObject

/// The GCD dispatch queue used to report events and internal process.
///
/// The SDK uses an internal queue by default. You can specify an other one instead through this property.
@property (class) dispatch_queue_t dispatchQueue;

/// Execute a specified block on the dispatch queue synchronously
///
/// If the calling code is already running on the queue, the block is called directly.
+ (void)executeSynchronously: (dispatch_block_t)block;

@end

NS_ASSUME_NONNULL_END
