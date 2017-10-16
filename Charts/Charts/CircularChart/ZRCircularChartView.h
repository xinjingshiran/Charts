//
//  ZRCircularChartView.h
//  Charts
//
//  Created by zhangrong on 2017/8/2.
//  Copyright © 2017年 ryan.zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZRCircularChartSector.h"

@interface ZRCircularChartView : UIView

@property (nonatomic, strong) NSArray *sectors;

@property (nonatomic, assign) CGFloat innerRadius;
@property (nonatomic, strong) UIColor *innerColor;

- (void)drawCircular;

@end
