//
//  ViewController.m
//  Charts
//
//  Created by zhangrong on 2017/5/4.
//  Copyright © 2017年 ryan.zhang. All rights reserved.
//

#import "ViewController.h"
#import "ZRPieChartView.h"
#import "ZRLineChartView.h"
#import "CircleProgressView.h"

@interface ViewController ()

@property (nonatomic, strong) ZRLineChartView *lineChartView;

@property (nonatomic, strong) CircleProgressView * circleProgressView;

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
    
    /*
    UIImage *icon = [UIImage imageNamed:@"work_order_finish_icon.png"];
    
    ZRPieChartView *pieView = [[ZRPieChartView alloc] initWithFrame:rc];
    pieView.backgroundColor = [UIColor whiteColor];
    pieView.percents = @[@2, @2, @3, @1, @4];
    pieView.colors = @[[UIColor redColor],[UIColor orangeColor],[UIColor greenColor],[UIColor brownColor],[UIColor cyanColor]];
    pieView.icons = @[icon, icon, icon, icon, icon];
    [self.view addSubview:pieView];
    
    [pieView drawPie];
     */
    
    _lineChartView = [[ZRLineChartView alloc] initWithFrame:rc];
    _lineChartView.points = @[[NSValue valueWithCGPoint:CGPointMake(0, rc.size.height)],
                              [NSValue valueWithCGPoint:CGPointMake(20, rc.size.height-10)],
                              [NSValue valueWithCGPoint:CGPointMake(40, rc.size.height-20)],
                              [NSValue valueWithCGPoint:CGPointMake(60, rc.size.height-30)],
                              [NSValue valueWithCGPoint:CGPointMake(80, rc.size.height-40)],
                              [NSValue valueWithCGPoint:CGPointMake(100, rc.size.height-50)],
                              [NSValue valueWithCGPoint:CGPointMake(120, rc.size.height-60)],
                              [NSValue valueWithCGPoint:CGPointMake(140, rc.size.height-70)],];
    _lineChartView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_lineChartView];
    
    [_lineChartView drawLine];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
