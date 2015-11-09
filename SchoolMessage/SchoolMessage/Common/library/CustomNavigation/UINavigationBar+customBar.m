//
//  UINavigationBar+customBar.m
//  cuntomNavigationBar
//
//  Created by Edward on 13-4-22.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "UINavigationBar+customBar.h"

@implementation UINavigationBar (customBar)
- (void)customNavigationBar {
    if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
        if (IOS7)
        {
         [self setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
        }
        UIColor *color = [UIColor whiteColor];
        NSDictionary *dic = [NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
        self.titleTextAttributes = dic;
    } else {
        [self drawRect:self.bounds];
    }
    
    [self drawRoundCornerAndShadow];
}


- (void)drawRect:(CGRect)rect {
     [[UIImage imageNamed:@"nav_bg"] drawInRect:rect];
    if (IOS7)
    {
         [[UIImage imageNamed:@"nav_bg"] drawInRect:rect];
    }
   
}

- (void)drawRoundCornerAndShadow {
    CGRect bounds = self.bounds;
    bounds.size.height +=10;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                   byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                         cornerRadii:CGSizeMake(0, 0)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    
    [self.layer addSublayer:maskLayer];
    self.layer.mask = maskLayer;
    //self.layer.shadowOffset = CGSizeMake(3, 3);
    //self.layer.shadowOpacity = 0.7;
    //self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}
@end
