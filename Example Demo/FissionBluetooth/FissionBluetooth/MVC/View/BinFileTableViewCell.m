//
//  BinFileTableViewCell.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/3/10.
//

#import "BinFileTableViewCell.h"

@interface BinFileTableViewCell ()

@property (nonatomic, retain) QMUILabel *titleLab;

@property (nonatomic, retain) QMUILabel *detailLab;

@end

@implementation BinFileTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    self.selectedBackgroundView = UIView.new;
    self.selectedBackgroundView.backgroundColor = UIColorTestGreen;
        
    QMUILabel *titleLab = [[QMUILabel alloc] qmui_initWithFont:FONT(15) textColor:UIColorBlack];
    titleLab.numberOfLines = 0;
    titleLab.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [self.contentView addSubview:titleLab];
    titleLab.sd_layout.leftSpaceToView(self.contentView, 12).topSpaceToView(self.contentView, 12).widthIs(SCREEN_WIDTH-24).autoHeightRatio(0).maxHeightIs(60);
    self.titleLab = titleLab;
    
    QMUILabel *detailLab = [[QMUILabel alloc] qmui_initWithFont:[NSObject themePingFangSCMediumFont:13] textColor:BlueColor];
    detailLab.numberOfLines = 0;
    [self.contentView addSubview:detailLab];
    detailLab.sd_layout.leftEqualToView(titleLab).rightEqualToView(titleLab).topSpaceToView(titleLab, 8).autoHeightRatio(0).maxHeightIs(60);
    self.detailLab = detailLab;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadTitle:(NSString *)title {
    
    self.titleLab.text = title;
    
    if ([title containsString:@"https://"]) {
        self.detailLab.text = LWLocalizbleString(@"From Server");
    } else {
        self.detailLab.text = LWLocalizbleString(@"From Local Folder");
    }

    [self setupAutoHeightWithBottomView:self.detailLab bottomMargin:12];
}

@end
