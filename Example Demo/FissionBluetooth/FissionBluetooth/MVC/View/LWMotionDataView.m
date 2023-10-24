//
//  LWMotionDataView.m
//  LinWear
//
//  Created by 裂变智能 on 2022/1/16.
//  Copyright © 2022 lw. All rights reserved.
//

#import "LWMotionDataView.h"

@interface LWMotionDataView ()

@property (nonatomic, strong) QMUILabel *stateTitle; // 已暂停

@property (nonatomic, strong) QMUILabel *distance; // 距离

@property (nonatomic, strong) QMUILabel *sportTime; // 运动时间
@property (nonatomic, strong) QMUILabel *sportTimeLabel;

@property (nonatomic, strong) QMUILabel *calorie; // 卡路里
@property (nonatomic, strong) QMUILabel *calorieLabel;

@property (nonatomic, strong) QMUILabel *avgPace; // 平均配速
@property (nonatomic, strong) QMUILabel *avgPaceLabel;

@property (nonatomic, strong) QMUILabel *heartRate; // 心率
@property (nonatomic, strong) QMUILabel *heartRateLabel;

@property (nonatomic, strong) QMUILabel *steps; // 步数
@property (nonatomic, strong) QMUILabel *stepsLabel;

@property (nonatomic, assign) BOOL isStop; // 是否停止状态，是：开启动画

@end

@implementation LWMotionDataView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.isStop = NO;
        [self createUI];
    }
    return self;
}

- (void)setIsStop:(BOOL)isStop {
    _isStop = isStop;
    
    self.stateTitle.hidden = !isStop;
    
    if (isStop) {
        
        [self.distance.layer addAnimation:[self AlphaLight:2] forKey:@"aAlpha"];
        [self.sportTime.layer addAnimation:[self AlphaLight:2] forKey:@"aAlpha"];
        [self.calorie.layer addAnimation:[self AlphaLight:2] forKey:@"aAlpha"];
        [self.avgPace.layer addAnimation:[self AlphaLight:2] forKey:@"aAlpha"];
        [self.heartRate.layer addAnimation:[self AlphaLight:2] forKey:@"aAlpha"];
        [self.steps.layer addAnimation:[self AlphaLight:2] forKey:@"aAlpha"];
        
    } else {
        
        [self.distance.layer removeAnimationForKey:@"aAlpha"];
        [self.sportTime.layer removeAnimationForKey:@"aAlpha"];
        [self.calorie.layer removeAnimationForKey:@"aAlpha"];
        [self.avgPace.layer removeAnimationForKey:@"aAlpha"];
        [self.heartRate.layer removeAnimationForKey:@"aAlpha"];
        [self.steps.layer removeAnimationForKey:@"aAlpha"];
    }
}

- (CABasicAnimation *)AlphaLight:(float)time{

    CABasicAnimation *animation =[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.2f];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];

    return animation;
}

- (void)createUI {
    
    self.backgroundColor = UIColorClear;
    
    _stateTitle = [self text:LWLocalizbleString(@"已暂停") textFont:[NSObject BahnschriftFont:18] textColor:UIColorBlack];
    _distance = [self text:@"0.00km" textFont:[NSObject BahnschriftFont:40] textColor:UIColorBlack];
    _sportTime = [self text:@"00:00:00" textFont:[NSObject BahnschriftFont:24] textColor:UIColorBlack];
    _sportTimeLabel = [self text:LWLocalizbleString(@"Duration") textFont:FONT(15) textColor:UIColorGrayLighten];
    _calorie = [self text:@"0kcal" textFont:[NSObject BahnschriftFont:24] textColor:UIColorBlack];
    _calorieLabel = [self text:LWLocalizbleString(@"Calorie") textFont:FONT(15) textColor:UIColorGrayLighten];
    _avgPace = [self text:@"00'00\"/km" textFont:[NSObject BahnschriftFont:24] textColor:UIColorBlack];
    _avgPaceLabel = [self text:LWLocalizbleString(@"Average Pace") textFont:FONT(15) textColor:UIColorGrayLighten];
    _heartRate = [self text:@"0bpm" textFont:[NSObject BahnschriftFont:24] textColor:UIColorBlack];
    _heartRateLabel = [self text:LWLocalizbleString(@"Heart Rate") textFont:FONT(15) textColor:UIColorGrayLighten];
    _steps = [self text:@"0" textFont:[NSObject BahnschriftFont:24] textColor:UIColorBlack];
    _stepsLabel = [self text:LWLocalizbleString(@"Step") textFont:FONT(15) textColor:UIColorGrayLighten];
    [self addSubview:self.stateTitle];
    self.stateTitle.sd_layout.leftEqualToView(self).topEqualToView(self).rightEqualToView(self).heightIs(30);
    self.stateTitle.hidden = YES;
    
    [self addSubview:self.distance];
    self.distance.sd_layout.leftEqualToView(self).topSpaceToView(self.stateTitle, 0).rightEqualToView(self).heightIs(65);
    
    
    CGFloat h1 = 30;
    CGFloat h2 = 20;
    
    [self addSubview:self.sportTime];
    [self addSubview:self.sportTimeLabel];
    [self addSubview:self.calorie];
    [self addSubview:self.calorieLabel];
    [self addSubview:self.avgPace];
    [self addSubview:self.avgPaceLabel];
    [self addSubview:self.heartRate];
    [self addSubview:self.heartRateLabel];
    [self addSubview:self.steps];
    [self addSubview:self.stepsLabel];
    
    self.sportTime.sd_layout.leftEqualToView(self).topSpaceToView(self.distance, 20).rightSpaceToView(self, SCREEN_WIDTH/2).heightIs(h1);
    self.sportTimeLabel.sd_layout.leftEqualToView(self.sportTime).topSpaceToView(self.sportTime, 0).rightEqualToView(self.sportTime).heightIs(h2);
    
    self.calorie.sd_layout.leftSpaceToView(self.sportTime, 0).topEqualToView(self.sportTime).rightEqualToView(self).heightIs(h1);
    self.calorieLabel.sd_layout.leftSpaceToView(self.sportTimeLabel, 0).topEqualToView(self.sportTimeLabel).rightEqualToView(self).heightIs(h2);
    
    self.avgPace.sd_layout.leftEqualToView(self.sportTime).topSpaceToView(self.sportTimeLabel, 12).rightEqualToView(self.sportTime).heightIs(h1);
    self.avgPaceLabel.sd_layout.leftEqualToView(self.avgPace).topSpaceToView(self.avgPace, 0).rightEqualToView(self.avgPace).heightIs(h2);
    
    self.heartRate.sd_layout.leftSpaceToView(self.avgPace, 0).topEqualToView(self.avgPace).rightEqualToView(self).heightIs(h1);
    self.heartRateLabel.sd_layout.leftEqualToView(self.heartRate).topEqualToView(self.avgPaceLabel).rightEqualToView(self.heartRate).heightIs(h2);
    
    self.steps.sd_layout.leftEqualToView(self.avgPace).topSpaceToView(self.avgPaceLabel, 12).rightEqualToView(self.avgPace).heightIs(h1);
    self.stepsLabel.sd_layout.leftEqualToView(self.steps).topSpaceToView(self.steps, 0).rightEqualToView(self.steps).heightIs(h2);

    
    [self richTextDisplay];
}

// 富文本显示处理
- (void)richTextDisplay {
    // 距离
    [Tools setUILabel:self.distance setDataArr:@[@"km"] setColorArr:@[UIColorBlack] setFontArr:@[[NSObject BahnschriftFont:20]]];
    // 卡路里
    [Tools setUILabel:self.calorie setDataArr:@[@"kcal"] setColorArr:@[UIColorBlack] setFontArr:@[[NSObject BahnschriftFont:14]]];
    // 平均配速
    [Tools setUILabel:self.avgPace setDataArr:@[@"/km"] setColorArr:@[UIColorBlack] setFontArr:@[[NSObject BahnschriftFont:14]]];
    // 心率
    [Tools setUILabel:self.heartRate setDataArr:@[@"bpm"] setColorArr:@[UIColorBlack] setFontArr:@[[NSObject BahnschriftFont:14]]];
}


- (QMUILabel *)text:(NSString *)text textFont:(UIFont *)textFont textColor:(UIColor *)textColor {
    QMUILabel *label = [[QMUILabel alloc] qmui_initWithFont:textFont textColor:textColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    
    return label;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)reloadWithMotionModel:(LWSportsConnectModel *)model {
    
    WeakSelf(self);
    GCD_MAIN_QUEUE((^{
        
        weakSelf.isStop = model.MotionState==FB_SettingPauseMotion;
        
        weakSelf.sportTime.text = [Tools HMS:model.realTime];
        
        weakSelf.distance.text = [NSString stringWithFormat:@"%.2fkm", model.distance/1000.0];
        
        weakSelf.calorie.text = [NSString stringWithFormat:@"%ldkcal", model.calorie];
        
        weakSelf.avgPace.text = [NSString stringWithFormat:@"%02ld'%02ld\"/km", model.avgPace/60, model.avgPace%60];
        
        weakSelf.heartRate.text = [Tools stringValue:model.heartRate unit:@"bpm" space:NO];
                
        weakSelf.steps.text = [NSString stringWithFormat:@"%ld", model.steps];
        
        [weakSelf richTextDisplay];
    }));
}

@end
