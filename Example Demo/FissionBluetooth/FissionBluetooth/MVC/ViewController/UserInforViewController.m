//
//  UserInforViewController.m
//  WP-810-Dome2
//
//  Created by ChenFan on 2019/3/27.
//  Copyright © 2019年 steven. All rights reserved.
//

#import "UserInforViewController.h"

@interface UserInforViewController ()
<UITableViewDelegate,
UITableViewDataSource,
UITextFieldDelegate>

@property (nonatomic,strong) UITableView * tableView;
@property(nonatomic,strong) UITextView *textView;
@property (nonatomic,strong) UIButton * sendBtn;
@property (nonatomic,strong) UIButton *getBtn;
@property (nonatomic,strong) NSArray * datas;


@end

@implementation UserInforViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.userInfoModel = [[FBUserInforModel alloc] init];
//        self.userInfoModel.userGender = 1;
    }
    return self;
}

-(UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, NavigationContentTop+10, SCREEN_WIDTH,100)];
        _textView.textColor = [UIColor redColor];
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.editable = NO;
        _textView.layer.borderWidth = 1;
        _textView.layer.borderColor = [UIColor darkGrayColor].CGColor;
        _textView.layer.cornerRadius = 5;
        _textView.clipsToBounds = YES;
    }
    return _textView;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_textView.frame)+10, SCREEN_WIDTH,SCREEN_HEIGHT-NavigationContentTop-250) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.rowHeight = 50;
    }
    return _tableView;
}

-(UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.frame = CGRectMake(100,SCREEN_HEIGHT-120,SCREEN_WIDTH-100 * 2,40);
        [_sendBtn setTitle:LWLocalizbleString(@"Set") forState:UIControlStateNormal];
        _sendBtn.layer.cornerRadius = 5;
        _sendBtn.layer.masksToBounds = YES;
        _sendBtn.backgroundColor = [UIColor blueColor];
        [_sendBtn addTarget:self action:@selector(send:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

-(UIButton *)getBtn{
    if (!_getBtn) {
        _getBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _getBtn.frame = CGRectMake(100,SCREEN_HEIGHT-70,SCREEN_WIDTH-100 * 2,40);
        [_getBtn setTitle:LWLocalizbleString(@"Get") forState:UIControlStateNormal];
        _getBtn.layer.cornerRadius = 5;
        _getBtn.layer.masksToBounds = YES;
        _getBtn.backgroundColor = [UIColor blueColor];
        [_getBtn addTarget:self action:@selector(getUserInfor:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getBtn;
}

-(void)getUserInfor:(UIButton *)sender{
    WeakSelf(self);
    self.textView.text = LWLocalizbleString(@"Get");
    [FBBgCommand.sharedInstance fbGetPersonalUserInforWithBlock:^(FB_RET_CMD status, float progress, FBUserInforModel * _Nonnull responseObject, NSError * _Nonnull error) {
        if (error) {
            [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
        } else if (status==FB_INDATATRANSMISSION) {
            weakSelf.textView.text = [NSString stringWithFormat:@"Receiving Progress: %.f%%", progress*100];
        } else if (status==FB_DATATRANSMISSIONDONE) {
            weakSelf.userInfoModel = responseObject;
            weakSelf.textView.text = [NSString stringWithFormat:@"%@", [responseObject mj_JSONObject]];
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.datas = @[
        LWLocalizbleString(@"Gender:"),
        LWLocalizbleString(@"Age:"),
        LWLocalizbleString(@"Height (cm):"),
        LWLocalizbleString(@"Weight(kg):"),
        LWLocalizbleString(@"Stride(cm):"),
        LWLocalizbleString(@"Nickname (up to 32Byte):"),
        LWLocalizbleString(@"Time zone:"),
        LWLocalizbleString(@"User ID:")
    ];
    
    [self.view addSubview:self.textView];
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.sendBtn];
    [self.view addSubview:self.getBtn];    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reusedId = @"UserInfoId";
    
    UserInforViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedId];
    if (!cell) {
        cell = [[UserInforViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.userInfoModel = self.userInfoModel;
    cell.indexPath = indexPath;
    cell.titelLab.text = self.datas[indexPath.row];
    cell.textField.delegate = self;
    cell.textField.keyboardType = UIKeyboardTypeDefault;
    
    __weak typeof(self) weakS = self;
    [cell setSexBlock:^(int sex) {
        if (sex == 0) {
            weakS.userInfoModel.UserGender = FB_UserMale;
            
        }else{
            weakS.userInfoModel.UserGender = FB_UserFemale;
        }
    }];
    
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSInteger tag = textField.tag;
    if (tag ==0) {
        
    } else if (tag == 1){
        self.userInfoModel.userAge = [textField.text integerValue];
        
    } else if (tag == 2){
        self.userInfoModel.userHeight = [textField.text integerValue];
        
    } else if (tag == 3){
        self.userInfoModel.userWeight = [textField.text integerValue];
        
    } else if (tag == 4){
        self.userInfoModel.userStride = [textField.text integerValue];
        
    } else if (tag == 5){
        self.userInfoModel.userNickname = textField.text;
        
    } else if (tag == 6){
        self.userInfoModel.userTimeZoneMinute = [textField.text integerValue];
        
    } else if (tag == 7){
        self.userInfoModel.userId = [textField.text integerValue];
    }
}

- (void)send:(UIButton *)send{
    [self.view endEditing:YES];
    
    WeakSelf(self);
    FBUserInforModel *model = self.userInfoModel;
    [FBBgCommand.sharedInstance fbSetPersonalUserInforWithUserModel:model withBlock:^(NSError * _Nullable error) {
        if (error) {
            [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
        } else {
            //设置成功
            weakSelf.textView.text = LWLocalizbleString(@"Success");
        }
    }];
    
}

@end

@interface UserInforViewCell ()<UITextFieldDelegate>

@end

@implementation UserInforViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *titelLab = [[UILabel alloc] init];
        titelLab.font = [UIFont systemFontOfSize:16];
        titelLab.textAlignment = NSTextAlignmentRight;
        titelLab.textColor = [UIColor blackColor];
        titelLab.numberOfLines = 2;
        self.titelLab = titelLab;
        [self.contentView addSubview:titelLab];
        
        UITextField *textField = [[UITextField alloc] init];
        textField.font = [UIFont systemFontOfSize:16];
        textField.textAlignment = NSTextAlignmentLeft;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.delegate = self;
        textField.returnKeyType = UIReturnKeyDone;
        textField.keyboardAppearance = UIKeyboardAppearanceLight;
       
        self.textField = textField;
        [self.contentView addSubview:self.textField];
        
        for (int i = 0; i<2; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.layer.cornerRadius = 5;
            btn.layer.masksToBounds = YES;
            btn.tag = 10 + i;
//            btn.hidden = YES;
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(sexSelect:) forControlEvents:UIControlEventTouchUpInside];
        
            if (i==0) {
                [btn setTitle:LWLocalizbleString(@"Male") forState:UIControlStateNormal];
                self.leftBtn = btn;
                [self.contentView addSubview:self.leftBtn];
                
            }else{
                btn.selected = YES;
                [btn setTitle:LWLocalizbleString(@"Female") forState:UIControlStateNormal];
                self.rightBtn = btn;
                [self.contentView addSubview:self.rightBtn];
            }
        }
    }
    return self;
}

-(void)setIsFemale:(BOOL)isFemale{
    _isFemale = isFemale;
    
    if (!isFemale) {
        self.leftBtn.selected = YES;
        self.rightBtn.selected = NO;
        
        self.leftBtn.layer.borderColor = [UIColor blueColor].CGColor;
        self.leftBtn.layer.borderWidth = 2;
        self.rightBtn.layer.borderColor = [UIColor clearColor].CGColor;
        self.rightBtn.layer.borderWidth = 0;
        
    }else{
        self.rightBtn.selected = YES;
        self.leftBtn.selected = NO;
        
        self.rightBtn.layer.borderColor = [UIColor blueColor].CGColor;
        self.rightBtn.layer.borderWidth = 2;
        self.leftBtn.layer.borderColor = [UIColor clearColor].CGColor;
        self.leftBtn.layer.borderWidth = 0;
    }
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.titelLab.frame = CGRectMake(0,0,SCREEN_WIDTH/2,self.frame.size.height);
    self.textField.frame = CGRectMake(CGRectGetMaxX(self.titelLab.frame)+10,5,self.frame.size.width-CGRectGetMaxX(self.titelLab.frame)-30,self.frame.size.height - 5 * 2);
    
    for (int i = 0; i<2; i++) {
        UIButton *btn = [self.contentView viewWithTag:10 + i];
        CGFloat originX = CGRectGetMaxX(self.titelLab.frame)+10;
        CGFloat btnWidth = (self.frame.size.width - CGRectGetMaxX(self.titelLab.frame)-20)/2.0;
        btn.frame = CGRectMake(originX + (btnWidth + 5) * i,15,btnWidth,30);
    }
    
}
- (void)setUserInfoModel:(FBUserInforModel *)userInfoModel{
    _userInfoModel = userInfoModel;
}
-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    if (_indexPath.row == 0) {
        for (int i = 0; i<2; i++) {
            UIButton *btn = [self.contentView viewWithTag:10 + i];
            btn.hidden = NO;
        }
        self.textField.hidden = YES;
        
    }else{
        for (int i = 0; i<2; i++) {
            UIButton *btn = [self.contentView viewWithTag:10 + i];
            btn.hidden = YES;
        }
        self.textField.hidden = NO;
    }
    self.textField.tag = indexPath.row;
    
    if (indexPath.row==0) {
        self.isFemale = self.userInfoModel.UserGender==FB_UserFemale ;
    } else if (indexPath.row == 1){
        self.textField.text = [NSString stringWithFormat:@"%ld",self.userInfoModel.userAge];
        
    } else if (indexPath.row == 2){
        self.textField.text = [NSString stringWithFormat:@"%ld",self.userInfoModel.userHeight];
        
    } else if (indexPath.row == 3){
        self.textField.text = [NSString stringWithFormat:@"%ld",self.userInfoModel.userWeight];
        
    } else if (indexPath.row == 4){
        self.textField.text = [NSString stringWithFormat:@"%ld",self.userInfoModel.userStride];
        
    } else if (indexPath.row == 5){
        self.textField.text = self.userInfoModel.userNickname;
        
    } else if (indexPath.row == 6){
        self.textField.text = [NSString stringWithFormat:@"%ld",self.userInfoModel.userTimeZoneMinute];
        
    } else if (indexPath.row == 7){
        self.textField.text = [NSString stringWithFormat:@"%ld",self.userInfoModel.userId];
    }
}

-(void)sexSelect:(UIButton *)sender{
    for (int i = 0; i<2; i++) {
        UIButton *btn = [self.contentView viewWithTag:10+i];
        btn.selected = NO;
        btn.layer.borderWidth = 0;
        btn.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    
    sender.selected = YES;
    if (sender.selected) {
        sender.layer.borderWidth = 2;
        sender.layer.borderColor = [UIColor blueColor].CGColor;
    }
    
    if (self.sexBlock) {
        self.sexBlock((int)sender.tag - 10);
    }
}

@end
