//
//  UIView+Gap.h
//  card
//
//  Created by Hale Chan on 15/5/7.
//  Copyright (c) 2015年 Papaya Mobile Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Gap)

- (void)buildBottomGapAtX:(CGFloat)x arrowSize:(CGSize)size borderWidth:(CGFloat)width borderColor:(UIColor *)color;
- (void)clearGap;

@end

@interface CALayer(SublayerName)

- (CALayer *)layerWithName:(NSString *)name;

@end
