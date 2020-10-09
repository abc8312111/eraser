//
//  DrawBezierModel.h
//  eraser
//
//  Created by 张健 on 2020/9/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DrawBezierModel : NSObject
@property (nonatomic , assign) NSInteger colorIndex;
@property (nonatomic , assign) NSInteger lineWidth;
@property (nonatomic , assign) BOOL isEraser;
@property (nonatomic , assign) BOOL isUndo;
@property (nonatomic , strong) NSMutableArray * points;
@end

NS_ASSUME_NONNULL_END
