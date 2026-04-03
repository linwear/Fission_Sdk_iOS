//
//  NSData+Generation.h
//  RTKLEFoundation
//
//  Created by jerome_gu on 2021/12/17.
//  Copyright (c) 2021, Realtek Semiconductor Corporation. All rights reserved.
//
//  SPDX-License-Identifier: LicenseRef-Realtek-5-Clause
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Generation)

+ (NSData *)dataByRandomBytesWithLength:(NSUInteger)length;

@end

NS_ASSUME_NONNULL_END
