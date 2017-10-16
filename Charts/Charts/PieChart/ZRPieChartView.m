//
//  ZRPieChartView.m
//  Charts
//
//  Created by zhangrong on 2017/5/4.
//  Copyright © 2017年 ryan.zhang. All rights reserved.
//

#import "ZRPieChartView.h"
#import "ZRPieShapeLayer.h"

@interface ZRPieChartView ()<CAAnimationDelegate>

@property (nonatomic, strong) UIView *pieContainerView;

@property (nonatomic, assign) CGPoint pieCenter;

@property (nonatomic, assign) CGFloat radius;

@property (nonatomic, assign) CGFloat animationDuration;

@property (nonatomic, strong) NSMutableArray *pieLayers;

@property (nonatomic, strong) NSMutableArray *iconLayers;

@property (nonatomic, strong) ZRPieShapeLayer *selectedLayer;

@property (nonatomic, strong) CAShapeLayer *holeLayer;

@property (nonatomic, strong) NSMutableArray *animations;

@property (nonatomic, strong) NSTimer *animationTimer;

@end

@implementation ZRPieChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setupDefault];
        
        _pieContainerView = [[UIView alloc] initWithFrame:self.bounds];
        _pieContainerView.layer.cornerRadius = frame.size.width/2;
        [self addSubview:_pieContainerView];
        
        _pieLayers = [[NSMutableArray alloc] init];
        
        _iconLayers = [[NSMutableArray alloc] init];
        
        _animations = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)setupDefault
{
    _pieCenter = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    _radius = (MIN(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)))/2;
    _innerRadius = 70;
    _innerColor = [UIColor whiteColor];
    
    _animationDuration = 1.5;
}

- (void)drawPie
{
    [self reset];
    
    [self drawLayers];
}

- (void)reset
{
    [_pieContainerView.layer removeAllAnimations];
    _pieContainerView.transform = CGAffineTransformIdentity;
    _pieContainerView.backgroundColor = [UIColor lightGrayColor];
    
    [_animationTimer invalidate];
    _animationTimer = nil;
    
    [_pieLayers makeObjectsPerformSelector:@selector(removeAllAnimations)];
    [_pieLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [_pieLayers removeAllObjects];
    
    [_iconLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [_iconLayers removeAllObjects];
}

- (void)drawLayers
{
    [self addHoleLayer];
    
    CGFloat totalValue = 0.0;
    
    for (ZRPieChartSector *sector in _sectors) {
        
        totalValue += sector.percent;
    }
    
    CGFloat startFromAngle = 0;
    CGFloat startToAngle = 0;
    
    CGFloat endFromAngle = 0;
    CGFloat endToAngle = 0;
    
    for (NSInteger i = 0; i < _sectors.count; i++) {
        
        ZRPieChartSector *obj = _sectors[i];
        
        CGFloat value = obj.percent;
        
        endToAngle += (value/totalValue) * M_PI * 2;
        
        ZRPieShapeLayer *layer = [self layerWithCenter:_pieCenter
                                                radius:_radius
                                           innerRadius:_innerRadius
                                            startAngle:startToAngle
                                              endAngle:endToAngle];
        layer.fillColor = [obj.backgroundColor CGColor];
        [_pieContainerView.layer insertSublayer:layer below:_holeLayer];
        
        [_pieLayers addObject:layer];
        
        [self addIconLayerViewAtLayer:layer];
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:_animationDuration];
        
        [layer createAnimationWithKey:@"startAngle"
                            fromValue:@(startFromAngle)
                              toValue:@(startToAngle)
                             delegate:self];
        
        [layer createAnimationWithKey:@"endAngle"
                            fromValue:@(endFromAngle)
                              toValue:@(endToAngle)
                             delegate:self];
        
        [CATransaction commit];
        
        startToAngle = endToAngle;
    }
}

- (ZRPieShapeLayer *)layerWithCenter:(CGPoint)center radius:(CGFloat)radius innerRadius:(CGFloat)innerRadius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle
{
    ZRPieShapeLayer *layer = [ZRPieShapeLayer layer];
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
    [path closePath];
    
    return path;
}

- (void)addHoleLayer
{
    [_holeLayer removeFromSuperlayer];
    
    CGFloat holeRadius = _innerRadius;
    
    UIBezierPath *path = [self pathWithCenter:_pieCenter radius:holeRadius innerRadius:0 startAngle:0 endAngle:M_PI*2];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.fillColor = _innerColor.CGColor;
    [_pieContainerView.layer addSublayer:layer];
    
    self.holeLayer = layer;
}

- (void)addIconLayerViewAtLayer:(ZRPieShapeLayer *)pieLayer
{
    ZRPieChartSector *obj = _sectors[[_pieLayers indexOfObject:pieLayer]];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.bounds = CGRectMake(0, 0, 20, 20);
    layer.anchorPoint = CGPointMake(0.5, 0.5);
    layer.position = CGPointMake(pieLayer.center.x+(pieLayer.radius+pieLayer.innerRadius)/2, pieLayer.center.y);
    layer.backgroundColor = [UIColor clearColor].CGColor;
    layer.contents = (id)[obj.icon CGImage];
    
    [pieLayer addSublayer:layer];
    
    [_iconLayers addObject:layer];
}

#pragma mark - CAAnimation Delegate -

- (void)animationDidStart:(CAAnimation *)anim
{
    if (_animationTimer == nil) {
        
        static float timeInterval = 1.0/60;
        
        _animationTimer= [NSTimer timerWithTimeInterval:timeInterval target:self selector:@selector(updateTimerFired:) userInfo:nil repeats:YES];
        
        [[NSRunLoop mainRunLoop] addTimer:_animationTimer forMode:NSRunLoopCommonModes];
    }
    
    [_animations addObject:anim];
}

- (void)updateTimerFired:(NSTimer *)timer;
{
    [_pieLayers enumerateObjectsUsingBlock:^(CAShapeLayer *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ZRPieShapeLayer *layer = (ZRPieShapeLayer *)obj;
        
        NSNumber *presentationLayerStartAngle = [[layer presentationLayer] valueForKey:@"startAngle"];
        CGFloat startAngle = [presentationLayerStartAngle doubleValue];
        
        NSNumber *presentationLayerEndAngle = [[layer presentationLayer] valueForKey:@"endAngle"];
        CGFloat endAngle = [presentationLayerEndAngle doubleValue];
        
        [self animateLayer:layer startAngle:startAngle endAngle:endAngle];
    }];
}

- (void)animateLayer:(ZRPieShapeLayer *)layer startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle
{
    UIBezierPath *path = [self pathWithCenter:layer.center radius:layer.radius innerRadius:layer.innerRadius startAngle:startAngle endAngle:endAngle];
    
    layer.path = path.CGPath;
    
    CALayer *iconLayer = layer.sublayers[0];
    
    CGFloat midAngle = (startAngle + endAngle)/2;
    [CATransaction setDisableActions:YES];
    iconLayer.position = CGPointMake(layer.center.x + ((layer.radius+layer.innerRadius)/2 * cos(midAngle)),
                                     layer.center.y + ((layer.radius+layer.innerRadius)/2 * sin(midAngle)));
    [CATransaction setDisableActions:NO];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [_animations removeObject:anim];
    
    if (_animations.count == 0) {
        
        [_animationTimer invalidate];
        _animationTimer = nil;
        
        [_pieLayers enumerateObjectsUsingBlock:^(CAShapeLayer *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            ZRPieShapeLayer *layer = (ZRPieShapeLayer *)obj;

            [self animateLayer:layer startAngle:layer.startAngle endAngle:layer.endAngle];
        }];
        
        _pieContainerView.backgroundColor = _pieLayers.lastObject ? [UIColor clearColor] : [UIColor lightGrayColor];
        
        self.selectedLayer = [_pieLayers firstObject];
    }
}

#pragma mark - Setter -

- (void)setSelectedLayer:(ZRPieShapeLayer *)selectedLayer
{
    _selectedLayer = selectedLayer;
    
    CGFloat angle = M_PI_2-(_selectedLayer.startAngle+_selectedLayer.endAngle)/2;
    
    for (ZRPieShapeLayer *layer in _pieLayers) {
        
        [self translateIconAtLayer:layer angle:-angle];
    }
    
    if (_selectedLayer) {
        
        [UIView animateWithDuration:0.3
                              delay:0.3
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             _pieContainerView.transform = CGAffineTransformRotate(CGAffineTransformIdentity,angle);
                         }
                         completion:^(BOOL finished) {
                            
                             if (_sectors.count > 1) {
                                 
                                 _selectedLayer.selected = YES;
                             }
                             
                             if ([_delegate respondsToSelector:@selector(pieView:didSelectSectorAtIndex:)]) {
                                 
                                 [_delegate pieView:self didSelectSectorAtIndex:[_pieLayers indexOfObject:_selectedLayer]];
                             }
                         }];
    }
}

#pragma mark - UITouch Event -

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:_pieContainerView];
    
    if (CGPathContainsPoint(_holeLayer.path, 0, touchPoint, YES)) {
        
        return;
    }
    
    if (_selectedLayer) {
        
        _selectedLayer.selected = NO;
    }
    
    for (ZRPieShapeLayer *layer in _pieLayers) {

        if (CGPathContainsPoint(layer.path, 0, touchPoint, YES)) {
            
            self.selectedLayer = layer;
            
            break;
        }
    }
}

#pragma mark - Animate Icon -

- (void)translateIconAtLayer:(ZRPieShapeLayer *)layer angle:(CGFloat)angle
{
    CALayer *iconLayer = _iconLayers[[_pieLayers indexOfObject:layer]];
    
    iconLayer.affineTransform = CGAffineTransformRotate(CGAffineTransformIdentity, angle);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
