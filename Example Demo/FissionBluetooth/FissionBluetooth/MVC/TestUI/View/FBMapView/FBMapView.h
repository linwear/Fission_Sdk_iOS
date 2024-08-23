//
//  FBMapView.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2024-01-24.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FBPointAnnotation;
@class FBPassingPointModel;
@class FBPolyline;
@class FBCountingModel;

@interface FBMapView : UIView <MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *mapView;

// 地图类型，默认MKMapTypeStandard
@property (nonatomic, assign) MKMapType mapType;

/// 运动位置数据是否在中国地区境内
@property (nonatomic, assign) BOOL chinaRegion;

/// 是否开启轨迹平滑优化
@property (nonatomic, assign) BOOL optimization;

/// 绘制地图轨迹，显示区域边距
- (void)addMapTrack:(RLMArray <RLMSportsLocationModel> *)locations edgePadding:(UIEdgeInsets)insets;

/// 开始播放轨迹回放
- (void)startPlayingWithDistance:(NSInteger)distance progress:(void(^)(FBCountingModel *countingModel, BOOL first))progressBlock complete:(void(^)(void))completeBlock;
/// 停止播放轨迹回放
- (void)stopPlaying;
/// 是否正在播放中
@property (nonatomic, assign, readonly) BOOL isPlaying;

@end



@interface FBLocation : CLLocation
/// 是否暂停
@property (nonatomic, assign) BOOL pause;
/// 公/英里 里程点
@property (nonatomic, strong, nullable) UIImage *icon;
@end



typedef enum {
    FBAnnotationPointType_Starting,     // 起点
    FBAnnotationPointType_PassingPoint, // 途经点
    FBAnnotationPointType_Ending,       // 终点
    FBAnnotationPointType_GuidePoint,   // 轨迹回放 先行引导点
}FBAnnotationPointType;

@interface FBPointAnnotation : MKPointAnnotation
/// 大头针类型
@property (nonatomic, assign) FBAnnotationPointType pointType;
/// 大头针图片
@property (nonatomic, strong) UIImage *pointImage;
/// 大头针中心点偏移量
@property (nonatomic, assign) CGPoint centerOffset;
@end



@interface FBPassingPointModel : NSObject
+ (FBPassingPointModel *)sharedInstance;
/// 里程点
@property (nonatomic, strong) NSArray <UIImage *> *imageIcon;
@end



@interface FBPolyline : MKPolyline
/// 该段轨迹是否使用虚线绘制
@property (nonatomic, assign) BOOL dashed;
@end



@interface FBCountingModel : NSObject
/// 起始
@property (nonatomic, assign) float startValue;
/// 结束
@property (nonatomic, assign) float endValue;
/// 当前时长
@property (nonatomic, assign) NSTimeInterval interval;
/// 总时长
@property (nonatomic, assign) NSTimeInterval totalInterval;
@end

NS_ASSUME_NONNULL_END
