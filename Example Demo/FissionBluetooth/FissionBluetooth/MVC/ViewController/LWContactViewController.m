//
//  LWContactViewController.m
//  LinWear
//
//  Created by 裂变智能 on 2022/11/11.
//  Copyright © 2022 lw. All rights reserved.
//

#import "LWContactViewController.h"
#import "LWContactSearchBarHeaderView.h"
#import "LWPersonCell.h"

#define rowH 68

@interface LWContactViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray <LWPersonModel *> *dataArray; // 数据源（通讯录）

@property (nonatomic, strong) NSMutableArray <LWPersonModel *> *selectedArray; // 已选

@property (nonatomic, copy) LWSelectedPersonBlock selectedPersonBlock; // block回调

@property (nonatomic, assign) BOOL isSearching; // 当前是否处于搜索状态

@property (nonatomic, strong) NSArray <LWPersonModel *> *searchArray; // 已匹配搜索到的数据

@end

@implementation LWContactViewController

- (instancetype)initWithSelectedArray:(NSArray<LWPersonModel *> *)selectedArray withBlock:(LWSelectedPersonBlock)selectedPersonBlock {
    if (self = [super init]) {
        
        self.dataArray = NSMutableArray.array;
        self.selectedArray = [NSMutableArray arrayWithArray:selectedArray];
        self.selectedPersonBlock = selectedPersonBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = LWLocalizbleString(@"Address Book");
    
    [self setNaviRigBar];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationContentTop-100) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:@"LWPersonCell" bundle:nil] forCellReuseIdentifier:@"LWPersonCell"];
    [tableView registerClass:LWContactSearchBarHeaderView.class forHeaderFooterViewReuseIdentifier:@"LWContactSearchBarHeaderView"];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.rowHeight = rowH;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    if (@available(iOS 15.0, *)) {
        tableView.sectionHeaderTopPadding = 0;
    }
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    // 完成
    QMUIButton *doneBut = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [doneBut setBackgroundColor:BlueColor];
    [doneBut setTitleColor:UIColorWhite forState:UIControlStateNormal];
    [doneBut setTitle:LWLocalizbleString(@"Set") forState:UIControlStateNormal];
    doneBut.titleLabel.font = [NSObject BahnschriftFont:18];
    doneBut.cornerRadius = 24;
    [self.view addSubview:doneBut];
    [doneBut addTarget:self action:@selector(doneButClick) forControlEvents:UIControlEventTouchUpInside];
    doneBut.sd_layout.leftSpaceToView(self.view, 60).rightSpaceToView(self.view, 60).bottomSpaceToView(self.view, 34).heightIs(48);
    
    // 数据源加载
    [self getContacts];
}

- (void)setNaviRigBar {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%ld/50", self.selectedArray.count] style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)doneButClick {
    // 返回选择结果
    if (self.selectedPersonBlock) {
        self.selectedPersonBlock(self.selectedArray);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClick {};

#pragma mark - 数据源加载

- (void)getContacts {
    // 获取所有通讯录
    NSArray *keys = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc]initWithKeysToFetch:keys];
    CNContactStore *contactStore = CNContactStore.new;
    WeakSelf(self);
    [contactStore enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        
        NSString *givenName = contact.givenName;
        NSString *familyName = contact.familyName;
        
        NSString *name = nil;
        
        NSString *systemLanguage = [NSLocale preferredLanguages].firstObject; // 系统当前语言
        if ([systemLanguage hasPrefix:@"zh"]) {
            name = [NSString stringWithFormat:@"%@%@", StringHandle(familyName), StringHandle(givenName)];
        } else {
            name = [NSString stringWithFormat:@"%@%@", StringHandle(givenName), StringHandle(familyName)];
        }
        
        
        NSArray <CNLabeledValue <CNPhoneNumber *> *> *phoneNumbers = contact.phoneNumbers;
        
        for(CNLabeledValue *labeledValue in phoneNumbers) {
            id phoneValue = labeledValue.value;
            if ([phoneValue isKindOfClass:CNPhoneNumber.class]) {
                CNPhoneNumber *phoneNumber = (CNPhoneNumber *)phoneValue;
                NSString * Str = phoneNumber.stringValue;
                NSCharacterSet *setToRemove = [[ NSCharacterSet characterSetWithCharactersInString:@"0123456789"]invertedSet];
                NSString *phoneStr = [[Str componentsSeparatedByCharactersInSet:setToRemove]componentsJoinedByString:@""];
                
                LWPersonModel *model = LWPersonModel.new;
                model.name = name;
                model.phoneNumber = phoneStr;
                
                // 谓词检索是否已选择
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@ && phoneNumber == %@", name, phoneStr];
                NSArray <LWPersonModel *> *array = [weakSelf.selectedArray filteredArrayUsingPredicate:predicate];
                if (array.count) {
                    model.isSelect = YES;
                }
                
                // 加入数据源
                [weakSelf.dataArray addObject:model];
            }
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
       
    if (self.isSearching) {
        return self.searchArray.count;
    } else {
        return self.dataArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return rowH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    LWContactSearchBarHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LWContactSearchBarHeaderView"];
    headerView.searchBar.delegate = self;

    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LWPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LWPersonCell" forIndexPath:indexPath];
    
    NSArray *data = @[];
    if (self.isSearching) {
        data = self.searchArray;
    } else {
        data = self.dataArray;
    }
    
    if (indexPath.row < data.count) {
        LWPersonModel *model = data[indexPath.row];
        
        cell.name.text = model.name;
        cell.tel.text = model.phoneNumber;
        
        cell.line.hidden = indexPath.row==(data.count-1);
        
        cell.choice.hidden = NO;
        cell.choice.image = model.isSelect ? UIImageMake(@"ic_person_select") : UIImageMake(@"ic_person_unselect");
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *data = @[];
    if (self.isSearching) {
        data = self.searchArray;
    } else {
        data = self.dataArray;
    }
    
    if (indexPath.row >= data.count) return;
    
    LWPersonModel *model = data[indexPath.row];
    NSString *name = model.name;
    NSString *phoneStr = model.phoneNumber;
    
    if (self.selectedArray.count >= 50 && !model.isSelect) {

        [NSObject showLoading:LWLocalizbleString(@"Add up to 50 frequently used contacts")];

    } else {
    
        //name 不能为空
        //phone 不能为空
        if (StringIsEmpty(name) || StringIsEmpty(phoneStr)) {
            [NSObject showHUDText:LWLocalizbleString(@"The length of the selected contact name or number is wrong, please choose again!")];
            return;
        }
        else if (!model.isSelect) {
            
            // 检索号码是否已被选中
            if ([self predicateModel:phoneStr]) {
                [NSObject showHUDText:LWLocalizbleString(@"The selected contact already exists, please select again!")];
                return;
            }
        }
        
        
        // 变更选择状态
        model.isSelect = !model.isSelect;
        
        // 未选中-->选中 - 加入队列
        if (model.isSelect) {
            [self.selectedArray addObject:model];
        }
        // 选中-->未选中 - 移除队列
        else {
            // 匹配要移除的对象
            LWPersonModel *predicateModel = [self predicateModel:phoneStr];
            if (predicateModel) {
                [self.selectedArray removeObject:predicateModel];
            }
        }
        
        // 已选个数更新
        [self setNaviRigBar];
        
        // 刷新列表
        [self.tableView reloadData];
    }
}

- (LWPersonModel *)predicateModel:(NSString *)phoneStr {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"phoneNumber == %@", phoneStr];
    NSArray <LWPersonModel *> *array = [self.selectedArray filteredArrayUsingPredicate:predicate];
    if (array.count) {
        return array.firstObject;
    }
    return nil;
}


#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [self.tableView qmui_scrollToTop];
    
    self.isSearching = StringIsEmpty(searchBar.text) ? NO : YES;
    
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    
    self.isSearching = StringIsEmpty(searchBar.text) ? NO : YES;
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@ || phoneNumber CONTAINS %@", searchText, searchText];

    NSArray *filterData = [self.dataArray filteredArrayUsingPredicate:predicate];
    
    self.searchArray = filterData;
    
    self.isSearching = StringIsEmpty(searchBar.text) ? NO : YES;
    
    [self.tableView reloadData];
}

@end
