//
//  FemaleCircadianCycleVC.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/6/1.
//

#import "FemaleCircadianCycleVC.h"
#import "BRPickerView.h"
#import "FemaleCell.h"

@interface FemaleCircadianCycleVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, retain) BRDatePickerView *datePickerView;
@property (nonatomic, retain) BRTextPickerView *textPickerView;

@property (nonatomic, retain) FBFemalePhysiologyModel *model;

@end

@implementation FemaleCircadianCycleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 490;
    [self.tableView registerNib:[UINib nibWithNibName:@"FemaleCell" bundle:nil] forCellReuseIdentifier:@"FemaleCell"];
    
    // 1.创建日期选择器
    self.datePickerView = [[BRDatePickerView alloc] init];
    self.textPickerView = [[BRTextPickerView alloc] initWithPickerMode:BRTextPickerComponentSingle];
    
    self.model = [FBFemalePhysiologyModel new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeakSelf(self);
    FemaleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FemaleCell"];
    cell.femaleCellBlock = ^(NSInteger type) {
        [weakSelf femaleCellBlockClick:type];
    };
    cell.model = self.model;
    return cell;
}

- (void)femaleCellBlockClick:(NSInteger)type{
    WeakSelf(self);
    if (type==1) {
        self.textPickerView.title = @"Health mode";
        self.textPickerView.pickerMode = BRTextPickerComponentSingle;
        self.textPickerView.dataSourceArr = @[@"Closure", @"Menstrual Period", @"Pregnancy Period", @"Pregnancy"];
        self.textPickerView.selectIndex = self.model.HealthModel;
        self.textPickerView.singleResultBlock = ^(BRTextModel * _Nullable model, NSInteger index) {
            weakSelf.model.HealthModel = (int)index;
            [weakSelf.tableView reloadData];
        };
        [self.textPickerView show];
    } else if (type==2){
        NSMutableArray *ary = @[].mutableCopy;
        for (int i = 1; i < 4; i++) {
            [ary addObject: @(i).stringValue];
        }
        self.textPickerView.title = @"Reminder days in advance";
        self.textPickerView.pickerMode = BRTextPickerComponentSingle;
        self.textPickerView.dataSourceArr = ary;
        self.textPickerView.singleResultBlock = ^(BRTextModel * _Nullable model, NSInteger index) {
            weakSelf.model.daysInAdvance = model.text.integerValue;
            [weakSelf.tableView reloadData];
        };
        [self.textPickerView show];
    } else if (type==3){
        NSMutableArray *ary = @[].mutableCopy;
        for (int i = 3; i < 16; i++) {
            [ary addObject: @(i).stringValue];
        }
        self.textPickerView.title = @"Days of menstrual period";
        self.textPickerView.pickerMode = BRTextPickerComponentSingle;
        self.textPickerView.dataSourceArr = ary;
        self.textPickerView.singleResultBlock = ^(BRTextModel * _Nullable model, NSInteger index) {
            weakSelf.model.daysMenstruation = model.text.integerValue;
            [weakSelf.tableView reloadData];
        };
        [self.textPickerView show];
    } else if (type==4){
        NSMutableArray *ary = @[].mutableCopy;
        for (int i = 17; i < 61; i++) {
            [ary addObject: @(i).stringValue];
        }
        self.textPickerView.title = @"Menstrual Cycle";
        self.textPickerView.pickerMode = BRTextPickerComponentSingle;
        self.textPickerView.dataSourceArr = ary;
        self.textPickerView.singleResultBlock = ^(BRTextModel * _Nullable model, NSInteger index) {
            weakSelf.model.cycleLength = model.text.integerValue;
            [weakSelf.tableView reloadData];
        };
        [self.textPickerView show];
    } else if (type==5){
        self.datePickerView.pickerMode = BRDatePickerModeYMD;
        self.datePickerView.minDate = [NSDate br_setYear:2020 month:1 day:1];
        self.datePickerView.maxDate = [NSDate date];
        self.datePickerView.title = @"Last menstrual period";
        self.datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
            
            weakSelf.model.lastYear = selectDate.br_year;
            weakSelf.model.lastMonth = selectDate.br_month;
            weakSelf.model.lastDay = selectDate.br_day;
            [weakSelf.tableView reloadData];
        };
        [self.datePickerView show];
    } else if (type==6){
        self.textPickerView.title = @"Pregnancy Reminder";
        self.textPickerView.pickerMode = BRTextPickerComponentSingle;
        self.textPickerView.dataSourceArr = @[@"Days Pregnant",@"Days to due date"];
        self.textPickerView.singleResultBlock = ^(BRTextModel * _Nullable model, NSInteger index) {
            weakSelf.model.isPreProduction = index==1?YES:NO;
            [weakSelf.tableView reloadData];
        };
        [self.textPickerView show];
    } else if (type==7){
        self.datePickerView.pickerMode = BRDatePickerModeHM;
        self.datePickerView.title = @"Reminder Time";
        self.datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
            
            weakSelf.model.reminderHours = selectDate.br_hour;
            weakSelf.model.reminderMinutes = selectDate.br_minute;
            [weakSelf.tableView reloadData];
        };
        [self.datePickerView show];
    } else if (type==100){
        self.model.reminderSwitch = YES;
        [self.tableView reloadData];
    } else if (type==200){
        self.model.reminderSwitch = NO;
        [self.tableView reloadData];
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
- (IBAction)getBut:(id)sender {
    WeakSelf(self);
    [FBBgCommand.sharedInstance fbGetFemaleCircadianCycleWithBlock:^(FB_RET_CMD status, float progress, FBFemalePhysiologyModel * _Nonnull responseObject, NSError * _Nonnull error) {
        if (error) {
            [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
        } else if (status==FB_INDATATRANSMISSION) {
            weakSelf.textView.text = [NSString stringWithFormat:@"Receiving Progress: %.f%%", progress*100];
        } else if (status==FB_DATATRANSMISSIONDONE) {
            weakSelf.model = responseObject;
            [weakSelf.tableView reloadData];
            weakSelf.textView.text = [NSString stringWithFormat:@"%@",[responseObject mj_JSONObject]];
        }
    }];
}
- (IBAction)setbut:(id)sender {
    WeakSelf(self);
    FBFemalePhysiologyModel *model = self.model;
    [FBBgCommand.sharedInstance fbSetFemaleCircadianCycleWithModel:model withBlock:^(NSError * _Nullable error) {
        if (error) {
            [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
        } else {
            weakSelf.textView.text = LWLocalizbleString(@"Success");
        }
    }];
}

@end
