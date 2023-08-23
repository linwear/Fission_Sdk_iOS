//
//  FBTextImageView.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-07-12.
//

#import "FBTextImageView.h"

@implementation FBTextImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView = UIImageView.new;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.imageView];
        self.imageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        
        self.titleLable = UILabel.new;
        [self addSubview:self.titleLable];
        self.titleLable.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    }
    return self;
}

- (void)setImagePosition:(FBTextImagePosition)imagePosition {
    _imagePosition = imagePosition;
    
    [self updateLayout];
    
    self.titleLable.hidden = NO;
    self.titleLable.textAlignment = NSTextAlignmentCenter;
    
    if (imagePosition == FBTextImageFill) {
        self.titleLable.hidden = YES;
        self.imageView.sd_resetLayout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    }
    else if (imagePosition == FBTextImagePositionTop) {
        self.imageView.sd_resetLayout.spaceToSuperView(UIEdgeInsetsMake(0, 0, self.frame.size.height/2.0, 0));
        self.titleLable.sd_resetLayout.spaceToSuperView(UIEdgeInsetsMake(self.frame.size.height/2.0, 0, 0, 0));
    }
    else if (imagePosition == FBTextImagePositionBottom) {
        self.imageView.sd_resetLayout.spaceToSuperView(UIEdgeInsetsMake(self.frame.size.height/2.0, 0, 0, 0));
        self.titleLable.sd_resetLayout.spaceToSuperView(UIEdgeInsetsMake(0, 0, self.frame.size.height/2.0, 0));
    }
    else if (imagePosition == FBTextImagePositionLeft) {
        self.imageView.sd_resetLayout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, self.frame.size.width*0.65));
        self.titleLable.sd_resetLayout.spaceToSuperView(UIEdgeInsetsMake(0, self.frame.size.width*0.35, 0, 0));
        self.titleLable.textAlignment = NSTextAlignmentLeft;
    }
    else if (imagePosition == FBTextImagePositionRight) {
        self.imageView.sd_resetLayout.spaceToSuperView(UIEdgeInsetsMake(0, self.frame.size.width*0.65, 0, 0));
        self.titleLable.sd_resetLayout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, self.frame.size.width*0.35));
        self.titleLable.textAlignment = NSTextAlignmentRight;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
