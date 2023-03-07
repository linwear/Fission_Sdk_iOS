//
//  LWMotionPushCollectionView.m
//  LinWear
//
//  Created by 裂变智能 on 2023/2/25.
//  Copyright © 2023 lw. All rights reserved.
//

#import "LWMotionPushCollectionView.h"
#import "LWMotionPushCell.h"

@interface LWMotionPushCollectionView () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIImage *icon;

@property (nonatomic, copy) LWMotionPushSelectBlock block;

@property (nonatomic, assign) BOOL isAdd;

@property (nonatomic, retain) UILongPressGestureRecognizer *longPress;

@end

@implementation LWMotionPushCollectionView

- (instancetype)initWithIcon:(UIImage *)icon add:(BOOL)isAdd block:(LWMotionPushSelectBlock)block {
    if (self == [super init]) {
        
        self.icon = icon;
        self.block = block;
        self.isAdd = isAdd;
        
        LWMotionPushCellModel *model = LWMotionPushCellModel.new;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = model.itemSize;
        layout.sectionInset = model.sectionInset;
        layout.minimumLineSpacing = model.minimumLineSpacing;
        layout.minimumInteritemSpacing = model.minimumInteritemSpacing;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = UIColorWhite;
        [collectionView registerNib:[UINib nibWithNibName:@"LWMotionPushCell" bundle:nil] forCellWithReuseIdentifier:@"LWMotionPushCell"];
        [self addSubview:collectionView];
        collectionView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        _collectionView = collectionView;
        
        if (self.isAdd) {
            self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(lonePressMoving:)];
            [self.collectionView addGestureRecognizer:self.longPress];
        }
    }
    return self;
}

- (void)setSportList:(NSMutableArray *)sportList {
    _sportList = sportList;
    
    [self.collectionView reloadData];
}

#pragma mark - UILongPressGestureRecognizer
- (void)lonePressMoving:(UILongPressGestureRecognizer *)longPress
{
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan: {
            {
                NSIndexPath *selectIndexPath = [self.collectionView indexPathForItemAtPoint:[longPress locationInView:self.collectionView]];

                // 如果最后一个是 添加+，则不移动
                if (selectIndexPath.row == self.sportList.count) return;
                
                [self.collectionView beginInteractiveMovementForItemAtIndexPath:selectIndexPath];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
                [self.collectionView updateInteractiveMovementTargetPosition:[longPress locationInView:self.collectionView]];
            break;
        }
        case UIGestureRecognizerStateEnded: {
                [self.collectionView endInteractiveMovement]; // 结束
            break;
        }
        default: [self.collectionView cancelInteractiveMovement]; // 取消
            break;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark - UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.isAdd) return 1;
    return self.sportList.count ? 1 : 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.isAdd && self.sportList.count < FBAllConfigObject.firmwareConfig.supportMultipleSportsCount) {
        return self.sportList.count + 1; // +1 添加item
    } else {
        return self.sportList.count;
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.isAdd;
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    
    //取出源item数据
    LWMotionPushModel *objc =  [self.sportList objectAtIndex:sourceIndexPath.row];
    
    if (destinationIndexPath.row < self.sportList.count) // 数据源内
    {
        //删除指定位置的数据
        [self.sportList removeObjectAtIndex:sourceIndexPath.row];
        //将数据插入到资源数组中的目标位置上
        [self.sportList insertObject:objc atIndex:destinationIndexPath.row];
    }
    else if (destinationIndexPath.row == self.sportList.count) // 超出数据源，最后一个是+号，强制在+号前面
    {
        //删除指定位置的数据
        [self.sportList removeObjectAtIndex:sourceIndexPath.row];
        //将数据插入到资源数组中的目标位置上
        [self.sportList insertObject:objc atIndex:destinationIndexPath.row -1];
    }
    
    if (self.block) {
        self.block(LWCellMoveClick, self.sportList);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LWMotionPushCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LWMotionPushCell" forIndexPath:indexPath];
    
    if (indexPath.row < self.sportList.count) {
        LWMotionPushModel *model = self.sportList[indexPath.row];
        [cell.cellImage sd_setImageWithURL:[NSURL URLWithString:model.appIconUrl]];
        cell.cellTitle.text = model.sportName;
        cell.icon.image = self.icon;
        cell.icon.hidden = !model.isShow;
    }
    else if (indexPath.row == self.sportList.count) {
        cell.cellImage.image = UIImageMake(@"ic_record_increase");
        cell.cellTitle.text = @"";
        cell.icon.hidden = YES;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row < self.sportList.count) {
        LWMotionPushModel *model = self.sportList[indexPath.row];
        
        if (self.isAdd) {
            if (self.block) {
                self.block(LWCellDeleteClick, model); // 删除
            }
        } else {
            if (self.block) {
                self.block(LWCellSelectClick, model); // 选择/取消
            }
        }
    }
    else {
        if (self.block) {
            self.block(LWCellAddClick, @(YES)); // 添加
        }
    }
}

@end
