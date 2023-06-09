//
//  SedentaryViewController.m
//  WP-810-Dome2
//
//  Created by ChenFan on 2019/3/27.
//  Copyright © 2019年 steven. All rights reserved.
//

#import "SedentaryViewController.h"

@interface SedentaryViewController ()
<UITableViewDelegate,
UITableViewDataSource,
UITextFieldDelegate>

@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) UIButton * sendBtn;
@property (nonatomic,strong) UIButton *getBtn;
@property (nonatomic,strong) FBLongSitModel * longSitModel;

@end

@implementation SedentaryViewController


-(UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, NavigationContentTop+10, SCREEN_WIDTH, 200)];
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_textView.frame)+10, SCREEN_WIDTH,SCREEN_HEIGHT-NavigationContentTop-200) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [UIView new];
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
        [_sendBtn addTarget:self action:@selector(sendLongSitParam:) forControlEvents:UIControlEventTouchUpInside];
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
        [_getBtn addTarget:self action:@selector(getLongSitParam:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.textView];
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.sendBtn];
    [self.view addSubview:self.getBtn];
    
    self.longSitModel = [[FBLongSitModel alloc] init];
    
}

#pragma mark --tableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.row;
    if (index == 0) {
        static NSString *reusedId1 = @"reusedId1";
        SedentaryCellOne *cell = [tableView dequeueReusableCellWithIdentifier:reusedId1];
        if (!cell) {
            cell = [[SedentaryCellOne alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedId1];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.swtch setOn:self.longSitModel.enable];
        
        [cell setSwtchBlock:^(BOOL ret) {
            FBLog(@"ret == %d",ret);
            self.longSitModel.enable = ret;
        }];
        
        return cell;
        
    }else{
        static NSString *reusedId2 = @"reusedId2";
        SedentaryCellTwo *cell = [tableView dequeueReusableCellWithIdentifier:reusedId2];
        if (!cell) {
            cell = [[SedentaryCellTwo alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedId2];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textField.delegate = self;
        cell.textField.tag = 10 + indexPath.row;  // 11,12
        
        if (index == 1) {
            cell.titelLab.text = @"Step count:";
            cell.unitLab.text = @"(steps)";
            cell.textField.text = [NSString stringWithFormat:@"%ld",self.longSitModel.targetSteps];
        }
        
        if (index == 2) {
            cell.titelLab.text = @"Duration:";
            cell.unitLab.text = @"(mins)";
            cell.textField.text = [NSString stringWithFormat:@"%ld",self.longSitModel.continueTime];
        }
        if (index==3) {
            cell.titelLab.text = @"Start time:";
            cell.unitLab.text = @"(mins)";
            cell.textField.text = [NSString stringWithFormat:@"%ld",self.longSitModel.startTime];
        }
        if (index==4) {
            cell.titelLab.text = @"End time:";
            cell.unitLab.text = @"(mins)";
            cell.textField.text = [NSString stringWithFormat:@"%ld",self.longSitModel.endTime];
        }
        return cell;
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 11) {  //monitoring time
        self.longSitModel.targetSteps = [textField text].integerValue;
        
    } else if (textField.tag == 12){ //Reminder limit
        self.longSitModel.continueTime = [textField text].integerValue;
        
    } else if (textField.tag == 13){ //start time hour
        self.longSitModel.startTime = [textField text].integerValue;
        
    } else if (textField.tag == 14){
         self.longSitModel.endTime = [textField text].integerValue;
    }
}

-(void)sendLongSitParam:(UIButton *)sender
{
    [self.view endEditing:YES];
    WeakSelf(self);
    FBLongSitModel *model = self.longSitModel;
    [FBBgCommand.sharedInstance fbSetLongSitInforWithModel:model withBlock:^(NSError * _Nullable error) {
        if (error) {
            [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
        } else {
            weakSelf.textView.text = LWLocalizbleString(@"Success");
        }
    }];
    
}

-(void)getLongSitParam:(UIButton *)sender
{
    WeakSelf(self);
    [FBBgCommand.sharedInstance fbGetLongSitInforWithBlock:^(FB_RET_CMD status, float progress, FBLongSitModel * _Nonnull responseObject, NSError * _Nonnull error) {
        if (error) {
            [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
        } else if (status==FB_INDATATRANSMISSION) {
            weakSelf.textView.text = [NSString stringWithFormat:@"Receiving Progress: %.f%%", progress*100];
        } else if (status==FB_DATATRANSMISSIONDONE) {
            weakSelf.longSitModel = responseObject;
            weakSelf.textView.text = [NSString stringWithFormat:@"%@",[responseObject mj_JSONObject]];
            [weakSelf.tableView reloadData];
        }
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)keyBoardWillShow:(NSNotification *)noti{
    NSDictionary *dict = noti.userInfo;
    NSValue *value = dict[UIKeyboardFrameEndUserInfoKey];
    CGRect endUserInfoFrame = value.CGRectValue;
    
    CGFloat sendBtnMaxY = CGRectGetMaxY(self.sendBtn.frame);
    
    CGFloat diff = endUserInfoFrame.origin.y - sendBtnMaxY;
    
    if (diff<0) {
        [self.tableView setContentOffset:CGPointMake(0,diff)];
    }
    
}

-(void)keyboardWillHide:(NSNotification *)noti{
    if (noti && [noti.name isEqualToString:UIKeyboardWillHideNotification]) {
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }
}

-(void)receLongSitData:(NSNotification *)noti{
    if (noti && noti.object) {
        self.longSitModel = noti.object;
        [self.tableView reloadData];
    }
}

@end


@implementation SedentaryCellOne

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *titelLab = [[UILabel alloc] init];
        titelLab.font = [UIFont systemFontOfSize:16];
        titelLab.textColor = [UIColor blackColor];
        titelLab.textAlignment = NSTextAlignmentRight;
        self.titelLab = titelLab;
        self.titelLab.text = LWLocalizbleString(@"Switch");
        [self.contentView addSubview:self.titelLab];
        
        UISwitch *swtch = [[UISwitch alloc] init];
        [swtch setOn:YES];
        swtch.onTintColor = [UIColor blueColor];
        [swtch addTarget:self action:@selector(swtchChange:) forControlEvents:UIControlEventValueChanged];
        self.swtch = swtch;
        [self.contentView addSubview:self.swtch];
        
    }
    return self;
}

-(void)swtchChange:(UISwitch *)sender{
    if (self.swtchBlock) {
        self.swtchBlock(sender.isOn);
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.titelLab.frame = CGRectMake(0, 0, 120, self.frame.size.height);
    
    CGFloat rightSpace = (self.frame.size.width - 120);
    
    self.swtch.frame = CGRectMake(CGRectGetMaxX(self.titelLab.frame) + rightSpace-30,(self.frame.size.height-51)/2.0,60,51);
    self.swtch.center = CGPointMake(CGRectGetMaxX(self.titelLab.frame) + rightSpace/2.0 , self.frame.size.height/2.0);
    
}

@end

@implementation SedentaryCellTwo

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *titelLab = [[UILabel alloc] init];
        titelLab.font = [UIFont systemFontOfSize:16];
        titelLab.textColor = [UIColor blackColor];
        titelLab.textAlignment = NSTextAlignmentRight;
        self.titelLab = titelLab;
        [self.contentView addSubview:self.titelLab];
        
        UITextField *textField = [[UITextField alloc] init];
        textField.font = [UIFont systemFontOfSize:16];
        textField.textColor = [UIColor blackColor];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.textAlignment = NSTextAlignmentLeft;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.returnKeyType = UIReturnKeyDone;
        textField.keyboardAppearance = UIKeyboardAppearanceLight;
        
        self.textField = textField;
        [self.contentView addSubview:self.textField];
        
        UILabel *unitLab = [[UILabel alloc] init];
        unitLab.font = [UIFont systemFontOfSize:16];
        unitLab.textColor = [UIColor blackColor];
        unitLab.textAlignment = NSTextAlignmentRight;
        self.unitLab = unitLab;
        [self.contentView addSubview:self.unitLab];
        
    }
    return self;
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
   self.titelLab.frame = CGRectMake(0, 0, 120, self.frame.size.height);
   self.textField.frame = CGRectMake(CGRectGetMaxX(self.titelLab.frame) + 10, 5, self.frame.size.width - CGRectGetMaxX(self.titelLab.frame)-80, self.frame.size.height-5 * 2);
   self.unitLab.frame = CGRectMake(self.frame.size.width-80, 0, 70, self.frame.size.height);
    
}

@end

@implementation SedentaryCellThree

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *titelLab = [[UILabel alloc] init];
        titelLab.font = [UIFont systemFontOfSize:16];
        titelLab.textColor = [UIColor blackColor];
        titelLab.textAlignment = NSTextAlignmentRight;
        self.titelLab = titelLab;
        [self.contentView addSubview:self.titelLab];
        
        UITextField *textField1 = [[UITextField alloc] init];
        textField1.font = [UIFont systemFontOfSize:16];
        textField1.textColor = [UIColor blackColor];
        textField1.textAlignment = NSTextAlignmentLeft;
        textField1.keyboardType = UIKeyboardTypeNumberPad;
        textField1.returnKeyType = UIReturnKeyDone;
        textField1.borderStyle = UITextBorderStyleRoundedRect;
        textField1.keyboardAppearance = UIKeyboardAppearanceLight;
        self.textField1 = textField1;
        [self.contentView addSubview:self.textField1];
        
        UITextField *textField2 = [[UITextField alloc] init];
        textField2.font = [UIFont systemFontOfSize:16];
        textField2.textColor = [UIColor blackColor];
        textField2.textAlignment = NSTextAlignmentLeft;
        textField2.keyboardType = UIKeyboardTypeNumberPad;
        textField2.returnKeyType = UIReturnKeyDone;
        textField2.borderStyle = UITextBorderStyleRoundedRect;
        textField2.keyboardAppearance = UIKeyboardAppearanceLight;
        self.textField2 = textField2;
        [self.contentView addSubview:self.textField2];
        
        UILabel *centerLab = [[UILabel alloc] init];
        centerLab.font = [UIFont systemFontOfSize:14];
        centerLab.textColor = [UIColor blackColor];
        centerLab.textAlignment = NSTextAlignmentCenter;
        self.centerLab = centerLab;
        self.centerLab.text = @":";
        [self.contentView addSubview:self.centerLab];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
     self.titelLab.frame = CGRectMake(0, 0, 120, self.frame.size.height);
    
     CGFloat unitLabWidth = 20;
     CGFloat textFieldWidth = (self.frame.size.width - 120-20-20)/2.0;
     self.textField1.frame = CGRectMake(CGRectGetMaxX(self.titelLab.frame)+5,10,textFieldWidth, self.frame.size.height-5*2);
     self.centerLab.frame = CGRectMake(CGRectGetMaxX(self.textField1.frame),0, unitLabWidth, self.frame.size.height);
     self.textField2.frame = CGRectMake(CGRectGetMaxX(self.centerLab.frame), 5, textFieldWidth, self.frame.size.height - 5 * 2);
    
}

@end
