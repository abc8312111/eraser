//
//  ViewController.m
//  eraser
//
//  Created by 张健 on 2020/9/29.
//

#import "ViewController.h"
#import "EraserViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (IBAction)beginClick:(id)sender {
    EraserViewController * vc = [[EraserViewController alloc] init];
    vc.eraserImg = [UIImage imageNamed:@"bg"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
