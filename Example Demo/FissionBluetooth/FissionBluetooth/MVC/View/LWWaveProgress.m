//
//  LWWaveProgress.m
//  LinWear
//
//  Created by 裂变智能 on 2021/6/22.
//  Copyright © 2021 lw. All rights reserved.
//

#import "LWWaveProgress.h"

@interface LWWaveProgress ()

@property (nonatomic, strong) UIView *progressView;

@property (nonatomic, strong) UILabel *titleLabel;

// 毛玻璃
@property (nonatomic, strong) UIVisualEffectView *effectView;

// 波浪
@property (nonatomic, retain) CAShapeLayer *waveLayer;

// 定时刷新器
@property (nonatomic, retain) CADisplayLink *disPlayLink;

// 曲线的振幅
@property (nonatomic, assign) CGFloat waveAmplitude;

// 曲线角速度
@property (nonatomic, assign) CGFloat wavePalstance;

// 曲线初相
@property (nonatomic, assign) CGFloat waveX;

// 曲线偏距
@property (nonatomic, assign) CGFloat waveY;

// 曲线移动速度
@property (nonatomic, assign) CGFloat waveMoveSpeed;

// 进度值
@property (nonatomic, assign) CGFloat progress;

@end

@implementation LWWaveProgress


+ (LWWaveProgress *)sharedInstance {
    static LWWaveProgress *waveProgress = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        waveProgress = [[LWWaveProgress alloc] initWithFrame:UIApplication.sharedApplication.keyWindow.bounds];
    });
    return waveProgress;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self=[super initWithFrame:frame]) {
        //振幅
        self.waveAmplitude = 5;
        //角速度
        self.wavePalstance = 0.1/M_PI;
        //偏距
        self.waveY = 0;
        //初相
        self.waveX = 0;
        //x轴移动速度
        self.waveMoveSpeed = self.wavePalstance * 2;
    }
    return self;
}

- (UIView *)progressView {
    if (!_progressView) {
        _progressView = [UIView new];
        [_progressView setBackgroundColor:LineColor];
    }
    return _progressView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [NSObject themePingFangSCMediumFont:18];
    }
    return _titleLabel;
}

- (CAShapeLayer *)waveLayer {
    if (!_waveLayer) {
        _waveLayer = [CAShapeLayer layer];
    }
    return _waveLayer;
}

- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _effectView.alpha = 0.9;
    }
    return _effectView;
}

- (void)showWithFrame:(CGRect)frame withTitle:(NSString *)title withProgress:(CGFloat)progress withWaveColor:(UIColor *)waveColor {
    if (!_progressView) {
        
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        [window addSubview:self];
        // 毛玻璃
        self.effectView.frame = self.bounds;
        [self addSubview:self.effectView];
        
        // 水纹
        [self.progressView.layer addSublayer:self.waveLayer];
        self.waveLayer.fillColor = waveColor.CGColor;
        self.waveLayer.strokeColor = waveColor.CGColor;
        
        // 进度view
        self.progressView.frame = frame;
        [self addSubview:self.progressView];
        self.progressView.layer.cornerRadius = frame.size.height/2;
        self.progressView.layer.masksToBounds = YES;
        
        // 进度title
        self.titleLabel.frame = self.progressView.bounds;
        [self.progressView addSubview:self.titleLabel];
        
        // 偏距
        self.waveY = frame.size.height;
    }
    self.titleLabel.text = title;
    self.progress = progress;
    
    [self start];
}

- (void)dismiss {
    WeakSelf(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf stop];
        [weakSelf removeFromSuperview];
        [weakSelf.effectView removeFromSuperview];
        [weakSelf.progressView removeFromSuperview];
        [weakSelf.titleLabel removeFromSuperview];
        [weakSelf.waveLayer removeFromSuperlayer];
        weakSelf.effectView = nil;
        weakSelf.progressView = nil;
        weakSelf.waveLayer = nil;
        weakSelf.titleLabel = nil;
    });
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)updateWave:(CADisplayLink *)link {
    self.waveX += self.waveMoveSpeed;
    [self updateWaveY];
    [self updateWaveLayer];
}

//更新偏距的大小 直到达到目标偏距 让wave有一个匀速增长的效果
-(void)updateWaveY
{
    CGFloat targetY = self.progressView.frame.size.height - self.progress * self.progressView.frame.size.height;
    if (self.waveY < targetY) {
        self.waveY += 1;
    }
    if (self.waveY > targetY ) {
        self.waveY -= 1;
    }
}

-(void)updateWaveLayer
{
    //波浪宽度
    CGFloat waterWaveWidth = self.progressView.frame.size.width;
    //初始化运动路径
    CGMutablePathRef path = CGPathCreateMutable();
    //设置起始位置
    CGPathMoveToPoint(path, nil, 0, self.waveY);
    //初始化波浪其实Y为偏距
    CGFloat y = self.waveY;
    //正弦曲线公式为： y=Asin(ωx+φ)+k;
    for (float x = 0.0f; x <= waterWaveWidth ; x++) {
        y = self.waveAmplitude * sin(self.wavePalstance * x + self.waveX) + self.waveY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    //添加终点路径、填充底部颜色
    CGPathAddLineToPoint(path, nil, waterWaveWidth, self.progressView.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.progressView.frame.size.height);
    CGPathCloseSubpath(path);
    self.waveLayer.path = path;
    CGPathRelease(path);
    
}

//开始
- (void)start {
    //以屏幕刷新速度为周期刷新曲线的位置
    if (!_disPlayLink) {
        self.disPlayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateWave:)];
        [self.disPlayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

//停止
- (void)stop {
    if (_disPlayLink) {
        [self.disPlayLink invalidate];
        self.disPlayLink = nil;
    }
}

@end
