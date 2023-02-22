//
//  LWContactSearchBarHeaderView.m
//  LinWear
//
//  Created by 裂变智能 on 2022/11/12.
//  Copyright © 2022 lw. All rights reserved.
//

#import "LWContactSearchBarHeaderView.h"

@implementation LWContactSearchBarHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.backgroundColor = UIColorWhite;

    QMUISearchBar *sb = [[QMUISearchBar alloc] initWithFrame:CGRectZero];
    sb.backgroundImage = [QMUISearchBar qmui_generateTextFieldBackgroundImageWithColor:UIColorGrayLighten];
    [sb setSearchFieldBackgroundImage:[QMUISearchBar qmui_generateTextFieldBackgroundImageWithColor:UIColorGrayLighten] forState:UIControlStateNormal];
    sb.qmui_placeholderColor = UIColorGrayDarken;
    sb.qmui_textColor = UIColorBlack;
    sb.qmui_font = FONT(16);
    sb.qmui_usedAsTableHeaderView = YES;
    sb.qmui_fixMaskViewLayoutBugAutomatically = YES;
    sb.placeholder = LWLocalizbleString(@"Search Contacts");
    sb.sd_cornerRadius = @(5);
    [self.contentView addSubview:sb];
    sb.sd_resetLayout.spaceToSuperView(UIEdgeInsetsMake(15, 20, 15, 20));
    self.searchBar = sb;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
