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
    
    ZRLineChartLine *line1 = [[ZRLineChartLine alloc] init];
    line1.points = @[[ZRLineChartPoint pointWithX:1 andY:0.1],
                     [ZRLineChartPoint pointWithX:2 andY:0.5],
                     [ZRLineChartPoint pointWithX:3 andY:0.5],
                     [ZRLineChartPoint pointWithX:4 andY:1],
                     [ZRLineChartPoint pointWithX:5 andY:0.7],
                     [ZRLineChartPoint pointWithX:6 andY:0.6],
                     [ZRLineChartPoint pointWithX:7 andY:1]];
    
    ZRLineChartLine *line2 = [[ZRLineChartLine alloc] init];
    line2.lineColor = [UIColor greenColor];
    line2.points = @[[ZRLineChartPoint pointWithX:1 andY:0.3],
                     [ZRLineChartPoint pointWithX:2 andY:0.2],
                     [ZRLineChartPoint pointWithX:3 andY:0.4],
                     [ZRLineChartPoint pointWithX:4 andY:0.8],
                     [ZRLineChartPoint pointWithX:5 andY:0.3],
                     [ZRLineChartPoint pointWithX:6 andY:0.5],
                     [ZRLineChartPoint pointWithX:7 andY:1]];
    
    ZRLineChartView *lineChartView = [[ZRLineChartView alloc] initWithFrame:rc];
    lineChartView.backgroundColor = [UIColor whiteColor];
    lineChartView.xAxisArray = @[@"5.1",@"5.2",@"5.3",@"5.4",@"5.5",@"5.6",@"5.7"];
    lineChartView.yAxisArray = @[@"0", @"25", @"50"];
    lineChartView.dataArray = @[line1, line2];
    lineChartView.clipsToBounds = NO;
    [self.view addSubview:lineChartView];
    
    [lineChartView drawLine];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
