//
//  SportTargetViewController.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/1/19.
//

#import "SportTargetViewController.h"

@interface SportTargetViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UISwitch *swi_1;
@property (weak, nonatomic) IBOutlet UISwitch *swi_2;
@property (weak, nonatomic) IBOutlet UISwitch *swi_3;
@property (weak, nonatomic) IBOutlet UISwitch *swi_4;
@property (weak, nonatomic) IBOutlet UITextField *TargetSteps;
@property (weak, nonatomic) IBOutlet UITextField *calories;
@property (weak, nonatomic) IBOutlet UITextField *TargetMileage;
@property (weak, nonatomic) IBOutlet UITextField *ExerciseTime;
@property (nonatomic, retain) FBSportTargetModel *model;
@end

@implementation SportTargetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.model = [FBSportTargetModel new];
    self.swi_1.on = YES;
    self.swi_2.on = YES;
    self.swi_3.on = YES;
    self.swi_4.on = YES;
    
}
- (IBAction)setTs:(id)sender {
    self.model.stepSwitch = self.swi_1.on;
    self.model.caculateSwitch = self.swi_2.on;
    self.model.distanceSwitch = self.swi_3.on;
    self.model.sportSwicth = self.swi_4.on;
    
    self.model.stepTarget = [self.TargetSteps.text integerValue];
    self.model.calorieTarget = [self.calories.text integerValue];
    self.model.distanceTarget = [self.TargetMileage.text integerValue];
    self.model.sportTimeTarget = [self.ExerciseTime.text integerValue];
        
    FBSportTargetModel *model = self.model;
    WeakSelf(self);
    [FBBgCommand.sharedInstance fbSetSportsTagargetWithModel:model withBlock:^(NSError * _Nullable error) {
        if (error) {
            [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
        } else {
            weakSelf.textView.text = LWLocalizbleString(@"Success");
        }
    }];
}
- (IBAction)getTs:(id)sender {
    WeakSelf(self);
    [FBBgCommand.sharedInstance fbGetSportsTagargetWithBlock:^(FB_RET_CMD status, float progress, FBSportTargetModel * _Nonnull responseObject, NSError * _Nonnull error) {
        if (error) {
            [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
        } else if (status==FB_INDATATRANSMISSION) {
            weakSelf.textView.text = [NSString stringWithFormat:@"Receiving Progress: %.f%%", progress*100];
        } else if (status==FB_DATATRANSMISSIONDONE) {
            weakSelf.model = responseObject;
            weakSelf.textView.text = [NSString stringWithFormat:@"%@",[responseObject mj_JSONObject]];
            [weakSelf sdd];
        }
    }];
}
- (void)sdd{
    self.swi_1.on = self.model.stepSwitch;
    self.swi_2.on =  self.model.caculateSwitch;
    self.swi_3.on = self.model.distanceSwitch;
    self.swi_4.on = self.model.sportSwicth;
    
    self.TargetSteps.text = [NSString stringWithFormat:@"%ld",self.model.stepTarget];
    self.calories.text = [NSString stringWithFormat:@"%ld",self.model.calorieTarget];
    self.TargetMileage.text = [NSString stringWithFormat:@"%ld",self.model.distanceTarget];
    self.ExerciseTime.text = [NSString stringWithFormat:@"%ld",self.model.sportTimeTarget];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
