//
//  LWMotionPushSelectCell.m
//  LinWear
//
//  Created by 裂变智能 on 2023/2/27.
//  Copyright © 2023 lw. All rights reserved.
//

#import "LWMotionPushSelectCell.h"
#import "LWMotionPushCollectionView.h"

@interface LWMotionPushSelectCell ()

@property (nonatomic, strong) LWMotionPushCollectionView *collectionView;

@property (nonatomic, copy) LWMotionPushSelectBlock block;

@end

@implementation LWMotionPushSelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = UIColorClear;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *bgView = UIView.new;
        bgView.backgroundColor = UIColorWhite;
        [self.contentView addSubview:bgView];
        bgView.sd_layout.leftSpaceToView(self.contentView, 10).rightSpaceToView(self.contentView, 10).topEqualToView(self.contentView).bottomEqualToView(self.contentView);
        [bgView setSd_cornerRadius:@(16)];
        
        WeakSelf(self);
        LWMotionPushCollectionView *collectionView = [[LWMotionPushCollectionView alloc] initWithIcon:UIImageMake(@"ic_push_delete") add:YES block:^(LWMotionPushClickType clickType, id  _Nonnull result) {
            if (weakSelf.block) {
                weakSelf.block(clickType, result);
            }
        }];
        [bgView addSubview:collectionView];
        collectionView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        self.collectionView = collectionView;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reload:(NSMutableArray <LWMotionPushModel *> *)selectList block:(LWMotionPushSelectBlock)block {
    
    self.block = block;
    
    self.collectionView.sportList = selectList;
}

@end
