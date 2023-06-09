//
//  FBLogViewController.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/1/6.
//

#import "FBLogViewController.h"
#import "FBLogTableViewCell.h"

@interface FBLogViewController () <UITableViewDataSource, UITableViewDelegate, UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *namesArray;

@property (nonatomic, strong) NSMutableArray *pathsArray;

@property(nonatomic,strong) UIDocumentInteractionController *documentController;

@end

@implementation FBLogViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = LWLocalizbleString(@"Log File");
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:IMAGE_NAME(@"ic_linear_refresh") style:UIBarButtonItemStylePlain target:self action:@selector(reloadList)];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,NavigationContentTop,SCREEN_WIDTH, SCREEN_HEIGHT-NavigationContentTop)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 64;
    [self.tableView registerNib:[UINib nibWithNibName:@"FBLogTableViewCell" bundle:nil] forCellReuseIdentifier:@"FBLogTableViewCell"];
    [self.view addSubview:self.tableView];
}

- (void)reloadList {
    [self.namesArray removeAllObjects];
    [self.pathsArray removeAllObjects];
    self.namesArray = [NSMutableArray arrayWithArray:FBLogManager.sharedInstance.allLogNames];
    self.pathsArray = [NSMutableArray arrayWithArray:FBLogManager.sharedInstance.allLogPaths];
    
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
#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.namesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FBLogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FBLogTableViewCell"];
    
    if (indexPath.row < self.namesArray.count) {
        cell.titleLab.text = self.namesArray[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < self.pathsArray.count) {
        
        NSString *path = self.pathsArray[indexPath.row];
        NSURL *url = [NSURL fileURLWithPath:path];
        
        [NSObject showLoading:LWLocalizbleString(@"Loading...")];
        
        self.documentController = [UIDocumentInteractionController interactionControllerWithURL:url];
        self.documentController.delegate = self;
        [self.documentController presentPreviewAnimated:YES];
    }
}

#pragma mark - UIDocumentInteractionControllerDelegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    
    return self;
}

- (void)documentInteractionControllerWillBeginPreview:(UIDocumentInteractionController *)controller {
    
    [SVProgressHUD dismiss];
}

@end
