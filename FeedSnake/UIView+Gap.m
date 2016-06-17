//
//  UIView+Gap.m
//  card
//
//  Created by Hale Chan on 15/5/7.
//  Copyright (c) 2015年 Papaya Mobile Inc. All rights reserved.
//

#import "UIView+Gap.h"

static NSString *const kGapBorderSublayerName = @"com.papayamobile.view.gap.border";

@implementation UIView (Gap)

- (void)buildBottomGapAtX:(CGFloat)x arrowSize:(CGSize)size borderWidth:(CGFloat)width borderColor:(UIColor *)color
{
    [self clearGap];
    
    CGRect rect = self.bounds;
    CGFloat const arrowHalfWidth = size.width/2.0;
    CGFloat const arrowHeight = size.height;
    CGFloat left = 0;
    CGFloat right = CGRectGetMaxX(rect);
    CGFloat top = 0;
    CGFloat bottom = CGRectGetMaxY(rect);
    
    UIBezierPath *path = [[UIBezierPath alloc]init];
    [path moveToPoint:CGPointMake(left, top)];
    [path addLineToPoint:CGPointMake(left, bottom)];
    [path addLineToPoint:CGPointMake(x - arrowHalfWidth, bottom)];
    [path addLineToPoint:CGPointMake(x, bottom - arrowHeight)];
    [path addLineToPoint:CGPointMake(x + arrowHalfWidth, bottom)];
    [path addLineToPoint:CGPointMake(right, bottom)];
    [path addLineToPoint:CGPointMake(right, top)];
    [path addLineToPoint:CGPointMake(left, top)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.path = path.CGPath;
    self.layer.mask = maskLayer;
    
    CAShapeLayer *borderLayer = [[CAShapeLayer alloc]init];
    borderLayer.path = path.CGPath;
    borderLayer.strokeColor = color.CGColor;
    borderLayer.fillColor = nil;
    borderLayer.name = kGapBorderSublayerName;
    borderLayer.lineWidth = width*2.0;
    [self.layer addSublayer:borderLayer];
}

- (void)clearGap
{
    CALayer *borderLayer = [self.layer layerWithName:kGapBorderSublayerName];
    if (borderLayer) {
        [borderLayer removeFromSuperlayer];
    }
    self.layer.mask = nil;
}

@end

@implementation CALayer(SublayerName)

- (CALayer *)layerWithName:(NSString *)name
{
    if ([self.name isEqualToString:name]) {
        return self;
    }
    
    for (CALayer *sublayer in self.sublayers) {
        CALayer *result = [sublayer layerWithName:name];
        if (result) {
            return result;
        }
    }
    return nil;
}

@end
