//
//  FBOTAFailureReportViewController.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-11-04.
//

#import "FBOTAFailureReportViewController.h"
#import "FBOTAFailureReportCell.h"

@interface FBOTAFailureReportViewController () <UITableViewDelegate, UITableViewDataSource>

@end

static NSString *FBOTAFailureReportCellID = @"FBOTAFailureReportCell";
static NSString *UITableViewHeaderFooterViewID = @"UITableViewHeaderFooterView";

@implementation FBOTAFailureReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = [NSString stringWithFormat:@"%@(%ld)", LWLocalizbleString(@"Fail"), self.failureSource.count];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationContentTop) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = 80;
    [tableView registerNib:[UINib nibWithNibName:FBOTAFailureReportCellID bundle:nil] forCellReuseIdentifier:FBOTAFailureReportCellID];
    [tableView registerClass:UITableViewHeaderFooterView.class forHeaderFooterViewReuseIdentifier:UITableViewHeaderFooterViewID];
    [self.view addSubview:tableView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.failureSource.count ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.failureSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *sectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:UITableViewHeaderFooterViewID];
    sectionView.contentView.backgroundColor = COLOR_HEX(0x7B68EE, 1);
    
    NSMutableArray *class = NSMutableArray.array;
    for (UIView *subview in sectionView.subviews) {
        [class addObject:NSStringFromClass(subview.class)];
    }
    
    if (![class containsObject:NSStringFromClass(FBOTAFailureReportCell.class)]) {
        FBOTAFailureReportCell *reportHeaderView = [NSBundle.mainBundle loadNibNamed:FBOTAFailureReportCellID owner:self options:nil].firstObject;
        reportHeaderView.titleLab.textAlignment = NSTextAlignmentCenter;
        reportHeaderView.titleLab.font = FONTBOLD(22);
        reportHeaderView.titleLab.text = @"ERROR";
        reportHeaderView.detailLab.font = FONTBOLD(22);
        reportHeaderView.detailLab.text = LWLocalizbleString(@"TIME");
        [sectionView addSubview:reportHeaderView];
        [reportHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
    }
    
    return sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FBOTAFailureReportCell *cell = [tableView dequeueReusableCellWithIdentifier:FBOTAFailureReportCellID];
    if (indexPath.row < self.failureSource.count) {
        FBAutomaticOTAFailureModel *model = self.failureSource[indexPath.row];
        cell.titleLab.text = model.errorString;
        cell.detailLab.text = @(model.errorCount).stringValue;
    }
    return cell;
}

@end


@implementation FBAutomaticOTAFailureModel

@end
