//
//  FBColorPickerView.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/5/24.
//

#import "FBColorPickerView.h"
#import "FBColorSliderView.h"

#define indicatorWidth      20.0
#define indicatorHeight     10.0

@interface FBColorPickerView ()

@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, strong) UIView *indicatorline;

@end

@implementation FBColorPickerView

- (instancetype)initWithFrame:(CGRect)frame block:(FBColorPickerViewBlock)block {
    if (self = [super initWithFrame:frame]) {
        WeakSelf(self);
        
        // 颜色滑块
        FBColorSliderView *colorSliderView = [[FBColorSliderView alloc] initWithFrame:CGRectMake(indicatorWidth/2, 0, frame.size.width-indicatorWidth, frame.size.height-indicatorHeight) block:^(UIColor * _Nonnull color, CGFloat x) {
            
            weakSelf.indicatorline.backgroundColor = color.qmui_inverseColor;
            weakSelf.indicatorView.left = x;
            
            if (block) {
                block(color);
            }
        }];
        [self addSubview:colorSliderView];
        
        // 指示器
        UIView *indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, indicatorWidth, frame.size.height)];
        indicatorView.backgroundColor = UIColor.clearColor;
        [self addSubview:indicatorView];
        
        UIImageView *indicatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, colorSliderView.height, indicatorWidth, indicatorHeight)];
        indicatorImage.image = [UIImage qmui_imageWithShape:QMUIImageShapeTriangle size:indicatorImage.size tintColor:UIColor.blackColor];
        [indicatorView addSubview:indicatorImage];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, colorSliderView.height)];
        line.backgroundColor = UIColor.blackColor;
        line.centerX = indicatorImage.centerX;
        [indicatorView addSubview:line];
        
        self.indicatorline = line;
        self.indicatorView = indicatorView;
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

@end
