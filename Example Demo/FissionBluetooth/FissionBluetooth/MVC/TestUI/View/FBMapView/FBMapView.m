//
//  FBMapView.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2024-01-24.
//

#import "FBMapView.h"
#import "FBLocationConverter.h"
#import "MASmoothPathTool.h"

typedef void(^FBPlayProgressBlock)(FBCountingModel *countingModel, BOOL first);
typedef void(^FBPlayCompleteBlock)(void);

@interface FBMapView ()

/// 大头针数据
@property (nonatomic, strong) NSMutableArray <FBPointAnnotation *> *annotations;

/// 缓存轨迹数据
@property (nonatomic, strong) NSArray <NSArray <FBLocation *> *> *allLocationArray;
@property (nonatomic, strong) NSMutableArray <FBCountingModel *> *countingArray;

/// 缓存显示区域边距
@property (nonatomic, assign) UIEdgeInsets insets;

/// 缓存显示路径数据
@property (nonatomic, strong) NSArray <FBPolyline *> *polylineArray;

/// 缓存显示区域的跨度
@property (nonatomic, assign) MKCoordinateSpan span;

@property (nonatomic, assign) CGFloat currentSpan; // 切换释放内存用 - - - 当前的跨度
@property (nonatomic, strong) MKPolygon *backMaskPolygon; // 切换释放内存用 - - - 背面遮罩

/// 计时器
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) FBLocation *lastLocation; // 记录上一个点，已当前点划线用
@property (nonatomic, strong) NSIndexPath *indexPath; // 记录当前正在执行的索引

// 播放进行中回调
@property (nonatomic, copy) FBPlayProgressBlock progressBlock;
// 播放完成回调
@property (nonatomic, copy) FBPlayCompleteBlock completeBlock;
// 引导点
@property (nonatomic, strong) FBPointAnnotation *guidePointAnnotation;

@property (nonatomic, strong) dispatch_queue_t serialQuene; // 串行 + 异步

@end

#define startingIcon        UIImageMake(@"icon_starting")
#define startingCenter      CGPointMake(11, -20)
#define endingIcon          UIImageMake(@"icon_ending")
#define endingCenter        CGPointMake(7, -16)
#define guideIcon           UIImageMake(@"icon_guide_point")
#define centerPoint         CGPointMake(0, 0)


@implementation FBMapView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        // 单例初始化公/英里 里程点
        [FBPassingPointModel sharedInstance];
        
        self.annotations = NSMutableArray.array;
        self.countingArray = NSMutableArray.array;
        
        self.mapType = MKMapTypeStandard;
        
        // 初始化地图
        MKMapView *mapView = MKMapView.new;
        mapView.backgroundColor = UIColor.clearColor;
        mapView.mapType = self.mapType;
        mapView.showsScale = YES;
        mapView.showsCompass = YES;
        mapView.zoomEnabled = YES;
        mapView.scrollEnabled = YES;
        mapView.rotateEnabled = YES;
        mapView.pitchEnabled = YES;
        mapView.delegate = self;
        [self addSubview:mapView];
        [mapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        self.mapView = mapView;

        // 1.创建一个串行队列
        _serialQuene = dispatch_queue_create("com.mapView.playing.quene", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)setMapType:(MKMapType)mapType {
    _mapType = mapType;
    
    self.mapView.mapType = mapType;
}

#pragma mark - 地图 委托代理 MKMapViewDelegate
/**  大头针 */
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if (![annotation isKindOfClass:[FBPointAnnotation class]]) return nil;
    
    FBPointAnnotation *pointAnnotation = (FBPointAnnotation *)annotation;
    
    static NSString *reuseIndetifier = @"annotationReuseIndetifier";
    MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
    if (!annotationView)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
    }
    // 设置途径点为选择状态（选中的图标->置顶UI层级，不被其他图层覆盖）
    annotationView.selected = (pointAnnotation.pointType == FBAnnotationPointType_PassingPoint || pointAnnotation.pointType == FBAnnotationPointType_GuidePoint);
    // 大头针图标
    annotationView.image = pointAnnotation.pointImage;
    // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
    annotationView.centerOffset = pointAnnotation.centerOffset;
    
    return annotationView;
}

/**  大头针下坠动画 */
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views {
        
    for (MKAnnotationView *annoView in views) {
        // 系统定位的大头针不设置动画效果
        if (![annoView.annotation isKindOfClass:[MKUserLocation class]]) {
            // 记录要放置的大头针坐标的位置
            CGRect startFrame = annoView.frame;
            // 位置的 Y 改为0，用来掉落
            annoView.frame = CGRectMake(startFrame.origin.x, 0, startFrame.size.width, startFrame.size.height);
            // 执行动画掉落
            [UIView animateWithDuration:0.3 animations:^{
                annoView.frame = startFrame;
            }];
        }
    }
}

/**  轨迹路径 */
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    if (![overlay isKindOfClass:[FBPolyline class]]) return nil;
    
    FBPolyline *polyline = (FBPolyline *)overlay;
    MKPolylineRenderer *polylineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:polyline];
    
    polylineRenderer.lineWidth   = 4;
    polylineRenderer.strokeColor = UIColor.blueColor;
    polylineRenderer.lineJoin    = kCGLineJoinRound;
    polylineRenderer.lineCap     = kCGLineCapRound;
    if (polyline.dashed) { // 使用虚线
        polylineRenderer.lineWidth       = 3;
        polylineRenderer.strokeColor     = UIColor.redColor;
        polylineRenderer.lineDashPattern = @[@(0), @(6)];
    }
    
    return polylineRenderer;
}

// 地图区域改变时调用
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    if (self.isPlaying) return; // 播放中不刷新
        
    // 苹果原生地图内存会持续增加，这里做下刷新处理来稍微降下内存...
    [self setBackMask];
    if (fabs(self.currentSpan - mapView.region.span.latitudeDelta) > 0.04) {
        [self applyMapViewMemoryRelease];
        self.currentSpan = mapView.region.span.latitudeDelta;
    }
}

/** 显示区域改变的时候 刷新背景蒙版 */
- (void)setBackMask{
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CLLocationCoordinate2D leftTop =[self.mapView convertPoint:CGPointMake(0, 0) toCoordinateFromView:self];
    CLLocationCoordinate2D rightTop =[self.mapView convertPoint:CGPointMake(width, 0) toCoordinateFromView:self];
    CLLocationCoordinate2D leftBottom =[self.mapView convertPoint:CGPointMake(0, height) toCoordinateFromView:self];
    CLLocationCoordinate2D rightBottom =[self.mapView convertPoint:CGPointMake(width, height) toCoordinateFromView:self];
    CLLocationCoordinate2D  pointCoords[4];
    CGFloat interval = self.mapView.region.span.latitudeDelta;
    CGFloat offset = interval > 5 ? 0 : 10;
    
    pointCoords[0] = CLLocationCoordinate2DMake(leftTop.latitude+offset, leftTop.longitude-offset);
    pointCoords[1] = CLLocationCoordinate2DMake(rightTop.latitude-offset, rightTop.longitude-offset);
    
    pointCoords[3] = CLLocationCoordinate2DMake(leftBottom.latitude+offset, leftBottom.longitude+offset);
    pointCoords[2] = CLLocationCoordinate2DMake(rightBottom.latitude-offset, rightBottom.longitude+offset);
    
    if (self.backMaskPolygon) {
        [self.mapView removeOverlay:self.backMaskPolygon];
    }
    
    MKPolygon* polygon = [MKPolygon polygonWithCoordinates:pointCoords count:4];
    self.backMaskPolygon = polygon;
    [self.mapView insertOverlay:self.backMaskPolygon atIndex:0 level:MKOverlayLevelAboveRoads];
}

/**  快速 切换一遍 地图的类型， 以便释放掉内存 */
- (void)applyMapViewMemoryRelease {
    
    switch (self.mapType) {
        case MKMapTypeSatellite:{
            self.mapView.mapType = MKMapTypeStandard;
            break;
        }
        default:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
    }
    self.mapView.mapType = self.mapType;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark - 绘制地图轨迹，显示区域边距
- (void)addMapTrack:(RLMArray<RLMSportsLocationModel> *)locations edgePadding:(UIEdgeInsets)insets {
    
    [self.annotations removeAllObjects];
    
    // 加载、轨迹平滑优化
    NSArray <NSArray <FBLocation *> *> *allLocationArray = [self trajectorySmoothingOptimization:locations];
    self.allLocationArray = allLocationArray;
    
    // 添加 标记点 定位大头针
    [self addMarkPointPins:allLocationArray];
    
    // 添加 绘制 地图轨迹
    NSArray <FBPolyline *> *polylineArray = [self addDrawingMapTrack:allLocationArray];
    
    // 地图显示区域
    [self mapTrackShowRegionWithEdgePadding:insets polylineArray:polylineArray];
}

#pragma mark - 加载、轨迹平滑优化
- (NSArray <NSArray <FBLocation *> *> *)trajectorySmoothingOptimization:(RLMArray <RLMSportsLocationModel> *)locations {
    
    NSArray <UIImage *> *pointIcons = FBPassingPointModel.sharedInstance.imageIcon;
    
    // 轨迹拆分：如果轨迹集合存在暂停的数据，则将其拆分成 @[ @[正常], @[暂停], @[正常]...]，用于后续画轨迹区分 虚实线。
    NSMutableArray <NSArray <FBLocation *> *> *allLocationArray = NSMutableArray.array;
    
    BOOL gpsPause = YES; // 记录状态是否变化
    NSMutableArray <MALonLatPoint *> *paragraphArray;
    NSInteger mileagePoint = 0;
    
    for (NSInteger index = 0; index < locations.count; index++) {

        RLMSportsLocationModel *model = locations[index];
        
        if (gpsPause != model.gpsPause) { // 状态发生变化，先存储已添加的，再准备添加新的
            NSArray <FBLocation *> *locationArray = [self addOptimizeResultConversion:paragraphArray.copy];
            if (locationArray.count) {
                [allLocationArray addObject:locationArray];
            }
            paragraphArray = NSMutableArray.array;
            gpsPause = model.gpsPause;
        }
        
        MALonLatPoint *LonLatPoint = MALonLatPoint.new;
        LonLatPoint.begin = model.begin;
        LonLatPoint.lon = model.longitude;
        LonLatPoint.lat = model.latitude;
        LonLatPoint.speed = model.speed;
        LonLatPoint.pause = model.gpsPause; /// 是否暂停
        if ((Tools.isMetric && model.gpsKilometerPoints) || (!Tools.isMetric && model.gpsMilePoints)) { /// 里程点
            LonLatPoint.icon = pointIcons[mileagePoint<pointIcons.count ? mileagePoint : pointIcons.count-1];
            mileagePoint ++;
        }
        [paragraphArray addObject:LonLatPoint];
        
        if (index == (locations.count - 1)) { // 最后一组，直接添加
            NSArray <FBLocation *> *locationArray = [self addOptimizeResultConversion:paragraphArray.copy];
            if (locationArray.count) {
                [allLocationArray addObject:locationArray];
            }
        }
    }
    
    return allLocationArray.copy;
}
/// 轨迹平滑优化
- (NSArray <FBLocation *> *)addOptimizeResultConversion:(NSArray <MALonLatPoint *> *)paragraphArray {
    
    if (!paragraphArray.count) return nil;
    
    MASmoothPathTool *tool = [[MASmoothPathTool alloc] init];
    tool.intensity = 4;
    tool.threshHold = 0.4;
    tool.noiseThreshhold = 11;
    
    // 是否开启优化
    NSArray <MALonLatPoint *> *OptimizationResults = self.optimization ? [tool pathOptimize:paragraphArray] : paragraphArray;
    
    NSMutableArray <FBLocation *> *locationArray = NSMutableArray.array;
    
    
    if (OptimizationResults.count) {
        
        // 遍历优化后的数据转换为FBLocation
        for (MALonLatPoint *LonLatPoint in OptimizationResults) {
            
            FBLocation *location = [self handleMALonLatPoint:LonLatPoint];
            
            [locationArray addObject:location];
        }
        
        return locationArray.copy;
    }
    else { // 确保有定位数据，如果被简化成0个，则添加第一个
        // 将被算法过滤，但是该组有标记点，需要保留
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(MALonLatPoint * _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            return (evaluatedObject.icon != nil);
        }];
        NSArray <MALonLatPoint *> *list = [paragraphArray filteredArrayUsingPredicate:predicate];
        
        if (list.count) {
            for (MALonLatPoint *LonLatPoint in list) {
                FBLocation *location = [self handleMALonLatPoint:LonLatPoint];
                [locationArray addObject:location];
            }
            return locationArray.copy;
        }
        else {
            // 被优化为0个，默认保留第一个
            FBLocation *location = [self handleMALonLatPoint:paragraphArray.firstObject];
            [locationArray addObject:location];
            
            return locationArray.copy;
        }
    }
}
- (FBLocation *)handleMALonLatPoint:(MALonLatPoint *)LonLatPoint {
    
    CLLocationCoordinate2D coordinate;
    // 处于中国地区，则需要转换
    if (self.chinaRegion) {
        coordinate = [FBLocationConverter wgs_84ToGcj_02:CLLocationCoordinate2DMake(LonLatPoint.lat, LonLatPoint.lon)];
    } else {
        coordinate = CLLocationCoordinate2DMake(LonLatPoint.lat, LonLatPoint.lon);
    }
    
    FBLocation *location = [[FBLocation alloc] initWithCoordinate:coordinate altitude:0 horizontalAccuracy:0 verticalAccuracy:0 course:0 speed:LonLatPoint.speed timestamp:[NSDate dateWithTimeIntervalSince1970:LonLatPoint.begin]];
    location.pause = LonLatPoint.pause;
    location.icon = LonLatPoint.icon;
    
    if (LonLatPoint.icon) { // 存在里程点
        FBPointAnnotation *annotation = [self annotationType:FBAnnotationPointType_PassingPoint pointImage:LonLatPoint.icon centerOffset:centerPoint coordinate:coordinate];
        
        [self.annotations addObject:annotation];
    }
    
    return location;
}

- (FBPointAnnotation *)annotationType:(FBAnnotationPointType)pointType pointImage:(UIImage *)pointImage centerOffset:(CGPoint)centerOffset coordinate:(CLLocationCoordinate2D)coordinate {
    
    FBPointAnnotation *annotation = FBPointAnnotation.new;
    annotation.pointType = pointType;
    annotation.pointImage = pointImage;
    annotation.centerOffset = centerOffset;
    annotation.coordinate = coordinate;
    
    return annotation;
}

#pragma mark - 添加 标记点 定位大头针
- (void)addMarkPointPins:(NSArray <NSArray <FBLocation *> *> *)allLocationArray {
    
    // 起点
    FBLocation *startingLocation = allLocationArray.firstObject.firstObject;
        
    FBPointAnnotation *starting = [self annotationType:FBAnnotationPointType_Starting pointImage:startingIcon centerOffset:startingCenter coordinate:startingLocation.coordinate];
    [self.annotations addObject:starting];
    
    // 终点
    FBLocation *endingLocation = allLocationArray.lastObject.lastObject;
    
    FBPointAnnotation *ending = [self annotationType:FBAnnotationPointType_Ending pointImage:endingIcon centerOffset:endingCenter coordinate:endingLocation.coordinate];
    [self.annotations addObject:ending];
    
    
    // 替换前先移除所有
    if (self.mapView.annotations.count) {
        [self.mapView removeAnnotations:self.mapView.annotations];
    }
    
    // 替换方案: 添加
    [self.mapView addAnnotations:self.annotations];
}


#pragma mark - 添加 绘制 地图轨迹
- (NSArray <FBPolyline *> *)addDrawingMapTrack:(NSArray <NSArray <FBLocation *> *> *)allLocationArray {
        
    // 替换方案:
    NSMutableArray <FBPolyline *> *polylineArray = NSMutableArray.array;
    
    for (NSArray <FBLocation *> *locationArray in allLocationArray) { // 遍历所有的点
        
        // 遍历所有点
        CLLocationCoordinate2D  pointCoords[locationArray.count];
                    
        for (NSInteger i = 0; i < locationArray.count; i++) {
            pointCoords[i] = locationArray[i].coordinate;
        }
        
        FBPolyline *commonPolyline = [FBPolyline polylineWithCoordinates:pointCoords count:locationArray.count]; // 轨迹路径
        commonPolyline.dashed = locationArray.firstObject.pause; // 暂停区间的轨迹使用虚线绘制
        [polylineArray addObject:commonPolyline];
    }
        
    // 替换前先移除所有
    if (self.mapView.overlays.count>0) {
        for (id<MKOverlay> ovrelay in self.mapView.overlays) {
            if ([ovrelay isKindOfClass:[MKPolyline class]]) {
                [self.mapView removeOverlay:ovrelay];
            }
        }
    }
    // 替换方案: 添加
    if (polylineArray.count) {
        [self.mapView addOverlays:polylineArray.copy];
    }
    
    return polylineArray.copy;
}


#pragma mark - 地图显示区域
/**
 * @brief 地图显示区域
 */
- (void)mapTrackShowRegionWithEdgePadding:(UIEdgeInsets)insets polylineArray:(NSArray <FBPolyline *> *)polylineArray {
    
    self.insets = insets;
    self.polylineArray = polylineArray;
    
    MKMapRect rect = MKMapRectNull;
    for (FBPolyline *polyline in polylineArray) {
        rect = MKMapRectUnion(rect, polyline.boundingMapRect);
    }
    if (MKMapRectIsEmpty(rect)) {
        // 没有画线轨迹，这里会为空，为空要正确显示窗口请设置这里...
    } else {
        [self.mapView setVisibleMapRect:rect edgePadding:insets animated:YES];
    }
    
    
    
    // 计算个合适的窗口跨度大小（可以根据自身实际的业务去优化）
    CGFloat max = (rect.size.width > rect.size.height) ? rect.size.width : rect.size.height;
    CGFloat zoom = 0.0;
    if (max >= 5000) {
        zoom = 0.010;
    } else {
        zoom = 0.003;
    }
    MKCoordinateSpan span = MKCoordinateSpanMake(zoom, zoom);
    self.span = span;
}


#pragma mark - 开始播放轨迹回放
/// 开始播放轨迹回放
- (void)startPlayingWithDistance:(NSInteger)distance progress:(void (^)(FBCountingModel * _Nonnull, BOOL))progressBlock complete:(void (^)(void))completeBlock {
    
    self.progressBlock = progressBlock;
    self.completeBlock = completeBlock;
    
    if (self.timer) { // 如果存在，先销毁
        [self stopPlayingFromRecovery:NO];
    }
    
    // 移除所有大头针
    if (self.mapView.annotations.count) {
        [self.mapView removeAnnotations:self.mapView.annotations];
    }
    
    // 移除所有轨迹
    if (self.mapView.overlays.count) {
        [self.mapView removeOverlays:self.mapView.overlays];
    }
    
    self.isPlaying = YES;
    
    // 先转换镜头视角
    CLLocationCoordinate2D centerCoordinate = self.allLocationArray.firstObject.firstObject.coordinate;
    MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, self.span);
    [self.mapView setRegion:region animated:YES];
    
    // 添加引导点
    FBPointAnnotation *guidePointAnnotation = [self annotationType:FBAnnotationPointType_GuidePoint pointImage:guideIcon centerOffset:centerPoint coordinate:centerCoordinate];
    [self.mapView addAnnotation:guidePointAnnotation];
    self.guidePointAnnotation = guidePointAnnotation;
    
    [self.countingArray removeAllObjects];
    NSTimeInterval interval = 0.07;
    NSInteger totalCount = 0;
    NSInteger currentCount = 0;
    NSInteger index = 0;
    for (NSArray <FBLocation *> *array in self.allLocationArray) {
        
        totalCount += array.count;
        
        for (FBLocation *item in array) {
            
            currentCount ++;
            
            if (item.icon) {
                FBCountingModel *countingModel = FBCountingModel.new;
                countingModel.startValue = index;
                countingModel.endValue = (index+1);
                countingModel.interval = currentCount * interval;
                [self.countingArray addObject:countingModel];
                
                currentCount = 0;
                index ++;
            }
        }
    }
    if (currentCount != 0) {
        CGFloat dis = [Tools distance_metre_Convert_1:distance];
        NSString *distanceString = [Tools ConvertValues:dis scale:2 rounding:NO];
        
        FBCountingModel *countingModel = FBCountingModel.new;
        countingModel.startValue = index;
        countingModel.endValue = distanceString.doubleValue;
        countingModel.interval = currentCount * interval;
        [self.countingArray addObject:countingModel];
    }
    [self.countingArray enumerateObjectsUsingBlock:^(FBCountingModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.totalInterval = totalCount * interval; // 总时长
    }];
    
    WeakSelf(self);
    GCD_AFTER(1.0, ^{ // 稍微等待下上方的执行动画，再开启定时器
        
        // 创建计时器
        weakSelf.timer = [NSTimer timerWithTimeInterval:interval repeats:YES block:^(NSTimer * _Nonnull timer) {
            [weakSelf timerAction];
        }];
        [NSRunLoop.mainRunLoop addTimer:weakSelf.timer forMode:NSRunLoopCommonModes];

        [weakSelf progressCallback:YES]; // 更新距离动态进度
    });
}

// 更新距离动态进度
- (void)progressCallback:(BOOL)first {
    if (self.progressBlock && self.countingArray.count) {
        NSArray <FBCountingModel *> *array = [NSArray arrayWithArray:self.countingArray.copy];
        self.progressBlock(array.firstObject, first);
        [self.countingArray removeObjectAtIndex:0];
    }
}

#pragma mark - 停止播放轨迹回放
/// 停止播放轨迹回放
- (void)stopPlaying {
    [self stopPlayingFromRecovery:NO];
}

/// 停止播放轨迹回放，并恢复窗口显示（如果是pop回去那就没有恢复的必要了）
- (void)stopPlayingFromRecovery:(BOOL)recovery {
    // 销毁计时器
    [self.timer invalidate];
    self.timer = nil;
    self.indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    self.lastLocation = nil;
    [self.mapView removeAnnotation:self.guidePointAnnotation];
    
    if (recovery) {
        // 恢复显示窗口
        [self mapTrackShowRegionWithEdgePadding:self.insets polylineArray:self.polylineArray];
        
        WeakSelf(self);
        GCD_AFTER(2.0, ^{ // 稍微等待窗口恢复动画执行
            weakSelf.isPlaying = NO;
            if (weakSelf.completeBlock) {
                weakSelf.completeBlock();
            }
        });
    } else {
        self.isPlaying = NO;
    }
}
- (void)setIsPlaying:(BOOL)isPlaying {
    _isPlaying = isPlaying;
    
    // 动画期间禁止地图交互
    self.mapView.userInteractionEnabled = !isPlaying;
}

/// 计时器事件
- (void)timerAction {
    WeakSelf(self);
    dispatch_async(_serialQuene, ^{
        
        NSIndexPath *indexPath = weakSelf.indexPath;
        
        if (indexPath.section < weakSelf.allLocationArray.count) {
            NSArray <FBLocation *> *locationArray = weakSelf.allLocationArray[indexPath.section];
            if (indexPath.row < locationArray.count) {
                
                FBLocation *location = locationArray[indexPath.row];
                CLLocationCoordinate2D centerCoordinate = location.coordinate;
                            
                // 如果是第一个，添加起点大头针
                if (indexPath.row == 0 && indexPath.section == 0) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        FBPointAnnotation *starting = [weakSelf annotationType:FBAnnotationPointType_Starting pointImage:startingIcon centerOffset:startingCenter coordinate:centerCoordinate];
                        [weakSelf.mapView addAnnotation:starting];
                    });
                }
                // 如果是最后一个，添加终点大头针
                if (indexPath.row == locationArray.count-1 && indexPath.section == weakSelf.allLocationArray.count-1) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        FBPointAnnotation *ending = [weakSelf annotationType:FBAnnotationPointType_Ending pointImage:endingIcon centerOffset:endingCenter coordinate:centerCoordinate];
                        [weakSelf.mapView addAnnotation:ending];
                    });
                }
                // 如果icon不为nil，添加里程点大头针
                if (location.icon) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        FBPointAnnotation *annotation = [weakSelf annotationType:FBAnnotationPointType_PassingPoint pointImage:location.icon centerOffset:centerPoint coordinate:centerCoordinate];
                        [weakSelf.mapView addAnnotation:annotation];
                        
                        [weakSelf progressCallback:NO]; // 更新距离动态进度
                    });
                }
                
                if (weakSelf.lastLocation && locationArray.count >= 2) { // 有上一个点，且当前组至少有2个点才需要画线
                    int pointCount = 2;
                    CLLocationCoordinate2D  pointCoords[pointCount];
                    pointCoords[0] = weakSelf.lastLocation.coordinate;
                    pointCoords[1] = centerCoordinate;
                    
                    FBPolyline *commonPolyline = [FBPolyline polylineWithCoordinates:pointCoords count:pointCount]; // 轨迹路径
                    commonPolyline.dashed = location.pause; // 暂停区间的轨迹使用虚线绘制
                    [weakSelf.mapView addOverlay:commonPolyline];
                }
                
                // 视角跟随、更新引导点位置
                MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, weakSelf.span);
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [weakSelf.mapView setRegion:region animated:YES];
                    [weakSelf.guidePointAnnotation setCoordinate:centerCoordinate];
                });
                
                weakSelf.lastLocation = location;
                
                if (indexPath.row+1 < locationArray.count) {
                    indexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
                } else {
                    if (indexPath.section+1 < weakSelf.allLocationArray.count) {
                        indexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section+1];
                    } else {
                        // 结束，暂停计时器
                        indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [weakSelf stopPlayingFromRecovery:YES];
                        });
                    }
                }
                
                weakSelf.indexPath = indexPath;
            }
        }
    });
}

- (void)dealloc {
    FBLog(@"🌍FBMapView - - - dealloc");
}

@end


@implementation FBLocation
@end


@implementation FBPointAnnotation
@end


@interface FBPassingPointModel ()
@property (nonatomic, strong) QMUILabel *label;
@end
@implementation FBPassingPointModel
+ (FBPassingPointModel *)sharedInstance {
    static FBPassingPointModel *model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = FBPassingPointModel.new;
    });
    return model;
}
- (instancetype)init {
    if (self = [super init]) {
        /*
        18*18 #000000
        描边 1px #FFFFFF
        字体 #FFFFFF 9px
         */
        QMUILabel *label = [[QMUILabel alloc] qmui_initWithFont:FONT(9) textColor:UIColor.whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = UIColor.blackColor;
        label.frame = CGRectMake(0, 0, 18, 18);
        label.circle = YES;
        label.borderWidth = 1;
        label.borderColor = UIColor.whiteColor;
        self.label = label;
        
        NSMutableArray <UIImage *> *imageIcon = NSMutableArray.array;
        for (int j = 1; j <= 1001; j++) {
            UIImage *image = [self imageWithTest:j];
            [imageIcon addObject:image];
        }
        self.imageIcon = imageIcon.copy;
    }
    return self;
}
- (UIImage *)imageWithTest:(int)text {
    if (text<1000) {
        self.label.text = @(text).stringValue;
    } else if (text == 1000) {
        self.label.text = @"1k";
    } else {
        self.label.text = @"1k+";
    }
    UIImage *image = [UIImage qmui_imageWithView:self.label];
    return image;
}
@end


@implementation FBPolyline
@end


@implementation FBCountingModel
@end
