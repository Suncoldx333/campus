//
//  UpRefrashView.h
//  SWCampus
//
//  Created by WangZhaoyun on 16/11/4.
//  Copyright © 2016年 WanHang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwiftModule-Swift.h"
#import "LoadingAniView.h"

@interface UpRefrashView : UIView

@property(nonatomic,strong) UpRefrashViewSwift *LoadingStatic;  //静态加载菊花视图
@property(nonatomic)                       int showCount;       //视图展示计数
@property(nonatomic,strong)           NSString *TimerPass;      //修改菊花颜色标识
@property(nonatomic)                      BOOL isLoading;       //菊花是否在 动态展示 状态标识

//动态加载菊花参数
@property(nonatomic)           uint newstart;
@property(nonatomic,strong) NSTimer *newtimer;
@property(nonatomic)           uint newmax;
@property(nonatomic)        CGFloat *newcapacity;
@property(nonatomic,strong) UIBezierPath *path;

-(void)changStaticLaoding:(NSNumber *)num;  //根据上拉距离展示菊花瓣数
-(void)showLoadinAni;                       //展示动态菊花
-(void)EndLoadAni;                          //停止展示动态菊花
-(void)reCount;                             //清空状态

@end
