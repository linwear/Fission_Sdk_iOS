//
//  LWCustomDialColorCell.m
//  LinWear
//
//  Created by 裂变智能 on 2021/6/16.
//  Copyright © 2021 lw. All rights reserved.
//

#import "LWCustomDialColorCell.h"
#import "LWCustomDialColorCollectionCell.h"

@interface LWCustomDialColorCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, retain) NSArray *arrayData;

@end

@implementation LWCustomDialColorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置item的行间距
    layout.minimumLineSpacing = 7;
    // 设置item大小
    layout.itemSize = CGSizeMake(55, 55);
    // 设置每个分区的 上左下右 的内边距
    layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    // 设置滚动条方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.backgroundColor = UIColorWhite;
    self.collectionView.showsHorizontalScrollIndicator = NO;   //是否显示滚动条
    self.collectionView.scrollEnabled = YES;  //滚动使能
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"LWCustomDialColorCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"LWCustomDialColorCollectionCell"];
    
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [NSObject themePingFangSCMediumFont:16];
    
    self.lineView.backgroundColor = [UIColor lightGrayColor];
    
    UIColor *color1 = [UIColor whiteColor];
    UIColor *color2 = COLOR_HEX(0x44FF75, 1);
    UIColor *color3 = COLOR_HEX(0xFF4747, 1);
    UIColor *color4 = COLOR_HEX(0xFFE244, 1);
    UIColor *color5 = COLOR_HEX(0xFF8144, 1);
    UIColor *color6 = COLOR_HEX(0x9244FF, 1);
    UIColor *color7 = COLOR_HEX(0x44ECFF, 1);
    UIColor *color8 = COLOR_HEX(0x333333, 1);
    UIColor *color9 = COLOR_HEX(0x4469FF, 1);
    
    self.arrayData = @[color1,color2,color3,color4,color5,color6,color7,color8,color9];
}

- (void)setSelectColor:(UIColor *)selectColor{
    _selectColor = selectColor;
    
    [self.collectionView reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrayData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LWCustomDialColorCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LWCustomDialColorCollectionCell" forIndexPath:indexPath];
    if (indexPath.row<self.arrayData.count) {
        [cell cellColor:self.arrayData[indexPath.row] withSelectColor:self.selectColor];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIColor *color = self.arrayData[indexPath.row];
    if (self.didSelectColorBlock) {
        self.didSelectColorBlock(color);
    }
}

@end
