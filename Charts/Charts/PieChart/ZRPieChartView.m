//
//  ZRPieChartView.m
//  Charts
//
//  Created by zhangrong on 2017/5/4.
//  Copyright © 2017年 ryan.zhang. All rights reserved.
//

#import "ZRPieChartView.h"
#import "ZRPieShapeLayer.h"

static void pathApplierSumCoordinatesOfAllPoints(void* info, const CGPathElement* element)
{
    float* dataArray = (float*) info;
    float xTotal = dataArray[0];
    float yTotal = dataArray[1];
    float numPoints = dataArray[2];
    
    
    switch (element->type)
    {
        case kCGPathElementMoveToPoint:
        {
            /** for a move to, add the single target point only */
            
            CGPoint p = element->points[0];
            xTotal += p.x;
            yTotal += p.y;
            numPoints += 1.0;
            
        }
            break;
        case kCGPathElementAddLineToPoint:
        {
            /** for a line to, add the single target point only */
            
            CGPoint p = element->points[0];
            xTotal += p.x;
            yTotal += p.y;
            numPoints += 1.0;
            
        }
            break;
        case kCGPathElementAddQuadCurveToPoint:
            for( int i=0; i<2; i++ ) // note: quad has TWO not THREE
            {
                /** for a curve, we add all ppints, including the control poitns */
                CGPoint p = element->points[i];
                xTotal += p.x;
                yTotal += p.y;
                numPoints += 1.0;
            }
            break;
        case kCGPathElementAddCurveToPoint:
            for( int i=0; i<3; i++ ) // note: cubic has THREE not TWO
            {
                /** for a curve, we add all ppints, including the control poitns */
                CGPoint p = element->points[i];
                xTotal += p.x;
                yTotal += p.y;
                numPoints += 1.0;
            }
            break;
        case kCGPathElementCloseSubpath:
            /** for a close path, do nothing */
            break;
    }
    
    //NSLog(@"new x=%2.2f, new y=%2.2f, new num=%2.2f", xTotal, yTotal, numPoints);
    dataArray[0] = xTotal;
    dataArray[1] = yTotal;
    dataArray[2] = numPoints;
}

@interface ZRPieChartView ()

@property CGFloat currentAngle;

@property (nonatomic, strong) NSMutableArray *pieLayers;

@property (nonatomic, strong) NSMutableArray *iconImageViews;

@property (nonatomic, strong) CAShapeLayer *animationLayer;

@end

@implementation ZRPieChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _pieLayers = [[NSMutableArray alloc] init];
        
        _iconImageViews = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)drawPie
{
    [self drawLayers];
}

- (void)setupDefault
{
    
}

- (void)drawLayers
{
    [_pieLayers removeAllObjects];
    
    NSArray *percents = @[@"2", @"2", @"3", @"1", @"4"];
    NSArray *colors = @[[UIColor redColor],[UIColor orangeColor],[UIColor greenColor],[UIColor brownColor],[UIColor cyanColor]];
    
    CGFloat totalValue = 0.0;
    
    for (NSString *value in percents) {
        
        totalValue += value.floatValue;
    }
    
    CGPoint center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    CGFloat radius = (self.frame.size.width - 40)/2;
    CGFloat innerRadius = (self.frame.size.width - 40)/4;
    _currentAngle = 0;
    
    for (NSInteger i = 0; i < percents.count; i++) {
        
        CGFloat value = [percents[i] floatValue];
        
        CGFloat endAngle = _currentAngle + (value/totalValue) * M_PI * 2;
        
        ZRPieShapeLayer *layer = [self layerWithCenter:center
                                                radius:radius
                                           innerRadius:innerRadius
                                            startAngle:_currentAngle
                                              endAngle:endAngle];
        layer.fillColor = [colors[i] CGColor];
        [self.layer addSublayer:layer];
        
        [_pieLayers addObject:layer];
        
        _currentAngle = endAngle;
    }
    
    for (ZRPieShapeLayer *layer in _pieLayers) {
        
        CGPoint iconCenter = CGPointZero;
        iconCenter.x = center.x+cosf((layer.startAngle+layer.endAngle)/2)*((layer.innerRadius+layer.radius)/2);
        iconCenter.y = center.y+sinf((layer.startAngle+layer.endAngle)/2)*((layer.innerRadius+layer.radius)/2);
        
        CGRect bounds = CGRectMake(0, 0, 20, 20);
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:bounds];
        iconImageView.center = iconCenter;
        iconImageView.backgroundColor = [UIColor blueColor];
        [self addSubview:iconImageView];
        
        [_iconImageViews addObject:iconImageView];
    }
    
    CGFloat holeRadius = innerRadius;
    
    CAShapeLayer *holeLayer = [self layerWithCenter:center radius:holeRadius innerRadius:0 startAngle:0 endAngle:M_PI*2];
    holeLayer.fillColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:holeLayer];
}

- (ZRPieShapeLayer *)layerWithCenter:(CGPoint)center radius:(CGFloat)radius innerRadius:(CGFloat)innerRadius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle
{
    UIBezierPath *path = [self pathWithCenter:center radius:radius innerRadius:innerRadius startAngle:startAngle endAngle:endAngle];

    ZRPieShapeLayer *layer = [ZRPieShapeLayer layer];
    layer.path = path.CGPath;
    layer.center = center;
    layer.radius = radius;
    layer.innerRadius = innerRadius;
    layer.startAngle = startAngle;
    layer.endAngle = endAngle;
    
    return layer;
}

- (UIBezierPath *)pathWithCenter:(CGPoint)center radius:(CGFloat)radius innerRadius:(CGFloat)innerRadius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:center];
    [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    [path addArcWithCenter:center radius:innerRadius startAngle:endAngle endAngle:startAngle clockwise:NO];
    [path closePath];
    
    return path;
}

- (CGPoint)centerOfCGPath:(CGPathRef)path
{
    float dataArray[3] = { 0, 0, 0 };
    CGPathApply(path, dataArray, pathApplierSumCoordinatesOfAllPoints);
    
    float averageX = dataArray[0] / dataArray[2];
    float averageY = dataArray[1]  / dataArray[2];
    CGPoint centerOfPath = CGPointMake(averageX, averageY);
    
    return centerOfPath;
}

#pragma mark - UITouch Event -

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    
    ZRPieShapeLayer *selectedLayer = nil;
    
    for (ZRPieShapeLayer *layer in _pieLayers) {
        
        layer.selected = NO;
        
        [self animateIconAtLayer:layer selected:NO];
        
        if (CGPathContainsPoint(layer.path, 0, touchPoint, YES)) {
            
            selectedLayer = layer;
        }
    }
    
    [UIView animateWithDuration:0.3
                          delay:0.3
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2 - (selectedLayer.startAngle + (selectedLayer.endAngle - selectedLayer.startAngle)/2));
                     }
                     completion:^(BOOL finished) {
                         
                         [self animateIconAtLayer:selectedLayer selected:YES];
                         
                         selectedLayer.selected = YES;
                     }];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

#pragma mark - Animate Icon -

- (void)animateIconAtLayer:(ZRPieShapeLayer *)layer selected:(BOOL)selected
{
    UIImageView *iconImageView = _iconImageViews[[_pieLayers indexOfObject:layer]];
    
    CGPoint iconCenter = iconImageView.center;
    
    CGPoint newCenter = layer.center;
    
    if (selected) {
        
        newCenter = CGPointMake(layer.center.x + cosf((layer.startAngle + layer.endAngle)/2) * layer.offset,
                                layer.center.y + sinf((layer.startAngle + layer.endAngle)/2) * layer.offset);
    }
    
    iconCenter.x = newCenter.x+cosf((layer.startAngle+layer.endAngle)/2)*((layer.innerRadius+layer.radius)/2);
    iconCenter.y = newCenter.y+sinf((layer.startAngle+layer.endAngle)/2)*((layer.innerRadius+layer.radius)/2);
    
    [UIView animateWithDuration:0.3
                     animations:^{
                        
                         iconImageView.center = iconCenter;
                     }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
