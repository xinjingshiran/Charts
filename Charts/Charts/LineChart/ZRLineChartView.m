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
#define kYPadding           25

@interface ZRLineChartView ()<CAAnimationDelegate>

@property (nonatomic, assign) CGFloat xAxisSpacing;

@property (nonatomic, assign) CGFloat yAxisSpacing;

@end

@implementation ZRLineChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
    
        _axisLabelColor = [UIColor lightGrayColor];
        _axisLineColor = [UIColor blueColor];
        
        _animationDuration = 1.5;
        
        _animation = YES;
    }
    
    return self;
}

- (void)drawLine
{
    self.xAxisSpacing = (self.frame.size.width - kXPadding*2)/_xAxisArray.count;
    self.yAxisSpacing = (self.frame.size.height - kYPadding*2)/(_yAxisArray.count-1);
    
    [self setNeedsDisplay];
    
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    [_dataArray enumerateObjectsUsingBlock:^(ZRLineChartLine *line, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        for (NSInteger idx = 0; idx < line.points.count; idx++) {
            
            ZRLineChartPoint *obj = line.points[idx];
            
            CGPoint point = CGPointMake(kXPadding + obj.x*_xAxisSpacing-_xAxisSpacing/2,
                                        kYPadding + (_yAxisSpacing*(_yAxisArray.count-1))*(1-obj.y));
            
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
        
        if (_animation) {
            
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            animation.fromValue = @(0);
            animation.toValue = @(1.0);
            animation.fillMode = kCAFillModeForwards;
            animation.duration = _animationDuration;
            animation.repeatCount = 1;
            animation.removedOnCompletion = YES;
            [lineLayer addAnimation:animation forKey:@"strokeEnd"];
        }
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
        
        CGFloat width = [obj sizeWithAttributes:attribute].width;
        
        CGFloat diff = (_xAxisSpacing-width)/2;
        
        CGFloat x = kXPadding+_xAxisSpacing*idx + diff;
        
        CGRect rc = CGRectMake(x, self.frame.size.height-kYPadding+2, width, kYPadding-4);
        
        [obj drawInRect:rc withAttributes:attribute];
        
        // x坐标轴格子
        CGContextSetStrokeColorWithColor(context, _axisLineColor.CGColor);
        CGContextMoveToPoint(context, kXPadding+_xAxisSpacing*idx, self.frame.size.height-kYPadding+0.5);
        CGContextAddLineToPoint(context, kXPadding+_xAxisSpacing*idx, self.frame.size.height-kYPadding-3);
        
        CGContextStrokePath(context);
    }];

    // y坐标轴
    [_yAxisArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx > 0) {
            
            // y坐标轴虚线
            CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
            CGContextMoveToPoint(context, kXPadding, self.frame.size.height - kYPadding - _yAxisSpacing*idx);
            
            CGFloat lengths[] = {5, 5};
            CGContextSetLineDash(context, 0, lengths, 2);
            
            CGContextAddLineToPoint(context, self.frame.size.width-kXPadding, self.frame.size.height - kYPadding - _yAxisSpacing*idx);
            
            CGContextStrokePath(context);
        }
        
        UIFont *font = [UIFont systemFontOfSize:10.0];
        UIColor *fontColor = _axisLabelColor;
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.alignment = NSTextAlignmentLeft;
        
        NSDictionary *attribute = @{NSFontAttributeName: font,
                                    NSForegroundColorAttributeName: fontColor,
                                    NSParagraphStyleAttributeName: style};
        
        CGFloat width = [obj sizeWithAttributes:attribute].width;
        CGFloat height = [obj sizeWithAttributes:attribute].height;
        CGFloat y = self.frame.size.height - kYPadding - _yAxisSpacing*idx - height/2;
        
        CGRect rc = CGRectMake(1, y, width, height);
        
        [obj drawInRect:rc withAttributes:attribute];
    }];
}

@end
