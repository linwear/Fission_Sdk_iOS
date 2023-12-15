//
//  FBRadarView.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/1/6.
//

#import "FBRadarView.h"

#define RippleAnimationAvatarSize CGSizeMake(100, 100)
#define RippleAnimationExpandSizeValue 40.0
#define RippleAnimationDuration 2.0
#define RippleAnimationLineWidth 1.0

@interface FBRadarView ()

@property (nonatomic, strong) UIView *avatarWrapView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIBezierPath *staPath;
@property (nonatomic, strong) UIBezierPath *endPath;

@end

@implementation FBRadarView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self UI];
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
- (void)UI {
    self.avatarWrapView = UIView.new;
    self.avatarWrapView.frame = CGRectMake(CGFloatGetCenter(CGRectGetWidth(self.bounds), RippleAnimationAvatarSize.width), CGFloatGetCenter(CGRectGetWidth(self.bounds), RippleAnimationAvatarSize.height), RippleAnimationAvatarSize.width, RippleAnimationAvatarSize.height);
    [self addSubview:self.avatarWrapView];
    
    self.avatarImageView = [[UIImageView alloc] initWithImage:UIImageMake(@"ic_color_radar")];
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.frame = self.avatarWrapView.bounds;
    [self.avatarWrapView addSubview:self.avatarImageView];
    
    self.avatarImageView.layer.cornerRadius = RippleAnimationAvatarSize.height / 2;
    
    self.staPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(CGRectMake(0, 0, RippleAnimationAvatarSize.width, RippleAnimationAvatarSize.height), RippleAnimationLineWidth, RippleAnimationLineWidth)];
    self.endPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(CGRectMake(- RippleAnimationExpandSizeValue*2.5, - RippleAnimationExpandSizeValue*2.5, RippleAnimationAvatarSize.width + RippleAnimationExpandSizeValue * 5, RippleAnimationAvatarSize.height + RippleAnimationExpandSizeValue * 5), RippleAnimationLineWidth, RippleAnimationLineWidth)];
}

- (void)animation:(BOOL)isAnimation {
    _isAnimation = isAnimation;
    [self animationReplicatorAvatarInView:self.avatarWrapView animated:isAnimation];
    [self.avatarWrapView bringSubviewToFront:self.avatarImageView];
}

- (void)animationReplicatorAvatarInView:(UIView *)view animated:(BOOL)animated {
    
    NSMutableArray *_layers = [[NSMutableArray alloc] init];
    NSInteger count = view.layer.sublayers.count;
    for (int i = 0; i < count; i++) {
        if ([view.layer.sublayers[i] isKindOfClass:[CAReplicatorLayer class]]) {
            [_layers addObject:view.layer.sublayers[i]];
            [view.layer.sublayers[i] setHidden:YES];
        }
    }
    count = _layers.count;
    for (int i = 0; i < count; i++) {
        [_layers[i] removeFromSuperlayer];
    }
    
    self.hidden = !animated;
    if (!animated) {
        return;
    }
    
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.instanceCount = 4;
    replicatorLayer.instanceDelay = RippleAnimationDuration / 4;
    replicatorLayer.backgroundColor = UIColorClear.CGColor;
    [view.layer addSublayer:replicatorLayer];
    
    CAShapeLayer *layer = [self animationLayerWithPath:self.staPath];
    layer.frame = CGRectMake(0, 0, RippleAnimationAvatarSize.width, RippleAnimationAvatarSize.height);
    [replicatorLayer addSublayer:layer];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.fromValue = (id)self.staPath.CGPath;
    pathAnimation.toValue = (id)self.endPath.CGPath;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @1;
    opacityAnimation.toValue = @0;
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[pathAnimation, opacityAnimation];
    groupAnimation.duration = RippleAnimationDuration;
    groupAnimation.repeatCount = HUGE_VALF;
    
    [layer addAnimation:groupAnimation forKey:nil];
}

- (CAShapeLayer *)animationLayerWithPath:(UIBezierPath *)path {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.strokeColor = COLOR_HEX(0x506FE4, 1).CGColor;
    layer.fillColor = COLOR_HEX(0x506FE4, 1).CGColor;
    layer.lineWidth = RippleAnimationLineWidth;
    return layer;
}


@end
