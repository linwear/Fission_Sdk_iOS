//
//  LeftViewController.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2022/12/6.
//

#import "LeftViewController.h"
#import "ListViewController.h"
#import "FBLogViewController.h"
#import "FBAboutViewController.h"

@interface LeftViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *arrayData;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorClear;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.75, SCREEN_HEIGHT) style:UITableViewStylePlain];
    tableView.backgroundColor = UIColorClear;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 52;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    [tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"LeftViewControllerCell"];
    self.tableView = tableView;
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, tableView.width-NavigationContentTop)];
    headView.backgroundColor = UIColorClear;
    
    UIImageView *headImage = [[UIImageView alloc] initWithImage:Tools.appIcon];
    [headView addSubview:headImage];
    headImage.sd_layout.centerXEqualToView(headView).centerYEqualToView(headView).widthIs(80).heightIs(80);
    headImage.sd_cornerRadius = @(8);
    headImage.layer.borderWidth = 2;
    headImage.layer.borderColor = UIColorWhite.CGColor;
    self.tableView.tableHeaderView = headView;
    
    [self loadData];
}

- (void)loadData {
    NSMutableArray *array = NSMutableArray.array;
    if (FBAllConfigObject.firmwareConfig.deviceName.length > 0) {
        [array addObject:@{@"personal_preview_icons" : LWLocalizbleString(@"Disconnect")}];
    } else {
        [array addObject:@{@"personal_preview_icons" : LWLocalizbleString(@"Search Connected")}];
    }
    [array addObjectsFromArray:@[
        @{@"personal_order_icons" : LWLocalizbleString(@"Log File")},
        @{@"personal_myservice_icons" : LWLocalizbleString(@"About")},
    ]];
    
    self.arrayData = array.copy;
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftViewControllerCell"];
    cell.backgroundColor = UIColorClear;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row < self.arrayData.count) {
        NSDictionary *dict = self.arrayData[indexPath.row];
        cell.imageView.image = IMAGE_NAME(dict.allKeys.firstObject);
        cell.textLabel.text = dict.allValues.firstObject;
        cell.textLabel.textColor = [dict.allValues.firstObject isEqualToString:LWLocalizbleString(@"Disconnect")] ? UIColorRed : UIColorWhite;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.arrayData[indexPath.row];
    
    if ([dict.allValues.firstObject isEqualToString:LWLocalizbleString(@"Search Connected")]) {
        ListViewController *vc = ListViewController.new;
        [self cw_pushViewController:vc];
    }
    else if ([dict.allValues.firstObject isEqualToString:LWLocalizbleString(@"Disconnect")]) {
        
        WeakSelf(self);
        [UIAlertObject presentAlertTitle:LWLocalizbleString(@"Tip") message:LWLocalizbleString(@"Confirm whether to unbind the device and disconnect?") cancel:LWLocalizbleString(@"Cancel") sure:LWLocalizbleString(@"Disconnect") block:^(AlertClickType clickType) {
            
            if (clickType == AlertClickType_Sure) {
                [FBAtCommand.sharedInstance fbUnbindDeviceRequestWithBlock:^(NSError * _Nullable error) {
                    if (error) {
                        // error...
                    }
                    
                    [FBBluetoothManager.sharedInstance disconnectPeripheral];
                    
                    GCD_MAIN_QUEUE(^{
                        [weakSelf loadData];
                    });
                }];
            }
        }];
    }
    else if ([dict.allValues.firstObject isEqualToString:LWLocalizbleString(@"Log File")]) {
        FBLogViewController *vc = FBLogViewController.new;
        [self cw_pushViewController:vc];
    }
    else if ([dict.allValues.firstObject isEqualToString:LWLocalizbleString(@"About")]) {
        FBAboutViewController *vc = FBAboutViewController.new;
        [self cw_pushViewController:vc];
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

@end
