//
//  ViewController.m
//  Charts
//
//  Created by zhangrong on 2017/5/4.
//  Copyright © 2017年 ryan.zhang. All rights reserved.
//

#import "ViewController.h"
#import "ZRPieChartView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGRect rc = CGRectZero;
    rc.origin.x = 10;
    rc.origin.y = 50;
    rc.size.width = self.view.frame.size.width - rc.origin.x*2;
    rc.size.height = rc.size.width;
    
    ZRPieChartView *pieView = [[ZRPieChartView alloc] initWithFrame:rc];
    pieView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:pieView];
    
    [pieView drawPie];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
