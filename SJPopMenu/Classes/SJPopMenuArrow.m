//
//  SJPopMenuArrow.m
//  SJPopMenu
//
//  Created by sj on 2022/7/4.
//

#import "SJPopMenuArrow.h"

@interface SJPopMenuArrow ()

@property (nonatomic, strong) UIColor *backColor;

@end

@implementation SJPopMenuArrow

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)backColor
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self.backColor = backColor;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);
    
    CGFloat arrowWid = rect.size.width;
    CGFloat arrowHei = rect.size.height;
    CGContextMoveToPoint(ctx, 0, arrowHei);
    CGContextAddLineToPoint(ctx, arrowWid / 2.0, 0);
    CGContextAddLineToPoint(ctx, arrowWid, arrowHei);
    
    [self.backColor set];
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
}

@end
