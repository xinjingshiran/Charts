//
//  ZRPieChartView.h
//  Charts
//
//  Created by zhangrong on 2017/5/4.
//  Copyright © 2017年 ryan.zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZRPieChartView : UIView

@property (nonatomic, strong) NSArray *percents;

@property (nonatomic, strong) NSArray *colors;

@property (nonatomic, strong) NSArray *icons;

- (void)drawPie;

@end
