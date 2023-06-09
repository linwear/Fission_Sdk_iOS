//
//  FBBatteryView.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/3/31.
//

#import "FBBatteryView.h"

@interface FBBatteryView ()

@property (nonatomic, strong) UIImageView *batteryImage;

@property (nonatomic, strong) QMUILabel *batteryLabel;

@end

@implementation FBBatteryView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    NSMutableArray <UIImage *> *imageArray = NSMutableArray.array;
    
    for (int j = 1; j<=10; j++) {
        NSString *imageName = [NSString stringWithFormat:@"ic_device_power%d", j];
        UIImage *image = [UIImageMake(imageName) qmui_imageWithTintColor:UIColor.greenColor];
        [imageArray addObject:image];
    }
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, self.height)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = imageArray.firstObject;
    imageView.animationImages = imageArray;
    imageView.animationDuration = 1.5; // 动画时间
    imageView.animationRepeatCount = 0; // 重复次数 0 表示重复
    imageView.qmui_smoothAnimation = YES; // 高性能
    [self addSubview:imageView];
    imageView.hidden = YES;
    self.batteryImage = imageView;
    
    
    QMUILabel *label = [[QMUILabel alloc] qmui_initWithFont:[NSObject themePingFangSCMediumFont:14] textColor:UIColorWhite];
    label.frame = CGRectMake(imageView.width+3, imageView.top, self.width-imageView.width-3, imageView.height);
    [self addSubview:label];
    self.batteryLabel = label;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)reloadBattery:(NSInteger)battery state:(FB_BATTERYLEVEL)level {
    
    self.battery = battery;
    self.level = level;
    
    self.batteryLabel.hidden = (battery == -1); // -1 隐藏电量🔋
    
    if (level==BATT_CHARGING) {
        self.batteryImage.hidden = NO;
        if (!self.batteryImage.isAnimating) {
            [self.batteryImage startAnimating]; // 开始动画
        }
    } else {
        self.batteryImage.hidden = YES;
        if (self.batteryImage.isAnimating) {
            [self.batteryImage stopAnimating]; // 停止动画
        }
    }
    
    self.batteryLabel.textColor = level==BATT_LOW_POWER ? UIColorRed : UIColorWhite;
    self.batteryLabel.text = [NSString stringWithFormat:@"%ld%%", battery];
}

@end
