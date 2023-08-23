//
//  FBCustomDialListContentView.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-05-30.
//

#import "LWBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN


typedef void(^FBCustomDialListContentViewBlock)(FBCustomDialListModel *dialList, FBCustomDialSoures *item, NSIndexPath *indexPath);

typedef void(^FBCustomDialListContentHeightUpdateBlock)(FBCustomDialListType listType, CGFloat updateHeight);


@interface FBCustomDialListContentView : LWBaseViewController <JXCategoryListContentViewDelegate>

/// 初始化
- (instancetype)initWithListContentBlock:(FBCustomDialListContentViewBlock)listContentBlock heightUpdateBlock:(FBCustomDialListContentHeightUpdateBlock)heightUpdateBlock;

/// 刷新列表
- (void)reloadCollectionView:(FBCustomDialListModel *)dialList soures:(NSArray <FBCustomDialSoures *> *)selectSoures;

/// 文字组是否显示小圆点提示
- (void)textGroupDisplaySmallDotPrompts:(BOOL)isTitleSelect withIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
