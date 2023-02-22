//
//  HeartRateReminderVC.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/8/5.
//

#import "HeartRateReminderVC.h"

@interface HeartRateReminderVC ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *staH;
@property (weak, nonatomic) IBOutlet UITextField *endH;
@property (weak, nonatomic) IBOutlet UITextField *numb_high;
@property (weak, nonatomic) IBOutlet UITextField *numb_low;
@property (weak, nonatomic) IBOutlet UITextField *numb_count;
@property (weak, nonatomic) IBOutlet UISwitch *swi;

@property (nonatomic, strong) FBHrReminderModel *model;

@end

@implementation HeartRateReminderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.model = [FBHrReminderModel new];
    [self ddd];
}
- (void)ddd{
    self.swi.on = self.model.enable;
    self.staH.text = [NSString stringWithFormat:@"%ld",self.model.startTime];
    self.endH.text = [NSString stringWithFormat:@"%ld",self.model.endTime];
    self.numb_high.text = [NSString stringWithFormat:@"%ld",self.model.highReminder];
    self.numb_low.text = [NSString stringWithFormat:@"%ld",self.model.lowReminder];
    self.numb_count.text = [NSString stringWithFormat:@"%ld",self.model.exceedanceTimes];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)getClick:(id)sender {
    WeakSelf(self);
    [FBBgCommand.sharedInstance fbGetAbnormalHeartRateReminderWithBlock:^(FB_RET_CMD status, float progress, FBHrReminderModel * _Nonnull responseObject, NSError * _Nonnull error) {
        if (error) {
            [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
        } else if (status==FB_INDATATRANSMISSION) {
            weakSelf.textView.text = [NSString stringWithFormat:@"Receiving Progress: %.f%%", progress*100];
        } else if (status==FB_DATATRANSMISSIONDONE) {
            weakSelf.model = responseObject;
            weakSelf.textView.text = [NSString stringWithFormat:@"%@",[responseObject mj_JSONObject]];
            [weakSelf ddd];
        }
    }];
}
- (IBAction)setClick:(id)sender {
    self.model.enable = self.swi.on;
    self.model.startTime = [self.staH.text integerValue];
    self.model.endTime = [self.endH.text integerValue];
    self.model.highReminder = self.numb_high.text.integerValue;
    self.model.lowReminder = self.numb_low.text.integerValue;
    self.model.exceedanceTimes = self.numb_count.text.integerValue;
    FBHrReminderModel *model = self.model;
    WeakSelf(self);
    [FBBgCommand.sharedInstance fbSetAbnormalHeartRateReminderWithModel:model withBlock:^(NSError * _Nullable error) {
        if (error) {
            [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
        } else {
            weakSelf.textView.text = LWLocalizbleString(@"Success");
        }
    }];
}

@end
