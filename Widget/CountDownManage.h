//
//  CountDownManage.h
//  SWCampus
//
//  Created by 11111 on 2017/2/12.
//  Copyright © 2017年 WanHang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CountDownManage : NSObject

//时间差(单位:秒),表示已经过去了多少时间
@property (nonatomic) NSInteger timeInterval;
@property (nonatomic,strong) NSTimer *countDownTimer;

+(instancetype)manager;
//开始倒计时
-(void)start;
//刷新倒计时，将时间差重置为0
-(void)reload;
//停止计时器
-(void)stop;

@end
