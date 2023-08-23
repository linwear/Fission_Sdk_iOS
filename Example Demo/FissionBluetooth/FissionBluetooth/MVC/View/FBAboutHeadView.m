//
//  FBAboutHeadView.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/1/9.
//

#import "FBAboutHeadView.h"

@interface FBAboutHeadView ()

@property (nonatomic, strong) UIImageView *headerImageView;

@property (nonatomic, assign) CGRect originalHeaderImageViewFrame;

@end

@implementation FBAboutHeadView

- (instancetype)initWithFrame:(CGRect)frame withImage:(UIImage *)image {
    if (self = [super initWithFrame:frame]) {
                
        UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:frame];
        headerImageView.clipsToBounds = YES;
        headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        headerImageView.image = image;
        [self addSubview:headerImageView];
        self.headerImageView = headerImageView;
        self.originalHeaderImageViewFrame = frame;
        
        UIImageView *appIcon = [[UIImageView alloc] initWithImage:Tools.appIcon];
        appIcon.sd_cornerRadius = @(5);
        appIcon.layer.borderColor = UIColorWhite.CGColor;
        appIcon.layer.borderWidth = 1;
        [self addSubview:appIcon];
        appIcon.sd_layout.centerXEqualToView(self).centerYEqualToView(self).widthIs(65).heightIs(65);
        
        UILabel *lab = [[UILabel alloc] qmui_initWithFont:[NSObject BahnschriftFont:14] textColor:UIColorWhite];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = [NSString stringWithFormat:@"SDK Version %@\nSDK Build %@", FBBluetoothManager.sdkVersion, FBBluetoothManager.sdkBuild];
        [self addSubview:lab];
        lab.sd_layout.leftEqualToView(self).rightEqualToView(self).topSpaceToView(appIcon, 10).autoHeightRatio(0);
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)scrollViewDidScroll_y:(CGFloat)offset_y {
    
    //防止height小于0
    if (self.originalHeaderImageViewFrame.size.height - offset_y < 0) {
        return;
    }
    //如果不使用约束的话，图片的y值要上移offsetY,同时height也要增加offsetY
    CGFloat x = offset_y<0 ? (offset_y - self.originalHeaderImageViewFrame.origin.x) / 2 :self.originalHeaderImageViewFrame.origin.x;
    CGFloat y = self.originalHeaderImageViewFrame.origin.y + offset_y;
    CGFloat width = offset_y<0 ? self.originalHeaderImageViewFrame.size.width - offset_y :self.originalHeaderImageViewFrame.size.width;
    CGFloat height = self.originalHeaderImageViewFrame.size.height - offset_y;
    
    self.headerImageView.frame = CGRectMake(x, y, width, height);
}

@end
