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

@property (nonatomic, strong) NSArray <DDLogFileInfo *> *allLogFileInfo;

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
    self.allLogFileInfo = FBLogManager.sharedInstance.allLogFileInfo;
    
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
    
    return self.allLogFileInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FBLogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FBLogTableViewCell"];
    
    if (indexPath.row < self.allLogFileInfo.count) {
        DDLogFileInfo *logFileInfo = self.allLogFileInfo[indexPath.row];
        cell.titleLab.text = logFileInfo.fileName;
        cell.detailLab.text = [self stringForFileSize:logFileInfo.fileSize];
    }
    
    return cell;
}

- (NSString *)stringForFileSize:(unsigned long long)fileSize {
    NSString *string = nil;
    if (fileSize < 1024.0) {
        string = [NSString stringWithFormat:@"%.2f B", (CGFloat)fileSize];
    }
    else if (fileSize < 1024.0*1024.0) {
        string = [NSString stringWithFormat:@"%.2f KB", (CGFloat)(fileSize/1024.0)];
    }
    else {
        string = [NSString stringWithFormat:@"%.2f MB", (CGFloat)(fileSize/(1024.0*1024.0))];
    }
    return string;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *filePath = self.allLogFileInfo[indexPath.row].filePath;
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    [NSObject showLoading:LWLocalizbleString(@"Loading...")];
    
    self.documentController = [UIDocumentInteractionController interactionControllerWithURL:url];
    self.documentController.delegate = self;
    [self.documentController presentPreviewAnimated:YES];
}

#pragma mark - UIDocumentInteractionControllerDelegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    
    return self;
}

- (void)documentInteractionControllerWillBeginPreview:(UIDocumentInteractionController *)controller {
    
    [SVProgressHUD dismiss];
}

@end
