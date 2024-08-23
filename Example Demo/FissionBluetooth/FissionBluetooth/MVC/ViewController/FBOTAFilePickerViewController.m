//
//  FBOTAFilePickerViewController.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-11-04.
//

#import "FBOTAFilePickerViewController.h"
#import "FBAutomaticOTACell.h"
#import "FBTutorialViewController.h"

@interface FBOTAFilePickerViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) FBOTAFilePickerBlock pickerBlock;

@property (nonatomic, strong) NSArray <FBOTAFilePickerModel *> *selectArray;

@property (nonatomic, strong) NSMutableArray <FBOTAFilePickerModel *> *dataSource;

@property (nonatomic, strong) UIButton *button;

@end

static NSString *FBAutomaticOTACellID = @"FBAutomaticOTACell";
static NSString *UITableViewHeaderFooterViewID = @"UITableViewHeaderFooterView";

@implementation FBOTAFilePickerViewController

- (instancetype)initWithArray:(NSArray<FBOTAFilePickerModel *> *)selectArray block:(FBOTAFilePickerBlock)pickerBlock {
    if (self = [super init]) {
        self.selectArray = selectArray;
        self.pickerBlock = pickerBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = LWLocalizbleString(@"File");
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:IMAGE_NAME(@"ic_linear_refresh") style:UIBarButtonItemStylePlain target:self action:@selector(reloadList)];
    
    self.dataSource = NSMutableArray.array;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationContentTop - 60 - 48) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:tableView];
    [tableView registerNib:[UINib nibWithNibName:FBAutomaticOTACellID bundle:nil] forCellReuseIdentifier:FBAutomaticOTACellID];
    [tableView registerClass:UITableViewHeaderFooterView.class forHeaderFooterViewReuseIdentifier:UITableViewHeaderFooterViewID];
    self.tableView = tableView;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = BlueColor;
    [button setTitle:LWLocalizbleString(@"OK") forState:UIControlStateNormal];
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(60);
        make.right.mas_equalTo(-60);
        make.bottom.mas_equalTo(-30);
        make.height.mas_equalTo(48);
    }];
    self.button = button;
    
    [self reloadList];
}

- (void)reloadList {
    
    [self.dataSource removeAllObjects];
    
    NSString *filePath = FBDocumentDirectory(FBAutomaticOTAFile);
    NSArray <NSString *> *fileArray = [NSFileManager.defaultManager contentsOfDirectoryAtPath:filePath error:nil];
    for (NSString *fileName in fileArray) {
        NSString *file = [filePath stringByAppendingPathComponent:fileName];
        NSData *binFile = [NSData dataWithContentsOfFile:file];
        FBOTAFilePickerModel *model = FBOTAFilePickerModel.new;
        model.name = fileName;
        model.data = binFile;
        
        for (FBOTAFilePickerModel *selectModel in self.selectArray) {
            if ([model.name isEqualToString:selectModel.name]) {
                
                model.select = YES;
                
                break;
            }
        }
        [self.dataSource addObject:model];
    }
    
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.button.hidden = !self.dataSource.count;
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *sectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    sectionView.contentView.backgroundColor = COLOR_HEX(0xFAFAD2, 1);
    
    NSMutableArray *class = NSMutableArray.array;
    for (UIView *subview in sectionView.subviews) {
        [class addObject:NSStringFromClass(subview.class)];
    }
    
    if (![class containsObject:NSStringFromClass(QMUIButton.class)]) {
        QMUIButton *sectionButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [sectionButton setTitleColor:UIColorBlack forState:UIControlStateNormal];
        [sectionButton setTitle:[NSString stringWithFormat:@"%@【%@】%@ 👈", LWLocalizbleString(@"⚠️How to import local .Bin file for testing OTA function, click here for detailed tutorial~👉"), FBAutomaticOTAFile, LWLocalizbleString(@"Folder")] forState:UIControlStateNormal];
        sectionButton.titleLabel.font = FONT(13);
        sectionButton.titleLabel.numberOfLines = 0;
        [sectionView addSubview:sectionButton];
        [sectionButton addTarget:self action:@selector(sectionButtonClick) forControlEvents:UIControlEventTouchUpInside];
        sectionButton.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 12, 0, 12));
    }
    
    return sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FBAutomaticOTACell *cell = [tableView dequeueReusableCellWithIdentifier:FBAutomaticOTACellID];
    if (indexPath.row < self.dataSource.count) {
        FBOTAFilePickerModel *model = self.dataSource[indexPath.row];
        cell.backgroundColor = model.select ? UIColorTestGreen : UIColor.whiteColor;
        [cell text:[NSString stringWithFormat:@"🧧%ld: %@", indexPath.row+1, model.name]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FBOTAFilePickerModel *model = self.dataSource[indexPath.row];
    model.select = !model.select;
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)sureClick {
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(FBOTAFilePickerModel * _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return (evaluatedObject.select == YES);
    }];

    NSArray <FBOTAFilePickerModel *> *soures = [self.dataSource filteredArrayUsingPredicate:predicate]; // 当前组已选中
    
    if (soures.count) {
        
        self.pickerBlock(soures.copy);
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// 组头点击 - 教程
- (void)sectionButtonClick {
    FBTutorialViewController *vc = FBTutorialViewController.new;
    vc.tutorialType = FBTutorialType_AutomaticOTA;
    [self.navigationController pushViewController:vc animated:YES];
}

@end


@implementation FBOTAFilePickerModel

@end
