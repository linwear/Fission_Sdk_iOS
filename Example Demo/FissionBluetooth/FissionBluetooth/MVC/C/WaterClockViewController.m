//
//  WaterClockViewController.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/1/18.
//

#import "WaterClockViewController.h"

@interface WaterClockViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *staH;
@property (weak, nonatomic) IBOutlet UITextField *endH;
@property (weak, nonatomic) IBOutlet UITextField *numb;
@property (weak, nonatomic) IBOutlet UISwitch *swi;
@property (nonatomic, retain) FBWaterClockModel *model;

@end

@implementation WaterClockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.staH.delegate = self;
    self.endH.delegate = self;
    self.numb.delegate = self;
    self.swi.on = YES;
    self.model = [FBWaterClockModel new];

    self.staH.text = [NSString stringWithFormat:@"%ld",self.model.startTime];
    self.endH.text = [NSString stringWithFormat:@"%ld",self.model.endTime];
    self.numb.text = [NSString stringWithFormat:@"%ld", (long)self.model.repeatCount];
}
- (IBAction)setWc:(id)sender {
    self.model.alterSwitch = self.swi.on;
    self.model.startTime = [self.staH.text integerValue];
    self.model.endTime = [self.endH.text integerValue];
    self.model.repeatCount = self.numb.text.integerValue;
    
    FBWaterClockModel *model = self.model;
    
    WeakSelf(self);
    [FBBgCommand.sharedInstance fbSetDrinkWaterWithModel:model withBlock:^(NSError * _Nullable error) {
        if (error) {
            [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
        } else {
            weakSelf.textView.text = LWLocalizbleString(@"Success");
        }
    }];
}
- (IBAction)getWc:(id)sender {
    WeakSelf(self);
    [FBBgCommand.sharedInstance fbGetDrinkWaterWithBlock:^(FB_RET_CMD status, float progress, FBWaterClockModel * _Nonnull responseObject, NSError * _Nonnull error) {
        if (error) {
            [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
        } else if (status==FB_INDATATRANSMISSION) {
            weakSelf.textView.text = [NSString stringWithFormat:@"Receiving Progress: %.f%%", progress*100];
        } else if (status==FB_DATATRANSMISSIONDONE) {
            weakSelf.model = responseObject;
            weakSelf.textView.text = [NSString stringWithFormat:@"%@",[responseObject mj_JSONObject]];
            [weakSelf sass];
        }
    }];
}
- (void)sass{
    self.swi.on = self.model.alterSwitch;
    self.staH.text = [NSString stringWithFormat:@"%ld",self.model.startTime];
    self.endH.text = [NSString stringWithFormat:@"%ld",self.model.endTime];
    self.numb.text = [NSString stringWithFormat:@"%ld",self.model.repeatCount];
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
