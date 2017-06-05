//
//  DashViewWidget.m
//  SWCampus
//
//  Created by 11111 on 2016/12/29.
//  Copyright © 2016年 WanHang. All rights reserved.
//

#import "DashViewWidget.h"

@implementation DashViewWidget

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

-(void)initUI
{
    self.backgroundColor = [UIColor clearColor];
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    
    CGContextSetLineWidth(ctx, 0.5f);
    CGContextSetShouldAntialias(ctx, NO);
    CGContextSetStrokeColorWithColor(ctx, hexColor(0xe6e6e6).CGColor);
    
    CGFloat length[] = {2.5,2.5};
    CGContextSetLineDash(ctx, 0, length, 2);
    
    CGContextMoveToPoint(ctx, 0, 0.25);
    CGContextAddLineToPoint(ctx, self.frame.size.width, 0.25);
    
    CGContextStrokePath(ctx);
}

@end
