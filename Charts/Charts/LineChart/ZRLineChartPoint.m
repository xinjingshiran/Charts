//
//  ZRLineChartPoint.m
//  Charts
//
//  Created by zhangrong on 2017/5/9.
//  Copyright © 2017年 ryan.zhang. All rights reserved.
//

#import "ZRLineChartPoint.h"

@implementation ZRLineChartPoint

+ (instancetype)pointWithX:(float)x andY:(float)y
{
    ZRLineChartPoint *point = [[ZRLineChartPoint alloc] init];
    point.x = x;
    point.y = y;
    
    return point;
}

@end
