//
//  QDoodlingDrawView.m
//  画板
//
//  Created by zyj on 2017/12/13.
//  Copyright © 2017年 ittest. All rights reserved.
//

#import "QDoodlingDrawView.h"
#import <MJExtension.h>
#import "QDoodlingBezierPath.h"
#import "AnchorView.h"

@interface QDoodlingDrawView()
@property (nonatomic , assign) CGFloat offic_x;//偏移x
@property (nonatomic , assign) CGFloat offic_y;//偏移y
@property (nonatomic , assign) CGFloat image_w;
@property (nonatomic , assign) CGFloat image_h;
@property (nonatomic , assign) CGFloat f_radio;//缩放比例

@property (nonatomic , strong) AnchorView * anchor;
@end


@implementation QDoodlingDrawView

-(instancetype)init{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    AnchorView * anchor = [[AnchorView alloc] init];
    [self addSubview:anchor];
    self.anchor = anchor;
    self.anchor.radius = self.radius;
    self.anchor.distance = self.distance;
}

-(void)setRadius:(CGFloat)radius{
    _radius = radius;
    self.anchor.radius = radius;
}

-(void)setDistance:(CGFloat)distance{
    _distance = distance;
    self.anchor.distance = distance;
}

- (void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    self.isEraser = NO;
}

- (void)setLineWidth:(CGFloat)lineWidth{
    _lineWidth = lineWidth;
    self.isEraser = NO;
}

-(NSArray *)paths{
    if(!_paths){
        _paths=[NSMutableArray array];
    }
    return _paths;
}

- (void)clean{
    [self.paths removeAllObjects];
    //重绘
    [self setNeedsDisplay];
}

-(void)reset{
    // 优先居中 宽高 不超范围
    CGFloat fixelW = CGImageGetWidth(self.eraserImg.CGImage);
    CGFloat fixelH = CGImageGetHeight(self.eraserImg.CGImage);
    
    CGFloat pre_img_w = fixelW;
    CGFloat pre_img_h = fixelH;
    
    CGFloat v_width = self.frame.size.width;
    CGFloat v_height = self.frame.size.height;
    
    if (fixelW > v_width) {
        //图片宽度 大于视图宽度
        fixelH = fixelH / fixelW * v_width;
        fixelW = v_width;
    }
    if (fixelH > v_height) {
        //图片高度 大于视图高度
        fixelW =fixelW / fixelH * v_height;
        fixelH = v_height;
    }
    
    // 计算居中
    self.offic_y = (v_height - fixelH) / 2;
    self.offic_x = (v_width - fixelW) / 2;
    self.image_h = fixelH;
    self.image_w = fixelW;
    self.f_radio = v_width / pre_img_w;
    
    [self.paths removeAllObjects];
    
    [self setNeedsDisplay];
}
//撤销
- (void)undo{
//    [self.paths removeLastObject];
    for (int i = (int)self.paths.count-1; i >= 0; i --) {
        QDoodlingBezierPath * path = self.paths[i];
        if (!path.model.isUndo) {
            path.model.isUndo = YES;
            break;
        }
    }
    //重绘
    [self setNeedsDisplay];
}
//恢复
- (void)restore{
    for (QDoodlingBezierPath* path in self.paths) {
        if (path.model.isUndo) {
            path.model.isUndo = NO;
            break;
        }
    }
    //重绘
    [self setNeedsDisplay];
}

-(void)removeUndo{
    [self.paths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QDoodlingBezierPath* path = obj;
        if (path.model.isUndo) {
            [self.paths removeObject:path];
        }
    }];
//    for (QDoodlingBezierPath* path in self.paths) {
//        if (path.model.isUndo) {
//            [self.paths removeObject:path];
//        }
//    }
}

- (void)eraser{
    self.isEraser = YES;
}

- (void)save{
    //开启图片上下文
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    //获取上下文
    CGContextRef context=UIGraphicsGetCurrentContext();
    //截屏
    [self.layer renderInContext:context];
    //获取图片
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    //关闭图片上下文
    UIGraphicsEndImageContext();
    //保存到相册
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

//保存图片的回调
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSString *message = @"";
    if (!error) {
        message = @"成功保存到相册";
    }else{
        message = [error description];
    }
    NSLog(@"message is %@",message);
}

-(CGFloat)getDetailDistanceY:(CGFloat)current_y{
    CGFloat y = current_y - self.distance - 60 /2;
    return y;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeUndo];
    // 获取触摸对象
    UITouch *touch=[touches anyObject];
    // 获取手指的位置
    CGPoint point=[touch locationInView:touch.view];
    
    [self.anchor setX:point.x y:point.y];
    point.y = [self getDetailDistanceY:point.y];
    //当手指按下的时候就创建一条路径
    QDoodlingBezierPath *path= [QDoodlingBezierPath bezierPath];
    
    path.model = [[DrawBezierModel alloc] init];
    
    path.model.isEraser = self.isEraser;
    //设置画笔颜色
//    [path.model colorToIndexWithColor:self.lineColor];
    
    path.model.lineWidth = self.radius;

    [path.model.points addObject:NSStringFromCGPoint(point)];
    //设置起点
    [path moveToPoint:point];
    // 把每一次新创建的路径 添加到数组当中
    [self.paths addObject:path];
}


-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // 获取触摸对象
    UITouch *touch=[touches anyObject];
    // 获取手指的位置
    CGPoint point=[touch locationInView:touch.view];
    [self.anchor setX:point.x y:point.y];
    
    point.y = [self getDetailDistanceY:point.y];
    
    // 连线的点
    QDoodlingBezierPath *path = [self.paths lastObject];
    
    [path.model.points addObject:NSStringFromCGPoint(point)];
    [[self.paths lastObject] addLineToPoint:point];
    // 重绘
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 保存初始状态
    CGContextSaveGState(context);
    // 图形上下文移动{x,y}
//    CGContextTranslateCTM(context, self.offic_x, self.offic_y);
//    // 图形上下文缩放{x,y}
//    CGContextScaleCTM(context, self.f_radio, self.f_radio);

    // 绘制图片
    UIImage *image = self.eraserImg;
    
    CGRect rectImage = CGRectMake(self.offic_x, self.offic_y, self.image_w, self.image_h);
    
    
    // 2 在rect范围内完整显示图片-正常使用
    [image drawInRect:rectImage];
    
    // 恢复到初始状态
//    CGContextRestoreGState(context);
    
    // Drawing code
    BOOL isfirst = YES;
    for (QDoodlingBezierPath *path in self.paths) {
        if (path.model.isUndo) {
            continue;
        }
        // 设置连接处的样式
        [path setLineJoinStyle:kCGLineJoinRound];
        // 设置头尾的样式
        [path setLineCapStyle:kCGLineCapRound];
        
        [path setLineWidth:path.model.lineWidth];
        //渲染
        if(path.model.isEraser){
            [path strokeWithBlendMode:kCGBlendModeDestinationIn alpha:1.0];
            [self.backgroundColor set];
        }else {
            [path strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
            //设置颜色
            [[UIColor blackColor] set];
        }
        [path stroke];
        // 修复第一条线无效bug  未查出原因
        if (isfirst) {
            isfirst = NO;
            [path strokeWithBlendMode:kCGBlendModeDestinationIn alpha:1.0];
            [self.backgroundColor set];
            [path stroke];
        }
    }
}

- (UIImage *)snip {
    //开启图片上下文
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    //获取上下文
    CGContextRef context=UIGraphicsGetCurrentContext();
    //截屏
    [self.layer renderInContext:context];
    //获取图片
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    //关闭图片上下文
    UIGraphicsEndImageContext();
    return image;
}

- (NSString *)getPathsParams{
    if (_paths){
        NSMutableString *strs = [NSMutableString string];
        [strs appendString:@"["];
        for (int i = 0; i < self.paths.count; i ++){
            QDoodlingBezierPath *path = self.paths[i];
            if (path.model) {
                [strs appendString:path.model.mj_JSONString];
            }
            if (i != self.paths.count - 1){
                [strs appendString:@","];
            }
        }
        [strs appendString:@"]"];
        return strs;
//        return [[strs copy] encodeBase64];
    }
    return nil;
}

@end
