//
//  FBTestUIItemCell.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/5/5.
//

#import "FBTestUIItemCell.h"

@interface FBTestUIItemCell ()

@property (weak, nonatomic) IBOutlet UIView *BG_COLOR;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;

@property (weak, nonatomic) IBOutlet SDAnimatedImageView *animatedImageView;

@end

@implementation FBTestUIItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = UIColorWhite;
    
    self.BG_COLOR.gradientStyle = GradientStyleTopToBottom;
}

- (void)reloadItem:(FBTestUIItemModel *)item {
    
    self.BG_COLOR.gradientAColor = item.gradientAColor;
    self.BG_COLOR.gradientBColor = item.gradientBColor;
    
    self.titleLab.text = item.title;
    
    SDAnimatedImage *animatedImage = [SDAnimatedImage imageNamed:[NSString stringWithFormat:@"%@.gif", item.gif]];
    self.animatedImageView.image = animatedImage;
    
    self.iconImg.image = UIImageMake(item.icon);
}

@end
