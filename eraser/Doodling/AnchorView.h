//
//  AnchorView.h
//  eraser
//
//  Created by 张健 on 2020/9/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnchorView : UIView
@property (nonatomic , assign) CGFloat radius;//半径
@property (nonatomic , assign) CGFloat distance;// 距离

-(void)setX:(CGFloat)x y:(CGFloat)y;
@end

NS_ASSUME_NONNULL_END
