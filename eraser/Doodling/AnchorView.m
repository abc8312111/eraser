//
//  AnchorView.m
//  eraser
//
//  Created by 张健 on 2020/9/29.
//

#import "AnchorView.h"

#define anchor_w 60
#define anchor_h 150

@implementation AnchorView


-(instancetype)init{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    self.frame= CGRectMake(0, 0, anchor_w, anchor_h);
    self.userInteractionEnabled = NO;
    
    self.backgroundColor = [UIColor clearColor];
}

-(void)setDistance:(CGFloat)distance{
    _distance = distance;
    [self setNeedsDisplay];
}

-(void)setRadius:(CGFloat)radius{
    _radius = radius;
    [self setNeedsDisplay];
}

-(void)setX:(CGFloat)x y:(CGFloat)y{
    
    self.frame = CGRectMake(x - anchor_w / 2 , y - anchor_w - self.distance, anchor_w, anchor_h);
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    // 获取图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
     
    CGFloat width = rect.size.width;
    CGFloat x = (width - self.radius) / 2;
    CGRect bigRect = CGRectMake(x,x,self.radius,self.radius);
     
    //设置空心圆的线条宽度
    CGContextSetLineWidth(ctx, 2);
    //以矩形bigRect为依据画一个圆
    CGContextAddEllipseInRect(ctx, bigRect);
    //填充当前绘画区域的颜色
    [[UIColor yellowColor] set];
    //(如果是画圆会沿着矩形外围描画出指定宽度的（圆线）空心圆)/（根据上下文的内容渲染图层）
    CGContextStrokePath(ctx);
    
    // 绘制小红点
    CGContextSetLineWidth(ctx, 1);
    CGFloat red_y = width + self.distance;
    bigRect = CGRectMake(width / 2 ,red_y,1,1);
    //以矩形bigRect为依据画一个圆
    CGContextAddEllipseInRect(ctx, bigRect);
    [[UIColor redColor] set];
    CGContextStrokePath(ctx);
}


@end
