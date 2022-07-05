//
//  UIColor+Hex.h
//  SJPopMenu
//
//  Created by sj on 2022/7/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Hex)

+ (UIColor *)sj_colorWithHex:(long)hexColor;
+ (UIColor *)sj_colorWithHex:(long)hexColor alpha:(float)opacity;

@end

NS_ASSUME_NONNULL_END
