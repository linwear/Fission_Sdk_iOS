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
#import "FBCustomDialListColorCell.h"

#define dialScale (SCREEN_WIDTH / 375.0) // 系数，基于w=375开发

@interface FBCustomDialListContentView () <UICollectionViewDelegate, UICollectionViewDataSource, ZLCollectionViewBaseFlowLayoutDelegate>

@property (nonatomic, strong) FBCustomDialListModel *dialList;

@property (nonatomic, strong) NSArray <FBCustomDialSoures *> *selectSoures;

@property (nonatomic, copy) FBCustomDialListContentViewBlock listContentBlock;

@property (nonatomic, copy) FBCustomDialListContentHeightUpdateBlock heightUpdateBlock;

@property (nonatomic, copy) FBCustomDialListContentDynamicSelectionBlock dynamicSelectionBlock;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) CGFloat itemHeight;

@end

static NSString *FBCustomDialListHeadrViewID = @"FBCustomDialListHeadrView";
static NSString *FBCustomDialListImageCellID = @"FBCustomDialListImageCell";
static NSString *FBCustomDialListTitleCellID = @"FBCustomDialListTitleCell";
static NSString *FBCustomDialListColorCellID = @"FBCustomDialListColorCell";

@implementation FBCustomDialListContentView

/// 初始化
- (instancetype)initWithListContentBlock:(FBCustomDialListContentViewBlock)listContentBlock heightUpdateBlock:(FBCustomDialListContentHeightUpdateBlock)heightUpdateBlock dynamicSelectionBlock:(FBCustomDialListContentDynamicSelectionBlock)dynamicSelectionBlock {
    if (self = [super init]) {
        self.listContentBlock = listContentBlock;
        self.heightUpdateBlock = heightUpdateBlock;
        self.dynamicSelectionBlock = dynamicSelectionBlock;
    }
    return self;
}

/// 刷新列表
- (void)reloadCollectionView:(FBCustomDialListModel *)dialList soures:(NSArray <FBCustomDialSoures *> *)selectSoures {
    self.dialList = dialList;
    self.selectSoures = selectSoures;
    // 刷新列表
    [self listDidAppear];
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
        
    [collectionView registerNib:[UINib nibWithNibName:FBCustomDialListColorCellID bundle:nil] forCellWithReuseIdentifier:FBCustomDialListColorCellID];
    
    self.collectionView = collectionView;
    
    // 高度监听
    [self.collectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

// 高度监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if (object == self.collectionView && [keyPath isEqualToString:@"contentSize"] && self.heightUpdateBlock) {
        
        self.heightUpdateBlock(self.dialList.listType, self.collectionView.contentSize.height);
    }
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource, ZLCollectionViewBaseFlowLayoutDelegate

- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    
    if (section < self.dialList.list.count) {
        FBCustomDialItems *list = self.dialList.list[section];
        if (list.souresType == FBCustomDialListSouresType_Image || list.souresType == FBCustomDialListSouresType_Color) {
            return ClosedLayout;
        } else {
            return LabelLayout;
        }
    }
    
    return ClosedLayout;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section {
    
    if (self.dialList.listType == FBCustomDialListType_Module || self.dialList.listType == FBCustomDialListType_Colour) {
        NSInteger columns = 5;
        self.itemHeight = (self.view.width - (columns+1)*10) / columns;
        return columns;
    } else {
        NSInteger columns = 4;
        self.itemHeight = (self.view.width - (columns+1)*10) / columns;
        return columns;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.dialList.list.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section < self.dialList.list.count) {
        FBCustomDialItems *list = self.dialList.list[section];
        NSArray <FBCustomDialSoures *> *soures = [self dialSouresOfList:list withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        return soures.count;
    }
    
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FBCustomDialListImageCell *imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:FBCustomDialListImageCellID forIndexPath:indexPath];
    imageCell.edgeInsets = 0;
    imageCell.cornerRadius = 0;
    
    FBCustomDialListTitleCell *titleCell = [collectionView dequeueReusableCellWithReuseIdentifier:FBCustomDialListTitleCellID forIndexPath:indexPath];
    
    FBCustomDialListColorCell *colorCell = [collectionView dequeueReusableCellWithReuseIdentifier:FBCustomDialListColorCellID forIndexPath:indexPath];
    
    if (indexPath.section < self.dialList.list.count) {
        FBCustomDialItems *list = self.dialList.list[indexPath.section];
        
        NSArray <FBCustomDialSoures *> *dialSoures = [self dialSouresOfList:list withIndexPath:indexPath];
        
        if (indexPath.row < dialSoures.count) {
            
            FBCustomDialSoures *item = dialSoures[indexPath.row];
            
            if (list.souresType == FBCustomDialListSouresType_Image) {
                
                imageCell.backgroundColor = item.itemEvent==FBCustomDialListItemsEvent_BackgroundImage ? UIColorClear : COLOR_HEX(0x333333, 1);
                imageCell.backgroundImage.contentMode = item.itemEvent==FBCustomDialListItemsEvent_BackgroundImage ? UIViewContentModeScaleAspectFill : UIViewContentModeScaleAspectFit;
                imageCell.backgroundImage.image = (item.itemEvent==FBCustomDialListItemsEvent_BackgroundImage && indexPath.row==0) ? UIImageMake(@"ic_share_add") : item.image;
                imageCell.markImage.hidden = !item.isSelect;
                
                if (item.itemEvent == FBCustomDialListItemsEvent_NumberImage) {
                    imageCell.edgeInsets = 10 * dialScale;
                } else if (self.dialList.listType == FBCustomDialListType_Module) {
                    imageCell.edgeInsets = item.itemEvent==FBCustomDialListItemsEvent_StateBatteryImage ? 7 * dialScale : 17 * dialScale;
                    imageCell.cornerRadius = 10 * dialScale;
                }
                
                return imageCell;
            }
            else if (list.souresType == FBCustomDialListSouresType_Text) {
                
                titleCell.titleLabel.backgroundColor = item.isSelect ? BlueColor : LineColor;
                titleCell.titleLabel.textColor = item.isSelect ? UIColorWhite : UIColorBlack;
                titleCell.titleLabel.text = item.title;
                titleCell.pointView.backgroundColor = item.isTitleSelect ? BlueColor : UIColorClear;
                
                return titleCell;
            }
            else if (list.souresType == FBCustomDialListSouresType_Color) {
                
                colorCell.colorView.backgroundColor = item.color;
                colorCell.colorView.cornerRadius = 10 * dialScale;
                colorCell.cornerRadius = 12 * dialScale;
                colorCell.borderWidth = 2;
                colorCell.borderColor = item.isSelect ? COLOR_HEX(0xAAAAAA, 1) : UIColorClear;
                
                return colorCell;
            }
        }
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section < self.dialList.list.count) {
        FBCustomDialItems *list = self.dialList.list[indexPath.section];
        
        NSArray <FBCustomDialSoures *> *dialSoures = [self dialSouresOfList:list withIndexPath:indexPath];
        
        if (indexPath.row < dialSoures.count) {
            
            if (list.souresType == FBCustomDialListSouresType_Image || list.souresType == FBCustomDialListSouresType_Color) {
                
                return CGSizeMake(0, self.itemHeight);
            }
            else {
                FBCustomDialSoures *soures = dialSoures[indexPath.row];
                return CGSizeMake([soures.title boundingRectWithSize:CGSizeMake(1000000, 20) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:15]} context:nil].size.width + 30, 30);
            }
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
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader] && indexPath.section < self.dialList.list.count) {
        
        FBCustomDialItems *list = self.dialList.list[indexPath.section];
        
        if (StringIsEmpty(list.title)) {
            return nil;
        } else {
            FBCustomDialListHeadrView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:FBCustomDialListHeadrViewID forIndexPath:indexPath];
            headerView.textLabel.text = list.title;
            
            return headerView;
        }
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section < self.dialList.list.count) {
        
        FBCustomDialItems *list = self.dialList.list[section];
        
        if (StringIsEmpty(list.title)) {
            return CGSizeZero;
        } else {
            return CGSizeMake(collectionView.frame.size.width, 30);
        }
    }
    
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf(self);
    
    FBCustomDialItems *list = self.dialList.list[indexPath.section];
    NSArray <FBCustomDialSoures *> *dialSoures = [self dialSouresOfList:list withIndexPath:indexPath];
    FBCustomDialSoures *item = dialSoures[indexPath.row];
    FBCustomDialDynamicSelection dynamicSelection = FBCustomDialDynamicSelection_None; // 控件 加减数 显示
    
    if (self.dialList.listType == FBCustomDialListType_Background && indexPath.row == 0) { // "+" 相册、相机
        
        [FBAuthorityObject.sharedInstance presentRequestImageWithBlock:^(UIImage * _Nonnull image) {
            
            [weakSelf dialSouresOfArray:dialSoures withSelectedIndex:indexPath.row]; // 将要选中
            
            item.image = image;
            
            if (weakSelf.listContentBlock) {
                weakSelf.listContentBlock(weakSelf.dialList, item, indexPath);
            }
        }];
        
        return;
        
    } else if (item.allowRepeatSelection) { // 支持复选（选择 and 取消）
        
        BOOL isTitleSelect = NO; // 重置文字组
        
        if (item.isSelect) { // 已选择，将要取消选中
            
            if (item.itemEvent == FBCustomDialListItemsEvent_NumberImage ||
                item.itemEvent == FBCustomDialListItemsEvent_PointerImage) {
                // 这里根据自身业务处理，如无限制，移除上方条件限制
                NSMutableArray <FBCustomDialSoures *> *selectSoures = [NSMutableArray arrayWithArray:self.selectSoures];
                
                NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(FBCustomDialSoures * _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
                    return (evaluatedObject.itemEvent == FBCustomDialListItemsEvent_NumberImage ||
                            evaluatedObject.itemEvent == FBCustomDialListItemsEvent_PointerImage);
                }];
                
                // 该组是否已选择过
                NSArray *soures = [selectSoures filteredArrayUsingPredicate:predicate]; // 当前组已选中的个数
                if (soures.count > 1) {
                    isTitleSelect  = NO;
                    item.isSelect = NO;
                    dynamicSelection = FBCustomDialDynamicSelection_CutSuccess;
                } else {
                    [NSObject showHUDText:LWLocalizbleString(@"Select at least one watch face type")];
                    return;
                }
            } else {
                isTitleSelect  = NO;
                item.isSelect = NO;
                dynamicSelection = FBCustomDialDynamicSelection_CutSuccess;
            }
        }
        else {
            
            if ([self allowSelectionOfList:list withSoures:dialSoures withItem:item]) { // 是否允许选中，否就是超个数了，如组件最多6个
                
                /* 由于表盘内存空间有限，自定义内容最多不能超过16个控件，不同样式所占用的控件个数都有所不同。添加自定义内容前需要检查表盘空间是否足够｜Due to the limited memory space of the dial, the customized content cannot exceed 16 controls at most, and the number of controls occupied by different styles is different. Before adding custom content, you need to check whether there is enough space on the dial */
                if ([weakSelf checkForOverflowWithItem:item]) {
                    dynamicSelection = FBCustomDialDynamicSelection_AddFailure;
                    if (self.dynamicSelectionBlock) {
                        self.dynamicSelectionBlock(dynamicSelection, item);
                    }
                    [NSObject showHUDText:LWLocalizbleString(@"Insufficient memory space")];
                    return;
                } else {
                    isTitleSelect  = YES;
                    dynamicSelection = FBCustomDialDynamicSelection_AddSuccess;
                    [self dialSouresOfArray:dialSoures withSelectedIndex:indexPath.row]; // 将要选中
                }
        
            } else {
                // 这里根据自身业务处理，如无限制，移除上方条件限制
                [NSObject showHUDText:[NSString stringWithFormat:LWLocalizbleString(@"At most %d components can be set"), FBAllConfigObject.firmwareConfig.shape==1 ? 5 : 6]];
                return;
            }
        }
        
        [self textGroupDisplaySmallDotPrompts:isTitleSelect withIndexPath:indexPath];
    }
    else {
        if (item.isSelect) return; // 不支持复选，如已选中，那么什么都不做
        
        /* 由于表盘内存空间有限，自定义内容最多不能超过16个控件，不同样式所占用的控件个数都有所不同。添加自定义内容前需要检查表盘空间是否足够｜Due to the limited memory space of the dial, the customized content cannot exceed 16 controls at most, and the number of controls occupied by different styles is different. Before adding custom content, you need to check whether there is enough space on the dial */
        if ([weakSelf checkForOverflowWithItem:item]) {
            dynamicSelection = FBCustomDialDynamicSelection_AddFailure;
            if (self.dynamicSelectionBlock) {
                self.dynamicSelectionBlock(dynamicSelection, item);
            }
            [NSObject showHUDText:LWLocalizbleString(@"Insufficient memory space")];
            return;
        } else {
            dynamicSelection = FBCustomDialDynamicSelection_AddSuccess;
            [self dialSouresOfArray:dialSoures withSelectedIndex:indexPath.row]; // 将要选中
        }
    }
    
    if (self.dynamicSelectionBlock) {
        self.dynamicSelectionBlock(dynamicSelection, item);
    }
    
    if (self.listContentBlock) {
        self.listContentBlock(self.dialList, item, indexPath);
    }
}

#pragma mark - 行为工具
// 返回对应组的row信息
- (NSArray <FBCustomDialSoures *> *)dialSouresOfList:(FBCustomDialItems *)list withIndexPath:(NSIndexPath *)indexPath {
     
    if (list.souresType == FBCustomDialListSouresType_Image && indexPath.section-1 >= 0 && self.dialList.list[indexPath.section-1].souresType == FBCustomDialListSouresType_Text) { // 当前组为image类型 且 当前不是第一组 且 上一组是title类型，说明该组内容是根据上一组选择结果而定定
        NSArray <FBCustomDialSoures *> *dialSoures = self.dialList.list[indexPath.section-1].items.firstObject; // 文字组
        NSInteger index = 0; // 选择的类型索引
        for (FBCustomDialSoures *item in dialSoures) {
            if (item.isSelect) break;
            index ++;
        }
        
        if (index < list.items.count) {
            NSArray <FBCustomDialSoures *> *dialSoures = list.items[index];
            return dialSoures;
        } else {
            return nil;
        }
    } else {
        NSArray <FBCustomDialSoures *> *dialSoures = list.items.firstObject;
        return dialSoures;
    }
}

// 是否允许选中，否就是超个数了，如组件最多6个
- (BOOL)allowSelectionOfList:(FBCustomDialItems *)list withSoures:(NSArray <FBCustomDialSoures *> *)dialSoures withItem:(FBCustomDialSoures *)item {
    
    BOOL allowSelection = YES;
    
    if (item.itemEvent >= FBCustomDialListItemsEvent_ModuleStepImage &&
        item.itemEvent <= FBCustomDialListItemsEvent_ModuleStressImage) { // 组件
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(FBCustomDialSoures * _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            return (evaluatedObject.isSelect); // 过滤未选中的
        }];
        
        // 当前组是否有已选中，如果有，则是用来替换的，要允许选择
        NSArray *filteredDialSoures = [dialSoures filteredArrayUsingPredicate:predicate]; // 当前组已选中的个数
        if (filteredDialSoures.count) {
            return allowSelection;
        }
        else {
            NSInteger maxCount = FBAllConfigObject.firmwareConfig.shape==1 ? 5 : 6; // 最大允许选中的个数（圆形5、方形6）
            NSInteger count = 0;
            
            for (NSArray <FBCustomDialSoures *> *soures in list.items) {
                NSArray *filteredArray = [soures filteredArrayUsingPredicate:predicate]; // 已选中的个数
                
                count += filteredArray.count;
                
                if (count >= maxCount) {
                    allowSelection = NO;
                    break;
                }
            }
            
            return allowSelection;
        }
    } else {
        return allowSelection;
    }
}

// 将要选中的item
- (void)dialSouresOfArray:(NSArray <FBCustomDialSoures *> *)dialSoures withSelectedIndex:(NSInteger)selectedIndex {
    
    for (NSInteger k = 0; k < dialSoures.count; k++) {
        FBCustomDialSoures *item = dialSoures[k];
        item.isSelect = k==selectedIndex;
    }
}

// 文字组是否显示小圆点提示
- (void)textGroupDisplaySmallDotPrompts:(BOOL)isTitleSelect withIndexPath:(NSIndexPath *)indexPath {
    if (self.dialList.list[indexPath.section].souresType == FBCustomDialListSouresType_Image &&
        indexPath.section-1 >= 0 &&
        self.dialList.list[indexPath.section-1].souresType == FBCustomDialListSouresType_Text) { // 当前组为image类型 且 当前不是第一组 且 上一组是title类型，说明该组内容是根据上一组选择结果而定定
        NSArray <FBCustomDialSoures *> *dialSoures = self.dialList.list[indexPath.section-1].items.firstObject; // 文字组
        
        for (FBCustomDialSoures *item in dialSoures) {
            if (item.isSelect) {
                item.isTitleSelect = isTitleSelect;
                break;
            }
        }
    }
}

// 由于表盘内存空间有限，自定义内容最多不能超过16个控件
- (BOOL)checkForOverflowWithItem:(FBCustomDialSoures *)item {
    
#ifdef FBINTERNAL
    
    if (item.itemEvent <= FBCustomDialListItemsEvent_DialTypeText ||
        (item.itemEvent >= FBCustomDialListItemsEvent_ScaleImage && item.itemEvent <= FBCustomDialListItemsEvent_StateTypeText) ||
        (item.itemEvent == FBCustomDialListItemsEvent_ModuleTypeText) ||
        (item.itemEvent >= FBCustomDialListItemsEvent_Color)) {

        return NO;
    }
    else {

        NSMutableArray <FBCustomDialSoures *> *selectSoures = [NSMutableArray arrayWithArray:self.selectSoures];

        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(FBCustomDialSoures * _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            return (evaluatedObject.itemEvent == item.itemEvent);
        }];

        // 该组是否已选择过
        FBCustomDialSoures *soures = [selectSoures filteredArrayUsingPredicate:predicate].firstObject; // 当前组已选中的个数
        if (soures) { // 已存在
            if (item.isSelect) { // 当前已是选中，将要取消
                [selectSoures removeObject:soures];
            } else { // 当前未被选择，将要选中（替换）
                NSUInteger index = [selectSoures indexOfObject:soures];
                [selectSoures replaceObjectAtIndex:index withObject:item];
            }
        } else {
            // 新增
            [selectSoures addObject:item];
        }


        // 转换
        NSMutableArray <FBCustomDialItem *> *selectItem = NSMutableArray.array;

        for (FBCustomDialSoures *soures in selectSoures) {

            FBCustomDialItem *item = FBCustomDialItem.new;
            item.index = soures.index;

            FB_CUSTOMDIALITEMS type = FB_CustomDialItems_None;

            if (soures.itemEvent == FBCustomDialListItemsEvent_NumberImage) {
                type = FB_CustomDialItems_Time_Style;
            }
            else if (soures.itemEvent == FBCustomDialListItemsEvent_PointerImage) {
                type = FB_CustomDialItems_Pointer;
            }
            else if (soures.itemEvent == FBCustomDialListItemsEvent_StateBatteryImage) {
                type = FB_CustomDialItems_Battery;
            }
            else if (soures.itemEvent == FBCustomDialListItemsEvent_StateBluetoothImage_BLE) {
                type = FB_CustomDialItems_BLE;
            }
            else if (soures.itemEvent == FBCustomDialListItemsEvent_StateBluetoothImage_BT) {
                type = FB_CustomDialItems_BT;
            }
            else if (soures.itemEvent == FBCustomDialListItemsEvent_ModuleStepImage) {
                type = FB_CustomDialItems_Step;
            }
            else if (soures.itemEvent == FBCustomDialListItemsEvent_ModuleCalorieImage) {
                type = FB_CustomDialItems_Calorie;
            }
            else if (soures.itemEvent == FBCustomDialListItemsEvent_ModuleDistanceImage) {
                type = FB_CustomDialItems_Distance;
            }
            else if (soures.itemEvent == FBCustomDialListItemsEvent_ModuleHeartRateImage) {
                type = FB_CustomDialItems_HeartRate;
            }
            else if (soures.itemEvent == FBCustomDialListItemsEvent_ModuleBloodOxygenImage) {
                type = FB_CustomDialItems_BloodOxygen;
            }
            else if (soures.itemEvent == FBCustomDialListItemsEvent_ModuleBloodPressureImage) {
                type = FB_CustomDialItems_BloodPressure;
            }
            else if (soures.itemEvent == FBCustomDialListItemsEvent_ModuleStressImage) {
                type = FB_CustomDialItems_Stress;
            }

            item.type = type;

            if (item.type != FB_CustomDialItems_None) {
                [selectItem addObject:item];
            }
        }

        /* 由于表盘内存空间有限，自定义内容最多不能超过16个控件，不同样式所占用的控件个数都有所不同。添加自定义内容前需要检查表盘空间是否足够｜Due to the limited memory space of the dial, the customized content cannot exceed 16 controls at most, and the number of controls occupied by different styles is different. Before adding custom content, you need to check whether there is enough space on the dial */
        BOOL overflow = [FBCustomDataTools checkForOverflow:selectItem];

        return overflow;
    }
    
#endif
    
    return NO;
}

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
    // 刷新列表
    [self.collectionView reloadData];
}

- (void)dealloc {
    [self.collectionView removeObserver:self forKeyPath:@"contentSize"];
}

@end
