//
//  FBAutomaticOTAOverview.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-11-02.
//

#import "FBAutomaticOTAOverview.h"

@implementation FBAutomaticOTAOverview

- (instancetype)initWithFrame:(CGRect)frame overviewBlock:(FBAutomaticOTAOverviewBlock)overviewBlock {
    if (self = [super initWithFrame:frame]) {
        
        self.overviewBlock = overviewBlock;
                
        CGFloat spacing = 10;
        CGFloat margin = 20;
        CGFloat item = (frame.size.width - spacing*4 - margin*2)/3.0;
        
        self.height = 30*2 + 20*2 + 50;
        
        UIView *bgView = UIView.new;
        bgView.backgroundColor = UIColor.blackColor;
        bgView.circle = YES;
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(30);
            make.bottom.mas_equalTo(-30);
            make.left.mas_equalTo(spacing);
            make.right.mas_equalTo(-spacing);
        }];
        
        UIView *lView = UIView.new;
        lView.backgroundColor = UIColor.redColor;
        lView.circle = YES;
        [bgView addSubview:lView];
        [lView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(margin);
            make.bottom.mas_equalTo(-margin);
            make.left.mas_equalTo(margin);
            make.width.mas_equalTo(item);
        }];
        UILabel *lLabel = [[UILabel alloc] qmui_initWithFont:FONT(18) textColor:UIColor.whiteColor];
        lLabel.text = @"NG";
        lLabel.textAlignment = NSTextAlignmentCenter;
        [lView addSubview:lLabel];
        [lLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
        }];
        UILabel *lValue = [[UILabel alloc] qmui_initWithFont:FONT(25) textColor:UIColor.whiteColor];
        lValue.text = @"0";
        lValue.textAlignment = NSTextAlignmentCenter;
        [lView addSubview:lValue];
        [lValue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
        }];
        self.NG = lValue;
        
        UIView *cView = UIView.new;
        cView.backgroundColor = UIColor.yellowColor;
        cView.circle = YES;
        [bgView addSubview:cView];
        [cView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lView.mas_top);
            make.bottom.mas_equalTo(lView.mas_bottom);
            make.left.mas_equalTo(lView.mas_right).offset(spacing);
            make.width.mas_equalTo(item);
        }];
        UILabel *cLabel = [[UILabel alloc] qmui_initWithFont:FONT(18) textColor:UIColor.blackColor];
        cLabel.text = @"ALL";
        cLabel.textAlignment = NSTextAlignmentCenter;
        [cView addSubview:cLabel];
        [cLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
        }];
        UILabel *cValue = [[UILabel alloc] qmui_initWithFont:FONT(25) textColor:UIColor.blackColor];
        cValue.text = @"0";
        cValue.textAlignment = NSTextAlignmentCenter;
        [cView addSubview:cValue];
        [cValue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
        }];
        self.ALL = cValue;
        
        UIView *rView = UIView.new;
        rView.backgroundColor = UIColor.greenColor;
        rView.circle = YES;
        [bgView addSubview:rView];
        [rView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(cView.mas_top);
            make.bottom.mas_equalTo(cView.mas_bottom);
            make.left.mas_equalTo(cView.mas_right).offset(spacing);
            make.width.mas_equalTo(item);
        }];
        UILabel *rLabel = [[UILabel alloc] qmui_initWithFont:FONT(18) textColor:UIColor.whiteColor];
        rLabel.text = @"OK";
        rLabel.textAlignment = NSTextAlignmentCenter;
        [rView addSubview:rLabel];
        [rLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
        }];
        UILabel *rValue = [[UILabel alloc] qmui_initWithFont:FONT(25) textColor:UIColor.whiteColor];
        rValue.text = @"0";
        rValue.textAlignment = NSTextAlignmentCenter;
        [rView addSubview:rValue];
        [rValue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
        }];
        self.OK = rValue;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = UIColor.clearColor;
        [button setTitleColor:UIColor.clearColor forState:UIControlStateNormal];
        [bgView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.mas_equalTo(0);
        }];
        [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)buttonClick {
    if (self.overviewBlock) {
        self.overviewBlock();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
