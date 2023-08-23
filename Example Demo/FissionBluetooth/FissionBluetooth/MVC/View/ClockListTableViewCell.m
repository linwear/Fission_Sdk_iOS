//
//  ClockListTableViewCell.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/4/2.
//

#import "ClockListTableViewCell.h"

@implementation ClockListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)ssss:(UISwitch *)sender {
    self.swi.on = sender.on;
    self.model.clockEnableSwitch = self.swi.on;
    [FBBgCommand.sharedInstance fbSetClockInforWithClockModel:self.model withRemoved:NO withBlock:^(NSError * _Nullable error) {
        if (error) {
            [NSObject showHUDText:error.localizedDescription];
        } else {
            [NSObject showHUDText:LWLocalizbleString(@"Success")];
        }
    }];
}

- (void)cellModel:(FBAlarmClockModel *)model{
    self.model = model;
    self.title.text = [NSString stringWithFormat:@"SN: %ld",(long)model.clockID];
    self.swi.on = model.clockEnableSwitch;
    self.type.text = model.clockCategory==FB_Reminders?LWLocalizbleString(@"Reminder"):LWLocalizbleString(@"Alarm Clock");
    self.time.text = model.clockCategory==FB_Reminders?model.clockYMDHm:model.clockHm;
    NSMutableString *str = [NSMutableString string];
    for (int k = 0; k<model.clockRepeatArray.count; k++) {
        NSNumber *num = model.clockRepeatArray[k];
        if (num.intValue==1) {
            if (k==0) {
                [str appendFormat:@"%@\t", LWLocalizbleString(@"Ss")];
            } else if (k==1){
                [str appendFormat:@"%@\t", LWLocalizbleString(@"M")];
            } else if (k==2){
                [str appendFormat:@"%@\t", LWLocalizbleString(@"T")];
            } else if (k==3){
                [str appendFormat:@"%@\t", LWLocalizbleString(@"W")];
            } else if (k==4){
                [str appendFormat:@"%@\t", LWLocalizbleString(@"T")];
            } else if (k==5){
                [str appendFormat:@"%@\t", LWLocalizbleString(@"F")];
            } else if (k==6){
                [str appendFormat:@"%@\t", LWLocalizbleString(@"S")];
            }
        }
    }
    if (!str.length) {
        [str appendString:LWLocalizbleString(@"Not Repeating")];
    }
    self.week.text = str;
}

@end
