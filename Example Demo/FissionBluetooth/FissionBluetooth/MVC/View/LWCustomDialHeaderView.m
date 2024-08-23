//
//  LWCustomDialHeaderView.m
//  LinWear
//
//  Created by lw on 2021/5/21.
//  Copyright © 2021 lw. All rights reserved.
//

#import "LWCustomDialHeaderView.h"

@interface LWCustomDialHeaderView()

@property (nonatomic, strong) UIImageView *bkImageView; // 背景图片

@property (nonatomic, strong) UIImageView *hullImageView; // 表壳 圆, 方

@property (nonatomic, strong) UIImageView *styleImageView; // 表盘样式图

@property (nonatomic, strong) UIView *preView;
@property (nonatomic, assign) CGSize preViewSize;

@end

@implementation LWCustomDialHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    
    if (Tools.getShapeOFTheWatchCurrentlyConnectedIsRound) {
        // 表框
        self.hullImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.hullImageView.image = IMAGE_NAME(@"pic_dial_circular");
        [self addSubview:self.hullImageView];
        [self.hullImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(33+24);
            make.left.mas_equalTo((SCREEN_WIDTH-160)/2);
            make.size.mas_equalTo(CGSizeMake(160, 160));
        }];
        
        self.preView = [UIView new];
        [self.hullImageView addSubview:self.preView];
        NSInteger wh = 160 - 16*2;
        [self.preView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.hullImageView);
            make.size.mas_equalTo(CGSizeMake(wh, wh));
        }];
        self.preViewSize = CGSizeMake(wh, wh);
        self.preView.layer.cornerRadius = wh/2;
        self.preView.layer.masksToBounds = YES;
        
        // 背景图
        self.bkImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.preView addSubview:self.bkImageView];
        [self.bkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.preView);
            make.size.mas_equalTo(self.preView);
        }];
        self.bkImageView.layer.cornerRadius = wh/2;
        self.bkImageView.clipsToBounds = YES;
        
    } else {
        // 表框
        self.hullImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.hullImageView.image = IMAGE_NAME(@"pic_dial_rectangle@3x");
        [self addSubview:self.hullImageView];
        [self.hullImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(33);
            make.left.mas_equalTo((SCREEN_WIDTH-160)/2);
            make.size.mas_equalTo(CGSizeMake(160, 210));
        }];

        self.preView = [UIView new];
        [self addSubview:self.preView];
        NSInteger w = 160 - 16*2;
        NSInteger h = 210 - 27*2;
        [self.preView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.hullImageView);
            make.size.mas_equalTo(CGSizeMake(w, h));
        }];
        self.preViewSize = CGSizeMake(w, h);
        self.preView.layer.cornerRadius = 0;
        self.preView.layer.masksToBounds = YES;

        // 背景图
        self.bkImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.preView addSubview:self.bkImageView];
        [self.bkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.preView);
            make.size.mas_equalTo(self.preView);
        }];
        self.bkImageView.layer.cornerRadius = 0;
        self.bkImageView.clipsToBounds = YES;
    }
    // 样式
    self.styleImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.preView addSubview:self.styleImageView];
    [self.styleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bkImageView.mas_top).offset(24);
        make.centerXWithinMargins.mas_equalTo(self.bkImageView.center);
        make.size.mas_equalTo(CGSizeMake(62, 40));
    }];
    // 自定义表盘
    UILabel *titleLabel = UILabel.new;
    titleLabel.text = LWLocalizbleString(@"Custom Dial");
    titleLabel.font = [NSObject BahnschriftFont:16];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hullImageView.mas_bottom).offset(16);
        make.height.mas_equalTo(22);
        make.centerX.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
    }];

    // 移动图层
    [self sendSubviewToBack:self.preView];
}

- (void)selectedCustomDialModel:(LWCustomDialModel *)model handler:(ResultBlock)resultBlock{
    
    //背景图
    [self.bkImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.styleImageView setContentMode:UIViewContentModeScaleAspectFit];
    self.bkImageView.image = model.selectImage;
    
    //样式
    self.styleImageView.image = [Tools maskWithImage:UIImageMake(@"dial_style1_white.jpg") withColor:model.selectColor?model.selectColor:nil];
    
    
    // 更新位置
    if (model.selectPosition==LWCustomTimeLocationStyleTop) { // 上
        [self.styleImageView mas_remakeConstraints:^(MASConstraintMaker *make) { // 时间
            
            make.top.mas_equalTo(self.bkImageView.mas_top).offset(7);
            make.centerXWithinMargins.mas_equalTo(self.bkImageView.center);
            make.size.mas_equalTo(CGSizeMake(62, 40));
        }];
    }
    else if (model.selectPosition==LWCustomTimeLocationStyleBottom) { // 下
        [self.styleImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.mas_equalTo(self.bkImageView.mas_bottom).offset(-7);
            make.centerXWithinMargins.mas_equalTo(self.bkImageView.center);
            make.size.mas_equalTo(CGSizeMake(62, 40));
        }];
    }
    else if (model.selectPosition==LWCustomTimeLocationStyleLeft) { // 左
        [self.styleImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.bkImageView.mas_left).offset(7);
            make.centerYWithinMargins.mas_equalTo(self.bkImageView.center);
            make.size.mas_equalTo(CGSizeMake(62, 40));
        }];
    }
    else if (model.selectPosition==LWCustomTimeLocationStyleRight) { // 右
        [self.styleImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.bkImageView.mas_right).offset(-7);
            make.centerYWithinMargins.mas_equalTo(self.bkImageView.center);
            make.size.mas_equalTo(CGSizeMake(62, 40));
        }];
    }
    else if (model.selectPosition==LWCustomTimeLocationStyleCentre) { // 中间
        [self.styleImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerXWithinMargins.mas_equalTo(self.bkImageView.center);
            make.centerYWithinMargins.mas_equalTo(self.bkImageView.center);
            make.size.mas_equalTo(CGSizeMake(62, 40));
        }];
    }

    
    // 第一个参数:延迟的时间
    // 可以通过改变队列来改变线程
    WeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       // 需要延迟执行的代码
        if (resultBlock) {
            resultBlock([weakSelf UIViewToUIImageView:weakSelf.preView]);
        }
    });
}

#pragma mark - UIView转UIImage
//使用该方法不会模糊，根据屏幕密度计算
- (UIImage *)UIViewToUIImageView:(UIView *)view {
    CGSize size = self.preViewSize;
    UIImage *imageRet = [[UIImage alloc]init];
    //UIGraphicsBeginImageContextWithOptions(区域大小, 是否是非透明的, 屏幕密度);
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    imageRet = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageRet;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
