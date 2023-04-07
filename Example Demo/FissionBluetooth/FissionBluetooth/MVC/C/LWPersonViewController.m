//
//  LWPersonViewController.m
//  LinWear
//
//  Created by 裂变智能 on 2021/12/18.
//  Copyright © 2021 lw. All rights reserved.
//

#import "LWPersonViewController.h"
#import "LWContactViewController.h"
#import "LWPersonCell.h"

#define ToolH 170

@interface LWPersonViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataAry;

@property (nonatomic, assign) BOOL isEditing; // 编辑是否是删除模式

@property (nonatomic, strong) QMUIButton *deleteBut;

@property (nonatomic, strong) QMUIButton *addBut;

@property (nonatomic, strong) QMUIButton *selectAllBut;

@end

@implementation LWPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    [self.view addSubview:self.tableView];
    
    self.dataAry = NSMutableArray.array;
        
    [self.tableView setEditing:YES];
    
    self.isEditing = YES;
    
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-ToolH, SCREEN_WIDTH, ToolH)];
    toolView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:toolView];

    
    NSArray *ima = @[@"ic_person_add", @"ic_person_selectall", @"ic_person_delete"];
    NSArray *tit = @[@"", LWLocalizbleString(@"Select All"), LWLocalizbleString(@"Delete")];
    
    for (int j = 0; j < ima.count; j++) {
        QMUIButton *but = [self createBut:ima[j] title:tit[j]];
        but.tag = 10000+j;
        [toolView addSubview:but];
        but.frame = CGRectMake((SCREEN_WIDTH - SCREEN_WIDTH/3)/2, 10, (SCREEN_WIDTH/3), 70);
        if (j==0) {
            self.addBut = but;
        } else if (j==1) {
            self.selectAllBut = but;
        } else if (j==2) {
            self.deleteBut = but;
        }
    }
    self.deleteBut.alpha = 0;
    self.selectAllBut.alpha = 0;
    
    
    UILabel *lab = UILabel.new;
    lab.backgroundColor = UIColor.clearColor;
    lab.font = FONT(12);
    lab.textColor = UIColorGray;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.numberOfLines = 0;
    lab.text = [NSString stringWithFormat:@"%@", LWLocalizbleString(@"The frequently used contacts you set will be automatically synced to the device.")];
    [toolView addSubview:lab];
    lab.sd_layout.leftSpaceToView(toolView, 10).rightSpaceToView(toolView, 10).topSpaceToView(self.deleteBut, 0).bottomEqualToView(toolView);
    
    [self getFavContactsList];
}

- (QMUIButton *)createBut:(NSString *)image title:(NSString *)title {
    QMUIButton *but = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [but setImage:UIImageMake(image) forState:UIControlStateNormal];
    [but setTitle:title forState:UIControlStateNormal];
    but.titleLabel.font = FONT(12);
    [but setTitleColor:UIColorBlack forState:UIControlStateNormal];
    but.imagePosition = QMUIButtonImagePositionTop;
    but.spacingBetweenImageAndTitle = 5.0f;
    but.backgroundColor = self.view.backgroundColor;
    
    [but addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
    return but;
}

- (void)setNaviRightBut {
    
    NSString *imageName = @"";
    if (self.dataAry.count && self.isEditing) { // 有个数，非编辑模式，显示编辑图标
        imageName = @"ic_linear_edit";
    } else if (self.dataAry.count && !self.isEditing) { // 有个数，编辑模式，显示取消图标
        imageName = @"ic_linear_cancel";
    }
    
    if (StringIsEmpty(imageName)) {
        self.navigationItem.rightBarButtonItem = nil;
    } else {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:IMAGE_NAME(imageName) style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
}

- (void)rightBtnClick {
    if (self.dataAry.count && self.isEditing) { // 进入编辑模式
        [self editingState];
    } else if (self.dataAry.count && !self.isEditing) { // 退出编辑模式
        [self defaultState];
    }
}

- (void)butClick:(UIButton *)but {
    if (but.tag==10000) { // 添加
        [self authorization];
    }
    else if (but.tag==10001) { // 全选
        
        // 遍历决定是全部选中还是全部取消
        __block BOOL isAll = YES;
        [self.dataAry enumerateObjectsUsingBlock:^(LWPersonModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!obj.isSelect) {
                isAll = NO;
                *stop = YES;
            }
        }];
        
        for (LWPersonModel *model in self.dataAry) {
            model.isSelect = !isAll;
        }
        [self.tableView reloadData];
    }
    else if (but.tag==10002) { // 删除
        
        if (self.dataAry.count && !self.isEditing) {
            
            NSMutableArray *arr = [NSMutableArray array];
            NSMutableArray *arrDelete = [NSMutableArray array];
            for (LWPersonModel *model in self.dataAry) {
                if (model.isSelect) {
                    [arrDelete addObject:model];
                } else {
                    [arr addObject:model];
                }
            }
            if (arrDelete.count) {
                                
                WeakSelf(self);
                [UIAlertObject presentAlertTitle:LWLocalizbleString(@"Tip") message:LWLocalizbleString(@"Are you sure you want to delete the selected contacts?") cancel:LWLocalizbleString(@"Cancel") sure:LWLocalizbleString(@"Delete") block:^(AlertClickType clickType) {
                    
                    if (clickType == AlertClickType_Sure) {
                        [weakSelf setFavContactsList:arr];
                    }
                }];
            }
        }
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationContentTop-ToolH) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"LWPersonCell" bundle:nil] forCellReuseIdentifier:@"LWPersonCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 68;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        
    [self setNaviRightBut];
    
    return self.dataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LWPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LWPersonCell" forIndexPath:indexPath];
    
    if (indexPath.row < self.dataAry.count) {
        LWPersonModel *model = self.dataAry[indexPath.row];
        
        cell.name.text = model.name;
        cell.tel.text = model.phoneNumber;
        
        cell.line.hidden = indexPath.row==(self.dataAry.count-1);
        
        cell.choice.hidden = self.isEditing;
        if (!self.isEditing) {
            cell.choice.image = model.isSelect ? UIImageMake(@"ic_dial_button") : UIImageMake(@"ic_dial_button_d");
        }
    }
    
    return cell;
}

// 不缩进
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

// 移动模式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

// 是否允许移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.isEditing;
}

// 更新数据
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if (sourceIndexPath.section == destinationIndexPath.section && sourceIndexPath.row == destinationIndexPath.row) return;
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataAry];
    
    // 1.获取需要修改的数据
    LWPersonModel *model = [array objectAtIndex:sourceIndexPath.row];
    
    // 2. 先将数据从当前位置移除
    [array removeObjectAtIndex:sourceIndexPath.row];
    
    // 3. 将数据插入到对应位置
    [array insertObject:model atIndex:destinationIndexPath.row];
    
    [self setFavContactsList:array];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isEditing) return; //编辑模式，拦截点击
    
    LWPersonModel *model = self.dataAry[indexPath.row];
    model.isSelect = !model.isSelect;
    
    [self.tableView reloadData];
}

#pragma mark - 通讯录权限
- (void)authorization {
    
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    if (status == CNAuthorizationStatusNotDetermined) {
        CNContactStore *store = [[CNContactStore alloc] init];
        WeakSelf(self);
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
            GCD_MAIN_QUEUE(^{
                if (error) {
                    FBLog(@"通讯录未授权");
                } else {
                    [weakSelf presentContactPickerViewController];
                }
            });
        }];
    }
    
    else if (status == CNAuthorizationStatusAuthorized) {//有权限时
        
        [self presentContactPickerViewController];
    }
    else {
        FBLog(@"您未开启通讯录权限,请前往设置中心开启");
        NSString *message = [NSString stringWithFormat:LWLocalizbleString(@"Please allow %@ to access contact information in iPhone's [Settings-Privacy-Contacts]"), Tools.appName];
        
        [UIAlertObject presentAlertTitle:LWLocalizbleString(@"Tip") message:message cancel:LWLocalizbleString(@"Cancel") sure:LWLocalizbleString(@"Set") block:^(AlertClickType clickType) {
            
            if (clickType == AlertClickType_Sure) {
                //进入系统设置页面，APP本身的权限管理页面
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
            }
        }];
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

#pragma mark - 读取手表联系人

// 获取联系人列表
- (void)getFavContactsList {
    WeakSelf(self);
    [NSObject showLoading:LWLocalizbleString(@"Get Contacts")];
    
    [FBBgCommand.sharedInstance fbGetFavoriteContactListWithBlock:^(FB_RET_CMD status, float progress, NSArray<FBFavContactModel *> * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [NSObject showHUDText:[NSString stringWithFormat:@"%@", error.localizedDescription]];
        }
        else if (status==FB_INDATATRANSMISSION) {
            [NSObject showProgress:progress status:[NSString stringWithFormat:@"%.0f%%", progress*100]];
        }
        else if (status==FB_DATATRANSMISSIONDONE) {
            
            [SVProgressHUD dismiss];
            
            [self.dataAry removeAllObjects];
            
            NSMutableArray *arr = NSMutableArray.array;
            for (FBFavContactModel *favContactModel in responseObject) {
                LWPersonModel *model = LWPersonModel.new;
                model.name = favContactModel.contactName;
                model.phoneNumber = favContactModel.contactNumber;
                [arr addObject:model];
            }
            
            [self.dataAry addObjectsFromArray:arr];
            
            [weakSelf.tableView reloadData];
        }
    }];
}

#pragma mark - 设置手表联系人
- (void)setFavContactsList:(NSArray *)array {
    WeakSelf(self);
    [NSObject showLoading:LWLocalizbleString(@"Set contacts")];
    
    NSMutableArray *arr = NSMutableArray.array;
    for (LWPersonModel *model in array) {
        FBFavContactModel *favContactModel = FBFavContactModel.new;
        favContactModel.contactName = model.name;
        favContactModel.contactNumber = model.phoneNumber;
        [arr addObject:favContactModel];
    }
    
    [FBBgCommand.sharedInstance fbSetFavoriteContactListWithModel:arr withBlock:^(NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        if (error) {
            [NSObject showHUDText:[NSString stringWithFormat:@"%@", error.localizedDescription]];
        } else {
            [weakSelf.dataAry removeAllObjects];
            [weakSelf.dataAry addObjectsFromArray:array];
            [weakSelf.tableView reloadData];
            
            if (!weakSelf.isEditing) {
                if (!array.count) {
                    [weakSelf defaultState];
                }
            }
        }
    }];
}

- (void)defaultState {
    self.isEditing = YES;
    [self.tableView setEditing:self.isEditing animated:YES];
    [self.tableView reloadData];
    
    WeakSelf(self);
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:10 options:0 animations:^{
        weakSelf.deleteBut.alpha = 0;
        weakSelf.selectAllBut.alpha = 0;
        weakSelf.addBut.alpha = 1;
        weakSelf.deleteBut.centerX = weakSelf.selectAllBut.centerX = weakSelf.addBut.centerX;
    } completion:nil];
}

- (void)editingState {
    self.isEditing = NO;
    [self.tableView setEditing:self.isEditing animated:YES];
    [self.tableView reloadData];
    
    WeakSelf(self);
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.deleteBut.alpha = 1;
        weakSelf.selectAllBut.alpha = 1;
        weakSelf.addBut.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:20 options:0 animations:^{
            weakSelf.deleteBut.frame = CGRectMake(SCREEN_WIDTH/2-weakSelf.deleteBut.width, weakSelf.deleteBut.origin.y, weakSelf.deleteBut.width, weakSelf.deleteBut.height);
            weakSelf.selectAllBut.frame = CGRectMake(SCREEN_WIDTH/2, weakSelf.deleteBut.origin.y, weakSelf.deleteBut.width, weakSelf.deleteBut.height);
        } completion:nil];
    }];
}

- (void)presentContactPickerViewController {
    WeakSelf(self);
    LWContactViewController *vc = [[LWContactViewController alloc] initWithSelectedArray:self.dataAry withBlock:^(NSArray<LWPersonModel *> * _Nullable selectedArray) {
        // 设置联系人
        [weakSelf setFavContactsList:selectedArray];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
