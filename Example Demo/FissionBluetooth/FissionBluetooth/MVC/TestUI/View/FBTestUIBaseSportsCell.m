//
//  FBTestUIBaseSportsCell.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-05-29.
//

#import "FBTestUIBaseSportsCell.h"

@interface FBTestUIBaseSportsCell ()

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UILabel *detailLab;

@property (nonatomic, strong) UIView *line;

@end

@implementation FBTestUIBaseSportsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectedBackgroundView = UIView.new;
        self.selectedBackgroundView.backgroundColor = UIColorTestGreen;
        
        UILabel *titleLab = [[UILabel alloc] qmui_initWithFont:[NSObject themePingFangSCMediumFont:15] textColor:UIColorBlack];
        titleLab.numberOfLines = 0;
        [self.contentView addSubview:titleLab];
        titleLab.sd_layout.leftSpaceToView(self.contentView, 20).rightSpaceToView(self.contentView, 20).topSpaceToView(self.contentView, 20).autoHeightRatio(0);
        self.titleLab = titleLab;
        
        UILabel *detailLab = [[UILabel alloc] qmui_initWithFont:[NSObject themePingFangSCMediumFont:15] textColor:UIColorGray];
        detailLab.numberOfLines = 0;
        [self.contentView addSubview:detailLab];
        detailLab.sd_layout.leftEqualToView(titleLab).rightEqualToView(titleLab).topSpaceToView(titleLab, 10).autoHeightRatio(0);
        self.detailLab = detailLab;
        
        UIView *line = UIView.new;
        line.backgroundColor = UIColorGrayLighten;
        [self.contentView addSubview:line];
        line.sd_layout.leftEqualToView(detailLab).rightEqualToView(detailLab).bottomEqualToView(self.contentView).heightIs(0.7);
        self.line = line;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshModel:(RLMSportsModel *)sportsModel hiddenLine:(BOOL)isHidden {
     
    NSString *string = nil;
    if ([FBLoadDataObject isCalorie:sportsModel]) { // 卡路里运动
        string = [NSString stringWithFormat:@"%@  %ldkcal", [Tools HMS:sportsModel.duration], sportsModel.calorie];
    } else { // 步数运动
        string = [NSString stringWithFormat:@"%@  %@%ld %ldkcal  %@", [Tools HMS:sportsModel.duration], LWLocalizbleString(@"Step"), sportsModel.step, sportsModel.calorie, [Tools distanceConvert:sportsModel.distance space:NO]];
    }
    
    self.titleLab.text = [NSString stringWithFormat:@"%@\n%@", [FBLoadDataObject sportName:sportsModel.MotionMode], string];
    
    self.detailLab.text = [NSString stringWithFormat:@"%@", [NSDate timeStamp:sportsModel.begin dateFormat:FBDateFormatYMDHm]];
    
    self.line.hidden = isHidden;
    
    [self setupAutoHeightWithBottomView:self.detailLab bottomMargin:20];
}

@end
