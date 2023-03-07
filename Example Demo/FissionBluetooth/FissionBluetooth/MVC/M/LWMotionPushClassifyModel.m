//
//  LWMotionPushClassifyModel.m
//  LinWear
//
//  Created by 裂变智能 on 2023/2/27.
//  Copyright © 2023 lw. All rights reserved.
//

#import "LWMotionPushClassifyModel.h"

@implementation LWMotionPushClassifyModel

@end


@implementation LWMotionPushModel

@end


@implementation LWMotionPushSectionModel

@end


@implementation LWMotionPushCellModel

- (instancetype)init {
    if (self = [super init]) {
        
        CGFloat itemW = (SCREEN_WIDTH-40-24)/4;
        
        self.itemSize = CGSizeMake(itemW, itemW + itemW/2);
        
        self.sectionInset = UIEdgeInsetsMake(6, 10, 6, 10);

        self.minimumLineSpacing = 6;

        self.minimumInteritemSpacing = 6;
    }
    return self;
}

@end
