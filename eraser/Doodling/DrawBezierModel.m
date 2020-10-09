//
//  DrawBezierModel.m
//  eraser
//
//  Created by 张健 on 2020/9/30.
//

#import "DrawBezierModel.h"

@implementation DrawBezierModel
-(instancetype)init{
    self = [super init];
    if (self != nil) {
        [self setup];
    }
    return self;
}

-(void)setup{
    self.points = [NSMutableArray array];
    self.isUndo = NO;
}
@end
