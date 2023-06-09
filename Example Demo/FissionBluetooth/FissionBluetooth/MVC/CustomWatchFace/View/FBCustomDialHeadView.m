//
//  FBCustomDialHeadView.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-05-30.
//

#import "FBCustomDialHeadView.h"
#import "WMDragView.h"

@interface FBCustomDialHeadView ()

// 表盘预览图，包含所有组件：表盘背景、刻度背景、小组件等...
@property (nonatomic, strong) UIView *dialPreviewView;

// 表盘背景图：表盘背景组件、刻度背景组件
@property (nonatomic, strong) UIView *dialBackgroundView;
@property (nonatomic, strong) UIImageView *dialImage;       // 表盘背景图
@property (nonatomic, strong) UIImageView *scaleImage;      // 表盘刻度图

// 表盘小组件集
@property (nonatomic, strong) UIView *dialModuleView;
@property (nonatomic, strong) WMDragView *step;             // 步数
@property (nonatomic, strong) WMDragView *calorie;          // 卡路里
@property (nonatomic, strong) WMDragView *distance;         // 距离
@property (nonatomic, strong) WMDragView *heartRate;        // 心率
@property (nonatomic, strong) WMDragView *bloodOxygen;      // 血氧
@property (nonatomic, strong) WMDragView *bloodPressure;    // 血压
@property (nonatomic, strong) WMDragView *stress;           // 压力
@property (nonatomic, strong) WMDragView *digitalTime;      // 数字时间
@property (nonatomic, strong) UIImageView *pointerImage;    // 时间指针

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
    CGFloat scale = (CGFloat)object.watchDisplayHigh/(CGFloat)object.watchDisplayWide;
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
    
    
#pragma mark - 3⃣️表盘组件集（内含 指针、时间、各种小组件等等...）
    UIView *dialModuleView = UIView.new;
    dialModuleView.backgroundColor = UIColorClear;
    if (isCircle) {
        dialModuleView.circle = YES;
    }
    [dialPreviewView addSubview:dialModuleView];
    dialModuleView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    self.dialModuleView = dialModuleView;
    [self createDialModuleView:dialModuleView isCircle:isCircle rectRadius:rectRadius]; // 创建组件集
    
    
    // 表框 与背景同色，遮住漏出来的背景
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
    

    // 描述
    UILabel *label = [[UILabel alloc] qmui_initWithFont:FONT(14) textColor:UIColorGray];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = LWLocalizbleString(@"长按模块可移动");
    [self addSubview:label];
    label.sd_layout.leftSpaceToView(self, 10).rightSpaceToView(self, 10).topSpaceToView(backgroundView, 10).heightIs(19);
    [label updateLayout];
    
    
    // 更新高度
    self.height = CGRectGetMaxY(label.frame)+20;
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
    scaleImage.backgroundColor = UIColorClear;
    scaleImage.contentMode = UIViewContentModeScaleToFill;
    [dialBackgroundView addSubview:scaleImage];
    scaleImage.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    self.scaleImage = scaleImage;
}


#pragma mark - 创建组件集
- (void)createDialModuleView:(UIView *)dialModuleView isCircle:(BOOL)isCircle rectRadius:(CGFloat)rectRadius {
    
    // 步数
    UIImage *step = [UIImageMake(@"icon_dial_step") qmui_imageResizedInLimitedSize:CGSizeMake(24, 24)];
    self.step = [self moduleImage:step text:@"248723" size:CGSizeMake(60, 45) addView:dialModuleView isCircle:isCircle rectRadius:rectRadius];
    self.step.clickDragViewBlock = ^(WMDragView *dragView) {
        FBLog(@"点击了【步数】");
    };
    
    // 卡路里
    UIImage *calorie = [UIImageMake(@"icon_dial_calorie") qmui_imageResizedInLimitedSize:CGSizeMake(24, 24)];
    self.calorie = [self moduleImage:calorie text:@"9930" size:CGSizeMake(60, 45) addView:dialModuleView isCircle:isCircle rectRadius:rectRadius];
    self.calorie.clickDragViewBlock = ^(WMDragView *dragView) {
        FBLog(@"点击了【卡路里】");
    };
    
    // 距离
    UIImage *distance = [UIImageMake(@"icon_dial_distance") qmui_imageResizedInLimitedSize:CGSizeMake(24, 24)];
    self.distance = [self moduleImage:distance text:@"90.88km" size:CGSizeMake(60, 45) addView:dialModuleView isCircle:isCircle rectRadius:rectRadius];
    self.distance.clickDragViewBlock = ^(WMDragView *dragView) {
        FBLog(@"点击了【距离】");
    };
    
    // 心率
    UIImage *heartRate = [UIImageMake(@"icon_dial_hr") qmui_imageResizedInLimitedSize:CGSizeMake(24, 24)];
    self.heartRate = [self moduleImage:heartRate text:@"78" size:CGSizeMake(60, 45) addView:dialModuleView isCircle:isCircle rectRadius:rectRadius];
    self.heartRate.clickDragViewBlock = ^(WMDragView *dragView) {
        FBLog(@"点击了【心率】");
    };
    
    // 血氧
    UIImage *bloodOxygen = [UIImageMake(@"icon_dial_spo2") qmui_imageResizedInLimitedSize:CGSizeMake(24, 24)];
    self.bloodOxygen = [self moduleImage:bloodOxygen text:@"99%" size:CGSizeMake(60, 45) addView:dialModuleView isCircle:isCircle rectRadius:rectRadius];
    self.bloodOxygen.clickDragViewBlock = ^(WMDragView *dragView) {
        FBLog(@"点击了【血氧】");
    };
    
    // 血压
    UIImage *bloodPressure = [UIImageMake(@"icon_dial_bp") qmui_imageResizedInLimitedSize:CGSizeMake(24, 24)];
    self.bloodPressure = [self moduleImage:bloodPressure text:@"122/82" size:CGSizeMake(60, 45) addView:dialModuleView isCircle:isCircle rectRadius:rectRadius];
    self.bloodPressure.clickDragViewBlock = ^(WMDragView *dragView) {
        FBLog(@"点击了【血压】");
    };
    
    // 压力
    UIImage *stress = [UIImageMake(@"icon_dial_stress") qmui_imageResizedInLimitedSize:CGSizeMake(24, 24)];
    self.stress = [self moduleImage:stress text:@"24" size:CGSizeMake(60, 45) addView:dialModuleView isCircle:isCircle rectRadius:rectRadius];
    self.stress.clickDragViewBlock = ^(WMDragView *dragView) {
        FBLog(@"点击了【压力】");
    };
    
    // 数字时间
    self.digitalTime = [self moduleImage:UIImageMake(@"icon_dial_digitalTime") text:nil size:CGSizeMake(116, 64) addView:dialModuleView isCircle:isCircle rectRadius:rectRadius];
    self.digitalTime.clickDragViewBlock = ^(WMDragView *dragView) {
        FBLog(@"点击了【数字时间】");
    };

    // 时间指针
    UIImageView *pointerImage = UIImageView.new;
    pointerImage.backgroundColor = UIColorClear;
    pointerImage.contentMode = UIViewContentModeScaleToFill;
    [dialModuleView addSubview:pointerImage];
    pointerImage.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    self.pointerImage = pointerImage;
}

- (WMDragView *)moduleImage:(UIImage * _Nonnull)image text:(NSString * _Nullable)text size:(CGSize)size addView:(UIView * _Nonnull)dialModuleView isCircle:(BOOL)isCircle rectRadius:(CGFloat)rectRadius {
    WMDragView *dragView = [[WMDragView alloc] initWithFrame:(CGRect){CGPointZero, size}];
    dragView.backgroundColor = UIColorClear;
    dragView.imageView.backgroundColor = UIColorClear;
    dragView.button.backgroundColor = UIColorClear;
    dragView.circleRect = isCircle;
    dragView.rectRadius = isCircle ? 0 : (rectRadius/4.0);
    
    if (StringIsEmpty(text)) {
        dragView.button.hidden = YES;
        dragView.imageView.hidden = NO;
        dragView.imageView.image = image;
    } else {
        dragView.button.hidden = NO;
        dragView.imageView.hidden = YES;
        dragView.button.spacingBetweenImageAndTitle = 2;
        [dragView.button setImage:image forState:UIControlStateNormal];
        [dragView.button setTitle:text forState:UIControlStateNormal];
        [dragView.button setTitleColor:UIColorWhite forState:UIControlStateNormal];
        dragView.button.titleLabel.font = FONT(14);
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

- (void)reloadWithModel:(FBCustomDialSelectModel *)model {
    
    BOOL isNumber = model.selectDialType==FBCustomDialType_Number;
    
    self.digitalTime.imageView.hidden = !isNumber;
    self.scaleImage.hidden = isNumber;
    self.pointerImage.hidden = isNumber;
    
    self.dialImage.image = model.selectBackgroundImage;                     // 背景
    self.digitalTime.imageView.image = model.selectTimeImage;               // 数字时间
    self.scaleImage.image = model.selectScaleImage;                         // 刻度
    self.pointerImage.image = model.selectPointerImage;                     // 指针 
}

@end
