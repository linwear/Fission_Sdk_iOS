//
//  FBAboutHeadView.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/1/9.
//

#import "FBAboutHeadView.h"

@interface FBAboutHeadView ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *headImage;

@property (nonatomic, assign) BOOL isStop;

@end

@implementation FBAboutHeadView

- (instancetype)initWithFrame:(CGRect)frame withImage:(UIImage *)image {
    if (self = [super initWithFrame:frame]) {
        [self UI:image];
    }
    return self;
}

- (void)UI:(UIImage *)image {
    
    CGFloat coefficient = image.size.width / self.width;
    CGFloat imageHeight = coefficient * image.size.height;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollEnabled = NO;
    scrollView.contentSize = CGSizeMake(self.width, imageHeight);
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIImageView *headImage = [[UIImageView alloc] initWithImage:image];
    headImage.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
    [scrollView addSubview:headImage];
    self.headImage = headImage;
    
    UIImageView *appIcon = [[UIImageView alloc] initWithImage:Tools.appIcon];
    appIcon.sd_cornerRadius = @(5);
    appIcon.layer.borderColor = UIColorWhite.CGColor;
    appIcon.layer.borderWidth = 1;
    [self addSubview:appIcon];
    appIcon.sd_layout.centerXEqualToView(self).centerYEqualToView(self).widthIs(65).heightIs(65);
    
    UILabel *lab = [[UILabel alloc] qmui_initWithFont:[UIFont boldSystemFontOfSize:14] textColor:UIColorWhite];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = [NSString stringWithFormat:@"SDK Version %@\nSDK Build %@", FBBluetoothManager.sdkVersion, FBBluetoothManager.sdkBuild];
    [self addSubview:lab];
    lab.sd_layout.leftEqualToView(self).rightEqualToView(self).topSpaceToView(appIcon, 10).autoHeightRatio(0);
    
    [self StartAnimation:YES];
}

- (void)StartAnimation:(BOOL)scrollDown {
    
    [UIView setAnimationsEnabled:YES];

    WeakSelf(self);
    [UIView animateWithDuration:20.0f animations:^{
        if (scrollDown) {
            [weakSelf.scrollView setContentOffset:CGPointMake(0, weakSelf.scrollView.contentSize.height-weakSelf.height)];
        } else {
            [weakSelf.scrollView setContentOffset:CGPointMake(0, 0)];
        }
    } completion:^(BOOL finished) {
        
        if (finished) {
            [weakSelf StartAnimation:!scrollDown];
        }
    }];
}

- (void)dealloc {
    [self qmui_removeAllSubviews];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)scrollViewDidScroll_y:(CGFloat)offset_y {
    
    if (offset_y < 0) {
        
        self.headImage.frame = CGRectMake((offset_y * 4)/2, (offset_y * 4)/2, self.scrollView.contentSize.width - offset_y * 4, self.scrollView.contentSize.height - offset_y * 4);
        
    } else {
        
        self.headImage.frame = CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
    }
}

@end
