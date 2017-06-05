//
//  LoadingCircleView.m
//  SWCampus
//
//  Created by WangZhaoyun on 16/8/19.
//  Copyright © 2016年 WanHang. All rights reserved.
//

#import "LoadingCircleView.h"

@implementation LoadingCircleView

@synthesize timer;

+(instancetype)initWithTitle:(NSString *)title
{
    LoadingCircleView *loading = [[[self class] alloc]init];
    [loading initUIWithTitle:title];
    return loading;
}

-(void)initUIWithTitle:(NSString *)title
{
    self.frame = CGRectMake(0, 0, 100, 80);
    self.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    
    [self initBgViewWithTitle:title];
}

-(void)changCireCleCenter{
    CGFloat height = ScreenHeight/2 - 69.5 - 39.5;

    self.center = CGPointMake(ScreenWidth/2, height);
}

-(void)initBgViewWithTitle:(NSString *)title
{
    LoadingAniView *ani = [LoadingAniView initWithTitle:title];
    [self addSubview:ani];
}

-(void)dismiss
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

@end
