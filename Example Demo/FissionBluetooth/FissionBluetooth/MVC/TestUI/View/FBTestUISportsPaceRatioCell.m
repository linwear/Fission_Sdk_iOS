//
//  FBTestUISportsPaceRatioCell.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-08-07.
//

#import "FBTestUISportsPaceRatioCell.h"

@interface FBTestUISportsPaceRatioCell ()

@property (weak, nonatomic) IBOutlet UILabel *numberLab;

@property (weak, nonatomic) IBOutlet UILabel *paceLab;

@property (weak, nonatomic) IBOutlet UIView *trackView;

@property (weak, nonatomic) IBOutlet UIView *rationView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ration;

@property (weak, nonatomic) IBOutlet UILabel *textLab;

@end

#define FBTestUISportsPaceTrack (SCREEN_WIDTH - 20 - 40 - 65 - 20)

@implementation FBTestUISportsPaceRatioCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPaceRatioModel:(FBTestUISportsPaceRatioModel *)paceRatioModel {
    _paceRatioModel = paceRatioModel;
    
    self.numberLab.text = [NSString stringWithFormat:@"%d", paceRatioModel.index];
    
    self.paceLab.hidden = !StringIsEmpty(paceRatioModel.text);
    self.trackView.hidden = !StringIsEmpty(paceRatioModel.text);
    self.rationView.hidden = !StringIsEmpty(paceRatioModel.text);
    self.textLab.hidden = StringIsEmpty(paceRatioModel.text);;
    
    self.paceLab.text = [NSString stringWithFormat:@"%@", [Tools averageSpeed:paceRatioModel.pace unit:NO]];
    self.rationView.backgroundColor = paceRatioModel.color;
    self.ration.constant = FBTestUISportsPaceTrack * paceRatioModel.ratio;
    self.textLab.text = paceRatioModel.text;
}

@end


@implementation FBTestUISportsPaceRatioModel
@end
