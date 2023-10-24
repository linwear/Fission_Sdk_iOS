//
//  FBTestUISportsTrajectoryViewController.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-10-21.
//

#import "FBTestUISportsTrajectoryViewController.h"
#import "FBLocationConverter.h"
#import "MASmoothPathTool.h"

@interface FBTestUISportsTrajectoryViewController () <MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic, assign) BOOL optimization;

@property (nonatomic, assign) BOOL ChinaRegion;

@end

@implementation FBTestUISportsTrajectoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = LWLocalizbleString(@"Sports Trajectory");
    
    
    // 初始化地图
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationContentTop)];
    mapView.backgroundColor = UIColor.clearColor;
    mapView.showsScale = YES;
    mapView.showsCompass = YES;
    mapView.zoomEnabled = YES;
    mapView.scrollEnabled = YES;
    mapView.rotateEnabled = YES;
    mapView.pitchEnabled = YES;
    mapView.delegate = self;
    [self.view addSubview:mapView];
    self.mapView = mapView;
    
    
    // 轨迹优化按钮
    self.optimization = YES;
    UISwitch *rightBarSwitch = [[UISwitch alloc] qmui_initWithSize:CGSizeMake(50, 30)];
    rightBarSwitch.on = self.optimization;
    [rightBarSwitch addTarget:self action:@selector(dataLoading:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:rightBarSwitch];
    [self.navigationItem setRightBarButtonItem:rightBar animated:YES];
    

    // 反地理编码
    [self reverseGeocoding];
}


#pragma mark - 反地理编码
/**  反地理编码 */
- (void)reverseGeocoding {
    
    // 利用第一个定位数据进行反地理编码，确定位置在哪个国家，因为手表返回的是坐标系WGS-84，如果当前在中国，则需要转换成 火星坐标系GCJ-02
    RLMSportsLocationModel *firstObject = self.sportsModel.locations.firstObject;
    CLLocation *firstLocation = [[CLLocation alloc] initWithLatitude:firstObject.latitude longitude:firstObject.longitude];
    
    [NSObject showLoading:LWLocalizbleString(@"Loading...")];
    WeakSelf(self);
    [CLGeocoder.new reverseGeocodeLocation:firstLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        [NSObject dismiss];
        
        if (error) {
            FBLog(@"反地理编码失败 %@", error.localizedDescription);
            [NSObject showHUDText:error.localizedDescription];
        } else {
            CLPlacemark *placemark = placemarks.firstObject;
            NSString *country = nil;
            if (@available(ios 11.0,*)) {
                country = placemark.ISOcountryCode;
            } else {
                country = placemark.addressDictionary[@"CountryCode"];
            }
            
            weakSelf.ChinaRegion = [country isEqualToString:@"CN"];
            
            // 加载地图覆盖物
            [weakSelf dataLoading:nil];
        }
    }];
}


#pragma mark - 加载地图覆盖物
/**  加载地图覆盖物 */
- (void)dataLoading:(UISwitch *)swi {
    
    if (swi) {
        self.optimization = swi.on;
    }
    
    // 加载、轨迹平滑优化
    NSArray <NSArray <FBLocation *> *> *allLocationArray = [self trajectorySmoothingOptimization];
    
    // 添加 起点/终点 定位大头针
    [self addStartEndPointPositioningPins:allLocationArray];
    
    // 添加 绘制 地图轨迹
    NSArray <FBPolyline *> *polylineArray = [self addDrawingMapTrack:allLocationArray];
    
    // 地图显示区域
    [self mapTrackShowRegionWithEdgePadding:UIEdgeInsetsMake(40, 30, 30, 30) polylineArray:polylineArray];
}


#pragma mark - 地图 委托代理
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
    
    annotationView.image = pointAnnotation.pointImage;
    
    if (pointAnnotation.pointType == FBAnnotationPointType_Starting){
        // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(11, -20);
    }
    else if (pointAnnotation.pointType == FBAnnotationPointType_Ending) {
        // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(7, -16);
    }
    
    return annotationView;
}

/**  轨迹路径 */
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    if (![overlay isKindOfClass:[FBPolyline class]]) return nil;
    
    FBPolyline *polyline = (FBPolyline *)overlay;
    MKPolylineRenderer *polylineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:polyline];
    
    polylineRenderer.lineWidth   = 4;
    polylineRenderer.strokeColor = UIColor.redColor;
    polylineRenderer.lineJoin    = kCGLineJoinRound;
    polylineRenderer.lineCap     = kCGLineCapRound;
    if (polyline.dashed) { // 使用虚线
        polylineRenderer.lineWidth       = 3;
        polylineRenderer.strokeColor     = UIColor.blueColor;
        polylineRenderer.lineDashPattern = @[@(0), @(6)];
    }
    
    return polylineRenderer;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 加载、轨迹平滑优化
- (NSArray <NSArray <FBLocation *> *> *)trajectorySmoothingOptimization {
    
    // 轨迹拆分：如果轨迹集合存在暂停的数据，则将其拆分成 @[ @[正常], @[暂停], @[正常]...]，用于后续画轨迹区分 虚实线。
    NSMutableArray <NSArray <FBLocation *> *> *allLocationArray = NSMutableArray.array;
    
    BOOL gpsPause = YES; // 记录状态是否变化
    NSMutableArray <MALonLatPoint *> *paragraphArray;
    
    for (NSInteger index = 0; index < self.sportsModel.locations.count; index++) {

        RLMSportsLocationModel *model = self.sportsModel.locations[index];
        
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
        LonLatPoint.pause = model.gpsPause; /// 是否暂停
        [paragraphArray addObject:LonLatPoint];
        
        if (index == (self.sportsModel.locations.count - 1)) { // 最后一组，直接添加
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
    for (MALonLatPoint *LonLatPoint in OptimizationResults) {
        
        CLLocationCoordinate2D coordinate;
        
        // 处于中国地区，则需要转换
        if (self.ChinaRegion) {
            coordinate = [FBLocationConverter wgs_84ToGcj_02:CLLocationCoordinate2DMake(LonLatPoint.lat, LonLatPoint.lon)];
        } else {
            coordinate = CLLocationCoordinate2DMake(LonLatPoint.lat, LonLatPoint.lon);
        }
        
        FBLocation *location = [[FBLocation alloc] initWithCoordinate:coordinate altitude:0 horizontalAccuracy:0 verticalAccuracy:0 timestamp:[NSDate dateWithTimeIntervalSince1970:LonLatPoint.begin]];
        location.pause = LonLatPoint.pause;
        
        [locationArray addObject:location];
    }
    
    return locationArray.copy;
}


#pragma mark - 添加 起点/终点 定位大头针
- (void)addStartEndPointPositioningPins:(NSArray <NSArray <FBLocation *> *> *)allLocationArray {
    
    // 起点
    FBLocation *startingLocation = allLocationArray.firstObject.firstObject;
        
    FBPointAnnotation *starting = FBPointAnnotation.new;
    starting.pointType = FBAnnotationPointType_Starting;
    starting.pointImage = UIImageMake(@"icon_starting");
    starting.coordinate = startingLocation.coordinate;
    
    // 终点
    FBLocation *endingLocation = allLocationArray.lastObject.lastObject;
    
    FBPointAnnotation *ending = FBPointAnnotation.new;
    ending.pointType = FBAnnotationPointType_Ending;
    ending.pointImage = UIImageMake(@"icon_ending");
    ending.coordinate = endingLocation.coordinate;
    
    
    // 替换前先移除所有
    if (self.mapView.annotations.count) {
        [self.mapView removeAnnotations:self.mapView.annotations];
    }
    
    // 替换方案: 添加
    [self.mapView addAnnotations:@[starting, ending]];
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
- (void)mapTrackShowRegionWithEdgePadding:(UIEdgeInsets)insets polylineArray:(NSArray <FBPolyline *> *)polylineArray{
    
    MKMapRect rect = MKMapRectNull;
    for (FBPolyline *polyline in polylineArray) {
        rect = MKMapRectUnion(rect, polyline.boundingMapRect);
    }
    if (MKMapRectIsEmpty(rect)) {
        // 没有画线轨迹，这里会为空，为空要正确显示窗口请设置这里...
    } else {
        [self.mapView setVisibleMapRect:rect edgePadding:insets animated:YES];
    }
}


@end


@implementation FBLocation
@end


@implementation FBPointAnnotation
@end


@implementation FBPolyline
@end
