//
//  ZRCircularLayer.m
//  Charts
//
//  Created by zhangrong on 2017/8/2.
//  Copyright © 2017年 ryan.zhang. All rights reserved.
//

#import "ZRCircularLayer.h"

@implementation ZRCircularLayer

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

- (instancetype)initWithLayer:(id)layer
{
    self = [super initWithLayer:layer];
    
    if (self) {
        
        if ([layer isKindOfClass:[ZRCircularLayer class]]) {
            
            self.startAngle = [(ZRCircularLayer *)layer startAngle];
            self.endAngle = [(ZRCircularLayer *)layer endAngle];
        }
        
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
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

@end
