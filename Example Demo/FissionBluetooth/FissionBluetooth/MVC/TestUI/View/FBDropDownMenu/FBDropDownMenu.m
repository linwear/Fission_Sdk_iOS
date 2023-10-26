//
//  FBDropDownMenu.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-10-25.
//

#import "FBDropDownMenu.h"

@implementation FBDropDownMenu

+ (void)showDropDownMenuWithModel:(NSArray<FBDropDownMenuModel *> *)modelArray menuWidth:(CGFloat)menuWidth itemHeight:(CGFloat)itemHeight menuBlock:(FFMenuBlock)menuBlock {
    
    FFDropDownMenuView *dropDownMenuView = [FFDropDownMenuView ff_DefaultStyleDropDownMenuWithMenuModelsArray:modelArray menuWidth:FFDefaultFloat eachItemHeight:FFDefaultFloat menuRightMargin:10 triangleRightMargin:30 menuBlock:menuBlock];
    dropDownMenuView.menuAnimateType = FFDropDownMenuViewAnimateType_FallFromTop;
    dropDownMenuView.cellClassName = @"FBDropDownMenuCell";
    dropDownMenuView.menuWidth = menuWidth;
    dropDownMenuView.eachMenuItemHeight = itemHeight;
    dropDownMenuView.triangleY = NavigationContentTop;
    dropDownMenuView.animateDuration = 0.3;
    dropDownMenuView.bgColorEndAlpha = 0.5;
    dropDownMenuView.ifShouldScroll = YES;
    if (modelArray.count > 6) {
        dropDownMenuView.menuBarHeight = 6.5 * itemHeight;
    }
    [dropDownMenuView setup];
    
    [dropDownMenuView showMenu];
}

@end



@implementation FBDropDownMenuModel

+ (instancetype)fb_DropDownMenuModelWithTitle:(NSString *)mainTitle subTitle:(NSString *)subTitle mark:(BOOL)mark textAlignment:(NSTextAlignment)textAlignment {
    FBDropDownMenuModel *model = [FBDropDownMenuModel new];
    model.mainTitle = mainTitle;
    model.subTitle = subTitle;
    model.mark = mark;
    model.textAlignment = textAlignment;
    return model;
}

@end



@implementation FBDropDownMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    UIImageView *markImage = [[UIImageView alloc] initWithImage:UIImageMake(@"ic_dial_selected")];
    [self.contentView addSubview:markImage];
    [markImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.width.height.mas_equalTo(20);
        make.centerY.mas_equalTo(self.contentView);
    }];
    self.markImage = markImage;
    
    QMUILabel *mainTitleLabel = [[QMUILabel alloc] qmui_initWithFont:FONT(15) textColor:UIColor.blackColor];
    mainTitleLabel.numberOfLines = 0;
    [self.contentView addSubview:mainTitleLabel];
    [mainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(markImage.mas_left);
    }];
    self.mainTitleLabel = mainTitleLabel;
}

- (void)setMenuModel:(id)menuModel {
    _menuModel = menuModel;
    
    FBDropDownMenuModel *model = (FBDropDownMenuModel *)menuModel;
    
    self.mainTitleLabel.textAlignment = model.textAlignment;
    self.mainTitleLabel.text = StringIsEmpty(model.subTitle) ? model.mainTitle : [NSString stringWithFormat:@"%@\n%@", model.mainTitle, model.subTitle];
    
    if (!StringIsEmpty(model.subTitle)) {
        [Tools setUILabel:self.mainTitleLabel setDataArr:@[model.subTitle] setColorArr:@[UIColor.lightGrayColor] setFontArr:@[self.mainTitleLabel.font]];
    }
    
    self.markImage.hidden = !model.mark;
    if (self.markImage.hidden) {
        [self.mainTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
        }];
    }
}

@end
