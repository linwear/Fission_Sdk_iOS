//
//  FBTestUISportsTrajectoryViewController.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-10-21.
//

#import "LWBaseViewController.h"
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FBPointAnnotation;
@class FBPassingPointModel;
@class FBPolyline;

@interface FBTestUISportsTrajectoryViewController : LWBaseViewController

@property (nonatomic, strong) RLMSportsModel *sportsModel;

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

NS_ASSUME_NONNULL_END
