//
//  FBHUD.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-08-01.
//

#import "FBHUD.h"

@implementation FBHUD

/// 显示加载
+ (void)showLoading:(UIView *)view {
    [FBResultHUD hideIn:view];
    [FBLoadingHUD showIn:view];
}

/// 显示成功
+ (void)showSuccess:(UIView *)view {
    [FBLoadingHUD hideIn:view];
    [FBResultHUD showIn:view success:YES];
}

/// 显示失败
+ (void)showFailure:(UIView *)view {
    [FBLoadingHUD hideIn:view];
    [FBResultHUD showIn:view success:NO];
}

@end


static CGFloat lineWidth = 4.0f;
static CGFloat circleDuriation = 0.5f;
static CGFloat checkDuration = 0.5f;

@implementation FBLoadingHUD
{
    CADisplayLink *_link;
    CAShapeLayer *_animationLayer;
    
    CGFloat _startAngle;
    CGFloat _endAngle;
    CGFloat _progress;
}

+ (FBLoadingHUD *)showIn:(UIView *)view{
    [self hideIn:view];
    FBLoadingHUD *hud = [[FBLoadingHUD alloc] initWithFrame:view.bounds];
    [hud start];
    [view addSubview:hud];
    return hud;
}

+ (FBLoadingHUD *)hideIn:(UIView *)view{
    FBLoadingHUD *hud = nil;
    for (FBLoadingHUD *subView in view.subviews) {
        if ([subView isKindOfClass:[FBLoadingHUD class]]) {
            [subView hide];
            [subView removeFromSuperview];
            hud = subView;
        }
    }
    return hud;
}

- (void)start{
    _link.paused = false;
}

- (void)hide{
    _link.paused = true;
    _progress = 0;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI{
    _animationLayer = [CAShapeLayer layer];
    _animationLayer.bounds = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width);
    _animationLayer.position = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0);
    _animationLayer.fillColor = [UIColor clearColor].CGColor;
    _animationLayer.strokeColor = BlueColor.CGColor;
    _animationLayer.lineWidth = lineWidth;
    _animationLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:_animationLayer];

    
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction)];
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    _link.paused = true;

}

- (void)displayLinkAction{
    _progress += [self speed];
    if (_progress >= 1) {
        _progress = 0;
    }
    [self updateAnimationLayer];
}

- (void)updateAnimationLayer{
    _startAngle = -M_PI_2;
    _endAngle = -M_PI_2 +_progress * M_PI * 2;
    if (_endAngle > M_PI) {
        CGFloat progress1 = 1 - (1 - _progress)/0.25;
        _startAngle = -M_PI_2 + progress1 * M_PI * 2;
    }
    CGFloat radius = _animationLayer.bounds.size.width/2.0f - lineWidth/2.0f;
    CGFloat centerX = _animationLayer.bounds.size.width/2.0f;
    CGFloat centerY = _animationLayer.bounds.size.height/2.0f;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:_startAngle endAngle:_endAngle clockwise:true];
    path.lineCapStyle = kCGLineCapRound;
    
    _animationLayer.path = path.CGPath;
}

- (CGFloat)speed{
    if (_endAngle > M_PI) {
        return 0.3/60.0f;
    }
    return 2/60.0f;
}

@end



@implementation FBResultHUD {
    CALayer *_animationLayer;
    BOOL _success;
}

//显示
+ (FBResultHUD *)showIn:(UIView *)view success:(BOOL)success {
    [self hideIn:view];
    FBResultHUD *hud = [[FBResultHUD alloc] initWithFrame:view.bounds];
    [hud start:success];
    [view addSubview:hud];
    return hud;
}

//隐藏
+ (FBResultHUD *)hideIn:(UIView *)view {
    FBResultHUD *hud = nil;
    for (FBResultHUD *subView in view.subviews) {
        if ([subView isKindOfClass:[FBResultHUD class]]) {
            [subView hide];
            [subView removeFromSuperview];
            hud = subView;
        }
    }
    return hud;
}

- (void)start:(BOOL)success {
    _success = success;
    [self circleAnimation];
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.8 * circleDuriation * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^(void){
        [self checkAnimation];
    });
}

- (void)hide {
    for (CALayer *layer in _animationLayer.sublayers) {
        [layer removeAllAnimations];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    _animationLayer = [CALayer layer];
    _animationLayer.bounds = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width);
    _animationLayer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    [self.layer addSublayer:_animationLayer];
}

//画圆
- (void)circleAnimation {
    
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.frame = _animationLayer.bounds;
    [_animationLayer addSublayer:circleLayer];
    circleLayer.fillColor =  [[UIColor clearColor] CGColor];
    circleLayer.strokeColor  = BlueColor.CGColor;
    circleLayer.lineWidth = lineWidth;
    circleLayer.lineCap = kCALineCapRound;
    
    
    CGFloat lineWidth = 5.0f;
    CGFloat radius = _animationLayer.bounds.size.width/2.0f - lineWidth/2.0f;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:circleLayer.position radius:radius startAngle:-M_PI/2 endAngle:M_PI*3/2 clockwise:true];
    circleLayer.path = path.CGPath;
    
    CABasicAnimation *circleAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    circleAnimation.duration = circleDuriation;
    circleAnimation.fromValue = @(0.0f);
    circleAnimation.toValue = @(1.0f);
    circleAnimation.delegate = self;
    [circleAnimation setValue:@"circleAnimation" forKey:@"animationName"];
    [circleLayer addAnimation:circleAnimation forKey:nil];
}

//对号
- (void)checkAnimation {
    
    CGFloat a = _animationLayer.bounds.size.width;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (_success) { // ✅
        [path moveToPoint:CGPointMake(a*2.7/10,a*5.4/10)];
        [path addLineToPoint:CGPointMake(a*4.5/10,a*7/10)];
        [path addLineToPoint:CGPointMake(a*7.8/10,a*3.8/10)];
    } else { // ❌
        [path moveToPoint:CGPointMake(a*3/10,a*3/10)];
        [path addLineToPoint:CGPointMake(a*7/10,a*7/10)];
        [path moveToPoint:CGPointMake(a*3/10,a*7/10)];
        [path addLineToPoint:CGPointMake(a*7/10,a*3/10)];
    }
    
    CAShapeLayer *checkLayer = [CAShapeLayer layer];
    checkLayer.path = path.CGPath;
    checkLayer.fillColor = [UIColor clearColor].CGColor;
    checkLayer.strokeColor = BlueColor.CGColor;
    checkLayer.lineWidth = lineWidth;
    checkLayer.lineCap = kCALineCapRound;
    checkLayer.lineJoin = kCALineJoinRound;
    [_animationLayer addSublayer:checkLayer];
    
    CABasicAnimation *checkAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    checkAnimation.duration = checkDuration;
    checkAnimation.fromValue = @(0.0f);
    checkAnimation.toValue = @(1.0f);
    checkAnimation.delegate = self;
    [checkAnimation setValue:@"checkAnimation" forKey:@"animationName"];
    [checkLayer addAnimation:checkAnimation forKey:nil];
}

@end
