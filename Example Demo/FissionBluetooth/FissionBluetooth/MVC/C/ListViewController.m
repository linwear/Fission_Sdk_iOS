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

@interface ListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray <FBPeripheralModel *> *datas;

@property (nonatomic, assign) BOOL isReload;

@property (nonatomic, strong) FBRadarView *radarView;

@end

@implementation ListViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _datas = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // result
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(result:) name:FISSION_SDK_CONNECTBINGSTATE object:nil];
    
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
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationContentTop)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 64;
    tableView.tableHeaderView = [UIView new];
    [self.view addSubview:tableView];
    [tableView registerClass:LWDeviceListCell.class forCellReuseIdentifier:@"LWDeviceListCell"];
    self.tableView = tableView;
    
    self.radarView = [[FBRadarView alloc] initWithFrame:tableView.bounds];
    self.tableView.backgroundView = self.radarView;
}

- (void)reloadList {
    WeakSelf(self);
    if (!self.isReload) {
        self.isReload = YES;
        GCD_AFTER(5.0, ^{
            
            if (weakSelf.datas.count) {
                [weakSelf.radarView animation:NO];
            }
            
            [weakSelf.datas sortUsingComparator:^NSComparisonResult(FBPeripheralModel *  _Nonnull obj1, FBPeripheralModel *  _Nonnull obj2) {
                
                if (obj1.RSSI.integerValue > obj2.RSSI.integerValue) {
                    return NSOrderedAscending;
                } else if (obj1.RSSI.integerValue < obj2.RSSI.integerValue) {
                    return NSOrderedDescending;
                }else{
                    return NSOrderedSame;
                }
            }];
            
            [weakSelf.tableView reloadData];
            weakSelf.isReload = NO;
        });
    }
}

- (void)startScan{
    
    [self.radarView animation:YES];
    
    [self.datas removeAllObjects];
    [self.tableView reloadData];
    
    if (FBBluetoothManager.sharedInstance.getFBCentralManagerDidUpdateState == CBManagerStatePoweredOn) {
        [FBBluetoothManager.sharedInstance scanForPeripherals];
    }else{
        [NSObject showHUDText:LWLocalizbleString(@"Bluetooth is not turned on or not supported")];
    }
}

- (void)scanningCode {
    if (NSObject.accessCamera) {
        QRViewController *vc = QRViewController.new;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LWDeviceListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LWDeviceListCell"];
    UIView *view = UIView.new;
    view.backgroundColor = UIColorTestGreen;
    cell.selectedBackgroundView = view;
    
    if (indexPath.row < self.datas.count) {
        
        FBPeripheralModel *model = self.datas[indexPath.row];
        
        [cell reloadView:model];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FBPeripheralModel *model = self.datas[indexPath.row];
    
    [FBBluetoothManager.sharedInstance connectToPeripheral:model.peripheral];
    
    [NSObject showLoading:LWLocalizbleString(@"Connecting")];
}

- (void)result:(NSNotification *)obj {
    
    if ([obj.object isKindOfClass:NSNumber.class]) {
        
        CONNECTBINGSTATE state = (CONNECTBINGSTATE)[obj.object integerValue];
        if (state == CONNECTBINGSTATE_COMPLETE) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if ([obj.object isKindOfClass:FBPeripheralModel.class]) {
        
        FBPeripheralModel *model = obj.object;
        
        NSArray *array = [NSArray arrayWithArray:self.datas];
        
        __block BOOL contains = NO;
         
        [array enumerateObjectsUsingBlock:^(FBPeripheralModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.mac_Address isEqualToString:model.mac_Address] &&
                [obj.device_Name isEqualToString:model.device_Name]) {
                contains = YES;
                *stop = YES;
            }
        }];
        
        if (!contains) {
            
            [self.datas addObject:model];

            [self reloadList];
        }
    }
}
    
@end
