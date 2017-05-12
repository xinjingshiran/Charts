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
    
    [self drawPieChart];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawPieChart
{
    CGRect rc = CGRectZero;
    rc.origin.x = 10;
    rc.origin.y = 50;
    rc.size.width = self.view.frame.size.width - rc.origin.x*2;
    rc.size.height = rc.size.width;
    
    UIImage *icon = [UIImage imageNamed:@"work_order_finish_icon.png"];
    
    NSArray *percents = @[@2, @2, @3, @1, @4];
    NSArray *colors = @[[UIColor redColor],[UIColor orangeColor],[UIColor greenColor],[UIColor brownColor],[UIColor cyanColor]];
    NSArray *icons = @[icon, icon, icon, icon, icon];
    
    NSMutableArray *sectors = [[NSMutableArray alloc] init];
    
    for (NSInteger idx = 0; idx < percents.count; idx++) {
        
        CGFloat percent = [percents[idx] floatValue];
        UIColor *color = colors[idx];
        UIImage *icon = icons[idx];
        
        ZRPieChartSector *sector = [[ZRPieChartSector alloc] init];
        sector.percent = percent;
        sector.backgroundColor = color;
        sector.icon = icon;
        
        [sectors addObject:sector];
    }
    
    ZRPieChartView *pieView = [[ZRPieChartView alloc] initWithFrame:rc];
    pieView.backgroundColor = [UIColor whiteColor];
    pieView.sectors = sectors;
    [self.view addSubview:pieView];
    
    [pieView drawPie];
}

- (void)drawLineChart
{
    CGRect rc = CGRectZero;
    rc.origin.x = 10;
    rc.origin.y = 50;
    rc.size.width = self.view.frame.size.width - rc.origin.x*2;
    rc.size.height = rc.size.width;
    
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

@end
