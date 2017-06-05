//
//  SWCountdownViewWidget.m
//  SWCampus
//
//  Created by BruceLiu on 16/6/14.
//  Copyright © 2016年 WanHang. All rights reserved.
//

#import "SWCountdownViewWidget.h"
#import "UIView+Animation.h"

@interface SWCountdownViewWidget(){

    int secondsCountDown;
}

@property (nonatomic,strong) UILabel *labelText;
@property (nonatomic,strong) NSTimer *countDownTimer;
@end

@implementation SWCountdownViewWidget

@synthesize complete;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;

}
#pragma mark -初始化界面
-(void)initUI{
    self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.backgroundColor = RGB(30, 192, 141);
    [self createTimeView];
}
#pragma mark －倒计时view
-(void)createTimeView
{
    //创建UILabel 添加到当前view
    _labelText=[[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2.5, ScreenHeight/2.668, ScreenWidth/1.875,ScreenHeight/3.335)];
    _labelText.font = [UIFont systemFontOfSize:160];
    _labelText.textColor = [UIColor whiteColor];
    [self addSubview:_labelText];
    _labelText.textAlignment = NSTextAlignmentCenter;
    _labelText.center = CGPointMake(ScreenWidth/2.0,ScreenHeight/2.0);
    _labelText.text = @"3";
    [self scaleAnimationForPop];
    //设置倒计时总时长
    secondsCountDown = 3;//60秒倒计时
    //开始倒计时
    // 播放语音
   // [CommonUtils playSound];
    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES]; //启动倒计时后会每秒钟调用一次方法 timeFireMethod
    [[NSRunLoop currentRunLoop] addTimer:_countDownTimer forMode:NSRunLoopCommonModes];
    
    
}
-(void)timeFireMethod{
    
    [self scaleAnimationForPop];
    //倒计时-1
    secondsCountDown--;
    //修改倒计时标签现实内容
    
    _labelText.text=[NSString stringWithFormat:@"%d",secondsCountDown];
    
    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    if(secondsCountDown==0){
        [_countDownTimer invalidate];
        _countDownTimer = nil;
        [_labelText removeFromSuperview];
        if (complete != nil) {
            complete();
        }
    }
}
-(void)dealloc{
    [_countDownTimer invalidate];
    _countDownTimer = nil;
}
@end
