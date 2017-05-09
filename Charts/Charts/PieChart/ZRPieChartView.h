//
//  ZRPieChartView.h
//  Charts
//
//  Created by zhangrong on 2017/5/4.
//  Copyright © 2017年 ryan.zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZRPieChartSector.h"

@class ZRPieChartView;

@protocol ZRPieChartViewDelegate <NSObject>

- (void)pieView:(ZRPieChartView *)pieView didSelectSectorAtIndex:(NSInteger)index;

@end

@interface ZRPieChartView : UIView

@property (nonatomic, strong) NSArray *sectors;

@property (nonatomic, weak) NSObject<ZRPieChartViewDelegate> *delegate;

- (void)drawPie;

@end
