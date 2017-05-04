//
//  ZRPieChartView.m
//  Charts
//
//  Created by zhangrong on 2017/5/4.
//  Copyright © 2017年 ryan.zhang. All rights reserved.
//

#import "ZRPieChartView.h"
#import "ZRPieShapeLayer.h"

@interface ZRPieChartView ()

@property CGFloat currentAngle;

@property (nonatomic, strong) NSMutableArray *pieLayers;

@end

@implementation ZRPieChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _pieLayers = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)drawPie
{
    [_pieLayers removeAllObjects];
    
    NSArray *percents = @[@"2", @"2", @"3", @"1", @"4"];
    NSArray *colors = @[[UIColor redColor],[UIColor orangeColor],[UIColor greenColor],[UIColor brownColor],[UIColor cyanColor]];
    
    CGFloat totalValue = 0.0;
    
    for (NSString *value in percents) {
        
        totalValue += value.floatValue;
    }
   
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat radius = (self.frame.size.width - 40)/2;
    CGFloat innerRadius = 40.0;
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
    
    CGFloat holeRadius = innerRadius;

    CAShapeLayer *holeLayer = [self layerWithCenter:center radius:holeRadius innerRadius:0 startAngle:0 endAngle:M_PI*2];
    holeLayer.fillColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:holeLayer];
}

- (ZRPieShapeLayer *)layerWithCenter:(CGPoint)center radius:(CGFloat)radius innerRadius:(CGFloat)innerRadius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:center];
    [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    [path addArcWithCenter:center radius:innerRadius startAngle:endAngle endAngle:startAngle clockwise:NO];
    [path closePath];
    
    ZRPieShapeLayer *layer = [ZRPieShapeLayer layer];
    layer.path = path.CGPath;
    layer.center = center;
    layer.radius = radius;
    layer.innerRadius = innerRadius;
    layer.startAngle = startAngle;
    layer.endAngle = endAngle;
    
    return layer;
}

#pragma mark - UITouch Event -

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    
    ZRPieShapeLayer *selectedLayer = nil;
    
    for (ZRPieShapeLayer *layer in _pieLayers) {
        
        layer.selected = NO;
        
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
                         
                         selectedLayer.selected = YES;
                     }];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
