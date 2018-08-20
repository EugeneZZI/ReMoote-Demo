//
//  RCSlider.m
//  iOSClient
//
//  Created by Eugene Zozulya on 1/5/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import "RCSlider.h"

@implementation RCSlider

- (void)drawRect:(CGRect)rect {
    CGFloat width = [self thumbImageForState:UIControlStateNormal].size.width/2;
    CGRect rect2 = CGRectMake(0, 0, width, 2);
    CGRect rect3 = CGRectMake((rect.size.width - width), 0, width, 2);
    CAShapeLayer* layer = [CAShapeLayer layer];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, nil, rect2);
    CGPathAddRect(path, nil, rect3);
    CGPathAddRect(path, nil, rect);
    layer.path = path;
    CGPathRelease(path);
    layer.fillRule = kCAFillRuleEvenOdd;
    self.layer.mask = layer;
}

- (CGRect)trackRectForBounds:(CGRect)bounds
{
    CGRect frame = [super trackRectForBounds:bounds];
    frame.origin.y = 0;
    return frame;
}

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
{
    CGRect frame = [super thumbRectForBounds:bounds trackRect:rect value:value];
    frame.origin.y += 40;
    return frame;
}

@end
