//
//  FBTestUIPhoneRingView.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-07-05.
//

#import "FBTestUIPhoneRingView.h"

@interface FBTestUIPhoneRingView ()

@property (weak, nonatomic) IBOutlet SDAnimatedImageView *animatedImageView;

@property (weak, nonatomic) IBOutlet UIButton *button;

@property (nonatomic, assign) BOOL repeat;

@end

@implementation FBTestUIPhoneRingView

/// 单例
+ (FBTestUIPhoneRingView *)sharedInstance {
    static FBTestUIPhoneRingView *manage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manage = [NSBundle.mainBundle loadNibNamed:@"FBTestUIPhoneRingView" owner:self options:nil].firstObject;
    });
    return manage;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.button setTitle:@"" forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)buttonClick:(id)sender {
    WeakSelf(self);
    [FBAtCommand.sharedInstance fbUpPhoneConfirmedFoundDataWithBlock:^(NSError * _Nullable error) {
        FBLog(@"手机确认被找到...");
        
        [weakSelf dismiss];
    }];
}

- (void)phoneRing {
    if (!self.superview) {
        
        SDAnimatedImage *animatedImage = [SDAnimatedImage imageNamed:@"icons8-phonelink-ring.gif"];
        self.animatedImageView.image = animatedImage;
        
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        self.frame = window.bounds;
        [window addSubview:self];
        
        self.repeat = YES;
        [self audioServicesPlaySystemSoundID:1022];
    }
}

- (void)audioServicesPlaySystemSoundID:(SystemSoundID)soundID {
    WeakSelf(self);
    AudioServicesPlaySystemSoundWithCompletion(soundID, ^{
        if (weakSelf.repeat) {
            [weakSelf audioServicesPlaySystemSoundID:soundID];
        }
    });
}

- (void)dismiss {
    
    self.repeat = NO;
    
    self.animatedImageView.image = nil;
    [self removeFromSuperview];
}

@end
