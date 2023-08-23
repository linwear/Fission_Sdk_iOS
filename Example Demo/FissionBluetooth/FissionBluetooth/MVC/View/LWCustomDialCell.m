//
//  LWCustomDialCell.m
//  LinWear
//
//  Created by lw on 2021/5/21.
//  Copyright © 2021 lw. All rights reserved.
//

#import "LWCustomDialCell.h"

@implementation LWCustomDialCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    self.backgroundColor = UIColorWhite;
    
    self.titleLabel = UILabel.new;
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [NSObject BahnschriftFont:16];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    UIImageView *arrowImgView = [[UIImageView alloc] initWithImage:IMAGE_NAME(@"ic_list_next")];
    [self.contentView addSubview:arrowImgView];
    [arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    
    self.contentLabel = UILabel.new;
    self.contentLabel.textColor = [UIColor lightGrayColor];
    self.contentLabel.font = [NSObject BahnschriftFont:14];
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(arrowImgView.mas_left).offset(-10);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
