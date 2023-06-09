//
//  FBTestUIItemModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/5/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBTestUIItemModel : NSObject

@property (nonatomic, assign) FBTestUIDataType dataType;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *gif;

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, strong) UIColor *gradientAColor;

@property (nonatomic, strong) UIColor *gradientBColor;

@end

NS_ASSUME_NONNULL_END
