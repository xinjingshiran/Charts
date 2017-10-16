//
//  ZRCircularLayer.h
//  Charts
//
//  Created by zhangrong on 2017/8/2.
//  Copyright © 2017年 ryan.zhang. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface ZRCircularLayer : CAShapeLayer

@property (nonatomic, assign) CGPoint center;

@property (nonatomic, assign) CGFloat radius;

@property (nonatomic, assign) CGFloat startAngle;

@property (nonatomic, assign) CGFloat endAngle;

@property (nonatomic, assign) CGFloat innerRadius;

- (void)createAnimationWithKey:(NSString *)key fromValue:(NSNumber *)fromValue toValue:(NSNumber *)toValue delegate:(id)delegate;

@end
