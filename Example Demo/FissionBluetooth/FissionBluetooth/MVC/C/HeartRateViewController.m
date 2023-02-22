//
//  HeartRateViewController.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/1/18.
//

#import "HeartRateViewController.h"

@interface HeartRateViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *maxH;
@property (weak, nonatomic) IBOutlet UITextField *minH;
@property (weak, nonatomic) IBOutlet UITextField *moderate;
@property (weak, nonatomic) IBOutlet UITextField *vigorous;
@property (weak, nonatomic) IBOutlet UITextField *heigtH;
@property (weak, nonatomic) IBOutlet UITextField *HRnew;

@property (nonatomic, retain) FBHeartRateRatingModel *model;

@end

@implementation HeartRateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.maxH.delegate = self;
    self.minH.delegate = self;
    self.moderate.delegate = self;
    self.vigorous.delegate = self;
    self.heigtH.delegate = self;
    self.HRnew.delegate = self;
    
    self.model = [FBHeartRateRatingModel new];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField==self.maxH) {
        self.model.max_hr = [textField.text integerValue];
    } else if (textField==self.minH){
        self.model.min_hr = [textField.text integerValue];
    } else if (textField==self.moderate){
        self.model.moderate = [textField.text integerValue];
    } else if (textField==self.vigorous){
        self.model.vigorous = [textField.text integerValue];
    } else if (textField==self.heigtH){
        self.model.heigt_hr = [textField.text integerValue];
    } else if (textField==self.HRnew){
        self.model.other_hr = [textField.text integerValue];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)setHR:(id)sender {
    WeakSelf(self);
    FBHeartRateRatingModel *model = self.model;
    [FBBgCommand.sharedInstance fbSetHeartRateInforWithModel:model withBlock:^(NSError * _Nullable error) {
        if (error) {
            weakSelf.textView.text = [NSString stringWithFormat:@"%@", error];
        } else {
            weakSelf.textView.text = LWLocalizbleString(@"Success");
        }
    }];
}
- (IBAction)getHR:(id)sender {
    WeakSelf(self);
    [FBBgCommand.sharedInstance fbGetHeartRateInforWithBlock:^(FB_RET_CMD status, float progress, FBHeartRateRatingModel * _Nonnull responseObject, NSError * _Nonnull error) {
        if (error) {
            weakSelf.textView.text = [NSString stringWithFormat:@"%@", error];
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
    self.maxH.text = [NSString stringWithFormat:@"%ld",self.model.max_hr];
    self.minH.text = [NSString stringWithFormat:@"%ld",self.model.min_hr];
    self.moderate.text = [NSString stringWithFormat:@"%ld",self.model.moderate];
    self.vigorous.text = [NSString stringWithFormat:@"%ld",self.model.vigorous];
    self.heigtH.text = [NSString stringWithFormat:@"%ld",self.model.heigt_hr];
    self.HRnew.text = [NSString stringWithFormat:@"%ld",self.model.other_hr];
}
@end
