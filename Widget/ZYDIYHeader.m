//
//  ZYDIYHeader.m
//  SWCampus
//
//  Created by 11111 on 2016/12/17.
//  Copyright © 2016年 WanHang. All rights reserved.
//

#import "ZYDIYHeader.h"

@interface ZYDIYHeader()

@property (nonatomic,weak) UIActivityIndicatorView *headerIndi;

@end

@implementation ZYDIYHeader

-(UIActivityIndicatorView *)headerIndi{
    if (!_headerIndi) {
        UIActivityIndicatorView *head = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        head.hidesWhenStopped = YES;
        CGAffineTransform trans = CGAffineTransformMakeScale(1.25f, 1.25f);
        head.transform = trans;
        [self addSubview:_headerIndi = head];
    }
    return _headerIndi;
}

-(void)prepare{
    [super prepare];
    self.backgroundColor = [hexColor(0xff4438) colorWithAlphaComponent:0.3];
    [self.headerIndi stopAnimating];
}

-(void)placeSubviews{
    [super placeSubviews];
    
    self.headerIndi.center = CGPointMake(self.mj_w/2, self.mj_h/2);
    
}

-(void)setState:(MJRefreshState)state{
    
    MJRefreshCheckState
    
    if (state == 1) {
        NSLog(@"empty");
    }else if (state == 2){
        NSLog(@"pulling");
    }else if (state == 3){
        NSLog(@"is now loading");
    }else if (state == 4){
        NSLog(@"will refresh");
    }else if (state == 5){
        NSLog(@"no more");
    }
}

@end
