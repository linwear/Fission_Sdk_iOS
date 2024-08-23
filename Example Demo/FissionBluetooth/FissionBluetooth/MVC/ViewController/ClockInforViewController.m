//
//  ClockInforViewController.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/1/21.
//

#import "ClockInforViewController.h"
#import "BRPickerView.h"
#import "CollCell.h"

@interface ClockInforViewController ()<UICollectionViewDelegate,UICollectionViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *Snumber;
@property (weak, nonatomic) IBOutlet UISegmentedControl *ClockIFtype;
@property (weak, nonatomic) IBOutlet UISwitch *EnableSwi;
@property (weak, nonatomic) IBOutlet UISwitch *repSwi;
@property (weak, nonatomic) IBOutlet UICollectionView *collView;
@property (weak, nonatomic) IBOutlet UIButton *dayTime;
@property (weak, nonatomic) IBOutlet UITextField *describe;
@property (weak, nonatomic) IBOutlet UISwitch *laterSwi;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITextField *titleDescribe;
@property (weak, nonatomic) IBOutlet UITextField *locationDescribe;
@property (weak, nonatomic) IBOutlet UIButton *staBut;
@property (weak, nonatomic) IBOutlet UIButton *endBut;
@end

@implementation ClockInforViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.bottomView.hidden = !self.isSchedule;
    
    self.describe.delegate = self;
    self.titleDescribe.delegate = self;
    self.locationDescribe.delegate = self;
    
    if (self.isSchedule) {
        self.textView.text = [NSString stringWithFormat:@"%@", self.scheduleModel.mj_keyValues];
        
        self.Snumber.text = [NSString stringWithFormat:@"%ld",(long)self.scheduleModel.clockID];
        self.ClockIFtype.selectedSegmentIndex = self.scheduleModel.clockCategory;
        [self.ClockIFtype addTarget:self action:@selector(ClockIFtypeClick:) forControlEvents:UIControlEventValueChanged];
        self.EnableSwi.on = self.scheduleModel.clockEnableSwitch;
        
        self.repSwi.on = self.scheduleModel.isRepeat;
        
        [self ClockIFtypeClick:self.ClockIFtype];
        
        self.describe.placeholder = @"Description (up to 64 bytes)";
        self.describe.text = self.scheduleModel.contentDescribe;
        
        self.titleDescribe.text = self.scheduleModel.titleDescribe;
        
        self.locationDescribe.text = self.scheduleModel.locationDescribe;
        
        if (self.scheduleModel.startTime <= 0) {
            self.scheduleModel.startTime = NSDate.date.timeIntervalSince1970 + 15*60;
        }
        NSString *startTimeString = [NSDate br_stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.scheduleModel.startTime] dateFormat:@"MM-dd HH:mm"];
        [self.staBut setTitle:startTimeString forState:UIControlStateNormal];
        
        if (self.scheduleModel.endTime <= 0) {
            self.scheduleModel.endTime = NSDate.date.timeIntervalSince1970 + 30*60;
        }
        NSString *endTimeString = [NSDate br_stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.scheduleModel.endTime] dateFormat:@"MM-dd HH:mm"];
        [self.endBut setTitle:endTimeString forState:UIControlStateNormal];
        
        self.laterSwi.on = self.scheduleModel.remindLater;
    }
    else {
        self.textView.text = [NSString stringWithFormat:@"%@", self.alarmClockModel.mj_keyValues];
        
        self.Snumber.text = [NSString stringWithFormat:@"%ld",(long)self.alarmClockModel.clockID];
        self.ClockIFtype.selectedSegmentIndex = self.alarmClockModel.clockCategory;
        [self.ClockIFtype addTarget:self action:@selector(ClockIFtypeClick:) forControlEvents:UIControlEventValueChanged];
        self.EnableSwi.on = self.alarmClockModel.clockEnableSwitch;
        
        self.repSwi.on = self.alarmClockModel.isRepeat;
        
        [self ClockIFtypeClick:self.ClockIFtype];
        
        self.describe.placeholder = @"Description (up to 24 bytes)";
        self.describe.text = self.alarmClockModel.clockDescribe;
        
        self.laterSwi.on = self.alarmClockModel.remindLater;
    }
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置item的行间距和列间距
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
        // 设置item的大小
    CGFloat itemW = (SCREEN_WIDTH-40)/7;
    layout.itemSize = CGSizeMake(itemW, 31);
        // 设置每个分区的 上左下右 的内边距
    layout.sectionInset = UIEdgeInsetsMake(0, 0 ,0, 0);
        // 设置区头和区尾的大小
//    layout.headerReferenceSize = CGSizeMake(kScreenWidth, 65);
//    layout.footerReferenceSize = CGSizeMake(kScreenWidth, 65);
        // 设置分区的头视图和尾视图 是否始终固定在屏幕上边和下边
//        layout.sectionFootersPinToVisibleBounds = YES;
        // 设置滚动条方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    [self.collView setCollectionViewLayout:layout];
    self.collView.showsVerticalScrollIndicator = NO;   //是否显示滚动条
    self.collView.delegate = self;
    self.collView.dataSource = self;
    [self.collView registerNib:[UINib nibWithNibName:@"CollCell" bundle:nil] forCellWithReuseIdentifier:@"CollCell"];
}
- (void)dateTime:(NSDate *)date splitString:(NSString*)string{
    [self.dayTime setTitle:string forState:UIControlStateNormal];
    if (self.ClockIFtype.selectedSegmentIndex==0) {
        if (self.isSchedule) {
            self.scheduleModel.remindersTime = date.timeIntervalSince1970;
        } else {
            self.alarmClockModel.clockYMDHm = string;
        }
    } else {
        if (self.isSchedule) {
            self.scheduleModel.clockTime = date.br_hour*60 + date.br_minute;
        } else {
            self.alarmClockModel.clockHm = string;
        }
    }
}

- (void)ClockIFtypeClick:(UISegmentedControl *)Seg {
    FB_ALARMCATEGORY clockCategory = Seg.selectedSegmentIndex==0? FB_Reminders : FB_AlarmClock;
        
    NSString *timeString;
    
    if (clockCategory == FB_Reminders) {
        if (self.isSchedule) {
            if (self.scheduleModel.remindersTime <= 0) {
                self.scheduleModel.remindersTime = NSDate.date.timeIntervalSince1970;
            }
            timeString = [NSDate timeStamp:self.scheduleModel.remindersTime dateFormat:FBDateFormatYMDHm];
        } else {
            timeString = StringIsEmpty(self.alarmClockModel.clockYMDHm) ? [NSDate br_stringFromDate:NSDate.date dateFormat:@"YYYY-MM-dd HH:mm"] : self.alarmClockModel.clockYMDHm;
            self.alarmClockModel.clockYMDHm = timeString;
        }
    }
    else {
        if (self.isSchedule) {
            timeString = [NSString stringWithFormat:@"%02ld:%02ld", (NSInteger)floor(self.scheduleModel.clockTime/60.0), self.scheduleModel.clockTime%60];
        } else {
            timeString = StringIsEmpty(self.alarmClockModel.clockHm) ? [NSDate br_stringFromDate:NSDate.date dateFormat:@"HH:mm"] : self.alarmClockModel.clockHm;
            self.alarmClockModel.clockHm = timeString;
        }
    }
    
    
    [self.dayTime setTitle:timeString forState:UIControlStateNormal];
}

#pragma mark -collectionview 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if (self.isSchedule) {
        return self.scheduleModel.clockRepeatArray.count;  //每个section的Item数
    } else {
        return self.alarmClockModel.clockRepeatArray.count;  //每个section的Item数
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollCell" forIndexPath:indexPath];
    NSArray *array;
    if (self.isSchedule) {
        array = self.scheduleModel.clockRepeatArray;
    } else {
        array = self.alarmClockModel.clockRepeatArray;
    }
    if (indexPath.row < array.count) {
        if (indexPath.row==0) {
            cell.lab.text = LWLocalizbleString(@"Ss");
        } else if (indexPath.row==1){
            cell.lab.text = LWLocalizbleString(@"M");
        } else if (indexPath.row==2){
            cell.lab.text = LWLocalizbleString(@"T");
        } else if (indexPath.row==3){
            cell.lab.text = LWLocalizbleString(@"W");
        } else if (indexPath.row==4){
            cell.lab.text = LWLocalizbleString(@"Tt");
        } else if (indexPath.row==5){
            cell.lab.text = LWLocalizbleString(@"F");
        } else if (indexPath.row==6){
            cell.lab.text = LWLocalizbleString(@"S");
        }
        cell.lab.backgroundColor = [array[indexPath.row] integerValue]==1?[UIColor greenColor]:[UIColor grayColor];
    }
    return cell;

}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr;
    if (self.isSchedule) {
        arr = self.scheduleModel.clockRepeatArray;
    } else {
        arr = self.alarmClockModel.clockRepeatArray;
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:arr];
    NSNumber *num = array[indexPath.row];
    if (num.integerValue ==1) {
        num = @0;
        [array replaceObjectAtIndex:indexPath.row withObject:num];
    } else if(num.integerValue ==0){
        num = @1;
        [array replaceObjectAtIndex:indexPath.row withObject:num];
    }
    if (self.isSchedule) {
        self.scheduleModel.clockRepeatArray = array.copy;
    } else {
        self.alarmClockModel.clockRepeatArray = array.copy;
    }
    
    [self.collView reloadData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)selectionDayTimer:(id)sender {
    WeakSelf(self);
    
    // 1.创建日期选择器
    BRDatePickerView *datePickerView = [[BRDatePickerView alloc]init];
    datePickerView.title = @"Time";
    // 2.设置属性
    if (self.ClockIFtype.selectedSegmentIndex==0) {
        datePickerView.pickerMode = BRDatePickerModeYMDHM;
        datePickerView.showWeek = YES;
        datePickerView.showUnitType = BRShowUnitTypeNone;
        if (self.isSchedule) {
            datePickerView.selectDate = self.scheduleModel.remindersTime>0 ? [NSDate dateWithTimeIntervalSince1970:self.scheduleModel.remindersTime] : NSDate.date;
        } else {
            if (StringIsEmpty(self.alarmClockModel.clockYMDHm)) {
                datePickerView.selectDate = NSDate.date;
            } else {
                datePickerView.selectValue = self.alarmClockModel.clockYMDHm;
            }
        }
    }else{
        datePickerView.pickerMode = BRDatePickerModeHM;
        if (self.isSchedule) {
            datePickerView.selectValue = [NSString stringWithFormat:@"%02ld:%02ld", (NSInteger)floor(self.scheduleModel.clockTime/60.0), self.scheduleModel.clockTime%60];
        } else {
            if (StringIsEmpty(self.alarmClockModel.clockHm)) {
                datePickerView.selectDate = NSDate.date;
            } else {
                datePickerView.selectValue = self.alarmClockModel.clockHm;
            }
        }
    }
    datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
        
        [weakSelf dateTime:selectDate splitString:selectValue];
    };
    // 3.显示
    [datePickerView show];
}
- (IBAction)staClick:(id)sender {
    WeakSelf(self);
    
    // 1.创建日期选择器
    BRDatePickerView *datePickerView = [[BRDatePickerView alloc]init];
    datePickerView.title = @"Time";
    // 2.设置属性
    datePickerView.pickerMode = BRDatePickerModeYMDHM;
    datePickerView.selectDate = [NSDate dateWithTimeIntervalSince1970:self.scheduleModel.startTime];
    datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
        
        weakSelf.scheduleModel.startTime = selectDate.timeIntervalSince1970;
        [weakSelf.staBut setTitle:[NSDate br_stringFromDate:selectDate dateFormat:@"MM-dd HH:mm"] forState:UIControlStateNormal];
    };
    // 3.显示
    [datePickerView show];
}
- (IBAction)endClick:(id)sender {
    WeakSelf(self);
    
    // 1.创建日期选择器
    BRDatePickerView *datePickerView = [[BRDatePickerView alloc]init];
    datePickerView.title = @"Time";
    // 2.设置属性
    datePickerView.pickerMode = BRDatePickerModeYMDHM;
    datePickerView.selectDate = [NSDate dateWithTimeIntervalSince1970:self.scheduleModel.endTime];
    datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
        
        weakSelf.scheduleModel.endTime = selectDate.timeIntervalSince1970;
        [weakSelf.endBut setTitle:[NSDate br_stringFromDate:selectDate dateFormat:@"MM-dd HH:mm"] forState:UIControlStateNormal];
    };
    // 3.显示
    [datePickerView show];
}
- (IBAction)setClockInFor:(id)sender {
    
    if (self.isSchedule) {
        self.scheduleModel.clockID = self.Snumber.text.integerValue;
        self.scheduleModel.clockCategory = self.ClockIFtype.selectedSegmentIndex==0?FB_Reminders:FB_AlarmClock;
        self.scheduleModel.clockEnableSwitch = self.EnableSwi.on;
        
        self.scheduleModel.isRepeat = self.repSwi.on;
        self.scheduleModel.contentDescribe = self.describe.text;
        self.scheduleModel.remindLater = self.laterSwi.on;
        
        self.scheduleModel.titleDescribe = self.titleDescribe.text;
        self.scheduleModel.locationDescribe = self.locationDescribe.text;
        
        FBScheduleModel *scheduleModel = self.scheduleModel;
        //设置记事提醒/闹铃信息
        WeakSelf(self);
        [FBBgCommand.sharedInstance fbSetSchedulenforWithScheduleModel:scheduleModel withRemoved:NO withBlock:^(NSError * _Nullable error) {
            if (error) {
                weakSelf.textView.text = [NSString stringWithFormat:@"%@", error];
            } else {
                weakSelf.textView.text = LWLocalizbleString(@"Success");
            }
        }];
    }
    else {
        self.alarmClockModel.clockID = self.Snumber.text.integerValue;
        self.alarmClockModel.clockCategory = self.ClockIFtype.selectedSegmentIndex==0?FB_Reminders:FB_AlarmClock;
        self.alarmClockModel.clockEnableSwitch = self.EnableSwi.on;
        
        self.alarmClockModel.isRepeat = self.repSwi.on;
        self.alarmClockModel.clockDescribe = self.describe.text;
        self.alarmClockModel.remindLater = self.laterSwi.on;
        
        FBAlarmClockModel *alarmClockModel = self.alarmClockModel;
        //设置记事提醒/闹铃信息
        WeakSelf(self);
        [FBBgCommand.sharedInstance fbSetClockInforWithClockModel:alarmClockModel withRemoved:NO withBlock:^(NSError * _Nullable error) {
            if (error) {
                weakSelf.textView.text = [NSString stringWithFormat:@"%@", error];
            } else {
                weakSelf.textView.text = LWLocalizbleString(@"Success");
            }
        }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.describe resignFirstResponder];
    [self.titleDescribe resignFirstResponder];
    [self.locationDescribe resignFirstResponder];
    return YES;
}

@end
