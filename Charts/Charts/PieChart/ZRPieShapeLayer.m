//
//  ZRPieShapeLayer.m
//  Charts
//
//  Created by zhangrong on 2017/5/4.
//  Copyright © 2017年 ryan.zhang. All rights reserved.
//

#import "ZRPieShapeLayer.h"

@implementation ZRPieShapeLayer

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _offset = 5;
    }
    
    return self;
}

#pragma mark - Setter -

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    
    CGPoint newCenter = _center;
    CGFloat offset = _offset;
    
    if (selected) {

        newCenter = CGPointMake(_center.x + cosf((_startAngle + _endAngle)/2) * offset,
                                _center.y + sinf((_startAngle + _endAngle)/2) * offset);
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:newCenter];
    [path addArcWithCenter:newCenter radius:_radius startAngle:_startAngle endAngle:_endAngle clockwise:YES];
    [path closePath];
    
    self.path = path.CGPath;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.toValue = path;
    animation.duration = 0.3;
    [self addAnimation:animation forKey:@"selected"];
}

@end
