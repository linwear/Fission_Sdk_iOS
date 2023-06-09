//
//  FBTestUIOverviewModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-06-06.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBTestUIOverviewModel : NSObject

- (instancetype)initWithTitle:(NSString *)title value:(NSString *)value;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *value;

@end

NS_ASSUME_NONNULL_END
