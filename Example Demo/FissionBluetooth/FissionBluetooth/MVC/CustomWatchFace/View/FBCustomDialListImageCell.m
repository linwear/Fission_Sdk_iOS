//
//  FBCustomDialListImageCell.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-06-01.
//

#import "FBCustomDialListImageCell.h"

@interface FBCustomDialListImageCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;

@end

@implementation FBCustomDialListImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setEdgeInsets:(CGFloat)edgeInsets {
    _edgeInsets = edgeInsets;
    
    self.topConstraint.constant = edgeInsets;
    self.bottomConstraint.constant = edgeInsets;
    self.leftConstraint.constant = edgeInsets;
    self.rightConstraint.constant = edgeInsets;
}

@end
