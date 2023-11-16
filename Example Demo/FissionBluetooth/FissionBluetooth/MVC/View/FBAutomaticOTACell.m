//
//  FBAutomaticOTACell.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-11-01.
//

#import "FBAutomaticOTACell.h"

@implementation FBAutomaticOTACell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)text:(NSString *)text {
    self.titleLab.text = text;
    if ([text containsString:@"SUCCESS"]) {
        [Tools setUILabel:self.titleLab setDataArr:@[@"SUCCESS"] setColorArr:@[UIColor.greenColor] setFontArr:@[self.titleLab.font]];
    } else if ([text containsString:@"FAILURE"]) {
        [Tools setUILabel:self.titleLab setDataArr:@[@"FAILURE"] setColorArr:@[UIColor.redColor] setFontArr:@[self.titleLab.font]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


@implementation FBAutomaticOTAModel

- (instancetype)init {
    if (self = [super init]) {
        self.rowArray = NSMutableArray.array;
    }
    return self;
}

@end


@implementation FBAutomaticOTAHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = Color_Spo2;
        self.titleLab = [[UILabel alloc] qmui_initWithFont:FONT(15) textColor:UIColor.whiteColor];
        self.titleLab.numberOfLines = 0;
        self.titleLab.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).offset(5);
            make.bottom.mas_equalTo(self.contentView).offset(-5);
            make.left.mas_equalTo(self.contentView).offset(10);
            make.right.mas_equalTo(self.contentView).offset(-10);
        }];
    }
    return self;
}

@end
