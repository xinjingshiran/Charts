//
//  ZRCircularChartView.m
//  Charts
//
//  Created by zhangrong on 2017/8/2.
//  Copyright © 2017年 ryan.zhang. All rights reserved.
//

#import "ZRCircularChartView.h"
#import "ZRCircularLayer.h"

@interface ZRCircularChartView ()<CAAnimationDelegate>

@property (nonatomic, strong) UIView *circularContainerView;

@property (nonatomic, assign) CGPoint circularCenter;

@property (nonatomic, assign) CGFloat radius;

@property (nonatomic, assign) CGFloat animationDuration;

@property (nonatomic, strong) NSMutableArray *circularLayers;

@property (nonatomic, strong) NSMutableArray *iconLayers;

@property (nonatomic, strong) CAShapeLayer *trackLayer;

@property (nonatomic, strong) CAShapeLayer *holeLayer;

@property (nonatomic, strong) NSMutableArray *animations;

@property (nonatomic, strong) NSTimer *animationTimer;

@end

@implementation ZRCircularChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setupDefault];
        
        _circularContainerView = [[UIView alloc] initWithFrame:self.bounds];
        _circularContainerView.layer.cornerRadius = frame.size.width/2;
        [self addSubview:_circularContainerView];
        
        _circularLayers = [[NSMutableArray alloc] init];
        
        _iconLayers = [[NSMutableArray alloc] init];
        
        _animations = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)setupDefault
{
    _circularCenter = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    _radius = (MIN(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)))/2;
    _innerRadius = 70;
    _innerColor = [UIColor whiteColor];
    
    _animationDuration = 1.5;
}

- (void)drawCircular
{
    [self reset];
    
    [self drawLayers];
}

- (void)reset
{
    [_circularContainerView.layer removeAllAnimations];
    _circularContainerView.transform = CGAffineTransformIdentity;
    
    [_animationTimer invalidate];
    _animationTimer = nil;
    
    [_circularLayers makeObjectsPerformSelector:@selector(removeAllAnimations)];
    [_circularLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [_circularLayers removeAllObjects];
    
    [_iconLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [_iconLayers removeAllObjects];
}

- (void)drawLayers
{
    [self addTrackLayer];
    
    [self addHoleLayer];
    
    CGFloat totalValue = 0.0;
    
    for (ZRCircularChartSector *sector in _sectors) {
        
        totalValue += sector.percent;
    }
    
    CGFloat startFromAngle = 0;
    CGFloat startToAngle = 0;
    
    CGFloat endFromAngle = 0;
    CGFloat endToAngle = 0;
    
    for (NSInteger i = 0; i < _sectors.count; i++) {
        
        ZRCircularChartSector *obj = _sectors[i];
        
        CGFloat value = obj.percent;
        
        endToAngle += (value/totalValue) * M_PI * 2;
        
        ZRCircularLayer *layer = [self layerWithCenter:_circularCenter
                                                radius:_radius
                                           innerRadius:_innerRadius
                                            startAngle:startToAngle
                                              endAngle:endToAngle];
        layer.fillColor = [obj.backgroundColor CGColor];
        [_circularContainerView.layer insertSublayer:layer below:_holeLayer];
        
        [_circularLayers addObject:layer];
        
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

- (ZRCircularLayer *)layerWithCenter:(CGPoint)center radius:(CGFloat)radius innerRadius:(CGFloat)innerRadius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle
{
    ZRCircularLayer *layer = [ZRCircularLayer layer];
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

- (void)addTrackLayer
{
    [_trackLayer removeFromSuperlayer];
    
    UIBezierPath *path = [self pathWithCenter:_circularCenter radius:_radius innerRadius:_innerRadius startAngle:0 endAngle:M_PI*2];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor blueColor].CGColor;
    [_circularContainerView.layer addSublayer:layer];
    
    self.trackLayer = layer;
}

- (void)addHoleLayer
{
    [_holeLayer removeFromSuperlayer];
    
    CGFloat holeRadius = _innerRadius;
    
    UIBezierPath *path = [self pathWithCenter:_circularCenter radius:holeRadius innerRadius:0 startAngle:0 endAngle:M_PI*2];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.fillColor = _innerColor.CGColor;
    [_circularContainerView.layer addSublayer:layer];
    
    self.holeLayer = layer;
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
    [_circularLayers enumerateObjectsUsingBlock:^(CAShapeLayer *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ZRCircularLayer *layer = (ZRCircularLayer *)obj;
        
        NSNumber *presentationLayerStartAngle = [[layer presentationLayer] valueForKey:@"startAngle"];
        CGFloat startAngle = [presentationLayerStartAngle doubleValue];
        
        NSNumber *presentationLayerEndAngle = [[layer presentationLayer] valueForKey:@"endAngle"];
        CGFloat endAngle = [presentationLayerEndAngle doubleValue];
        
        [self animateLayer:layer startAngle:startAngle endAngle:endAngle];
    }];
}

- (void)animateLayer:(ZRCircularLayer *)layer startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle
{
    UIBezierPath *path = [self pathWithCenter:layer.center radius:layer.radius innerRadius:layer.innerRadius startAngle:startAngle endAngle:endAngle];
    
    layer.path = path.CGPath;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [_animations removeObject:anim];
    
    if (_animations.count == 0) {
        
        [_animationTimer invalidate];
        _animationTimer = nil;
        
        [_circularLayers enumerateObjectsUsingBlock:^(CAShapeLayer *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            ZRCircularLayer *layer = (ZRCircularLayer *)obj;
            
            [self animateLayer:layer startAngle:layer.startAngle endAngle:layer.endAngle];
        }];
        
        _circularContainerView.backgroundColor = _circularLayers.lastObject ? [UIColor clearColor] : [UIColor lightGrayColor];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
