//
//  FBCustomDialHeadView.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-05-30.
//

#import "FBCustomDialHeadView.h"
#import "WMDragView.h"
#import "dispatch_source_timer.h"

#define dialScale (SCREEN_WIDTH / 375.0) // 系数，基于w=375开发
#define FBDigitalTimeSize CGSizeMake(130 * dialScale, 76 * dialScale) // 数字时间
#define FBModuleSize CGSizeMake(80 * dialScale, 50 * dialScale) // 组件
#define imageSize CGSizeMake(25 * dialScale, 25 * dialScale) // 图标

#define batteryText @"80%"
#define stepText @"12345"
#define calorieText @"123"
#define distanceText @"4.02"
#define heartRateText @"88"
#define bloodOxygenText @"98%"
#define bloodPressureText @"122/82"
#define stressText @"23"

@interface FBCustomDialHeadView ()

// 表盘预览图，包含所有组件：表盘背景、刻度背景、小组件等...
@property (nonatomic, strong) UIView *dialPreviewView;

// 表盘背景图：表盘背景组件、刻度背景组件
@property (nonatomic, strong) UIView *dialBackgroundView;
@property (nonatomic, strong) UIImageView *dialImage;       // 表盘背景图
@property (nonatomic, strong) UIImageView *scaleImage;      // 表盘刻度图

// 表盘小组件集（由于手表空间内存限制，部分内容需要叠加在表盘背景图上dialBackgroundView）
@property (nonatomic, strong) WMDragView *digitalTime;      // 数字时间
@property (nonatomic, strong) UIImageView *pointerImage;    // 时间指针
@property (nonatomic, strong) WMDragView *battery;          // 电池电量
@property (nonatomic, strong) WMDragView *BLE;              // BLE状态
@property (nonatomic, strong) WMDragView *BT;               // BT状态
@property (nonatomic, strong) WMDragView *step;             // 步数
@property (nonatomic, strong) WMDragView *calorie;          // 卡路里
@property (nonatomic, strong) WMDragView *distance;         // 距离
@property (nonatomic, strong) WMDragView *heartRate;        // 心率
@property (nonatomic, strong) WMDragView *bloodOxygen;      // 血氧
@property (nonatomic, strong) WMDragView *bloodPressure;    // 血压
@property (nonatomic, strong) WMDragView *stress;           // 压力

// 记录，新选中需要初始化x、y轴坐标
@property (nonatomic, strong) NSMutableArray <FBCustomDialPointModel *> *modulePoint; // 小组件的初始位置信息

@property (nonatomic, assign) NSArray <FBCustomDialSoures *> *selectSoures; // 已选择的项目

@property (nonatomic, assign) NSInteger selectSouresCount; // 已选择的个数

@property (nonatomic, strong) UIColor *selectColor; // 已选择的字体颜色

@property (nonatomic, strong) UILabel *controlsNumber;
@property (nonatomic, strong) UILabel *number;

@end

@implementation FBCustomDialHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self UI];
    }
    return self;
}

- (void)UI {
    
    CGFloat ViewWidth = self.frame.size.width;
    CGFloat rectRadius = 40.0; // 方，圆角大小
    
    FBFirmwareVersionObject *object = FBAllConfigObject.firmwareConfig;
    CGFloat scale = IS_NAN((CGFloat)object.watchDisplayHigh/(CGFloat)object.watchDisplayWide);
    BOOL isCircle = object.shape==1; // 圆
    
    // 表框size
    CGFloat dialWide = ViewWidth-120;
    CGFloat dialHigh = dialWide;
    
    if (!isCircle) {
        dialHigh = dialWide * scale;
    }
    

#pragma mark - 1⃣️表盘预览图（内含 表盘背景、表盘组件）
    UIView *dialPreviewView = UIView.new;
    dialPreviewView.backgroundColor = UIColorClear;
    dialPreviewView.clipsToBounds = YES;
    if (isCircle) {
        dialPreviewView.circle = YES;
    }
    [self addSubview:dialPreviewView];
    dialPreviewView.sd_layout.leftSpaceToView(self, 60).rightSpaceToView(self, 60).topSpaceToView(self, 30).heightIs(dialHigh);
    self.dialPreviewView = dialPreviewView;
    
    
#pragma mark - 2⃣️表盘背景图（内含 表盘图片、刻度图片）
    UIView *dialBackgroundView = UIView.new;
    dialBackgroundView.backgroundColor = UIColorClear;
    if (isCircle) {
        dialBackgroundView.circle = YES;
    }
    [dialPreviewView addSubview:dialBackgroundView];
    dialBackgroundView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    self.dialBackgroundView = dialBackgroundView;
    [self createDialBackgroundView:dialBackgroundView]; // 创建背景、刻度
    
    
#pragma mark - 3⃣️表盘组件集
    [self createDialModuleView:dialBackgroundView dialPreviewView:dialPreviewView isCircle:isCircle rectRadius:rectRadius]; // 创建组件集
    
    
#pragma mark - 5⃣️表框 与背景同色，遮住漏出来的背景
    UIView *backgroundView = UIView.new;
    backgroundView.userInteractionEnabled = NO;
    backgroundView.backgroundColor = UIColorClear;
    backgroundView.borderWidth = 10;
    backgroundView.borderColor = UIColorWhite;
    if (isCircle) {
        backgroundView.circle = YES;
    } else {
        backgroundView.cornerRadius = rectRadius+10;
    }
    [self addSubview:backgroundView];
    backgroundView.sd_layout.leftSpaceToView(self, 40).rightSpaceToView(self, 40).topSpaceToView(self, 10).heightIs(dialHigh+40);
    // 银色表框
    UIView *contourBackgroundView = UIView.new;
    contourBackgroundView.userInteractionEnabled = NO;
    contourBackgroundView.backgroundColor = UIColorClear;
    contourBackgroundView.borderWidth = 10;
    contourBackgroundView.borderColor = COLOR_HEX(0xDEDEDE, 1);
    if (isCircle) {
        contourBackgroundView.circle = YES;
    } else {
        contourBackgroundView.cornerRadius = rectRadius;
    }
    [backgroundView addSubview:contourBackgroundView];
    contourBackgroundView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(10, 10, 10, 10));
    

#pragma mark - 6⃣️描述
    UILabel *controlsNumber = [[UILabel alloc] qmui_initWithFont:FONT(14) textColor:UIColorBlack];
    controlsNumber.textAlignment = NSTextAlignmentCenter;
    [self addSubview:controlsNumber];
    controlsNumber.sd_layout.topSpaceToView(backgroundView, 10).heightIs(19).centerXEqualToView(backgroundView);
    [controlsNumber setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];
    self.controlsNumber = controlsNumber;
    
    UILabel *number = [[UILabel alloc] qmui_initWithFont:FONT(12) textColor:UIColor.redColor];
    number.alpha = 0.0;
    [self addSubview:number];
    number.sd_layout.leftSpaceToView(controlsNumber, 2).centerYEqualToView(controlsNumber).offset(-8).widthIs(20).heightIs(16);
    self.number = number;
    
    UILabel *label = [[UILabel alloc] qmui_initWithFont:FONT(14) textColor:UIColorGray];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = LWLocalizbleString(@"Long press the module to move");
    [self addSubview:label];
    label.sd_layout.leftSpaceToView(self, 10).rightSpaceToView(self, 10).topSpaceToView(controlsNumber, 10).autoHeightRatio(0);
    [label updateLayout];
    
    
#pragma mark - 7⃣️更新高度
    self.height = CGRectGetMaxY(label.frame)+20;
    
    
#pragma mark - 8⃣️初始化小组件位置信息
    self.modulePoint = NSMutableArray.array;
    
    [self.dialPreviewView updateLayout];
    
    CGFloat sw = self.BLE.width;
    
    // 小组件：蓝牙
    FBCustomDialPointModel *pointModel_1 = FBCustomDialPointModel.new;
    if (isCircle) {
        pointModel_1.point = CGPointMake(self.dialPreviewView.width/2-sw, 15 * dialScale);
    } else {
        pointModel_1.point = CGPointMake(20 * dialScale, 20 * dialScale);
    }
    [self.modulePoint addObject:pointModel_1];
    
    FBCustomDialPointModel *pointModel_2 = FBCustomDialPointModel.new;
    pointModel_2.point = CGPointMake(pointModel_1.point.x+sw, pointModel_1.point.y);
    [self.modulePoint addObject:pointModel_2];
    
    
    // 小组件：步数～精神压力（2行3列）
    CGFloat w = self.heartRate.width; // 组件宽
    CGFloat h = self.heartRate.height; // 组件高
    
    CGFloat x = (self.dialPreviewView.width - w*3)/2; // 首行首列x轴
    CGFloat y = self.dialPreviewView.height - h*2.7; // 首行首列y轴
    for (int j = 0; j < 2; j++) { // 控制行
        CGFloat py = y + (j*h);
        if (isCircle && j == 1) { // 圆形 定制第二行
            /* 圆形
             口  口  口
               口  口
             */
            for (int k = 0; k < 2; k++) { // 控制列
                CGFloat px = x + (k*w) + w/2;
                FBCustomDialPointModel *pointModel = FBCustomDialPointModel.new;
                pointModel.isModule = YES;
                pointModel.point = CGPointMake(px, py);
                [self.modulePoint addObject:pointModel];
            }
        } else {
            /* 方形
             口  口  口
             口  口  口
             */
            for (int k = 0; k < 3; k++) { // 控制列
                CGFloat px = x + (k*w);
                FBCustomDialPointModel *pointModel = FBCustomDialPointModel.new;
                pointModel.isModule = YES;
                pointModel.point = CGPointMake(px, py);
                [self.modulePoint addObject:pointModel];
            }
        }
    }
}


#pragma mark - 创建背景、刻度
- (void)createDialBackgroundView:(UIView *)dialBackgroundView {
    
    UIImageView *dialImage = UIImageView.new;
    dialImage.backgroundColor = UIColorClear;
    dialImage.contentMode = UIViewContentModeScaleAspectFill;
    [dialBackgroundView addSubview:dialImage];
    dialImage.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    self.dialImage = dialImage;
    
    UIImageView *scaleImage = UIImageView.new;
    scaleImage.hidden = YES;
    scaleImage.backgroundColor = UIColorClear;
    scaleImage.contentMode = UIViewContentModeScaleToFill;
    [dialBackgroundView addSubview:scaleImage];
    scaleImage.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    self.scaleImage = scaleImage;
}


#pragma mark - 创建组件集
- (void)createDialModuleView:(UIView *)dialBackgroundView dialPreviewView:(UIView *)dialPreviewView isCircle:(BOOL)isCircle rectRadius:(CGFloat)rectRadius {
    
    // 数字时间
    self.digitalTime = [self moduleImage:UIImage.new text:nil size:FBDigitalTimeSize addView:dialPreviewView isCircle:isCircle rectRadius:rectRadius];
    self.digitalTime.hidden = NO;
    
    // 指针
    UIImageView *pointerImage = UIImageView.new;
    pointerImage.hidden = YES;
    pointerImage.backgroundColor = UIColorClear;
    pointerImage.contentMode = UIViewContentModeScaleToFill;
    [dialPreviewView addSubview:pointerImage];
    pointerImage.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    self.pointerImage = pointerImage;
    
    // 电池电量
    self.battery = [self moduleImage:UIImage.new text:batteryText size:FBModuleSize addView:dialBackgroundView isCircle:isCircle rectRadius:rectRadius];
    
    // BLE状态
    self.BLE = [self moduleImage:UIImage.new text:nil size:imageSize addView:dialPreviewView isCircle:isCircle rectRadius:rectRadius];
    
    // BT状态
    self.BT = [self moduleImage:UIImage.new text:nil size:imageSize addView:dialPreviewView isCircle:isCircle rectRadius:rectRadius];
    
    // 步数
    self.step = [self moduleImage:UIImage.new text:stepText size:FBModuleSize addView:dialBackgroundView isCircle:isCircle rectRadius:rectRadius];
    
    // 卡路里
    self.calorie = [self moduleImage:UIImage.new text:calorieText size:FBModuleSize addView:dialBackgroundView isCircle:isCircle rectRadius:rectRadius];
    
    // 距离
    self.distance = [self moduleImage:UIImage.new text:distanceText size:FBModuleSize addView:dialBackgroundView isCircle:isCircle rectRadius:rectRadius];
    
    // 心率
    self.heartRate = [self moduleImage:UIImage.new text:heartRateText size:FBModuleSize addView:dialBackgroundView isCircle:isCircle rectRadius:rectRadius];
    
    // 血氧
    self.bloodOxygen = [self moduleImage:UIImage.new text:bloodOxygenText size:FBModuleSize addView:dialBackgroundView isCircle:isCircle rectRadius:rectRadius];
    
    // 血压
    self.bloodPressure = [self moduleImage:UIImage.new text:bloodPressureText size:FBModuleSize addView:dialBackgroundView isCircle:isCircle rectRadius:rectRadius];

    // 压力
    self.stress = [self moduleImage:UIImage.new text:stressText size:FBModuleSize addView:dialBackgroundView isCircle:isCircle rectRadius:rectRadius];
}

- (WMDragView *)moduleImage:(UIImage * _Nonnull)image text:(NSString * _Nullable)text size:(CGSize)size addView:(UIView * _Nonnull)dialModuleView isCircle:(BOOL)isCircle rectRadius:(CGFloat)rectRadius {
    
    WMDragView *dragView = [[WMDragView alloc] initWithFrame:(CGRect){CGPointZero, size}];
    dragView.backgroundColor = UIColorClear;
    dragView.textImageView.backgroundColor = UIColorClear;
    dragView.circleRect = isCircle;
    if (!isCircle) {
        dragView.rectRadius = rectRadius/4.0;
    }
    
    if (StringIsEmpty(text)) {
        dragView.textImageView.imagePosition = FBTextImageFill;
    } else {
        dragView.textImageView.imagePosition = FBTextImagePositionTop;
        
        dragView.textImageView.imageView.image = image;
        dragView.textImageView.titleLable.text = text;
        dragView.textImageView.titleLable.textColor = UIColorWhite;
        dragView.textImageView.titleLable.font = [NSObject BahnschriftFont:20 * dialScale];
    }
    
    [dialModuleView addSubview:dragView];
    dragView.sd_layout.centerXEqualToView(dialModuleView).centerYEqualToView(dialModuleView);
    return dragView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/// 刷新
- (void)reloadWithSoures:(NSArray <FBCustomDialSoures *> *)selectSoures withColor:(UIColor *)color firstTime:(BOOL)isFirstTime {
    
    // 新增的Event
    FBCustomDialListItemsEvent NewEvents = FBCustomDialListItemsEvent_None;
    
    if (!isFirstTime && selectSoures.count > self.selectSouresCount) { // 非首次，且个数有增加，最后一个为新增
        FBCustomDialSoures *dialSoures = selectSoures.lastObject;
        NewEvents = dialSoures.itemEvent; // 新增的Event
    }
    self.selectSoures = selectSoures;
    self.selectSouresCount = selectSoures.count;
    self.selectColor = color;
    
    self.scaleImage.hidden = YES;       // 表盘刻度图
    
    // 表盘小组件集
    self.digitalTime.hidden = YES;      // 数字时间
    self.pointerImage.hidden = YES;     // 时间指针
    self.battery.hidden = YES;          // 电池电量
    self.BLE.hidden = YES;              // BLE状态
    self.BT.hidden = YES;               // BT状态
    self.step.hidden = YES;             // 步数
    self.calorie.hidden = YES;          // 卡路里
    self.distance.hidden = YES;         // 距离
    self.heartRate.hidden = YES;        // 心率
    self.bloodOxygen.hidden = YES;      // 血氧
    self.bloodPressure.hidden = YES;    // 血压
    self.stress.hidden = YES;           // 压力
    
    for (FBCustomDialSoures *item in selectSoures) {
        if (item.itemEvent == FBCustomDialListItemsEvent_BackgroundImage) { // 背景图
            self.dialImage.image = item.image;
        }
        else if (item.itemEvent == FBCustomDialListItemsEvent_NumberImage) { // 数字时间
            self.digitalTime.hidden = NO;
            self.digitalTime.textImageView.imageView.image = [item.image qmui_imageWithTintColor:color];
            if (isFirstTime || NewEvents == item.itemEvent) { // 重置x、y轴
                GCD_MAIN_QUEUE(^{
                    self.digitalTime.center = CGPointMake(self.dialBackgroundView.width/2.0, self.dialBackgroundView.height*0.30);
                });
            }
        }
        else if (item.itemEvent == FBCustomDialListItemsEvent_PointerImage) { // 时间指针
            self.pointerImage.hidden = NO;
            self.pointerImage.image = item.image;
        }
        else if (item.itemEvent == FBCustomDialListItemsEvent_ScaleImage) { // 表盘刻度图
            self.scaleImage.hidden = NO;
            self.scaleImage.image = item.image;
        }
        else if (item.itemEvent >= FBCustomDialListItemsEvent_StateBatteryImage && // 组件：电池电量～精神压力
                 item.itemEvent <= FBCustomDialListItemsEvent_ModuleStressImage) {
                        
            if (item.itemEvent == FBCustomDialListItemsEvent_StateBatteryImage) { // 电池电量
                // 转换
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"index == %ld", item.index];
                NSArray <FBCustomDialSoures *> *filteredArray = [FBCustomDialObject.sharedInstance.batterySoures filteredArrayUsingPredicate:predicate];
                UIImage *batteryImage = filteredArray.firstObject.image;
                
                self.battery.hidden = NO;
                self.battery.textImageView.imageView.image = batteryImage;
                
                if (item.index == 0) {
                    self.battery.textImageView.imagePosition = FBTextImagePositionTop;   // 图片在上
                } else if (item.index == 1) {
                    self.battery.textImageView.imagePosition = FBTextImagePositionRight; // 图片在右
                } else if (item.index == 2) {
                    self.battery.textImageView.imagePosition = FBTextImagePositionTop;   // 图片在上
                } else if (item.index == 3) {
                    self.battery.textImageView.imagePosition = FBTextImagePositionLeft;  // 图片在左
                }
                
                if (NewEvents == item.itemEvent) { // 重置x、y轴
                    GCD_MAIN_QUEUE(^{
                        if (FBAllConfigObject.firmwareConfig.shape == 1) { // 圆
                            self.battery.center = CGPointMake(self.dialBackgroundView.width/2, self.dialBackgroundView.height*0.9);
                        } else {
                            self.battery.center = CGPointMake(self.dialBackgroundView.width - 15*dialScale - self.battery.width/2, 35*dialScale);
                        }
                    });
                }
            }
            else if (item.itemEvent == FBCustomDialListItemsEvent_StateBluetoothImage_BLE) { // BLE状态
                [self selectPointNewEvents:NewEvents forItemEvents:item.itemEvent forView:self.BLE];

                self.BLE.hidden = NO;
                self.BLE.textImageView.imageView.image = item.image;
            }
            else if (item.itemEvent == FBCustomDialListItemsEvent_StateBluetoothImage_BT) { // BT状态
                [self selectPointNewEvents:NewEvents forItemEvents:item.itemEvent forView:self.BT];

                self.BT.hidden = NO;
                self.BT.textImageView.imageView.image = item.image;
            }
            else if (item.itemEvent == FBCustomDialListItemsEvent_ModuleStepImage) { // 步数
                [self selectPointNewEvents:NewEvents forItemEvents:item.itemEvent forView:self.step];

                self.step.hidden = NO;
                self.step.textImageView.imageView.image = item.image;
            }
            else if (item.itemEvent == FBCustomDialListItemsEvent_ModuleCalorieImage) { // 卡路里
                [self selectPointNewEvents:NewEvents forItemEvents:item.itemEvent forView:self.calorie];

                self.calorie.hidden = NO;
                self.calorie.textImageView.imageView.image = item.image;
            }
            else if (item.itemEvent == FBCustomDialListItemsEvent_ModuleDistanceImage) { // 距离
                [self selectPointNewEvents:NewEvents forItemEvents:item.itemEvent forView:self.distance];

                self.distance.hidden = NO;
                self.distance.textImageView.imageView.image = item.image;
            }
            else if (item.itemEvent == FBCustomDialListItemsEvent_ModuleHeartRateImage) { // 心率
                [self selectPointNewEvents:NewEvents forItemEvents:item.itemEvent forView:self.heartRate];

                self.heartRate.hidden = NO;
                self.heartRate.textImageView.imageView.image = item.image;
            }
            else if (item.itemEvent == FBCustomDialListItemsEvent_ModuleBloodOxygenImage) { // 血氧
                [self selectPointNewEvents:NewEvents forItemEvents:item.itemEvent forView:self.bloodOxygen];

                self.bloodOxygen.hidden = NO;
                self.bloodOxygen.textImageView.imageView.image = item.image;
            }
            else if (item.itemEvent == FBCustomDialListItemsEvent_ModuleBloodPressureImage) { // 血压
                [self selectPointNewEvents:NewEvents forItemEvents:item.itemEvent forView:self.bloodPressure];
                
                self.bloodPressure.hidden = NO;
                self.bloodPressure.textImageView.imageView.image = item.image;
            }
            else if (item.itemEvent == FBCustomDialListItemsEvent_ModuleStressImage) { // 压力
                [self selectPointNewEvents:NewEvents forItemEvents:item.itemEvent forView:self.stress];
                
                self.stress.hidden = NO;
                self.stress.textImageView.imageView.image = item.image;
            }
        }
    }
    
    [self clearPointForNewEvents:NewEvents withSoures:selectSoures];
}

// 新增加的组件初始化于排列好的坐标位置
- (void)selectPointNewEvents:(FBCustomDialListItemsEvent)newEvents forItemEvents:(FBCustomDialListItemsEvent)itemEvent forView:(WMDragView *)dragView {
    
    if (newEvents == itemEvent) {
        for (FBCustomDialPointModel *pointModel in self.modulePoint) {
            if (pointModel.itemEvent == FBCustomDialListItemsEvent_None) { // 可复用
                
                BOOL allowSettings = NO;
                
                if ((itemEvent == FBCustomDialListItemsEvent_StateBluetoothImage_BLE ||
                     itemEvent == FBCustomDialListItemsEvent_StateBluetoothImage_BT) && !pointModel.isModule) {
                    
                    allowSettings = YES;
                    
                } else if (itemEvent >= FBCustomDialListItemsEvent_ModuleStepImage &&
                           itemEvent <= FBCustomDialListItemsEvent_ModuleStressImage && pointModel.isModule) {
                    
                    allowSettings = YES;
                }
                if (allowSettings) {
                    pointModel.itemEvent = itemEvent;
                    dragView.origin_sd = CGPointMake(pointModel.point.x, pointModel.point.y);
                    break;
                }
            }
        }
    }
}

// 清除坐标的信息，便于下次复用
- (void)clearPointForNewEvents:(FBCustomDialListItemsEvent)newEvents withSoures:(NSArray <FBCustomDialSoures *> *)selectSoures {
    
    if (newEvents == FBCustomDialListItemsEvent_None) {
        
        for (FBCustomDialPointModel *pointModel in self.modulePoint) {
            BOOL isContain = NO;
            
            for (FBCustomDialSoures *dialSoures in selectSoures) {
                if (pointModel.itemEvent == dialSoures.itemEvent) {
                    
                    isContain = YES;
                    break;
                }
            }
            if (isContain == NO) {
                pointModel.itemEvent = FBCustomDialListItemsEvent_None;
            }
        }
    }
}


/// 刷新空间占用数量
- (void)reloadWithDynamicSelection:(FBCustomDialDynamicSelection)dynamicSelection soures:(FBCustomDialSoures *)soures {
    
#ifdef FBINTERNAL
    
    if (dynamicSelection == FBCustomDialDynamicSelection_Reset) {
        self.controlsNumber.text = [NSString stringWithFormat:@"%@: 16/6", LWLocalizbleString(@"Space Occupied")];

        return;
    }
    
    FBCustomDialItem *item = [self returnCustomDialItem:soures];
    
    NSMutableArray <FBCustomDialItem *> *selectItem = NSMutableArray.array;
    for (FBCustomDialSoures *soures in self.selectSoures) {
        FBCustomDialItem *item = [self returnCustomDialItem:soures];
        if (item.type != FB_CustomDialItems_None) {
            [selectItem addObject:item];
        }
    }
    
    int all = [FBCustomDataTools numberOfControlsInAllItems:selectItem.copy];
    int count = [FBCustomDataTools numberOfControlsInSingleItem:item];
    
    
    if (dynamicSelection == FBCustomDialDynamicSelection_None || // None
        dynamicSelection == FBCustomDialDynamicSelection_CutFailure || // 减 失败
        count == 0) { // 个数0
        
        return; // 不提示
    }
    
    else if (dynamicSelection == FBCustomDialDynamicSelection_CutSuccess) { // 减 成功
        all -= count;
    }
    
    else if (dynamicSelection == FBCustomDialDynamicSelection_AddSuccess || // 加 成功
             dynamicSelection == FBCustomDialDynamicSelection_AddFailure) { // 加 失败
        // 查询该类型是否已有被选择
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(FBCustomDialSoures * _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            return (evaluatedObject.itemEvent == soures.itemEvent);
        }];
        FBCustomDialSoures *originalSoures = [self.selectSoures filteredArrayUsingPredicate:predicate].firstObject;
        
        if (originalSoures) { // 已被选择
            
            FBCustomDialItem *originalItem = [self returnCustomDialItem:originalSoures];
            int originalCount = [FBCustomDataTools numberOfControlsInSingleItem:originalItem];
            
            // 计算 差
            if (originalCount == count) { // 且占用控件数一致
                
                return; // 不提示
            }
            else {
                if (count > originalCount) { // 大于，显示 +
                    if (dynamicSelection == FBCustomDialDynamicSelection_AddSuccess) { // 加 成功
                        count -= originalCount;
                        all += count;
                    } else { // 加 失败
                        count -= originalCount;
                        // all
                    }
                } else { // 小于，重置，显示 -
                    count = originalCount - count;
                    all -= count;
                    dynamicSelection = FBCustomDialDynamicSelection_CutSuccess;
                }
            }
        }
        else { // 第一次
            if (dynamicSelection == FBCustomDialDynamicSelection_AddSuccess) { // 加 成功
                all += count;
            } else { // 加 失败
                // all
            }
        }
    }
    
    
    if (dynamicSelection == FBCustomDialDynamicSelection_AddSuccess) {
        self.number.textColor = UIColor.greenColor;
        self.number.text = [NSString stringWithFormat:@"+%d", count];
    }
    else if (dynamicSelection == FBCustomDialDynamicSelection_AddFailure) {
        self.number.textColor = UIColor.redColor;
        self.number.text = [NSString stringWithFormat:@"+%d", count];
    }
    else if (dynamicSelection == FBCustomDialDynamicSelection_CutSuccess) {
        self.number.textColor = UIColor.greenColor;
        self.number.text = [NSString stringWithFormat:@"-%d", count];
    }
    
    self.controlsNumber.text = [NSString stringWithFormat:@"%@: 16/%d", LWLocalizbleString(@"Space Occupied"), all];
    self.number.alpha = 1.0; // 显示
    [self.controlsNumber updateLayout];
    self.number.centerY = self.controlsNumber.centerY - 8; // 重置Y
    
    // 计时器
    WeakSelf(self);
    [dispatch_source_timer.sharedInstance initializeTiming:0 andStartBlock:^(NSInteger timeIndex) {
        GCD_MAIN_QUEUE(^{
            if (timeIndex >= 3) {
                [dispatch_source_timer.sharedInstance PauseTiming]; // 停止计时
                [UIView animateWithDuration:0.3 animations:^{ // 上升Y 动画
                    weakSelf.number.centerY = weakSelf.controlsNumber.centerY - 18;
                    weakSelf.number.alpha = 0.3;
                } completion:^(BOOL finished) {
                    weakSelf.number.alpha = 0.0; // 隐藏
                }];
            }
        });
    }];
    [dispatch_source_timer.sharedInstance StartTiming]; // 开始计时
    
#endif
    
}


/// 生成自定义表盘数据
- (FBMultipleCustomDialsModel *)generateCustomWatchFaceData {
        
    [self StartScreenshot:NO];
    
    UIImage *dialBackgroundImage = [UIImage qmui_imageWithView:self.dialBackgroundView afterScreenUpdates:YES]; // 截图 - 背景
    
    [self StartScreenshot:YES];
    
    UIImage *dialPreviewImage = [UIImage qmui_imageWithView:self.dialPreviewView afterScreenUpdates:YES]; // 截图 - 预览
    
    FBMultipleCustomDialsModel *model = FBMultipleCustomDialsModel.new;
    model.packet_bin = FBCustomDialObject.sharedInstance.packet_bin;
    model.info_png = FBCustomDialObject.sharedInstance.info_png;
    model.dialBackgroundImage = dialBackgroundImage;
    model.dialPreviewImage = dialPreviewImage;
    
    NSMutableArray <FBCustomDialItem *> *selectItem = NSMutableArray.array;
    
    for (FBCustomDialSoures *soures in self.selectSoures) {
        
        FBCustomDialItem *item = [self returnCustomDialItem:soures];
        
        if (item.type != FB_CustomDialItems_None) {
            [selectItem addObject:item];
        }
    }
    model.items = selectItem;
    
    return model;
}

- (FBCustomDialItem *)returnCustomDialItem:(FBCustomDialSoures *)soures {
    
    FBCustomDialItem *item = FBCustomDialItem.new;
    item.index = soures.index;
    
    FB_CUSTOMDIALITEMS type = FB_CustomDialItems_None;
    CGPoint center = CGPointZero;
    
    if (soures.itemEvent == FBCustomDialListItemsEvent_NumberImage) {
        type = FB_CustomDialItems_Time_Style;
        item.fontColor = self.selectColor;
        center = self.digitalTime.center;
    }
    else if (soures.itemEvent == FBCustomDialListItemsEvent_PointerImage) {
        type = FB_CustomDialItems_Pointer;
        center = self.pointerImage.center;
    }
    else if (soures.itemEvent == FBCustomDialListItemsEvent_StateBatteryImage) {
        type = FB_CustomDialItems_Battery;
        center = self.battery.center;
    }
    else if (soures.itemEvent == FBCustomDialListItemsEvent_StateBluetoothImage_BLE) {
        type = FB_CustomDialItems_BLE;
        item.fontColor = nil; // 不设置颜色，SDK内部取json配置
        center = self.BLE.center;
    }
    else if (soures.itemEvent == FBCustomDialListItemsEvent_StateBluetoothImage_BT) {
        type = FB_CustomDialItems_BT;
        item.fontColor = nil; // 不设置颜色，SDK内部取json配置
        center = self.BT.center;
    }
    else if (soures.itemEvent == FBCustomDialListItemsEvent_ModuleStepImage) {
        type = FB_CustomDialItems_Step;
        center = self.step.center;
    }
    else if (soures.itemEvent == FBCustomDialListItemsEvent_ModuleCalorieImage) {
        type = FB_CustomDialItems_Calorie;
        center = self.calorie.center;
    }
    else if (soures.itemEvent == FBCustomDialListItemsEvent_ModuleDistanceImage) {
        type = FB_CustomDialItems_Distance;
        center = self.distance.center;
    }
    else if (soures.itemEvent == FBCustomDialListItemsEvent_ModuleHeartRateImage) {
        type = FB_CustomDialItems_HeartRate;
        center = self.heartRate.center;
    }
    else if (soures.itemEvent == FBCustomDialListItemsEvent_ModuleBloodOxygenImage) {
        type = FB_CustomDialItems_BloodOxygen;
        center = self.bloodOxygen.center;
    }
    else if (soures.itemEvent == FBCustomDialListItemsEvent_ModuleBloodPressureImage) {
        type = FB_CustomDialItems_BloodPressure;
        center = self.bloodPressure.center;
    }
    else if (soures.itemEvent == FBCustomDialListItemsEvent_ModuleStressImage) {
        type = FB_CustomDialItems_Stress;
        center = self.stress.center;
    }
    
    item.type = type;
    item.center = center;
    
    return item;
}

- (void)StartScreenshot:(BOOL)showAll {
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(FBCustomDialSoures * _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return (evaluatedObject.itemEvent == FBCustomDialListItemsEvent_StateBatteryImage);
    }];
    // 是否有选择了电量
    FBCustomDialSoures *soures = [self.selectSoures filteredArrayUsingPredicate:predicate].firstObject;
    
    if (soures) {
        if (soures.index==0 || soures.index==1) {
            self.battery.textImageView.hidden = !showAll;
        } else {
            self.battery.textImageView.titleLable.hidden = !showAll;
        }
    }
    self.step.textImageView.titleLable.hidden = !showAll;
    self.calorie.textImageView.titleLable.hidden = !showAll;
    self.distance.textImageView.titleLable.hidden = !showAll;
    self.heartRate.textImageView.titleLable.hidden = !showAll;
    self.bloodOxygen.textImageView.titleLable.hidden = !showAll;
    self.bloodPressure.textImageView.titleLable.hidden = !showAll;
    self.stress.textImageView.titleLable.hidden = !showAll;
}

@end


@implementation FBCustomDialPointModel
@end
