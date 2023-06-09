//
//  FBCustomDialListContentView.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-05-30.
//

#import "FBCustomDialListContentView.h"
#import "FBCustomDialListHeadrView.h"
#import "FBCustomDialListImageCell.h"
#import "FBCustomDialListTitleCell.h"

@interface FBCustomDialListContentView () <UICollectionViewDelegate, UICollectionViewDataSource, ZLCollectionViewBaseFlowLayoutDelegate>

@property (nonatomic, strong) FBCustomDialListModel *dialItem;
@property (nonatomic, strong) FBCustomDialSelectModel *selectModel;

@property (nonatomic, copy) FBCustomDialListContentViewBlock block;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) CGFloat itemHeight;

@end

static NSString *FBCustomDialListHeadrViewID = @"FBCustomDialListHeadrView";
static NSString *FBCustomDialListImageCellID = @"FBCustomDialListImageCell";
static NSString *FBCustomDialListTitleCellID = @"FBCustomDialListTitleCell";


@implementation FBCustomDialListContentView

- (instancetype)initWithDialItem:(FBCustomDialListModel *)dialItem selectModel:(FBCustomDialSelectModel *)selectModel block:(FBCustomDialListContentViewBlock)block {
    if (self = [super init]) {
        self.dialItem = dialItem;
        self.selectModel = selectModel;
        self.block = block;
    }
    return self;
}

- (void)reloadCollectionView:(FBCustomDialSelectModel *)selectModel {
    self.selectModel = selectModel;
    
    [self.collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    ZLCollectionViewVerticalLayout *layout = ZLCollectionViewVerticalLayout.new;
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.delegate = self;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = UIColorClear;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    
    [collectionView registerClass:NSClassFromString(FBCustomDialListHeadrViewID) forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:FBCustomDialListHeadrViewID];
    
    [collectionView registerNib:[UINib nibWithNibName:FBCustomDialListImageCellID bundle:nil] forCellWithReuseIdentifier:FBCustomDialListImageCellID];
    
    [collectionView registerNib:[UINib nibWithNibName:FBCustomDialListTitleCellID bundle:nil] forCellWithReuseIdentifier:FBCustomDialListTitleCellID];
    
    self.collectionView = collectionView;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource, ZLCollectionViewBaseFlowLayoutDelegate

- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    
    if (section < self.dialItem.list.count) {
        FBCustomDialItems *items = self.dialItem.list[section];
        if (items.itemEvent == FBCustomDialListItemsEvent_DialTypeText ||
            items.itemEvent == FBCustomDialListItemsEvent_StateTypeText ||
            items.itemEvent == FBCustomDialListItemsEvent_ModuleTypeText) {
            return LabelLayout;
        }
    }
    
    return ClosedLayout;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section {
    
    if (section < self.dialItem.list.count) {
        FBCustomDialItems *items = self.dialItem.list[section];
        if (items.itemEvent == FBCustomDialListItemsEvent_StateTypeImage ||
            items.itemEvent == FBCustomDialListItemsEvent_ModuleTypeImage) {
            self.itemHeight = (self.view.width - (5+1)*10) / 5.0;
            return 5;
        }
    }
    self.itemHeight = (self.view.width - (4+1)*10) / 4.0;
    return 4;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.dialItem.list.count;
    
//    if (self.dialItem.listType == FBCustomDialListType_Background)
//    {
//        return 1;
//    }
//    else if (self.dialItem.listType == FBCustomDialListType_DialType)
//    {
//        if (self.selectModel.selectDialType == FBCustomDialType_Number) {
//            return 1;
//        } else {
//            return 3;
//        }
//    }
//    else if (self.dialItem.listType == FBCustomDialListType_Module) {
//        return 4;
//    }
//    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section < self.dialItem.list.count) {
        FBCustomDialItems *items = self.dialItem.list[section];
        FBCustomDialSoures *dialSoures = items.items.firstObject;
        
        return dialSoures.soures.count;
    }
    
    return 0;
//    if (self.dialItem.listType == FBCustomDialListType_Background)
//    {
//        return self.dialItem.backgroundImages.count;
//    }
//    else if (self.dialItem.listType == FBCustomDialListType_Dial)
//    {
//        if (section == 0) {
//            return self.dialItem.dialTypeTitle.count;
//        }
//        else if (section == 1) {
//            return self.dialItem.pointerImages.count;
//        }
//        else if (section == 2) {
//            return self.dialItem.scaleImages.count;
//       }
//    }
//    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FBCustomDialListImageCell *imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:FBCustomDialListImageCellID forIndexPath:indexPath];
    imageCell.backgroundImage.backgroundColor = UIColorClear;
    imageCell.backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
    imageCell.backgroundImage.image = nil;
    imageCell.backgroundImage.clipsToBounds = YES;
    
    FBCustomDialListTitleCell *titleCell = [collectionView dequeueReusableCellWithReuseIdentifier:FBCustomDialListTitleCellID forIndexPath:indexPath];
    titleCell.titleLabel.circle = YES;
    titleCell.titleLabel.backgroundColor = UIColorClear;
    titleCell.titleLabel.textColor = UIColorBlack;
    titleCell.titleLabel.text = nil;
    
    if (indexPath.section < self.dialItem.list.count) {
        FBCustomDialItems *item = self.dialItem.list[indexPath.section];
        
        FBCustomDialSoures *dialSoures = item.items.firstObject;
        
        if (indexPath.row < dialSoures.soures.count) {
            
            if ([dialSoures.soures.firstObject isKindOfClass:UIImage.class]) {
                
                imageCell.backgroundImage.image = dialSoures.soures[indexPath.row];
                
                return imageCell;
            }
            else if ([dialSoures.soures.firstObject isKindOfClass:NSString.class]) {
                
                titleCell.titleLabel.text = dialSoures.soures[indexPath.row];
                
                return titleCell;
            }
        }
    }
    
//    if (self.dialItem.listType == FBCustomDialListType_Background)
//    {
//        if (indexPath.row < self.dialItem.backgroundImages.count) {
//            imageCell.backgroundImage.image = self.dialItem.backgroundImages[indexPath.row];
//            imageCell.markImage.hidden = (self.selectModel.selectBackgroundImage != imageCell.backgroundImage.image);
//        }
//
//        return imageCell;
//    }
//    else if (self.dialItem.listType == FBCustomDialListType_Dial)
//    {
//        if (indexPath.section == 0) {
//            if (indexPath.row < self.dialItem.dialTypeTitle.count) {
//                titleCell.titleLabel.circle = YES;
//                titleCell.titleLabel.backgroundColor = (FBCustomDialType)indexPath.row==self.selectModel.selectDialType ? BlueColor : LineColor;
//                titleCell.titleLabel.textColor = (FBCustomDialType)indexPath.row==self.selectModel.selectDialType ? UIColorWhite : UIColorBlack;
//                titleCell.titleLabel.text = self.dialItem.dialTypeTitle[indexPath.row];
//            }
//
//            return titleCell;
//        }
//        else {
//            imageCell.backgroundImage.backgroundColor = COLOR_HEX(0x333333, 1);
//            imageCell.backgroundImage.contentMode = UIViewContentModeScaleAspectFit;
//
//            if (indexPath.section == 1) {
//                if (indexPath.row < self.dialItem.pointerImages.count) {
//                    imageCell.backgroundImage.image = self.dialItem.pointerImages[indexPath.row];
//                    imageCell.markImage.hidden = (self.selectModel.selectPointerImage != imageCell.backgroundImage.image);
//                }
//            } else if (indexPath.section == 2) {
//                if (indexPath.row < self.dialItem.scaleImages.count) {
//                    imageCell.backgroundImage.image = self.dialItem.scaleImages[indexPath.row];
//                    imageCell.markImage.hidden = (self.selectModel.selectScaleImage != imageCell.backgroundImage.image);
//                }
//            }
//
//            return imageCell;
//        }
//    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section < self.dialItem.list.count) {
        FBCustomDialItems *item = self.dialItem.list[indexPath.section];
        
        FBCustomDialSoures *dialSoures = item.items.firstObject;
        
        if (indexPath.row < dialSoures.soures.count) {
            
            if ([dialSoures.soures.firstObject isKindOfClass:UIImage.class]) {
                
                return CGSizeMake(0, self.itemHeight);
            }
            else if ([dialSoures.soures.firstObject isKindOfClass:NSString.class]) {
                                
                return CGSizeMake([dialSoures.soures[indexPath.row] boundingRectWithSize:CGSizeMake(1000000, 20) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:15]} context:nil].size.width + 30, 30);            }
        }
    }
    
    return CGSizeZero;
    
//    if (self.dialItem.listType == FBCustomDialListType_Dial && indexPath.section == 0) {
//        return CGSizeMake([self.dialItem.dialTypeTitle[indexPath.row] boundingRectWithSize:CGSizeMake(1000000, 20) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:15]} context:nil].size.width + 30, 30);
//    }
//
//    return CGSizeMake(0, self.itemHeight);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader] && indexPath.section < self.dialItem.list.count) {
        
        FBCustomDialItems *items = self.dialItem.list[indexPath.section];
        
        if (StringIsEmpty(items.title)) {
            return nil;
        } else {
            FBCustomDialListHeadrView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:FBCustomDialListHeadrViewID forIndexPath:indexPath];
            headerView.textLabel.text = items.title;
            
            return headerView;
        }
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section < self.dialItem.list.count) {
        
        FBCustomDialItems *items = self.dialItem.list[section];
        
        if (StringIsEmpty(items.title)) {
            return CGSizeZero;
        } else {
            return CGSizeMake(collectionView.frame.size.width, 30);
        }
    }
    
    return CGSizeZero;
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    WeakSelf(self);
//    if (self.dialItem.listType == FBCustomDialListType_Background) {
//        if (indexPath.row == 0) {
//            [FBAuthorityObject.sharedInstance presentViewControllerGetPictures:^(UIImage * _Nonnull image) {
//                if (weakSelf.block) {
//                    weakSelf.block(FBCustomDialListReloadEvent_BackgroundImage, 0, image, 0);
//                }
//            }];
//        } else {
//            UIImage *image = self.dialItem.backgroundImages[indexPath.row];
//            if (self.block) {
//                self.block(FBCustomDialListReloadEvent_BackgroundImage, 0, image, 0);
//            }
//        }
//    }
//    else if (self.dialItem.listType == FBCustomDialListType_Dial) {
//        if (indexPath.section == 0) {
//            if (self.block) {
//                self.block(FBCustomDialListReloadEvent_DialType, 0, nil, indexPath.row);
//            }
//        } else if (indexPath.section == 1) {
//            UIImage *image = self.dialItem.pointerImages[indexPath.row];
//            if (self.block) {
//                self.block(FBCustomDialListReloadEvent_PointerImage, 0, image, 0);
//            }
//        } else if (indexPath.section == 2) {
//            UIImage *image = self.dialItem.scaleImages[indexPath.row];
//            if (self.block) {
//                self.block(FBCustomDialListReloadEvent_ScaleImages, 0, image, 0);
//            }
//        }
//    }
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView {
    return self.view;
}

- (void)listDidAppear {
    WeakSelf(self);
    [NSObject showLoading:LWLocalizbleString(@"Loading...")];
    GCD_AFTER(1.0, ^{
        [NSObject dismiss];
        if (weakSelf.block) {
            weakSelf.block(FBCustomDialListItemsEvent_UpdateHeight, weakSelf.collectionView.contentSize.height, nil, 0);
        }
    });
}

@end
