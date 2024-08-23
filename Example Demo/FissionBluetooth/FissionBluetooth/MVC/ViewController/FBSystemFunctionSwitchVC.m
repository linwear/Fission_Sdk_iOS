//
//  FBSystemFunctionSwitchVC.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-07-07.
//

#import "FBSystemFunctionSwitchVC.h"
#import "FBSystemFunctionSwitchCell.h"

@interface FBSystemFunctionSwitchVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray <FBSFSwitchModel *> *arrayData;

@property (weak, nonatomic) IBOutlet UISwitch *swicth_all;

@end

@implementation FBSystemFunctionSwitchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = LWLocalizbleString(@"System Function Switch");
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"FBSystemFunctionSwitchCell" bundle:nil] forCellReuseIdentifier:@"FBSystemFunctionSwitchCell"];
    
    self.arrayData = NSMutableArray.array;
}

- (IBAction)allClick:(UISwitch *)sender {
    
    for (FBSFSwitchModel *model in self.arrayData) {
        model.isSelect = sender.on;
    }
    
    [self.tableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayData.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FBSystemFunctionSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FBSystemFunctionSwitchCell"];
    
    if (indexPath.row < self.arrayData.count) {
        FBSFSwitchModel *model = self.arrayData[indexPath.row];
        cell.select.selected = model.isSelect;
        cell.title.text = model.title;
        cell.swi.on = model.enable;
        
        WeakSelf(self);
        [cell callBack:^(BOOL enable) {
            model.enable = enable;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FBSFSwitchModel *model = self.arrayData[indexPath.row];
    model.isSelect = !model.isSelect;
    
    if (!model.isSelect) {
        self.swicth_all.on = NO;
    }
    
    [self.tableView reloadData];
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
    
    if (FBAllConfigObject.firmwareConfig.supportSetSystemFunctionSwitch) {
        [self getSystemFunctionSwitchInformation];
    }
    else {
        [NSObject showHUDText:LWLocalizbleString(@"The current device does not support this feature")];
        self.textView.text = LWLocalizbleString(@"The current device does not support this feature");
    }
}

- (IBAction)setClick:(id)sender {
    
    if (FBAllConfigObject.firmwareConfig.supportSetSystemFunctionSwitch) {
        [self fbSetSystemFunctionSwitchInformation];
    }
    else {
        [NSObject showHUDText:LWLocalizbleString(@"The current device does not support this feature")];
        self.textView.text = LWLocalizbleString(@"The current device does not support this feature");
    }
}

- (void)getSystemFunctionSwitchInformation {
    WeakSelf(self);
    [FBBgCommand.sharedInstance fbGetSystemFunctionSwitchInformationWithBlock:^(FB_RET_CMD status, float progress, FBSystemFunctionSwitchModel * _Nullable responseObject, NSError * _Nullable error) {
        
        if (error) {
            [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
            weakSelf.textView.text = [NSString stringWithFormat:@"%@", error];
        } else if (status==FB_INDATATRANSMISSION) {
            weakSelf.textView.text = [NSString stringWithFormat:@"Receiving Progress: %.f%%", progress*100];
        } else if (status==FB_DATATRANSMISSIONDONE) {
            weakSelf.swicth_all.on = NO;
            
            [weakSelf.arrayData removeAllObjects];
            
            FBSFSwitchModel *model_1 = FBSFSwitchModel.new;
            model_1.title = LWLocalizbleString(@"Heart Rate");
            model_1.switchType = FB_SWITCH_HeartRate;
            model_1.enable = responseObject.heartRate;
            [weakSelf.arrayData addObject:model_1];
            
            FBSFSwitchModel *model_2 = FBSFSwitchModel.new;
            model_2.title = LWLocalizbleString(@"Blood Oxygen");
            model_2.switchType = FB_SWITCH_BloodOxygen;
            model_2.enable = responseObject.bloodOxygen;
            [weakSelf.arrayData addObject:model_2];
            
            FBSFSwitchModel *model_3 = FBSFSwitchModel.new;
            model_3.title = LWLocalizbleString(@"Blood Pressure");
            model_3.switchType = FB_SWITCH_BloodPressure;
            model_3.enable = responseObject.bloodPressure;
            [weakSelf.arrayData addObject:model_3];
            
            FBSFSwitchModel *model_4 = FBSFSwitchModel.new;
            model_4.title = LWLocalizbleString(@"Mental Stress");
            model_4.switchType = FB_SWITCH_MentalPressure;
            model_4.enable = responseObject.mentalPressure;
            [weakSelf.arrayData addObject:model_4];
            
            FBSFSwitchModel *model_5 = FBSFSwitchModel.new;
            model_5.title = LWLocalizbleString(@"Call Audio");
            model_5.switchType = FB_SWITCH_CallAudio;
            model_5.enable = responseObject.callAudio;
            [weakSelf.arrayData addObject:model_5];
            
            FBSFSwitchModel *model_6 = FBSFSwitchModel.new;
            model_6.title = LWLocalizbleString(@"Media Audio");
            model_6.switchType = FB_SWITCH_MultimediaAudio;
            model_6.enable = responseObject.multimediaAudio;
            [weakSelf.arrayData addObject:model_6];
            
            FBSFSwitchModel *model_7 = FBSFSwitchModel.new;
            model_7.title = LWLocalizbleString(@"DND Reminder");
            model_7.switchType = FB_SWITCH_DND;
            model_7.enable = responseObject.DND;
            [weakSelf.arrayData addObject:model_7];
            
            FBSFSwitchModel *model_8 = FBSFSwitchModel.new;
            model_8.title = LWLocalizbleString(@"Test Mode");
            model_8.switchType = FB_SWITCH_TestMode;
            model_8.enable = responseObject.testMode;
            [weakSelf.arrayData addObject:model_8];
            
            FBSFSwitchModel *model_9 = FBSFSwitchModel.new;
            model_9.title = LWLocalizbleString(@"Raise Wrist");
            model_9.switchType = FB_SWITCH_WristScreen;
            model_9.enable = responseObject.wristScreen;
            [weakSelf.arrayData addObject:model_9];
            
            weakSelf.textView.text = [NSString stringWithFormat:@"%@",[responseObject mj_JSONObject]];
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)fbSetSystemFunctionSwitchInformation {
    
    FBSystemFunctionSwitchModel *systemFunctionSwitchModel = FBSystemFunctionSwitchModel.new;
    
    FB_CUSTOMSETTINGSWITCHTYPE switchType = FB_SWITCH_None;
    
    for (FBSFSwitchModel *model in self.arrayData) {
        if (model.isSelect) {
            switchType |= model.switchType;
        }
        
        if (model.switchType == FB_SWITCH_HeartRate) {
            systemFunctionSwitchModel.heartRate = model.enable;
        } else if (model.switchType == FB_SWITCH_BloodOxygen) {
            systemFunctionSwitchModel.bloodOxygen = model.enable;
        } else if (model.switchType == FB_SWITCH_BloodPressure) {
            systemFunctionSwitchModel.bloodPressure = model.enable;
        } else if (model.switchType == FB_SWITCH_MentalPressure) {
            systemFunctionSwitchModel.mentalPressure = model.enable;
        } else if (model.switchType == FB_SWITCH_CallAudio) {
            systemFunctionSwitchModel.callAudio = model.enable;
        } else if (model.switchType == FB_SWITCH_MultimediaAudio) {
            systemFunctionSwitchModel.multimediaAudio = model.enable;
        } else if (model.switchType == FB_SWITCH_DND) {
            systemFunctionSwitchModel.DND = model.enable;
        } else if (model.switchType == FB_SWITCH_TestMode) {
            systemFunctionSwitchModel.testMode = model.enable;
        } else if (model.switchType == FB_SWITCH_WristScreen) {
            systemFunctionSwitchModel.wristScreen = model.enable;
        }
    }
    
    if (self.swicth_all.on) {
        switchType = FB_SWITCH_ALL;
    }
    
    WeakSelf(self);
    [FBBgCommand.sharedInstance fbSetSystemFunctionSwitchInformation:systemFunctionSwitchModel withBlock:^(NSError * _Nullable error) {
        if (error) {
            [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
            weakSelf.textView.text = [NSString stringWithFormat:@"%@", error];
        } else {
            weakSelf.textView.text = LWLocalizbleString(@"Success");
        }
    }];
}

@end

@implementation FBSFSwitchModel

@end
