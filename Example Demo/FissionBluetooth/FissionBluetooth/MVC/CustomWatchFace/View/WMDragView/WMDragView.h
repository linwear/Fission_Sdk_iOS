//
//  WMDragView.h
//  WMDragView
//
//  Created by zhengwenming on 2016/12/16.
//
//

#import <UIKit/UIKit.h>


// 拖曳view的方向
typedef NS_ENUM(NSInteger, WMDragDirection) {
    WMDragDirectionAny,          /**< 任意方向 */
    WMDragDirectionHorizontal,   /**< 水平方向 */
    WMDragDirectionVertical,     /**< 垂直方向 */
};

@interface WMDragView : UIView
/**
 是不是能拖曳，默认为YES
 YES，能拖曳
 NO，不能拖曳
 */
@property (nonatomic,assign) BOOL dragEnable;

/**
 活动范围，默认为父视图的frame范围内（因为拖出父视图后无法点击，也没意义）
 如果设置了，则会在给定的范围内活动
 如果没设置，则会在父视图范围内活动
 注意：设置的frame不要大于父视图范围
 注意：设置的frame为0，0，0，0表示活动的范围为默认的父视图frame，如果想要不能活动，请设置dragEnable这个属性为NO
 */
@property (nonatomic,assign) CGRect freeRect;
@property (nonatomic,assign) BOOL circleRect; // 是否圆形区域，默认NO - - - 吴2023.05.31新增
@property (nonatomic,assign) CGFloat rectRadius; // 四边形区域圆角大小，仅当circleRect=NO时有效，默认0 - - - 吴2023.05.31新增

/**
 拖曳的方向，默认为any，任意方向
 */
@property (nonatomic,assign) WMDragDirection dragDirection;

/**
 contentView内部懒加载的一个UIImageView
 开发者也可以自定义控件添加到本view中
 注意：最好不要同时使用内部的imageView和button
 */
@property (nonatomic,strong) UIImageView *imageView;
/**
 contentView内部懒加载的一个UIButton
 开发者也可以自定义控件添加到本view中
 注意：最好不要同时使用内部的imageView和button
 */
@property (nonatomic,strong) QMUIButton *button;
/**
 点击的回调block
 */
@property (nonatomic,copy) void(^clickDragViewBlock)(WMDragView *dragView);
/**
 开始拖动的回调block
 */
@property (nonatomic,copy) void(^beginDragBlock)(WMDragView *dragView);
/**
 拖动中的回调block
 */
@property (nonatomic,copy) void(^duringDragBlock)(WMDragView *dragView);
/**
 结束拖动的回调block
 */
@property (nonatomic,copy) void(^endDragBlock)(WMDragView *dragView);
@end


