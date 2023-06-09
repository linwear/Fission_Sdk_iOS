//
//  FBTestUISportsDetailsCell.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-06-02.
//

#import "FBTestUISportsDetailsCell.h"

@implementation FBTestUISportsDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDetailsModel:(FBTestUISportsDetailsModel *)detailsModel {
    _detailsModel = detailsModel;
    
    self.img.image = UIImageMake(detailsModel.img);
    self.tit.text = detailsModel.title;
    self.dei.text = detailsModel.details;
}

@end

@implementation  FBTestUISportsDetailsModel
@end
