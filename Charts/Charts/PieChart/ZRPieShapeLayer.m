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

- (instancetype)initWithLayer:(id)layer
{
    self = [super initWithLayer:layer];
    
    if (self) {
        
        if ([layer isKindOfClass:[ZRPieShapeLayer class]]) {
            
            self.startAngle = [(ZRPieShapeLayer *)layer startAngle];
            self.endAngle = [(ZRPieShapeLayer *)layer endAngle];
        }
        
        _offset = 5;
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        _offset = 5;
    }
    
    return self;
}

- (void)createAnimationWithKey:(NSString *)key fromValue:(NSNumber *)fromValue toValue:(NSNumber *)toValue delegate:(id)delegate
{
    NSNumber *currentAngle = [[self presentationLayer] valueForKey:key];
    if(!currentAngle)
        currentAngle = fromValue;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:key];
    animation.fromValue = currentAngle;
    animation.toValue = toValue;
    animation.delegate = delegate;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    [self addAnimation:animation forKey:key];
    
    [self setValue:toValue forKey:key];
}

#pragma mark - Overrides -

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:@"startAngle"] || [key isEqualToString:@"endAngle"]) {
        
        return YES;
    }
    
    return [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)ctx
{
    NSLog(@"startAngle :%f   endAngle :%f", _startAngle, _endAngle);
}

#pragma mark - Setter -

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    
    CGPoint currentPosition = self.position;
    
    if (selected) {
        
        CGPoint newPosition = CGPointMake(currentPosition.x + (_offset*cosf((_startAngle+_endAngle)/2)),
                                          currentPosition.y + (_offset*sinf((_startAngle+_endAngle)/2)));
        
        self.position = newPosition;
        
    }else {
        
        self.position = CGPointMake(0, 0);
    }
}

@end
