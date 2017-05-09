//
//  ZRLineChartView.h
//  Charts
//
//  Created by zhangrong on 2017/5/9.
//  Copyright © 2017年 ryan.zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZRLineChartLine.h"
#import "ZRLineChartPoint.h"

@interface ZRLineChartView : UIView

@property (nonatomic, strong) NSArray *xAxisArray;

@property (nonatomic, strong) NSArray *yAxisArray;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UIColor *axisLabelColor;

@property (nonatomic, strong) UIColor *axisLineColor;

@property (nonatomic, assign) CGFloat animationDuration;

- (void)drawLine;

@end
