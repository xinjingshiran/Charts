//
//  ZRLineChartLine.h
//  Charts
//
//  Created by zhangrong on 2017/5/9.
//  Copyright © 2017年 ryan.zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZRLineChartLine : NSObject

@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, strong) UIColor *lineColor;

@property (nonatomic, strong) NSArray *points;

@end
