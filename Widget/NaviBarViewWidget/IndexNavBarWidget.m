//
//  IndexNavBarWidget.m
//  WashCar
//
//  Created by yanshengli on 15-1-13.
//  Copyright (c) 2015年 cheletong. All rights reserved.
//

#import "IndexNavBarWidget.h"
#import "CustBgViewWidget.h"
#import "TapImageViewWidget.h"
#import "AppDelegate.h"
#import "UIView+WashCarUtility.h"

//联系客户按钮对应的宽度
#define contactBtnAreaW 82.f
//定位图标的宽度
#define mapIconW 16.f
//定位图标的高度
#define mapIconH 19.f
//显示定位信息label的长度
#define addressW 160.f
//定位图标x偏移量
#define mapIconXPadding 15.f
//分割线的长度
#define seperatorLineW 2.f
//正在定位的提示
#define locatingTitle @"正在获取您的位置，请稍后..."
//定位失败的提示
#define locateFailTitle @"对不起，获取您的位置失败"

/**
 *
 *@description:首页导航栏--接口
 @author:liys
 *@since 2014-1-13
 *
 */
@interface IndexNavBarWidget()
{
    CustBgViewWidget *_headView;//头部背景视图
    TapImageViewWidget *_callServiceBtn;//按钮
    UILabel *_addresslb;//地理位置信息显示的label
}
@end

@implementation IndexNavBarWidget

#pragma mark 代理属性
@synthesize delegate;

#pragma mark 地理位置信息
@synthesize addressInfo;

@synthesize addresslb = _addresslb;

#pragma mark 初始化方法
- (instancetype)init
{
    //初始化
    CGRect selfFrame = Rect(0.f, 0.f, SCREEN_WIDTH, TOP_BLANNER_HEIGHT + SCREEN_HEIGHT_START);
    self = [super initWithFrame:selfFrame];
    if (self)
    {
        self.backgroundColor = hexColorWithAlpha(0x4193cd, 1.0);
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self initSubViews];
}

-(void)updateInfo:(NSString*)newInfo
{
    self.addressInfo = newInfo;
    _addresslb.text = self.addressInfo;
    [self setNeedsDisplay];
}

#pragma mark 初始化子视图
-(void)initSubViews
{
    [self removeAllSubviews];
    //1.头部背景视图
    _headView = [[CustBgViewWidget alloc]initWithFrame:self.bounds
                                         shadowOpacity:1.f
                                           shadowColor:nil
                                          shadowRadius:2.f
                                               bgColor:0x4193cd
                                          bgColorAlpha:1.0
                                          cornerRadius:0
                                         shadowYOffset:2.f
                                         shadowXOffset:0.f];
    [self addSubview:_headView];
    
    //3.定位图标
    CGFloat mapIconX = mapIconXPadding;
    CGFloat mapIconY = SCREEN_HEIGHT_START + (TOP_BLANNER_HEIGHT- mapIconH)/2;
    CGRect  mapIconFrame = (CGRect){mapIconX,mapIconY,mapIconW,mapIconH};
    UIImageView *mapIcon = [[UIImageView alloc]initWithFrame:mapIconFrame];
    mapIcon.image = [UIImage imageNamed:@"myLocation"];
    mapIcon.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:mapIcon];
    UITapGestureRecognizer *locateRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                      action:@selector(locateRecognizerTaped:)];
    [mapIcon addGestureRecognizer:locateRecognizer];

    //5.分割线
    CGFloat lineX = CGRectGetWidth(self.frame) - 82.f;
    CGFloat lineY = SCREEN_HEIGHT_START;
    CGFloat lineW = seperatorLineW;
    CGFloat lineH = TOP_BLANNER_HEIGHT;
    CGRect  lineFrame = Rect(lineX, lineY, lineW, lineH);
    UIImageView *separatorLine = [[UIImageView alloc]initWithFrame:lineFrame];
    separatorLine.image = [UIImage imageNamed:@"seperatorLine"];
    separatorLine.contentMode = UIViewContentModeScaleAspectFit;
    separatorLine.backgroundColor = [UIColor clearColor];
    [self addSubview:separatorLine];
    
    //6.客服按钮区域
    CGFloat callBtnViewW = 82.f;
    CGFloat callBtnViewH = TOP_BLANNER_HEIGHT;
    CGFloat callBtnViewX = CGRectGetMaxX(separatorLine.frame);
    CGFloat callBtnViewY = SCREEN_HEIGHT_START;
    CGRect  callBtnViewFrame = Rect(callBtnViewX, callBtnViewY, callBtnViewW, callBtnViewH);
    UIView *callBtnView = [[UIView alloc]initWithFrame:callBtnViewFrame];
    callBtnView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *callBtnGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callBtnTap:)];
    [callBtnView addGestureRecognizer:callBtnGesture];
    [self addSubview:callBtnView];
    
    //7.客服按钮
    _callServiceBtn = [[TapImageViewWidget alloc]initWithImage:[UIImage imageNamed:@"callIcon"]];
    CGFloat callBtnW = 25.f;
    CGFloat callBtnH = 44.f;
    CGFloat callBtnX = (CGRectGetWidth(callBtnView.frame) - callBtnW)/2;
    CGFloat callBtnY = (CGRectGetHeight(callBtnView.frame) - callBtnH)/2;
    CGRect  callBtnFrame = Rect(callBtnX, callBtnY, callBtnW, callBtnH);
    _callServiceBtn.frame = callBtnFrame;
    _callServiceBtn.backgroundColor = [UIColor clearColor];
    _callServiceBtn.contentMode = UIViewContentModeScaleAspectFit;
    [callBtnView addSubview:_callServiceBtn];
}


#pragma mark   定位
-(void)locateRecognizerTaped:(UITapGestureRecognizer*)gesture
{
    if ([self.delegate respondsToSelector:@selector(locationLabelTap)])
    {
        [self.delegate locationLabelTap];
    }
}

#pragma mark 客服电话按钮被点击的事件
-(void)callBtnTap:(UITapGestureRecognizer*)gesture
{
    [self contactService];
}

#pragma mark 联系客服
-(void)contactService
{
//    [ApplicationDelegate showAlertWithTowBtns:@"提示" message:@"拨打洗车人员电话吗?" doneBtnFinishBlock:^()
//     {
//         [CommonUtils openUrl:WashCarServiceTelNum urltype:TELURL];
//     }];
    
}

@end
