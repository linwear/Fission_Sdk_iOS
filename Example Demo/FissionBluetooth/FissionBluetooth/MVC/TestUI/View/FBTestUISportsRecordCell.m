//
//  FBTestUISportsRecordCell.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/5/10.
//

#import "FBTestUISportsRecordCell.h"

@interface FBTestUISportsRecordCell ()

@property (weak, nonatomic) IBOutlet UIView *BG_COLOR;

@property (weak, nonatomic) IBOutlet SDAnimatedImageView *animatedImageView;

@property (weak, nonatomic) IBOutlet UILabel *titlelab;

@property (weak, nonatomic) IBOutlet UIImageView *icon_image;

@end

@implementation FBTestUISportsRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = UIColorWhite;
    
    self.BG_COLOR.gradientStyle = GradientStyleLeftToRight;
    self.BG_COLOR.gradientAColor = COLOR_HEX(0xFFFFFF, 0);
    self.BG_COLOR.gradientBColor = UIColorTestGreen;
    
    SDAnimatedImage *animatedImage = [SDAnimatedImage imageNamed:@"icons8-walking-gif.gif"];
    self.animatedImageView.image = animatedImage;
    
    self.icon_image.alpha = 0.3;
}

- (void)reloadCellModel:(RLMSportsModel *)sportsModel {
    
    self.titlelab.text = LWLocalizbleString(@"No Data");
        
    if (sportsModel) {
        NSMutableString *string = [NSMutableString stringWithFormat:@"%@", [FBLoadDataObject sportName:sportsModel.MotionMode]];
        
        if ([FBLoadDataObject isCalorie:sportsModel]) { // 卡路里运动
            [string appendFormat:@"\n%@", [NSString stringWithFormat:@"%@, %ldkcal", [Tools HMS:sportsModel.duration], sportsModel.calorie]];
        } else { // 步数运动
            [string appendFormat:@"\n%@", [NSString stringWithFormat:@"%@, %@%ld, %ldkcal, %@", [Tools HMS:sportsModel.duration], LWLocalizbleString(@"Step"), sportsModel.step, sportsModel.calorie, [Tools distanceConvert:sportsModel.distance space:NO]]];
        }
        
        [string appendFormat:@"\n%@", [NSString stringWithFormat:@"%@", [NSDate timeStamp:sportsModel.begin dateFormat:FBDateFormatYMDHm]]];
        
        self.titlelab.text = string;
    }
}

@end
