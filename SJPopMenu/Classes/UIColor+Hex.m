//
//  UIColor+Hex.m
//  SJPopMenu
//
//  Created by sj on 2022/7/4.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor *)sj_colorWithHex:(long)hexColor
{
    return [UIColor sj_colorWithHex:hexColor alpha:1.];
}

+ (UIColor *)sj_colorWithHex:(long)hexColor alpha:(float)opacity
{
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:opacity];
}


@end
