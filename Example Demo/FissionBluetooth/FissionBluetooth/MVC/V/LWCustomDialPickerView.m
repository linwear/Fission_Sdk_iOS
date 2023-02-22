//
//  LWCustomDialPickerView.m
//  LinWear
//
//  Created by 裂变智能 on 2021/6/16.
//  Copyright © 2021 lw. All rights reserved.
//

#import "LWCustomDialPickerView.h"
#import "LWCustomDialPickerViewCell.h"

typedef void(^LWCustomDialPickerViewSelectBlock)(LWCustomDialSelectMode mode, NSInteger result);

@interface LWCustomDialPickerView ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewHigh;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBut;
@property (weak, nonatomic) IBOutlet UIButton *confirmBut;

@property (nonatomic, strong) NSArray *array;
@property (nonatomic, assign) LWCustomDialSelectMode mode;
@property (nonatomic, assign) NSInteger selectObj;
@property (nonatomic, copy) LWCustomDialPickerViewSelectBlock customDialPickerViewSelectBlock;

@end

@implementation LWCustomDialPickerView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.backgroundColor = [UIColor whiteColor];
    [NSObject setView:self.bgView cornerRadius:20 borderWidth:0 borderColor:UIColorClear];
    
    [self.cancelBut setBackgroundColor:[UIColor whiteColor]];
     [NSObject setView:self.cancelBut cornerRadius:24 borderWidth:1 borderColor:COLOR_HEX(0x4469FF, 1)];
    self.cancelBut.titleLabel.font = [NSObject themePingFangSCMediumFont:18];
     [self.cancelBut setTitleColor:COLOR_HEX(0x4469FF, 1) forState:UIControlStateNormal];
    [self.cancelBut setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    
    [self.confirmBut setBackgroundColor:COLOR_HEX(0x4469FF, 1)];
     [NSObject setView:self.confirmBut cornerRadius:24 borderWidth:0 borderColor:UIColorClear];
    self.confirmBut.titleLabel.font = [NSObject themePingFangSCMediumFont:18];
    [self.confirmBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.confirmBut setTitle:NSLocalizedString(@"OK", nil) forState:UIControlStateNormal];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 80;
    [self.tableView registerNib:[UINib nibWithNibName:@"LWCustomDialPickerViewCell" bundle:nil] forCellReuseIdentifier:@"LWCustomDialPickerViewCell"];
}

+ (LWCustomDialPickerView *)sharedInstance {
    static LWCustomDialPickerView *pickerView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pickerView = [[NSBundle mainBundle] loadNibNamed:@"LWCustomDialPickerView" owner:nil options:nil].firstObject;
        pickerView.backgroundColor = COLOR_HEX(0x333333, 0.3);
        pickerView.frame = [UIApplication sharedApplication].keyWindow.bounds;
    });
    return pickerView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)bgCancelClick:(id)sender {
    [self dismiss];
}
- (IBAction)CancelClick:(id)sender {
    [self dismiss];
}
- (IBAction)ConfirmClick:(id)sender {
    [self dismiss];
    if (self.customDialPickerViewSelectBlock) {
        self.customDialPickerViewSelectBlock(self.mode, self.selectObj);
    }
}

- (void)dismiss {
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformMakeScale(1.21f, 1.21f);
        self.bgView.transform = CGAffineTransformMakeScale(1.21f, 1.21f);
        self.bgView.alpha = 0;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (void)showMode:(LWCustomDialSelectMode)mode withTitle:(NSString *)title withArrayData:(nonnull NSArray *)arrayData withSelectObj:(NSInteger)obj withBlock:(nonnull void (^)(LWCustomDialSelectMode, NSInteger))block{
    self.customDialPickerViewSelectBlock = block;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    self.transform = CGAffineTransformMakeScale(1.21f, 1.21f);
    self.bgView.transform = CGAffineTransformMakeScale(1.21f, 1.21f);
    self.bgView.alpha = 0;
    self.alpha = 0;
    
    self.mode = mode;
    self.titleLabel.text = title;
    self.selectObj = obj;
    self.array = arrayData;
    [self.tableView reloadData];
    NSInteger high = 60+110+arrayData.count*80;
    self.bgViewHigh.constant = high>keyWindow.frame.size.height-68?keyWindow.frame.size.height-68:high;
    
    [UIView animateWithDuration:.7f delay:0.f usingSpringWithDamping:.7f initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 1;
        self.bgView.alpha = 1;
        self.bgView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    } completion:nil];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LWCustomDialPickerViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LWCustomDialPickerViewCell"];
    if (indexPath.row<self.array.count) {
        NSDictionary *dict = self.array[indexPath.row];
        cell.titleLabel.text = dict.allKeys.firstObject;
        cell.rigImage.image = [dict.allValues.firstObject integerValue]==self.selectObj?IMAGE_NAME(@"ic_dial_button"):IMAGE_NAME(@"ic_dial_button_d");
        cell.lineView.hidden = indexPath.row==self.array.count-1;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.array[indexPath.row];
    self.selectObj = [dict.allValues.firstObject integerValue];
    [self.tableView reloadData];
}

@end
