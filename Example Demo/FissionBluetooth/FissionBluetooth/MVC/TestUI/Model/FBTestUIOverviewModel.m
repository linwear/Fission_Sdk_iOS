//
//  FBTestUIOverviewModel.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-06-06.
//

#import "FBTestUIOverviewModel.h"

@implementation FBTestUIOverviewModel

- (instancetype)initWithTitle:(NSString *)title value:(NSString *)value {
    if (self = [super init]) {
        self.title = title;
        self.value = value;
    }
    return self;
}

@end
