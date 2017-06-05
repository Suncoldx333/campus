//
//  LoadingAniView.m
//  SWCampus
//
//  Created by WangZhaoyun on 16/8/19.
//  Copyright © 2016年 WanHang. All rights reserved.
//

#import "LoadingAniView.h"

const CGFloat INRADIUS = 11.5f;
const CGFloat OUTRADIUS = 7.f;
const CGFloat WIDTH = 1.5f;

#define COLORA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface LoadingAniView ()

{
    uint _start;
    NSTimer *_timer;
    uint _max;  //展示几条
    CGFloat *_capacity;
}

@end

@implementation LoadingAniView

@synthesize timer;

+(instancetype)initWithTitle:(NSString *)title
{
    LoadingAniView *ani = [[[self class] alloc]init];
    [ani initUIWithTitle:title];
    return ani;
}

-(void)initUIWithTitle:(NSString *)title
{
    self.frame = CGRectMake(0, 0, 100, 80);
    self.backgroundColor = [hexColor(0x333333) colorWithAlphaComponent:0.8];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4.f;
    
    [self initInfoLabelWithTitle:title];
    
    _max = 12;
    CGFloat avg = 1.f/_max;
    _capacity = (CGFloat *)malloc(sizeof(CGFloat) *_max);
    for (int i = 0; i < _max; i++) {
        _capacity[i] = 1 - avg*i;
    }
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.05f
                                             target:self
                                           selector:@selector(draw)
                                           userInfo:nil
                                            repeats:YES];

}

-(void)initInfoLabelWithTitle:(NSString *)title
{
    UILabel *info      = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 12)];
    info.text          = [NSString stringWithFormat:@"%@...",title];
    info.textColor     = hexColor(0xffffff);
    info.font          = [UIFont systemFontOfSize:12];
    info.textAlignment = NSTextAlignmentCenter;
    [self addSubview:info];
    
    [info mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 12));
        make.centerX.equalTo(self).with.offset(0);
        make.bottom.mas_equalTo(self).with.offset(-15);
    }];
}

-(void)draw
{
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    
    [super drawRect:rect];
    
    const CGFloat PI2 = M_PI * 2;
    
    CGFloat x = self.bounds.size.width/2;
    CGFloat y = self.bounds.size.height/2 - 12.5;
    
    for (int i = 0 ; i < _max; i++) {
        
//        NSLog(@"refrashin======%d",i);
        
        CGFloat cosa = cos(PI2 / _max * i);
        CGFloat sina = sin(PI2 / _max * i);
        
        CGFloat minx = x + INRADIUS * cosa;
        CGFloat miny = y + INRADIUS * sina;
        
        CGFloat maxx = x + OUTRADIUS * cosa;
        CGFloat maxy = y + OUTRADIUS * sina;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        [path moveToPoint:CGPointMake(minx, miny)];
        [path addLineToPoint:CGPointMake(maxx, maxy)];
        
        path.lineWidth = WIDTH;
        path.lineCapStyle = kCGLineCapRound;
        
        UIColor *strokeColor = COLORA(0xff, 0xff, 0xff, _capacity[(i + _start) % (_max - 1)]);
        
        [strokeColor set];
        [path stroke];
    }
    _start = (--_start + _max) % _max;
}

-(void)dealloc
{
    free(_capacity);
}

-(void)changUIToFit:(CGPoint)AniCenter
{
    self.center = AniCenter;
}

@end
