//
//  ListViewController.m
//  GMBluetoothManagerDemo
//
//  Created by steven on 2020/11/18.
//  Copyright © 2020 suhengxian. All rights reserved.
//

#import "ListViewController.h"
#import "LWDeviceListCell.h"
#import "QRViewController.h"
#import "FBRadarView.h"
#import "FBConnectViewController.h"

@interface ListViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <FBPeripheralModel *> *dataSource;

@property (nonatomic, assign) BOOL isReload;

@property (nonatomic, strong) QMUISearchBar *searchBar;
@property (nonatomic, strong) NSArray <FBPeripheralModel *> *searchDataSource;
@property (nonatomic, strong) FBRadarView *radarView;

@end

@implementation ListViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _dataSource = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 扫描到设备｜Scan to device
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(ScanToDevice:) name:FISSION_SDK_SCANTODEVICENOTICE object:nil];
    
    // Start scanning device
    [self startScan];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    // Stop scanning peripherals
    [FBBluetoothManager.sharedInstance cancelScan];
    
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = LWLocalizbleString(@"Device List");
    UIBarButtonItem *reloadScan = [[UIBarButtonItem alloc] initWithImage:IMAGE_NAME(@"ic_linear_refresh") style:UIBarButtonItemStylePlain target:self action:@selector(startScan)];
    UIBarButtonItem *scanningCode = [[UIBarButtonItem alloc] initWithImage:IMAGE_NAME(@"ic_linear_scan") style:UIBarButtonItemStylePlain target:self action:@selector(scanningCode)];
    self.navigationItem.rightBarButtonItems = @[reloadScan, scanningCode];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationContentTop) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 64;
    tableView.tableHeaderView = [UIView new];
    [self.view addSubview:tableView];
    [tableView registerClass:LWDeviceListCell.class forCellReuseIdentifier:@"LWDeviceListCell"];
    [tableView registerClass:UITableViewHeaderFooterView.class forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
    self.tableView = tableView;
    
    self.radarView = [[FBRadarView alloc] initWithFrame:tableView.bounds];
    self.tableView.backgroundView = self.radarView;
}

- (void)reloadList {
    WeakSelf(self);
    if (!self.isReload) {
        self.isReload = YES;
        GCD_AFTER(2.0, ^{
            
            if (weakSelf.dataSource.count) {
                [weakSelf.radarView animation:NO];
            }
            
            [weakSelf.dataSource sortUsingComparator:^NSComparisonResult(FBPeripheralModel *  _Nonnull obj1, FBPeripheralModel *  _Nonnull obj2) {
                
                if (obj1.RSSI.integerValue > obj2.RSSI.integerValue) {
                    return NSOrderedAscending;
                } else if (obj1.RSSI.integerValue < obj2.RSSI.integerValue) {
                    return NSOrderedDescending;
                }else{
                    return NSOrderedSame;
                }
            }];
            
            if (StringIsEmpty(weakSelf.searchBar.text)) {
                [weakSelf.tableView reloadData];
            } else {
                [weakSelf searchBar:weakSelf.searchBar textDidChange:weakSelf.searchBar.text];
            }
            
            weakSelf.isReload = NO;
        });
    }
}

- (void)startScan{
    
    [self searchBarSearchButtonClicked:self.searchBar];
    [self.radarView animation:YES];
    
    self.searchDataSource = @[];
    [self.dataSource removeAllObjects];
    [self.tableView reloadData];
    
    if (FBBluetoothManager.sharedInstance.getFBCentralManagerDidUpdateState == CBManagerStatePoweredOn) {
        [FBBluetoothManager.sharedInstance scanForPeripherals];
    }else{
        [NSObject showHUDText:LWLocalizbleString(@"Bluetooth is not turned on or not supported")];
    }
}

- (void)scanningCode {
    [self searchBarSearchButtonClicked:self.searchBar];
    if (NSObject.accessCamera) {
        QRViewController *vc = QRViewController.new;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray <FBPeripheralModel *> *datas;
    if (StringIsEmpty(self.searchBar.text)) {
        datas = self.dataSource.copy;
    } else {
        datas = self.searchDataSource;
    }
    return datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (self.radarView.isAnimation || !self.dataSource.count) ? 0.01 : 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.radarView.isAnimation || !self.dataSource.count) return nil;

    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    if (![headerView.subviews containsObject:self.searchBar]) {
        QMUISearchBar *searchBar = QMUISearchBar.new;
        searchBar.qmui_usedAsTableHeaderView = YES;
        searchBar.placeholder = LWLocalizbleString(@"Search [Device Name] or [MAC Address]");
        searchBar.delegate = self;
        searchBar.returnKeyType = UIReturnKeyDone;
        [headerView addSubview:searchBar];
        searchBar.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        self.searchBar = searchBar;
    }
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LWDeviceListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LWDeviceListCell"];
    UIView *view = UIView.new;
    view.backgroundColor = UIColorTestGreen;
    cell.selectedBackgroundView = view;
    
    NSArray <FBPeripheralModel *> *datas;
    if (StringIsEmpty(self.searchBar.text)) {
        datas = self.dataSource.copy;
    } else {
        datas = self.searchDataSource;
    }
    
    if (indexPath.row < datas.count) {
        
        FBPeripheralModel *model = datas[indexPath.row];
        
        [cell reloadView:model];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray <FBPeripheralModel *> *datas;
    if (StringIsEmpty(self.searchBar.text)) {
        datas = self.dataSource.copy;
    } else {
        datas = self.searchDataSource;
    }
    
    FBPeripheralModel *model = datas[indexPath.row];
    
    FBConnectViewController *vc = FBConnectViewController.new;
    vc.peripheralModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)ScanToDevice:(NSNotification *)obj {
    
    if ([obj.object isKindOfClass:FBPeripheralModel.class]) {
        
        FBPeripheralModel *model = obj.object;
        
        NSArray *array = [NSArray arrayWithArray:self.dataSource];
        
        __block BOOL contains = NO;
         
        [array enumerateObjectsUsingBlock:^(FBPeripheralModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.mac_Address isEqualToString:model.mac_Address] &&
                [obj.device_Name isEqualToString:model.device_Name]) {
                contains = YES;
                *stop = YES;
            }
        }];
        
        if (!contains) {
            
            [self.dataSource addObject:model];

            [self reloadList];
        }
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    // [cd] 大小写不敏感
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"device_Name CONTAINS[cd] %@ || mac_Address CONTAINS[cd] %@", searchText, searchText];

    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"RSSI" ascending:NO];

    NSArray <FBPeripheralModel *> *dataSource = [NSArray arrayWithArray:self.dataSource];

    NSArray <FBPeripheralModel *> *filterData = [[dataSource filteredArrayUsingPredicate:predicate] sortedArrayUsingDescriptors:@[sortDescriptor]];

    self.searchDataSource = filterData;

    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}
    
@end
