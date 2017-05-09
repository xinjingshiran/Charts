//
//  ZRLineChartView.h
//  Charts
//
//  Created by zhangrong on 2017/5/9.
//  Copyright © 2017年 ryan.zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZRLineChartView : UIView

@property (nonatomic, strong) NSArray *points;

- (void)drawLine;

@end
