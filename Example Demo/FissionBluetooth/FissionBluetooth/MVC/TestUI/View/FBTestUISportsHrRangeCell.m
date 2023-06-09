//
//  FBTestUISportsHrRangeCell.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-06-02.
//

#import "FBTestUISportsHrRangeCell.h"

@implementation FBTestUISportsHrRangeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.progress.progressAnimationDuration = 1.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHrRangeModel:(FBTestUISportsHrRangeModel *)hrRangeModel {
    _hrRangeModel = hrRangeModel;
    
    self.title.text = hrRangeModel.title;
    self.point.text = [NSString stringWithFormat:@"%.2f%%", hrRangeModel.progress*100.0];
    [self.progress setProgress:hrRangeModel.progress animated:YES];
    self.progress.tintColor = hrRangeModel.color;
}

@end

@implementation FBTestUISportsHrRangeModel
@end
