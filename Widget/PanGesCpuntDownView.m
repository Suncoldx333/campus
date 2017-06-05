//
//  PanGesCpuntDownView.m
//  SWCampus
//
//  Created by 11111 on 2017/2/12.
//  Copyright © 2017年 WanHang. All rights reserved.
//

#import "PanGesCpuntDownView.h"

@implementation PanGesCpuntDownView

@synthesize panGesTimer;
@synthesize leftTimeLabel;
@synthesize goneTime;
@synthesize locLeftTime;

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = hexColor(0xffffff);
        [self initData];
        [self initUI];
    }
    return self;
}

-(void)initData{
    goneTime = 0;
}

-(void)initUI{
    self.backgroundColor = [hexColor(0x000000) colorWithAlphaComponent:0.4];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 30;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 53, 53)];
    bgView.backgroundColor = hexColor(0x4c4c4c);
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 26.5;
    bgView.center = CGPointMake(ViewWidth(self)/2, ViewHeight(self)/2);
    [self addSubview:bgView];
    
    leftTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, ViewWidth(self), 15)];
    leftTimeLabel.textColor = hexColor(0xffffff);
    leftTimeLabel.font = [UIFont fontWithName:@"Impact" size:15];
    leftTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:leftTimeLabel];
    
    UILabel *leftTimeTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ViewHeight(self) - 17 - 8, ViewWidth(self), 8)];
//    leftTimeTipLabel.text = @"距离约跑";
    leftTimeTipLabel.textColor = hexColor(0xffffff);
    leftTimeTipLabel.font = [UIFont systemFontOfSize:8];
    leftTimeTipLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:leftTimeTipLabel];
    leftTimeTipLabel.attributedText = [self createSlashCountTome:@"距离约跑"];
}

-(void)start{
    [self panGesTimer];
}

-(void)reload{
    goneTime = 0;
}

-(void)stop{
    [panGesTimer invalidate];
    panGesTimer = nil;
}

-(NSTimer *)panGesTimer{
    if (panGesTimer == nil) {
        panGesTimer = [NSTimer scheduledTimerWithTimeInterval:1.f
                                                       target:self
                                                     selector:@selector(changeLeftTime)
                                                     userInfo:nil
                                                      repeats:YES];
    }
    return panGesTimer;
}

-(void)changeLeftTime{
    goneTime ++;
    
    int locLeftInt = locLeftTime.intValue;
    int newLft = locLeftInt - [NSNumber numberWithInteger:goneTime].intValue * 1000;
    
    if (newLft < 1000) {
        [self stop];
        [self reload];
        [self.delegate timeCountDownDone];
    }else{
        NSString *newLftStr = [NSString stringWithFormat:@"%d",newLft];
        NSString *leftTimeStr = [self changeTimeFormatter:newLftStr];
        leftTimeLabel.attributedText = [self createSlashCountTome:leftTimeStr];
    }
}

-(void)setGivenLeftTime:(NSString *)givenLeftTime{
    locLeftTime = givenLeftTime;
    NSString *leftTimeStr = [self changeTimeFormatter:givenLeftTime];
    leftTimeLabel.attributedText = [self createSlashCountTome:leftTimeStr];
    
    [self reload];
    [self start];
}

-(NSString *)changeTimeFormatter:(NSString *)time{
    int shortTime = time.intValue/1000;
    NSString *time_min = [NSString stringWithFormat:@"%02d",(shortTime%3600)/60];
    NSString *time_sec = [NSString stringWithFormat:@"%02d",shortTime%60];
    NSString *leftTimeStr = [NSString stringWithFormat:@"%@:%@",time_min,time_sec];
    return leftTimeStr;
}

-(NSMutableAttributedString *)createSlashCountTome:(NSString *)countDownTime {
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:countDownTime];
    
    NSMutableDictionary *slashDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithFloat:0.2],NSObliquenessAttributeName, nil];
    
    [attr addAttributes:slashDic range:NSMakeRange(0, countDownTime.length)];
    return attr;
}

@end
