//
//  CALayer+UIColor.m
//  NewApp
//
//  Created by gxtc on 17/2/15.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "CALayer+UIColor.h"

@implementation CALayer (UIColor)

- (void)setBorderColorFromUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}

@end
