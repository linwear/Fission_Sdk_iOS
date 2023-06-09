//
//  FBCustomDialListContentView.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-05-30.
//

#import "LWBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^FBCustomDialListContentViewBlock)(FBCustomDialListItemsEvent listItemsEvent, CGFloat height, UIImage * _Nullable selectImage, NSInteger selectIndex);

@interface FBCustomDialListContentView : LWBaseViewController <JXCategoryListContentViewDelegate>

- (instancetype)initWithDialItem:(FBCustomDialListModel *)dialItem selectModel:(FBCustomDialSelectModel *)selectModel block:(FBCustomDialListContentViewBlock)block;

- (void)reloadCollectionView:(FBCustomDialSelectModel *)selectModel;

@end

NS_ASSUME_NONNULL_END
