//
//  FBColorSliderView.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/5/23.
//

#import "FBColorSliderView.h"

@interface FBColorSliderView ()

@property (nonatomic, strong) UIImageView *trackImage;

@property (nonatomic, copy) FBColorSliderViewBlock block;

@end

@implementation FBColorSliderView

- (instancetype)initWithFrame:(CGRect)frame block:(FBColorSliderViewBlock)block {
    if (self = [super initWithFrame:frame]) {
        self.block = block;
        
        UIImageView *trackImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        trackImage.image = UIImageMake(@"ic_colorSlider");
        trackImage.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:trackImage];
        self.trackImage = trackImage;
    }
    return self;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super beginTrackingWithTouch:touch withEvent:event];
    CGPoint point = [touch locationInView:self];
    
    [self HandleEvents:point]; // 处理事件
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super continueTrackingWithTouch:touch withEvent:event];
    CGPoint point = [touch locationInView:self];
    
    [self HandleEvents:point]; // 处理事件
    
    return YES;
}

// 处理事件
- (void)HandleEvents:(CGPoint)point {
    
    FBLog(@"ffffff %.f=%.f, %.f=%.f", point.x, point.y, self.width, self.height);
    
    if (CGRectContainsPoint(self.trackImage.frame, point)) {
        // 边界内
    } else {
        CGFloat pointY = self.height/2;
        // 边界外，扩大触摸事件响应范围
        if (CGRectContainsPoint(self.trackImage.frame, CGPointMake(point.x, pointY))) {
            if (point.y < 0 || point.y > self.height) { // 最小、最大 y
                point = CGPointMake(point.x, pointY);
            }
        } else {
            if (point.x < 0) { // 最小 x
                point = CGPointMake(0, pointY);
            } else if (point.x > self.width) { // 最大 x
                point = CGPointMake(self.width, pointY);
            }
        }
    }

    UIColor *color = [self selectedColorWithlocationViewPoint:point];
    if (self.block) {
        self.block (color, point.x);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIColor *)selectedColorWithlocationViewPoint:(CGPoint)locationPoint {
        
    CGFloat x_P = locationPoint.x > (CGRectGetMaxX(self.trackImage.frame) - 1)?(CGRectGetMaxX(self.trackImage.frame) - 1): locationPoint.x;
    CGFloat y_P = locationPoint.y > (CGRectGetMaxY(self.trackImage.frame) - 1)?(CGRectGetMaxY(self.trackImage.frame) - 1): locationPoint.y;
    
    CGPoint cPoint = CGPointMake(x_P, y_P);
    CGFloat scalex = self.trackImage.frame.size.width  / self.trackImage.image.size.width;
    CGFloat scaley = self.trackImage.frame.size.height  / self.trackImage.image.size.height;
    CGPoint rPoint = CGPointMake(cPoint.x / scalex, cPoint.y / scaley);
    UIColor *color = [[self colorAtPixel:rPoint] colorWithAlphaComponent:1.0f];
    return color;
}

- (UIColor *)colorAtPixel:(CGPoint)point {
    
    // Cancel if point is outside image coordinates
    
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, self.trackImage.image.size.width, self.trackImage.image.size.height), point)) {
        return nil;
    }
    
    NSInteger pointX = trunc(point.x);
    
    NSInteger pointY = trunc(point.y);
    
    CGImageRef cgImage = self.trackImage.image.CGImage;
    
    NSUInteger width = self.trackImage.image.size.width;
    
    NSUInteger height = self.trackImage.image.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    int bytesPerPixel = 4;
    
    int bytesPerRow = bytesPerPixel * 1;
    
    NSUInteger bitsPerComponent = 8;
    
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGColorSpaceRelease(colorSpace);
    
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    
    // Draw the pixel we are interested in onto the bitmap context
    
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    
    CGContextRelease(context);
    
    // Convert color values [0..255] to floats [0.0..1.0]
    
    CGFloat red = (CGFloat)pixelData[0] / 255.0f;
    
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    
    CGFloat blue = (CGFloat)pixelData[2] / 255.0f;
    
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
