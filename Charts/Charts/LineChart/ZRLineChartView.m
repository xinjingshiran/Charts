//
//  ZRLineChartView.m
//  Charts
//
//  Created by zhangrong on 2017/5/9.
//  Copyright © 2017年 ryan.zhang. All rights reserved.
//

#import "ZRLineChartView.h"
#import "ZRLineShapeLayer.h"

#define kXPadding           10
#define kYPadding           15

@interface ZRLineChartView ()<CAAnimationDelegate>

@end

@implementation ZRLineChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
    
        _axisLabelColor = [UIColor lightGrayColor];
        _axisLineColor = [UIColor blueColor];
        
        _animationDuration = 1.5;
    }
    
    return self;
}

- (void)drawLine
{
    CGFloat xAxisSpacing = (self.frame.size.width - kXPadding*2)/_xAxisArray.count;
    CGFloat yAxisSpacing = (self.frame.size.height - kYPadding)/_yAxisArray.count;
    
    [_dataArray enumerateObjectsUsingBlock:^(ZRLineChartLine *line, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        for (NSInteger idx = 0; idx < line.points.count; idx++) {
            
            ZRLineChartPoint *obj = line.points[idx];
            
            CGPoint point = CGPointMake(kXPadding + obj.x*xAxisSpacing-xAxisSpacing/2,
                                        self.frame.size.height-kYPadding-obj.y*yAxisSpacing);
            
            if (idx == 0) {
                
                [path moveToPoint:point];
                
            }else {
                
                [path addLineToPoint:point];
            }
        }
        
        ZRLineShapeLayer *lineLayer = [ZRLineShapeLayer layer];
        lineLayer.lineWidth = line.lineWidth;
        lineLayer.path = path.CGPath;
        lineLayer.strokeColor = line.lineColor.CGColor;
        lineLayer.fillColor = [[UIColor clearColor] CGColor];
        lineLayer.lineCap = kCALineCapRound;
        lineLayer.lineJoin = kCALineJoinRound;
        [self.layer addSublayer:lineLayer];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = @(0);
        animation.toValue = @(1.0);
        animation.fillMode = kCAFillModeForwards;
        animation.duration = _animationDuration;
        animation.repeatCount = 1;
        animation.removedOnCompletion = YES;
        [lineLayer addAnimation:animation forKey:@"strokeEnd"];
    }];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // x坐标轴横线
    CGContextSetStrokeColorWithColor(context, _axisLineColor.CGColor);
    CGContextSetLineWidth(context, 1.0/[UIScreen mainScreen].scale);
    
    CGContextMoveToPoint(context, kXPadding, self.frame.size.height-kYPadding);
    CGContextAddLineToPoint(context, self.frame.size.width-kXPadding, self.frame.size.height-kYPadding);
    
    CGContextStrokePath(context);

    // x坐标轴
    [_xAxisArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIFont *font = [UIFont systemFontOfSize:10.0];
        UIColor *fontColor = _axisLabelColor;

        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.alignment = NSTextAlignmentCenter;
        
        NSDictionary *attribute = @{NSFontAttributeName: font,
                                    NSForegroundColorAttributeName: fontColor,
                                    NSParagraphStyleAttributeName: style};
        
        CGFloat spacing = (self.frame.size.width - kXPadding*2)/_xAxisArray.count;
        
        CGRect rc = CGRectMake(kXPadding+spacing*idx, self.frame.size.height-kYPadding, spacing, kYPadding);
        
        [obj drawInRect:rc withAttributes:attribute];
        
        if (idx > 0) {
            
            CGContextSetStrokeColorWithColor(context, _axisLineColor.CGColor);
            CGContextMoveToPoint(context, rc.origin.x, self.frame.size.height-kYPadding+0.5);
            CGContextAddLineToPoint(context, rc.origin.x, self.frame.size.height-kYPadding-3);
            
            CGContextStrokePath(context);
        }
    }];

    // y坐标轴
    [_yAxisArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIFont *font = [UIFont systemFontOfSize:10.0];
        UIColor *fontColor = _axisLabelColor;
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.alignment = NSTextAlignmentLeft;
        
        NSDictionary *attribute = @{NSFontAttributeName: font,
                                    NSForegroundColorAttributeName: fontColor,
                                    NSParagraphStyleAttributeName: style};
        
        CGFloat spacing = (self.frame.size.height - kYPadding)/_yAxisArray.count;
    
        CGFloat width = [obj sizeWithAttributes:attribute].width;
        CGFloat height = [obj sizeWithAttributes:attribute].height;
        CGFloat y = self.frame.size.height - kYPadding - spacing*idx - height/2;
        
        CGRect rc = CGRectMake(0, y, width, height);
        
        [obj drawInRect:rc withAttributes:attribute];
    }];
}

@end
