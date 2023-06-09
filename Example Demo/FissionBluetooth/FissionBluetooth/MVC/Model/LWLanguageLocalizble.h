//
//  LWLanguageLocalizble.h
//  LinWear
//
//  Created by 裂变智能 on 2022/8/30.
//  Copyright © 2022 lw. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define LWLocalizbleString(key) [LWLanguageLocalizble.sharedInstance localizedString:key]

@interface LWLanguageLocalizble : NSObject

/// 实例化
+ (LWLanguageLocalizble *)sharedInstance;

/// 多语言key
- (NSString * _Nullable)localizedString:(NSString * _Nonnull)key;

@end

NS_ASSUME_NONNULL_END
