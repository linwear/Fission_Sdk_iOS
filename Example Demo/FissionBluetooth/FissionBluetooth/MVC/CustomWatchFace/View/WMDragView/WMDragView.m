//
//  WMDragView.m
//  WMDragView
//
//  Created by zhengwenming on 2016/12/16.
//
//

#import "WMDragView.h"

typedef enum {
    FB_Rectify_Not,
    FB_Rectify_L_T,
    FB_Rectify_L_B,
    FB_Rectify_R_T,
    FB_Rectify_R_B,
}FB_RectifyPoint;

@interface WMDragView ()<UIGestureRecognizerDelegate>
/**
 内容view，命名为contentViewForDrag，因为很多其他开源的第三方的库，里面同样有contentView这个属性
 ，这里特意命名为contentViewForDrag以防止冲突
 */
@property (nonatomic,strong) UIView *contentViewForDrag;
@property (nonatomic,assign) CGPoint startPoint;
@property (nonatomic,strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic,assign) CGFloat previousScale;
@end

@implementation WMDragView
-(UIImageView *)imageView{
    if (_imageView==nil) {
        _imageView = [[UIImageView alloc]init];
        _imageView.userInteractionEnabled = YES;
        _imageView.clipsToBounds = YES;
        [self.contentViewForDrag addSubview:_imageView];
    }
    return _imageView;
}
-(UIButton *)button{
    if (_button==nil) {
        _button = [QMUIButton buttonWithType:UIButtonTypeCustom];
        _button.clipsToBounds = YES;
        _button.userInteractionEnabled = NO;
        _button.imagePosition = QMUIButtonImagePositionTop;
        [self.contentViewForDrag addSubview:_button];
    }
    return _button;
}
-(UIView *)contentViewForDrag{
    if (_contentViewForDrag==nil) {
        _contentViewForDrag = [[UIView alloc]init];
        _contentViewForDrag.clipsToBounds = YES;
    }
    return _contentViewForDrag;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.contentViewForDrag];
        [self setUp];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUp];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (self.freeRect.origin.x!=0||self.freeRect.origin.y!=0||self.freeRect.size.height!=0||self.freeRect.size.width!=0) {
        //设置了freeRect--活动范围
    }else{
        //没有设置freeRect--活动范围，则设置默认的活动范围为父视图的frame
        self.freeRect = (CGRect){CGPointZero,self.superview.bounds.size};
    }
    _imageView.frame = (CGRect){CGPointZero,self.bounds.size};
    _button.frame = (CGRect){CGPointZero,self.bounds.size};
    self.contentViewForDrag.frame =  (CGRect){CGPointZero,self.bounds.size};
}
-(void)setUp{
    self.dragEnable = YES;//默认可以拖曳
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor lightGrayColor];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickDragView)];
    [self addGestureRecognizer:singleTap];
    
    //添加移动手势可以拖动
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragAction:)];
    self.panGestureRecognizer.minimumNumberOfTouches = 1;
    self.panGestureRecognizer.maximumNumberOfTouches = 1;
    self.panGestureRecognizer.delegate = self;
    [self addGestureRecognizer:self.panGestureRecognizer];
}
-(void)setFreeRect:(CGRect)freeRect{
    _freeRect = freeRect;
    [self keepBounds];
    
}
-(void)setCircleRect:(BOOL)circleRect{
    _circleRect = circleRect;
    if (circleRect) {
        [self keepBounds];
    }
}
-(void)setRectRadius:(CGFloat)rectRadius{
    _rectRadius = rectRadius;
    if (rectRadius > 0.0) {
        [self keepBounds];
    }
}
//-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//    return self.dragEnable;
//}
/**
 拖动事件
 @param pan 拖动手势
 */
-(void)dragAction:(UIPanGestureRecognizer *)pan{
    if(self.dragEnable==NO)return;
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{//开始拖动
            if (self.beginDragBlock) {
                self.beginDragBlock(self);
            }
            //注意完成移动后，将translation重置为0十分重要。否则translation每次都会叠加
            [pan setTranslation:CGPointZero inView:self];
            //保存触摸起始点位置
            self.startPoint = [pan translationInView:self];
            break;
        }
        case UIGestureRecognizerStateChanged:{//拖动中
            //计算位移 = 当前位置 - 起始位置
            if (self.duringDragBlock) {
                self.duringDragBlock(self);
            }
            CGPoint point = [pan translationInView:self];
            float dx;
            float dy;
            switch (self.dragDirection) {
                case WMDragDirectionAny:
                    dx = point.x - self.startPoint.x;
                    dy = point.y - self.startPoint.y;
                    break;
                case WMDragDirectionHorizontal:
                    dx = point.x - self.startPoint.x;
                    dy = 0;
                    break;
                case WMDragDirectionVertical:
                    dx = 0;
                    dy = point.y - self.startPoint.y;
                    break;
                default:
                    dx = point.x - self.startPoint.x;
                    dy = point.y - self.startPoint.y;
                    break;
            }
            
            //计算移动后的view中心点
            CGPoint newCenter = CGPointMake(self.center.x + dx, self.center.y + dy);
            //移动view
            self.center = newCenter;
            //  注意完成上述移动后，将translation重置为0十分重要。否则translation每次都会叠加
            [pan setTranslation:CGPointZero inView:self];
            break;
        }
        case UIGestureRecognizerStateEnded:{//拖动结束
            [self keepBounds];
            if (self.endDragBlock) {
                self.endDragBlock(self);
            }
            break;
        }
        default:
            break;
    }
}
//单击事件
-(void)clickDragView{
    if (self.clickDragViewBlock) {
        self.clickDragViewBlock(self);
    }
}
#pragma mark - 吴2023.05.31暴改
//黏贴边界效果
- (void)keepBounds{
    
    //中心点判断
    float centerX = self.mj_x+ self.mj_w/2;
    float centerY = self.mj_y+ self.mj_h/2;

    float centerFreeX = self.freeRect.size.width/2.0;
    float centerFreeY = self.freeRect.size.height/2.0;

    CGRect rect = self.frame;

    CGPoint point = CGPointMake(rect.origin.x, rect.origin.y);
    
    FB_RectifyPoint RectifyPoint = FB_Rectify_Not;

    if (centerX<=centerFreeX && centerY<=centerFreeY) {
        // 左上
        point = CGPointMake(self.mj_x, self.mj_y);
        RectifyPoint = FB_Rectify_L_T;

    } else if (centerX<=centerFreeX && centerY>centerFreeY) {
        // 左下
        point = CGPointMake(self.mj_x, self.mj_y+self.mj_h);
        RectifyPoint = FB_Rectify_L_B;

    } else if (centerX>centerFreeX && centerY<=centerFreeY) {
        // 右上
        point = CGPointMake(self.mj_x+self.mj_w, self.mj_y);
        RectifyPoint = FB_Rectify_R_T;

    } else if (centerX>centerFreeX && centerY>centerFreeY) {
        // 右下
        point = CGPointMake(self.mj_x+self.mj_w, self.mj_y+self.mj_h);
        RectifyPoint = FB_Rectify_R_B;
    }

    if ([self isOverflowing:point]) {

        rect = [self rectifyRect:RectifyPoint point:point];
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:@"rectifyRectMove" context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.5];
        self.frame = rect;
        [UIView commitAnimations];
    }
}

- (BOOL)isOverflowing:(CGPoint)point
{
    BOOL isOverflow = NO;
    
    if (self.circleRect) { // 圆
        
        CGFloat radius = self.freeRect.size.width/2.0;
        CGPoint center = CGPointMake(self.freeRect.origin.x+radius, self.freeRect.origin.y+radius);
        double dx = fabs(point.x-center.x);
        double dy = fabs(point.y-center.y);
        double dis = hypot(dx, dy);
        
        isOverflow = dis >= radius; // 是否超出圆的半径范围
        
        return isOverflow;
        
    } else { // 方
        if (point.x < 0 ||
            point.x > self.freeRect.size.width ||
            point.y < 0 ||
            point.y > self.freeRect.size.height) { // 上下左右超出
            
            return YES;
        } else if ((point.x<self.rectRadius                          && point.y<self.rectRadius) ||
                   (point.x>self.freeRect.size.width-self.rectRadius && point.y<self.rectRadius) ||
                   (point.x<self.rectRadius                          && point.y>self.freeRect.size.height-self.rectRadius) ||
                   (point.x>self.freeRect.size.width-self.rectRadius && point.y>self.freeRect.size.height-self.rectRadius)) { // 超圆角
            
            return YES;
        }
        
        return NO;
    }
}

- (CGRect)rectifyRect:(FB_RectifyPoint)RectifyPoint point:(CGPoint)point
{
    CGRect rect = (CGRect){CGPointZero, CGSizeMake(self.width, self.height)};
    
    CGFloat width = self.freeRect.size.width;
    CGFloat height = self.freeRect.size.height;
    
    CGPoint rectifyPoint;
    if (self.circleRect)
    {
        CGPoint center = CGPointMake(width/2.0, height/2.0);
        
        CGFloat angle = [self startingAngle:point endingAngle:center];
        
        rectifyPoint = [self center:center angle:angle radius:width/2.0]; // 圆计算
    }
    else
    {
        if (point.x < 0.0) {
            rectifyPoint.x = 0.0;
        }
        else if (point.x > width) {
            rectifyPoint.x = width;
        }
        else {
            rectifyPoint.x = point.x;
        }
        
        if (point.y < 0.0) {
            rectifyPoint.y = 0.0;
        }
        else if (point.y > height) {
            rectifyPoint.y = height;
        }
        else {
            rectifyPoint.y = point.y;
        }
        
        // 是否超出圆角部分
        if (point.x<self.rectRadius                                 && point.y<self.rectRadius) {
            rectifyPoint.x = self.rectRadius;
            rectifyPoint.y = self.rectRadius;
        } else if (point.x>self.freeRect.size.width-self.rectRadius && point.y<self.rectRadius) {
            rectifyPoint.x = self.freeRect.size.width-self.rectRadius;
            rectifyPoint.y = self.rectRadius;
        } else if (point.x<self.rectRadius                          && point.y>self.freeRect.size.height-self.rectRadius) {
            rectifyPoint.x = self.rectRadius;
            rectifyPoint.y = self.freeRect.size.height-self.rectRadius;
        } else if (point.x>self.freeRect.size.width-self.rectRadius && point.y>self.freeRect.size.height-self.rectRadius) {
            rectifyPoint.x = self.freeRect.size.width-self.rectRadius;
            rectifyPoint.y = self.freeRect.size.height-self.rectRadius;
        }
    }
    
    if (RectifyPoint == FB_Rectify_L_T) {
        rect.origin = rectifyPoint;
    }
    else if (RectifyPoint == FB_Rectify_L_B) {
        rect.origin.x = rectifyPoint.x;
        rect.origin.y = rectifyPoint.y-self.height;
    }
    else if (RectifyPoint == FB_Rectify_R_T) {
        rect.origin.x = rectifyPoint.x-self.width;
        rect.origin.y = rectifyPoint.y;
    }
    else if (RectifyPoint == FB_Rectify_R_B) {
        rect.origin.x = rectifyPoint.x-self.width;
        rect.origin.y = rectifyPoint.y-self.height;
    }
    
    return rect;
}

// 计算两点的角度
- (CGFloat)startingAngle:(CGPoint)startingPoint endingAngle:(CGPoint)endingPoint
{
    CGPoint originPoint = CGPointMake(endingPoint.x - startingPoint.x, endingPoint.y - startingPoint.y); // get origin point to origin by subtracting end from start
    float bearingRadians = atan2f(originPoint.y, originPoint.x); // get bearing in radians
    float bearingDegrees = bearingRadians * (180.0 / M_PI); // convert to degrees
    float angle = (bearingDegrees > 0.0 ? bearingDegrees : (360.0 + bearingDegrees)); // correct discontinuity
    return angle;
}

// 计算点在圆上的坐标
- (CGPoint)center:(CGPoint)center angle:(CGFloat)angle radius:(CGFloat)radius
{
    CGFloat x = radius * cosf(angle * M_PI/180);
    CGFloat y = radius * sinf(angle * M_PI/180);
    
    return CGPointMake(center.x-x, center.y-y);
}

@end
