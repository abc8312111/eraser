//
//  EraserViewController.m
//  eraser
//
//  Created by 张健 on 2020/9/29.
//

#import "EraserViewController.h"
#import "QDoodlingDrawView.h"
#import <Masonry.h>

@interface EraserViewController ()
@property (weak, nonatomic) IBOutlet UIView *drawContentView;
@property (weak, nonatomic) IBOutlet UISlider *sizeSlider;//大小指示器
@property (weak, nonatomic) IBOutlet UISlider *distanceSlider;//距离指示器

@property (strong , nonatomic) QDoodlingDrawView * drawView;
@end

@implementation EraserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    QDoodlingDrawView * drawView = [[QDoodlingDrawView alloc] init];
    [self.drawContentView addSubview:drawView];
    
    [drawView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    drawView.lineWidth = 10;
    drawView.lineColor = [UIColor orangeColor];
    drawView.backgroundColor = [UIColor clearColor];
    drawView.eraserImg = self.eraserImg;
    
    // 设置默认
    
    drawView.radius = 10;
    drawView.distance = 20;
    self.sizeSlider.value = 1.0/3.0;
    self.distanceSlider.value = 20.0/ 90.0;
    [drawView eraser];
    
    self.drawView = drawView;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [drawView reset];//重置下
    });
}
- (IBAction)imageTopClick:(UIButton *)sender {
    NSInteger tag = sender.tag;
    if (tag == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (tag == 2){
        // reset
        [self.drawView reset];
    }else if(tag == 3){
        // undo
        [self.drawView undo];
    }else if (tag == 4){
        // 回复
        [self.drawView restore];
    }else if (tag == 5){
        // 适配屏幕
    
    }else if (tag == 6){
        // 使用指南
    }else if (tag == 7){
        // 保存
    }
}

- (IBAction)sizeChange:(UISlider *)sender {
    CGFloat radius = 30 * sender.value;
    self.drawView.radius = radius;
}

- (IBAction)distanceChange:(UISlider *)sender {
    CGFloat distance = 90 * sender.value;
    self.drawView.distance = distance;
}

@end
