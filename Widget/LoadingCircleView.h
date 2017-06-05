//
//  LoadingCircleView.h
//  SWCampus
//
//  Created by WangZhaoyun on 16/8/19.
//  Copyright © 2016年 WanHang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingAniView.h"

@interface LoadingCircleView : UIView
/**
 *  创建方法
 *
 *  @param title 下方文字，eg:“正在保存...”,限制为四个汉字，省略号自动添加
 *
 */
+(instancetype)initWithTitle:(NSString *)title;
-(void)changCireCleCenter;
/**
 *  加载动画消失
 */
-(void)dismiss;

@property (nonatomic,strong) NSTimer *timer;

@end
