//
//  ZRPieShapeLayer.h
//  Charts
//
//  Created by zhangrong on 2017/5/4.
//  Copyright © 2017年 ryan.zhang. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface ZRPieShapeLayer : CAShapeLayer

@property (nonatomic, assign) CGPoint center;

@property (nonatomic, assign) CGFloat radius;

@property (nonatomic, assign) CGFloat startAngle;

@property (nonatomic, assign) CGFloat endAngle;

@property (nonatomic, assign) CGFloat innerRadius;

@property (nonatomic, assign) BOOL selected;

@property (nonatomic, assign) CGFloat offset;

@end
