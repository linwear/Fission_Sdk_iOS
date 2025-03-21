//
//  LWMotionPushDataCell.m
//  LinWear
//
//  Created by 裂变智能 on 2023/2/27.
//  Copyright © 2023 lw. All rights reserved.
//

#import "LWMotionPushDataCell.h"
#import "LWMotionPushCollectionView.h"

@interface LWMotionPushDataCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UIButton *morebut;

@property (nonatomic, strong) LWMotionPushCollectionView *collectionView;

@property (nonatomic, strong) UIView *line;

@property (nonatomic, copy) LWMotionPushSelectBlock block;

@end

@implementation LWMotionPushDataCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = UIColorClear;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *bgView = UIView.new;
        bgView.backgroundColor = UIColorWhite;
        [self.contentView addSubview:bgView];
        bgView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 10, 0, 10));
        self.bgView = bgView;
        
        UILabel *titleLab = [[UILabel alloc] qmui_initWithFont:[UIFont systemFontOfSize:16] textColor:UIColorBlack];
        titleLab.numberOfLines = 0;
        [bgView addSubview:titleLab];
        titleLab.sd_layout.leftSpaceToView(bgView, 20).topEqualToView(bgView).rightSpaceToView(bgView, 60).heightIs(60);
        self.titleLab = titleLab;
        
        UIButton *morebut = [UIButton buttonWithType:UIButtonTypeCustom];
        [morebut setImage:UIImageMake(@"ic_list_bot") forState:UIControlStateNormal];
        [morebut setImage:UIImageMake(@"ic_list_top") forState:UIControlStateSelected];
        [bgView addSubview:morebut];
        morebut.sd_layout.leftSpaceToView(titleLab, 0).topEqualToView(titleLab).rightEqualToView(bgView).heightIs(60);
        self.morebut = morebut;
        [self.morebut addTarget:self action:@selector(morebutClick) forControlEvents:UIControlEventTouchUpInside];

        WeakSelf(self);
        LWMotionPushCollectionView *collectionView = [[LWMotionPushCollectionView alloc] initWithIcon:UIImageMake(@"ic_dial_selected") add:NO block:^(LWMotionPushClickType clickType, id  _Nonnull result) {
            if (weakSelf.block) {
                weakSelf.block(clickType, (LWMotionPushModel *)result);
            }
        }];
        [bgView addSubview:collectionView];
        collectionView.sd_layout.leftEqualToView(bgView).rightEqualToView(bgView).topSpaceToView(titleLab, 0).bottomEqualToView(bgView);
        self.collectionView = collectionView;

        UIView *line = UIView.new;
        line.backgroundColor = UIColorGrayLighten;
        [bgView addSubview:line];
        line.sd_layout.leftSpaceToView(bgView, 20).rightSpaceToView(bgView, 20).bottomEqualToView(bgView).heightIs(1);
        self.line = line;
    }
    return self;
}

- (void)morebutClick {
    if (self.block) {
        self.block(LWHeadTitleClick, @(!self.morebut.selected));
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reload:(LWMotionPushClassifyModel *)model isLast:(BOOL)isLastIndex block:(nonnull LWMotionPushSelectBlock)block {
    
    self.block = block;
    
    self.titleLab.text = model.sportClassifyName;
    self.morebut.selected = model.isShow;
    self.line.hidden = isLastIndex;

    self.collectionView.sportList = [NSMutableArray arrayWithArray:model.sportList.count ? model.sportList : @[]];
}

@end
