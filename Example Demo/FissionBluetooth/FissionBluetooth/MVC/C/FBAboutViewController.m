//
//  FBAboutViewController.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/1/7.
//

#import "FBAboutViewController.h"
#import "FBAboutHeadView.h"

@interface FBAboutViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) FBAboutHeadView *headView;

@end

@implementation FBAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = LWLocalizbleString(@"About");
    
    UILabel *lab = [[UILabel alloc] qmui_initWithFont:FONT(12) textColor:UIColorGrayLighten];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = [NSString stringWithFormat:@"Fission Bluetooth\n©️2020 - %ld All Rights Reserved.", NSDate.date.br_year];
    [self.view addSubview:lab];
    lab.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).bottomSpaceToView(self.view, 25).autoHeightRatio(0);
    
    UITableView *tableView = UITableView.new;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 64;
    [tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"FBAboutTableViewCell"];
    [self.view addSubview:tableView];
    tableView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topEqualToView(self.view).bottomSpaceToView(lab, 0);
    self.tableView = tableView;
    
    FBAboutHeadView *headView = [[FBAboutHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.4) withImage:UIImageMake(@"IMG_0737")];
    self.tableView.tableHeaderView = headView;
    self.headView = headView;
    
    self.dataArray = @[
        @{@"GitHub" : @"https://github.com/linwear/Fission_Sdk_iOS.git"}
    ];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 获取当前偏移量
    CGFloat offsetY = scrollView.contentOffset.y;
    
    [self.headView scrollViewDidScroll_y:offsetY];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FBAboutTableViewCell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row < self.dataArray.count) {
        NSDictionary *dict = self.dataArray[indexPath.row];
        cell.textLabel.text = dict.allKeys.firstObject;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = self.dataArray[indexPath.row];
    FBWebViewController *vc = FBWebViewController.new;
    vc.url = [NSURL URLWithString:dict.allValues.firstObject];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
