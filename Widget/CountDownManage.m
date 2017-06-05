//
//  CountDownManage.m
//  SWCampus
//
//  Created by 11111 on 2017/2/12.
//  Copyright © 2017年 WanHang. All rights reserved.
//

#import "CountDownManage.h"

@implementation CountDownManage

@synthesize timeInterval,countDownTimer;

+(instancetype)manager{
    static CountDownManage *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CountDownManage alloc]init];
    });
    return manager;
}

-(void)start{
    [self countDownTimer];
}

-(void)reload{
    timeInterval = 0;
}

-(void)stop{
    [countDownTimer invalidate];
    countDownTimer = nil;
}

-(NSTimer *)countDownTimer{
    if (countDownTimer == nil) {
        
        countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.f
                                                          target:self
                                                        selector:@selector(timerAction)
                                                        userInfo:nil
                                                         repeats:YES];
    }
    return countDownTimer;
}

- (void)timerAction {
    // 时间差+1
    timeInterval ++;
    NSString *time = [NSString stringWithFormat:@"%ld",(long)timeInterval];
    NSDictionary *timeDic = @{@"TimeInterval" : time};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CountDownNotification"
                                                        object:nil
                                                      userInfo:timeDic];
}


@end
