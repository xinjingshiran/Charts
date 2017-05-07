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

@property CGFloat currentAngle;

@property (nonatomic, strong) CAShapeLayer *backgroundLayer;

@property (nonatomic, strong) NSMutableArray *pieLayers;

@property (nonatomic, strong) NSMutableArray *iconImageViews;

@property (nonatomic, strong) ZRPieShapeLayer *selectedLayer;

@end

@implementation ZRPieChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.layer.cornerRadius = frame.size.width/2;
        self.layer.masksToBounds = YES;
        
        _pieLayers = [[NSMutableArray alloc] init];
        
        _iconImageViews = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)drawPie
{
    [self drawLayers];
}

- (void)drawLayers
{
    [_pieLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [_pieLayers removeAllObjects];
    
    [_iconImageViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_iconImageViews removeAllObjects];
    
    CGFloat totalValue = 0.0;
    
    for (NSNumber *value in _percents) {
        
        totalValue += value.floatValue;
    }
    
    CGPoint center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    CGFloat radius = (self.frame.size.width - 40)/2;
    CGFloat innerRadius = (self.frame.size.width - 40)/4;
    _currentAngle = 0;
    
    for (NSInteger i = 0; i < _percents.count; i++) {
        
        CGFloat value = [_percents[i] floatValue];
        
        CGFloat endAngle = _currentAngle + (value/totalValue) * M_PI * 2;
        
        ZRPieShapeLayer *layer = [self layerWithCenter:center
                                                radius:radius
                                           innerRadius:innerRadius
                                            startAngle:_currentAngle
                                              endAngle:endAngle];
        layer.fillColor = [_colors[i] CGColor];
        [self.layer addSublayer:layer];
        
        [_pieLayers addObject:layer];
        
        _currentAngle = endAngle;
        
        UIImageView *iconImageView = [self iconImageViewAtLayer:layer];
        [self addSubview:iconImageView];
        
        [_iconImageViews addObject:iconImageView];
    }
    
    CGFloat holeRadius = innerRadius;
    
    CAShapeLayer *holeLayer = [self layerWithCenter:center radius:holeRadius innerRadius:0 startAngle:0 endAngle:M_PI*2];
    holeLayer.fillColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:holeLayer];
    
    self.selectedLayer = _pieLayers[0];
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
    [path closePath];
    
    return path;
}

- (UIImageView *)iconImageViewAtLayer:(ZRPieShapeLayer *)layer
{
    CGPoint iconCenter = CGPointZero;
    iconCenter.x = layer.center.x+cosf((layer.startAngle+layer.endAngle)/2)*((layer.innerRadius+layer.radius)/2);
    iconCenter.y = layer.center.y+sinf((layer.startAngle+layer.endAngle)/2)*((layer.innerRadius+layer.radius)/2);
    
    CGRect bounds = CGRectMake(0, 0, 20, 20);
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:bounds];
    iconImageView.center = iconCenter;
    iconImageView.image = _icons[[_pieLayers indexOfObject:layer]];
    [self.layer addSublayer:iconImageView.layer];
    
    return iconImageView;
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
                             
                             self.transform = CGAffineTransformRotate(CGAffineTransformIdentity,angle);
                         }
                         completion:^(BOOL finished) {
                             
                             [self moveIconAtLayer:_selectedLayer selected:YES];
                             
                             _selectedLayer.selected = YES;
                             
                             if ([_delegate respondsToSelector:@selector(pieView:didSelectSectorAtIndex:)]) {
                                 
                                 [_delegate pieView:self didSelectSectorAtIndex:[_pieLayers indexOfObject:_selectedLayer]];
                             }
                         }];
    }
}

#pragma mark - UITouch Event -

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    
    if (_selectedLayer) {
        
        _selectedLayer.selected = NO;
        
        [self moveIconAtLayer:_selectedLayer selected:NO];
    }
    
    for (ZRPieShapeLayer *layer in _pieLayers) {

        if (CGPathContainsPoint(layer.path, 0, touchPoint, YES)) {
            
            self.selectedLayer = layer;
            
            break;
        }
    }
}

#pragma mark - Animate Icon -

- (void)moveIconAtLayer:(ZRPieShapeLayer *)layer selected:(BOOL)selected
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

- (void)translateIconAtLayer:(ZRPieShapeLayer *)layer angle:(CGFloat)angle
{
    UIImageView *iconImageView = _iconImageViews[[_pieLayers indexOfObject:layer]];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                        
                         iconImageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, angle);
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
