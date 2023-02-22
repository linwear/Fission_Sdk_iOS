//
//  LWLanguageLocalizble.m
//  LinWear
//
//  Created by 裂变智能 on 2022/8/30.
//  Copyright © 2022 lw. All rights reserved.
//

#import "LWLanguageLocalizble.h"

@interface LWLanguageLocalizble ()
@property (nonatomic, strong) NSBundle *languageBundle;
@end

@implementation LWLanguageLocalizble

/// 实例化
+ (LWLanguageLocalizble *)sharedInstance {
    static LWLanguageLocalizble *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = LWLanguageLocalizble.new;
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {

        NSString *systemLanguage = [NSLocale preferredLanguages].firstObject; // 系统当前语言
        NSString *language = nil; // 语言重定向
        
        if ([systemLanguage hasPrefix:@"zh"]) {      // 中文
            language = @"zh-Hans";
        }
        else {
            language = @"en"; // 其他不支持语种，默认英文...
        }
        
        // 获取多语言文件Bundle
        NSBundle *languageBundle = [NSBundle bundleWithPath:[NSBundle.mainBundle pathForResource:language ofType:@"lproj"]];
        self.languageBundle = languageBundle;
    }
    return self;
}

/// 多语言key
- (NSString * _Nullable)localizedString:(NSString * _Nonnull)key {
    
    NSString *language = NSLocalizedStringFromTableInBundle(key, @"Localizable", self.languageBundle, nil); // Bundle中对应key的翻译
    
    return language;
}

@end
