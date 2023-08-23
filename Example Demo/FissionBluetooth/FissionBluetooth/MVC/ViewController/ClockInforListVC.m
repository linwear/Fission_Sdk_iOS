//
//  ClockInforListVC.m
//  sxs
//
//  Created by 裂变智能 on 2021/2/26.
//

#import "ClockInforListVC.h"
#import "ClockInforViewController.h"
#import "ClockListTableViewCell.h"

@interface ClockInforListVC () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, retain) NSMutableArray *arrayData;
@end

@implementation ClockInforListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"ClockListTableViewCell" bundle:nil] forCellReuseIdentifier:@"ClockListTableViewCell"];
    
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithImage:IMAGE_NAME(@"ic_linear_add") style:UIBarButtonItemStylePlain target:self action:@selector(add)];
    self.navigationItem.rightBarButtonItem = bar;
    
    UIImageView *ima = [[UIImageView alloc]initWithFrame:self.tableView.bounds];
    ima.image = IMAGE_NAME(@"pic_home");
    self.tableView.backgroundView = ima;
    
    //自定义功能状态变更通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveAlarmClockSwitchSynchronization:) name:FISSION_SDK_FUNCTIONSTATUSCHANGE object:nil]; //fission
}

- (void)receiveAlarmClockSwitchSynchronization:(NSNotification *)noti {
    
    FBWatchFunctionChangeNoticeModel *model = (FBWatchFunctionChangeNoticeModel *)noti.object;
    
    if (model.functionMode == FS_ALARMCLOCK_CHANGENOTICE) {
        [self GetClockInfor];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.tableView.backgroundView.hidden = self.arrayData.count;
    return self.arrayData.count;
}

#pragma mark 也可以使用 IOS11之后
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath  API_AVAILABLE(ios(11.0)){
    //删除
    WeakSelf(self);
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"Delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        //左滑删除之后数据处理操作
        [FBBgCommand.sharedInstance fbSetClockInforWithClockModel:weakSelf.arrayData[indexPath.row] withRemoved:YES withBlock:^(NSError * _Nullable error) {
            if (error) {
                [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
            } else {
                weakSelf.textView.text = LWLocalizbleString(@"Success");
                [weakSelf.arrayData removeObjectAtIndex:indexPath.row];
                [weakSelf.tableView reloadData];
            }
        }];
    }];
    deleteRowAction.backgroundColor = [UIColor grayColor];//删除背景颜色
    UISwipeActionsConfiguration *Configuration = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
    return Configuration;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClockListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClockListTableViewCell"];
    
    if (indexPath.row<self.arrayData.count) {
        FBAlarmClockModel *model = self.arrayData[indexPath.row];
        [cell cellModel:model];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FBAlarmClockModel *model = self.arrayData[indexPath.row];
    ClockInforViewController *vc = [ClockInforViewController new];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)add{
    
    if (FBAllConfigObject.firmwareConfig.supportSetAlarmClock) {
        
        WeakSelf(self);
        int max = FBAllConfigObject.firmwareConfig.supportMoreAlarmClock ? 10 : 5;
        
        [FBAtCommand.sharedInstance fbGetUnusedClockIDWithBlock:^(NSInteger responseObject, NSError * _Nullable error) {
            if (error) {
                [NSObject showHUDText:error.localizedDescription];
            }else{
                if (responseObject >= max) {
                    [NSObject showHUDText:[NSString stringWithFormat:LWLocalizbleString(@"Up to %d alarms can be set"), max]];
                }else{
                    FBAlarmClockModel *model = [FBAlarmClockModel new];
                    model.clockID = responseObject;
                    ClockInforViewController *vc = [ClockInforViewController new];
                    vc.navigationItem.title = self.navigationItem.title;
                    vc.model = model;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
            }
        }];
    }
    else {
        [NSObject showHUDText:LWLocalizbleString(@"This function does not support")];
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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self GetClockInfor];
}
- (IBAction)getinfor:(id)sender {
    [self GetClockInfor];
}
- (void)GetClockInfor {
    WeakSelf(self);
    [FBBgCommand.sharedInstance fbGetClockInforWithBlock:^(FB_RET_CMD status, float progress, NSArray<FBAlarmClockModel *> * _Nonnull responseObject, NSError * _Nonnull error) {
        if (error) {
            [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
        } else if (status==FB_INDATATRANSMISSION) {
            weakSelf.textView.text = [NSString stringWithFormat:@"Receiving Progress: %.f%%", progress*100];
        } else if (status==FB_DATATRANSMISSIONDONE) {
            weakSelf.arrayData = [NSMutableArray arrayWithArray:responseObject];
            NSMutableString *dsd = [NSMutableString string];
            for (FBAlarmClockModel *model in responseObject) {
                [dsd appendFormat:@"%@", [NSString stringWithFormat:@"%@",[model mj_JSONObject]]];
            }
            weakSelf.textView.text = dsd.length ? dsd: LWLocalizbleString(@"No Data");
            [weakSelf.tableView reloadData];
        }
    }];
}

@end
