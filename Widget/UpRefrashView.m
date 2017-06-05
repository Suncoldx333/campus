//
//  UpRefrashView.m
//  SWCampus
//
//  Created by WangZhaoyun on 16/11/4.
//  Copyright © 2016年 WanHang. All rights reserved.
//

#import "UpRefrashView.h"
#import "SwiftModule-Swift.h"

const CGFloat  NEWINRADIUS = 5.f; //内径
const CGFloat NEWOUTRADIUS = 9.f; //外径
const CGFloat     NEWWIDTH = 2.f;     //粗细

#define COLORA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface UpRefrashView()

@property (nonatomic,strong) NSThread *thread1;   //新线程，添加一个新的定时器threadTimer
@property (nonatomic,strong)  NSTimer *threadTimer;

@end

@implementation UpRefrashView

@synthesize LoadingStatic;
@synthesize showCount;
@synthesize newstart,newmax,newcapacity,newtimer;
@synthesize TimerPass;
@synthesize path;
@synthesize isLoading;

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
        showCount = 0;
        TimerPass = @"NoPass";
        isLoading = NO;
    }
    return self;
}

-(void)initUI
{
    CGFloat       height = self.bounds.size.height;
    self.backgroundColor = DEFAULT_BG_COLOR;
    
    LoadingStatic = [[UpRefrashViewSwift alloc]initWithFrame:CGRectMake(0, height - 20, ScreenWidth, 20)];
    [self addSubview:LoadingStatic];
    
    newmax = 12;
    CGFloat avg = 1.f/newmax;
    newcapacity = (CGFloat *)malloc(sizeof(CGFloat) *newmax);
    for (int i = 0; i < newmax; i++) {
        newcapacity[i] = 1 - avg * i;
    }
}

#pragma mark -----绘制Load动画
-(void)drawAni
{
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    const CGFloat PI2 = M_PI * 2;
    
    CGFloat x = self.bounds.size.width/2;
    CGFloat y = self.bounds.size.height - 25;
    
    for (int i = 0 ; i < newmax; i++) {
        CGFloat cosa = cos(PI2 / newmax * i);
        CGFloat sina = sin(PI2 / newmax * i);
        
        CGFloat minx = x + NEWINRADIUS * cosa;
        CGFloat miny = y + NEWINRADIUS * sina;
        
        CGFloat maxx = x + NEWOUTRADIUS * cosa;
        CGFloat maxy = y + NEWOUTRADIUS * sina;
        
        path = [UIBezierPath bezierPath];

        [path moveToPoint:CGPointMake(minx, miny)];
        [path addLineToPoint:CGPointMake(maxx, maxy)];
        
        path.lineWidth = NEWWIDTH;
        path.lineCapStyle = kCGLineCapRound;
        
        UIColor *strokeColor;
        if ([TimerPass isEqualToString:@"NoPass"]) {
            strokeColor = [UIColor clearColor];
        }else if ([TimerPass isEqualToString:@"DidPass"]){
            strokeColor = COLORA(0xb2, 0xb2, 0xb2, newcapacity[(i + newstart) % (newmax - 1)]);
        }
        
        [strokeColor set];
        [path stroke];
    }
    newstart = (--newstart + newmax) % newmax;
}

-(void)dealloc
{
    free(newcapacity);
}

#pragma mark -----根据上拉距离显示Load条数
-(void)changStaticLaoding:(NSNumber *)num
{
//    if (isLoading) {
//        LoadingStatic.hidden = YES;
//    }else{
//        LoadingStatic.hidden = NO;
//        [LoadingStatic changeStaLoadWithNum:num];
//    }
}

#pragma mark -----开启Load动画
-(void)showLoadinAni
{
    if (showCount == 0) {

        isLoading = YES;
        
        LoadingStatic.hidden = YES;
        
        __weak __typeof(self) weakself = self;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            __strong __typeof(weakself) strongself = weakself;
            if (strongself) {
                strongself.thread1 = [NSThread currentThread];
                [strongself.thread1 setName:@"县城A"];
                strongself.TimerPass = @"DidPass";
                strongself.threadTimer = [NSTimer scheduledTimerWithTimeInterval:0.05f
                                                                          target:strongself
                                                                        selector:@selector(drawAni)
                                                                        userInfo:nil
                                                                         repeats:YES];
                
                NSRunLoop *runloop = [NSRunLoop currentRunLoop];
                [runloop addTimer:strongself.threadTimer forMode:NSDefaultRunLoopMode];
                [runloop run];
            }
        });
        
        showCount++;
    }
}

#pragma mark -----停止展示Load动画
-(void)EndLoadAni
{
    if (self.threadTimer && self.thread1) {
        [self performSelector:@selector(cancelTimer)
                     onThread:self.thread1
                   withObject:nil
                waitUntilDone:YES];
    }
}

-(void)cancelTimer
{
    if (self.threadTimer) {
        [self.threadTimer invalidate];
        self.threadTimer = nil;
    }
}

#pragma mark -----上拉事件结束清零状态
-(void)reCount
{
    showCount = 0;
    TimerPass = @"NoPass";
    isLoading = NO;
    [self drawAni];
}

@end
