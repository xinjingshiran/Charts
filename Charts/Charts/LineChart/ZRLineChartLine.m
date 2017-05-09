//
//  ZRLineChartLine.m
//  Charts
//
//  Created by zhangrong on 2017/5/9.
//  Copyright © 2017年 ryan.zhang. All rights reserved.
//

#import "ZRLineChartLine.h"

@implementation ZRLineChartLine

- (id)init
{
    self = [super init];
    
    if (self) {
        
        _lineWidth = 2/[UIScreen mainScreen].scale;
        _lineColor = [UIColor orangeColor];
    }
    
    return self;
}

@end
