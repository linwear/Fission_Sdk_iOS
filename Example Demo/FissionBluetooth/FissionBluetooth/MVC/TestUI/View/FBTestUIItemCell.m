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

@property (weak, nonatomic) IBOutlet UILabel *detailLab;

@property (weak, nonatomic) IBOutlet UILabel *dateLab;

@end

@implementation FBTestUIItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = UIColorWhite;
    
//    self.BG_COLOR.gradientStyle = GradientStyleTopToBottom;
}

- (void)reloadItem:(FBTestUIItemModel *)item historicalModel:(FBLocalHistoricalModel *)historicalModel {
    
//    self.BG_COLOR.gradientAColor = item.gradientAColor;
//    self.BG_COLOR.gradientBColor = item.gradientBColor;
    
    self.titleLab.text = item.title;
    
    self.iconImg.image = UIImageMake(item.icon);
    

    if ([item.title isEqualToString:LWLocalizbleString(@"Sleep")]) {
        self.detailLab.text = historicalModel.sleep;
        self.dateLab.text = historicalModel.sleepBegin>0 ? [NSDate timeStamp:historicalModel.sleepBegin dateFormat:FBDateFormatYMD] : @"";
    } else if ([item.title isEqualToString:LWLocalizbleString(@"Heart Rate")]) {
        self.detailLab.text = historicalModel.hr;
        self.dateLab.text = historicalModel.hrBegin>0 ? [NSDate timeStamp:historicalModel.hrBegin dateFormat:FBDateFormatYMDHm] : @"";
    } else if ([item.title isEqualToString:LWLocalizbleString(@"Blood Oxygen")]) {
        self.detailLab.text = historicalModel.spo2;
        self.dateLab.text = historicalModel.spo2Begin>0 ? [NSDate timeStamp:historicalModel.spo2Begin dateFormat:FBDateFormatYMDHm] : @"";
    } else if ([item.title isEqualToString:LWLocalizbleString(@"Blood Pressure")]) {
        self.detailLab.text = historicalModel.bp;
        self.dateLab.text = historicalModel.bpBegin>0 ? [NSDate timeStamp:historicalModel.bpBegin dateFormat:FBDateFormatYMDHm] : @"";
    } else if ([item.title isEqualToString:LWLocalizbleString(@"Mental Stress")]) {
        self.detailLab.text = historicalModel.stress;
        self.dateLab.text = historicalModel.stressBegin>0 ? [NSDate timeStamp:historicalModel.stressBegin dateFormat:FBDateFormatYMDHm] : @"";
    } else if ([item.title isEqualToString:LWLocalizbleString(@"Women's Health")]) {
        self.detailLab.text = historicalModel.womenHealth;
        self.dateLab.text = historicalModel.womenHealthBegin>0 ? [NSDate timeStamp:historicalModel.womenHealthBegin dateFormat:FBDateFormatYMDHm] : @"";
    }
    
    
    self.detailLab.font = [self.detailLab.text isEqualToString:LWLocalizbleString(@"No Data")] ? [NSObject BahnschriftFont:20] : [NSObject BahnschriftFont:30];
    self.detailLab.textAlignment = [self.detailLab.text isEqualToString:LWLocalizbleString(@"No Data")] ? NSTextAlignmentCenter : NSTextAlignmentLeft;
}

@end
