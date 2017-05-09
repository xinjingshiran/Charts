//
//  ZRLineChartView.m
//  Charts
//
//  Created by zhangrong on 2017/5/9.
//  Copyright © 2017年 ryan.zhang. All rights reserved.
//

#import "ZRLineChartView.h"
#import "ZRLineShapeLayer.h"

@interface ZRLineChartView ()<CAAnimationDelegate>

@property (nonatomic, strong) ZRLineShapeLayer *lineLayer;

@end

@implementation ZRLineChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
    }
    
    return self;
}

- (void)drawLine
{
    CGPoint startPoint = [_points[0] CGPointValue];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    
    for (NSInteger index = 1; index < _points.count; index++) {
        
        [path addLineToPoint:[_points[index] CGPointValue]];
    }
    
    _lineLayer = [ZRLineShapeLayer layer];
    _lineLayer.lineWidth = 3;
    _lineLayer.path = path.CGPath;
    _lineLayer.strokeColor = [UIColor blueColor].CGColor;
    _lineLayer.fillColor = [[UIColor clearColor] CGColor];
    _lineLayer.lineCap = kCALineCapRound;
    _lineLayer.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:_lineLayer];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0);
    animation.toValue = @(1.0);
    animation.fillMode = kCAFillModeForwards;
    animation.duration = 1.0;
    animation.repeatCount = 1;
    animation.removedOnCompletion = YES;
    [_lineLayer addAnimation:animation forKey:@"strokeEnd"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
