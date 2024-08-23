//
//  ClockListTableViewCell.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/4/2.
//

#import "ClockListTableViewCell.h"

@interface ClockListTableViewCell ()
@property (nonatomic, strong) FBAlarmClockModel *alarmClockModel;
@property (nonatomic, strong) FBScheduleModel *scheduleModel;
@property (nonatomic, assign) BOOL isSchedule;
@end

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
    
    if (self.isSchedule) {
        self.scheduleModel.clockEnableSwitch = self.swi.on;
        [FBBgCommand.sharedInstance fbSetSchedulenforWithScheduleModel:self.scheduleModel withRemoved:NO withBlock:^(NSError * _Nullable error) {
            if (error) {
                [NSObject showHUDText:error.localizedDescription];
            } else {
                [NSObject showHUDText:LWLocalizbleString(@"Success")];
            }
        }];
    }
    else {
        self.alarmClockModel.clockEnableSwitch = self.swi.on;
        [FBBgCommand.sharedInstance fbSetClockInforWithClockModel:self.alarmClockModel withRemoved:NO withBlock:^(NSError * _Nullable error) {
            if (error) {
                [NSObject showHUDText:error.localizedDescription];
            } else {
                [NSObject showHUDText:LWLocalizbleString(@"Success")];
            }
        }];
    }
}

- (void)cellModel:(id)model isSchedule:(BOOL)isSchedule{
    
    self.isSchedule = isSchedule;
    
    if ([model isKindOfClass:[FBAlarmClockModel class]]) {
        self.alarmClockModel = model;
        
        self.title.text = [NSString stringWithFormat:@"SN: %ld",(long)self.alarmClockModel.clockID];
        self.swi.on = self.alarmClockModel.clockEnableSwitch;
        self.type.text = self.alarmClockModel.clockCategory==FB_Reminders?LWLocalizbleString(@"Reminder"):LWLocalizbleString(@"Alarm Clock");
        self.time.text = self.alarmClockModel.clockCategory==FB_Reminders?self.alarmClockModel.clockYMDHm:self.alarmClockModel.clockHm;
        NSMutableString *str = [NSMutableString string];
        for (int k = 0; k<self.alarmClockModel.clockRepeatArray.count; k++) {
            NSNumber *num = self.alarmClockModel.clockRepeatArray[k];
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
                    [str appendFormat:@"%@\t", LWLocalizbleString(@"Tt")];
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
    
    else if ([model isKindOfClass:[FBScheduleModel class]]) {
        self.scheduleModel = model;
        
        self.title.text = [NSString stringWithFormat:@"SN: %ld",(long)self.scheduleModel.clockID];
        self.swi.on = self.scheduleModel.clockEnableSwitch;
        
        if (self.scheduleModel.clockCategory==FB_Reminders) {
            NSString *sta = [NSDate br_stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.scheduleModel.startTime] dateFormat:@"MM/dd HH:mm"];
            NSString *end = [NSDate br_stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.scheduleModel.endTime] dateFormat:@"MM/dd HH:mm"];
            self.type.text = [NSString stringWithFormat:@"%@-%@ %@", sta, end, LWLocalizbleString(@"Reminder")];
            
            self.time.text = [NSDate timeStamp:self.scheduleModel.remindersTime dateFormat:FBDateFormatYMDHm];
        }
        else {
            self.type.text = LWLocalizbleString(@"Alarm Clock");
            
            self.time.text = [NSString stringWithFormat:@"%02ld:%02ld", (NSInteger)floor(self.scheduleModel.clockTime/60.0), self.scheduleModel.clockTime%60];
        }
        
        NSMutableString *str = [NSMutableString string];
        for (int k = 0; k<self.scheduleModel.clockRepeatArray.count; k++) {
            NSNumber *num = self.scheduleModel.clockRepeatArray[k];
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
                    [str appendFormat:@"%@\t", LWLocalizbleString(@"Tt")];
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
}

@end
