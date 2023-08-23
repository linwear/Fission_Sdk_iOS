//
//  FBCustomDialListHeadrView.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-06-01.
//

#import "FBCustomDialListHeadrView.h"

@implementation FBCustomDialListHeadrView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorClear;
        
        UILabel *textLabel = [[UILabel alloc] qmui_initWithFont:[NSObject BahnschriftFont:16] textColor:UIColorBlack];
        textLabel.backgroundColor = UIColorClear;
        [self addSubview:textLabel];
        self.textLabel = textLabel;
        textLabel.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 10, 0, 10));
    }
    return self;
}

@end
