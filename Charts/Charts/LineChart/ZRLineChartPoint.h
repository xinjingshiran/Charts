//
//  ZRLineChartPoint.h
//  Charts
//
//  Created by zhangrong on 2017/5/9.
//  Copyright © 2017年 ryan.zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZRLineChartPoint : NSObject

@property (nonatomic, assign) float x;

@property (nonatomic, assign) float y;

+ (instancetype)pointWithX:(float)x andY:(float)y;

@end
