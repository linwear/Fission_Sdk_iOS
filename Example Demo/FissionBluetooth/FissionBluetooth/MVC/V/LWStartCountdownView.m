//
//  LWStartCountdownView.m
//  SmartWatch
//
//  Created by 裂变智能 on 2021/7/30.
//

#import "LWStartCountdownView.h"

@interface LWStartCountdownView ()

@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *imageBGView;
@property (nonatomic, strong) UIImageView *imageView;

// 计时器
@property (nonatomic, strong) NSTimer *timer;
// 计数
@property (nonatomic) int timerOut;

@end

@implementation LWStartCountdownView

#pragma mark 初始化计时器
- (void)createTimer {
    
    self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (UIView *)view {
    if (!_view) {
        _view = [[UIView alloc] initWithFrame:self.bounds];
        _view.backgroundColor = UIColorWhite;
    }
    return _view;
}

- (UIView *)imageBGView {
    if (!_imageBGView) {
        _imageBGView = [[UIView alloc] initWithFrame:CGRectZero];
        _imageBGView.backgroundColor = COLOR_HEX(0x4469FF, 0.16);
    }
    return _imageBGView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

+ (LWStartCountdownView *)initialization {
    static LWStartCountdownView *initial = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        initial = [[LWStartCountdownView alloc] initWithFrame:UIApplication.sharedApplication.keyWindow.bounds];
        initial.backgroundColor = UIColorWhite;
    });
    return initial;
}

- (void)showWithBlock:(CompletionBlock)completionBlock {
    self.alpha = 1;
    self.block = completionBlock;
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    
    [self addSubview:self.view];
    [self.view addSubview:self.imageBGView];
    [self.view addSubview:self.imageView];
    
    [window addSubview:self];

    self.timerOut = 4;
    [self createTimer];
    [self timerAction];
}

- (void)timerAction {
    
    if (self.timerOut<=0) {
        if (self.block) {
            self.block();
        }
        [self disMiss];
        return;
    }
    
    NSArray *imageArray = @[@"pic_gps_go", @"pic_gps_1_b", @"pic_gps_2_b", @"pic_gps_3_b"];
    
    self.imageBGView.frame = CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH*0.5)/2, (SCREEN_HEIGHT-SCREEN_WIDTH*0.5)/2, SCREEN_WIDTH*0.5, SCREEN_WIDTH*0.5);
    self.imageBGView.cornerRadius = (SCREEN_WIDTH*0.5)/2;

    self.imageView.image = [Tools maskWithImage:UIImageMake(imageArray[self.timerOut-1]) withColor:COLOR_HEX(0x4469FF, 1)];;
    self.imageView.frame = CGRectMake((SCREEN_WIDTH-90)/2, (SCREEN_HEIGHT-90)/2, 90, 90);

    [UIView animateWithDuration:0.3f animations:^{
        self.imageView.frame = CGRectMake((SCREEN_WIDTH-180)/2, (SCREEN_HEIGHT-180)/2, 180, 180);
        self.imageBGView.frame = CGRectMake(0, 0, 270, 270);
        self.imageBGView.cornerRadius = 270/2;
        self.imageBGView.center = self.imageView.center;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.7f animations:^{
            self.imageBGView.frame = CGRectMake(0, 0, SCREEN_HEIGHT*1.2, SCREEN_HEIGHT*1.2);
            self.imageBGView.cornerRadius = (SCREEN_HEIGHT*1.2)/2;
            self.imageBGView.center = self.imageView.center;
        }];
    }];
    
    
    self.timerOut--;
}

- (void)disMiss {
    //销毁定时器
    [_timer invalidate];
    _timer = nil;
    [self.imageBGView removeFromSuperview];
    self.imageBGView = nil;
    [self.imageView removeFromSuperview];
    self.imageView = nil;
    [self.view removeFromSuperview];
    self.view = nil;
    [self removeFromSuperview];
}

@end
