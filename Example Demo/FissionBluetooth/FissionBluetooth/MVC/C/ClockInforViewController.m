//
//  ClockInforViewController.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/1/21.
//

#import "ClockInforViewController.h"
#import "BRPickerView.h"
#import "CollCell.h"

@interface ClockInforViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *Snumber;
@property (weak, nonatomic) IBOutlet UISegmentedControl *ClockIFtype;
@property (weak, nonatomic) IBOutlet UISwitch *EnableSwi;
@property (weak, nonatomic) IBOutlet UISwitch *repSwi;
@property (weak, nonatomic) IBOutlet UICollectionView *collView;
@property (weak, nonatomic) IBOutlet UIButton *dayTime;
@property (weak, nonatomic) IBOutlet UITextField *describe;
@property (weak, nonatomic) IBOutlet UISwitch *laterSwi;

@property (nonatomic, strong) BRDatePickerView *datePickerView;

@end

@implementation ClockInforViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    WeakSelf(self);
    if (!self.model) {
        self.model = [FBAlarmClockModel new];
    }
    FBAlarmClockModel *model = self.model;
    
    self.textView.text = [NSString stringWithFormat:@"%@", model.mj_keyValues];
    
    
    
    self.Snumber.text = [NSString stringWithFormat:@"%ld",(long)model.clockID];
    self.ClockIFtype.selectedSegmentIndex = model.clockCategory;
    [self.ClockIFtype addTarget:self action:@selector(ClockIFtypeClick:) forControlEvents:UIControlEventValueChanged];
    self.EnableSwi.on = model.clockEnableSwitch;
    
    self.repSwi.on = model.isRepeat;
    
    [self ClockIFtypeClick:self.ClockIFtype];
    
    self.describe.text = model.clockDescribe;
    
    self.laterSwi.on = model.remindLater;
    
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

    
    
    
    // 1.创建日期选择器
    self.datePickerView = [[BRDatePickerView alloc]init];
    self.datePickerView.title = @"Time";
    // 2.设置属性
    self.datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
        
        [weakSelf DateTimeSplitString:selectValue];
    };
}
- (void)DateTimeSplitString:(NSString*)string{
    [self.dayTime setTitle:string forState:UIControlStateNormal];
    if (self.ClockIFtype.selectedSegmentIndex==0) {
        self.model.clockYMDHm = string;
    }else{
        self.model.clockHm = string;
    }
}

- (void)ClockIFtypeClick:(UISegmentedControl *)Seg {
    FB_ALARMCATEGORY clockCategory = Seg.selectedSegmentIndex==0?FB_Reminders:FB_AlarmClock;
    
    NSString *clockYMDHm = StringIsEmpty(self.model.clockYMDHm) ? [NSDate br_stringFromDate:NSDate.date dateFormat:@"YYYY-MM-dd HH:mm"] : self.model.clockYMDHm;
    self.model.clockYMDHm = clockYMDHm;
    
    NSString *clockHm = StringIsEmpty(self.model.clockHm) ? [NSDate br_stringFromDate:NSDate.date dateFormat:@"HH:mm"] : self.model.clockHm;
    self.model.clockHm = clockHm;
    
    [self.dayTime setTitle:clockCategory==FB_Reminders ? clockYMDHm : clockHm forState:UIControlStateNormal];
}

#pragma mark -collectionview 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.model.clockRepeatArray.count;  //每个section的Item数
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollCell" forIndexPath:indexPath];
    if (indexPath.row<self.model.clockRepeatArray.count) {
        if (indexPath.row==0) {
            cell.lab.text = LWLocalizbleString(@"Ss");
        } else if (indexPath.row==1){
            cell.lab.text = LWLocalizbleString(@"M");
        } else if (indexPath.row==2){
            cell.lab.text = LWLocalizbleString(@"T");
        } else if (indexPath.row==3){
            cell.lab.text = LWLocalizbleString(@"W");
        } else if (indexPath.row==4){
            cell.lab.text = LWLocalizbleString(@"T");
        } else if (indexPath.row==5){
            cell.lab.text = LWLocalizbleString(@"F");
        } else if (indexPath.row==6){
            cell.lab.text = LWLocalizbleString(@"S");
        }
        cell.lab.backgroundColor = [self.model.clockRepeatArray[indexPath.row] integerValue]==1?[UIColor greenColor]:[UIColor grayColor];
    }
    return cell;

}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.model.clockRepeatArray];
    NSNumber *num = array[indexPath.row];
    if (num.integerValue ==1) {
        num = @0;
        [array replaceObjectAtIndex:indexPath.row withObject:num];
    } else if(num.integerValue ==0){
        num = @1;
        [array replaceObjectAtIndex:indexPath.row withObject:num];
    }
    self.model.clockRepeatArray = array;
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
    if (self.ClockIFtype.selectedSegmentIndex==0) {
        self.datePickerView.pickerMode = BRDatePickerModeYMDHM;
    }else{
        self.datePickerView.pickerMode = BRDatePickerModeHM;
    }
    // 3.显示
    [self.datePickerView show];
}
- (IBAction)setClockInFor:(id)sender {
    self.model.clockID = self.Snumber.text.integerValue;
    self.model.clockCategory = self.ClockIFtype.selectedSegmentIndex==0?FB_Reminders:FB_AlarmClock;
    self.model.clockEnableSwitch = self.EnableSwi.on;
    
    self.model.isRepeat = self.repSwi.on;
    self.model.clockDescribe = self.describe.text;
    self.model.remindLater = self.laterSwi.on;
    
    FBAlarmClockModel *model = self.model;
    //设置记事提醒/闹铃信息
    WeakSelf(self);
    [FBBgCommand.sharedInstance fbSetClockInforWithClockModel:model withRemoved:NO withBlock:^(NSError * _Nullable error) {
        if (error) {
            weakSelf.textView.text = [NSString stringWithFormat:@"%@", error];
        } else {
            weakSelf.textView.text = LWLocalizbleString(@"Success");
        }
    }];
}

@end
