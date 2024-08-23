//
//  LWCustomDialTableView.m
//  LinWear
//
//  Created by 裂变智能 on 2021/6/16.
//  Copyright © 2021 lw. All rights reserved.
//

#import "LWCustomDialTableView.h"
#import "LWCustomDialCell.h"
#import "LWCustomDialColorCell.h"
#import "LWCustomDialPickerView.h"

@interface LWCustomDialTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImagePickerController *imagePickerVc; // 图片选择器

@end

static NSString *const idty = @"LWCustomDialCell";

@implementation LWCustomDialTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registerClass:LWCustomDialCell.class forCellReuseIdentifier:idty];
        [self registerNib:[UINib nibWithNibName:@"LWCustomDialColorCell" bundle:nil] forCellReuseIdentifier:@"LWCustomDialColorCell"];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return self;
}

- (void)setTitles:(NSArray *)titles{
    _titles = titles;
    
    [self reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf(self);
    if (indexPath.row >= self.titles.count) return nil;
    
    NSDictionary *dict = self.titles[indexPath.row];
    NSString *title = dict.allKeys.firstObject;
    if ([title isEqualToString:LWLocalizbleString(@"Text Color Replacement")]) {
        LWCustomDialColorCell *colorCell = [tableView dequeueReusableCellWithIdentifier:@"LWCustomDialColorCell"];
        colorCell.titleLabel.text = title;
        colorCell.didSelectColorBlock = ^(UIColor * _Nullable didSelectColor) {
            if (weakSelf.customDialSelectModeBlock) {
                weakSelf.customDialSelectModeBlock(LWCustomDialSelectFontColor, didSelectColor);
            }
        };
        return colorCell;
    } else {
        LWCustomDialCell *dialCell = [tableView dequeueReusableCellWithIdentifier:idty forIndexPath:indexPath];
        dialCell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dict = self.titles[indexPath.row];
        NSString *title = dict.allKeys.firstObject;
        dialCell.titleLabel.text = title;
        dialCell.contentLabel.text = [self returnContentString:title withArray:dict.allValues.firstObject];
        
        return dialCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row >= self.titles.count) return 0;
    
    NSDictionary *dict = self.titles[indexPath.row];
    NSString *title = dict.allKeys.firstObject;
    if ([title isEqualToString:LWLocalizbleString(@"Text Color Replacement")]) {
        return 100;
    } else {
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeakSelf(self);
    NSDictionary *dict = self.titles[indexPath.row];
    NSString *title = dict.allKeys.firstObject;
    NSArray *array = dict.allValues.firstObject;
    
    if ([title isEqualToString:LWLocalizbleString(@"Background Picture")]) {
        [self handleSelectedPhoto];
    }
    else if ([title isEqualToString:LWLocalizbleString(@"Time Position")]) {
        
        NSInteger selectObj = self.selectModel.selectPosition;
        [[LWCustomDialPickerView sharedInstance] showMode:LWCustomDialSelectPosition withTitle:LWLocalizbleString(@"Time Position") withArrayData:array withSelectObj:selectObj withBlock:^(LWCustomDialSelectMode mode, NSInteger result) {
            if (mode==LWCustomDialSelectPosition) {
                LWCustomTimeLocationStyle selectPosition = result;
                if (weakSelf.customDialSelectModeBlock) {
                    weakSelf.customDialSelectModeBlock(mode, @(selectPosition));
                }
            }
        }];
    }
    else if ([title isEqualToString:LWLocalizbleString(@"Restore Default Settings")]) {
        if (weakSelf.customDialSelectModeBlock) {
            weakSelf.customDialSelectModeBlock(LWCustomDialSelectRestoreDefault, @(YES));
        }
    }
}

- (NSString *)returnContentString:(NSString *)title withArray:(NSArray *)array {
    NSString *content = @"";
    if ([title isEqualToString:LWLocalizbleString(@"Time Position")]) {
        
        for (NSDictionary *dict in array) {
            if ([dict.allValues.firstObject integerValue] == self.selectModel.selectPosition) {
                return dict.allKeys.firstObject;
                break;
            }
        }
    }
    return content;
}


#pragma mark - SelectedPhoto
- (void)handleSelectedPhoto {
    WeakSelf(self);
    [FBAuthorityObject.sharedInstance present:QMUIHelper.visibleViewController requestImageWithBlock:^(id  _Nullable results) {        
        // 将选择的照片刷新UI表盘预览
        if (weakSelf.customDialSelectModeBlock) {
            weakSelf.customDialSelectModeBlock(LWCustomDialSelectBgImage, results);
        }
    }];
}
@end
