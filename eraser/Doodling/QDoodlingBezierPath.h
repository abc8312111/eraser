//
//  QDoodlingBezierPath.h
//  画板
//
//  Created by zyj on 2017/12/13.
//  Copyright © 2017年 ittest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawBezierModel.h"

@interface QDoodlingBezierPath : UIBezierPath

@property(nonatomic, strong) DrawBezierModel *model;

//@property(nonatomic, strong) UIColor *lineColor;
//
//@property(nonatomic, assign) BOOL isEraser;
//
//@property(nonatomic, assign) CGFloat widthDoodling;

@end
