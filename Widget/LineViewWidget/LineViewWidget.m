//
//  LineViewWidget.m
//  SWCampus
//
//  Created by bruceliu on 2/26/16.
//  Copyright © 2016 WanHang. All rights reserved.
//

#import "LineViewWidget.h"

@implementation LineViewWidget

#pragma mark 线的颜色
@synthesize lineColor;

#pragma mark 线的宽度
@synthesize lineWidth;

#pragma mark 线的高度
@synthesize lineHeight;

#pragma mark线的透明度
@synthesize lineAlpha;

#pragma mark 距离父视图的x方向的偏移
@synthesize xOffset;

#pragma mark 距离父视图的y方向的偏移
@synthesize yOffset;

#pragma mark 初始化方法
- (id)initWithXoffset:(CGFloat)nXOffset yOffset:(CGFloat)nYOffset lineHeight:(CGFloat)nLineHeight lineWidth:(CGFloat)nLineWidth lineColor:(long)nLineColor lineAlpha:(CGFloat)nLineAlpha
{
    self = [super initWithFrame:Rect(nXOffset, nYOffset, nLineWidth, nLineHeight)];
    if (self)
    {
        self.lineHeight = nLineHeight;
        self.lineWidth = nLineWidth;
        self.xOffset = nXOffset;
        self.yOffset = nYOffset;
        self.lineColor = nLineColor;
        self.lineAlpha = nLineAlpha;
        self.backgroundColor = hexColorWithAlpha(nLineColor, nLineAlpha);
    }
    return self;
    
}

//- (void)drawRect:(CGRect)rect
//{
//
//}
@end
