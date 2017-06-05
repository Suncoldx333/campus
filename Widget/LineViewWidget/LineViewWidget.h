//
//  LineViewWidget.h
//  SWCampus
//
//  Created by bruceliu on 2/26/16.
//  Copyright © 2016 WanHang. All rights reserved.
//

#import <UIKit/UIKit.h>


/***
 *
 *@description:划线视图--接口
 *@author:bruceliu
 *@since:2016-6-10
 *@corp:WanHang
 */
@interface LineViewWidget : UIView

#pragma mark 线的16进制颜色
@property (nonatomic,assign)long lineColor;

#pragma mark 线的宽度
@property (nonatomic,assign)int lineWidth;

#pragma mark 线的高度
@property (nonatomic,assign)int lineHeight;

#pragma mark线的透明度
@property (nonatomic,assign)CGFloat lineAlpha;

#pragma mark 距离父视图的x方向的偏移
@property (nonatomic,assign)CGFloat xOffset;

#pragma mark 距离父视图的y方向的偏移
@property (nonatomic,assign)CGFloat yOffset;

#pragma mark 初始化方法
- (id)initWithXoffset:(CGFloat)nXOffset yOffset:(CGFloat)nYOffset lineHeight:(CGFloat)nLineHeight lineWidth:(CGFloat)nLineWidth lineColor:(long)nLineColor lineAlpha:(CGFloat)nLineAlpha;

@end
