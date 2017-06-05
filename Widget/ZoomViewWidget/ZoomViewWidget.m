//
//  ZoomViewWidget.m
//  SWCampus
//
//  Created by BruceLiu on 16/6/12.
//  Copyright © 2016年 WanHang. All rights reserved.
//

#import "ZoomViewWidget.h"

@implementation ZoomViewWidget
{
    CGRect  initFrame;
    CGFloat defaultViewHeight;
    CGRect   subViewsFrame;
    UIView *maskView;
}
-(void)zoomViewWithTableView:(UITableView *)tableView andBackGroundView:(UIView *)view andSubviews:(UIView *)subviews
{
    
    _tableView                     = tableView;
    _bigImageView                  = view;
    _touXiangImageView             = subviews;
    initFrame                      = _bigImageView.frame;
    defaultViewHeight              = initFrame.size.height;
    subViewsFrame                  = _touXiangImageView.frame;
    
    
    
    
    UIView* heardView=[[UIView alloc] initWithFrame:initFrame];
    self.tableView.tableHeaderView = heardView;
    
    [_tableView addSubview:_bigImageView];
    
    if (self.isShowMaskView) {
        maskView                 = [[UIView alloc] initWithFrame:view.frame];
        maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.15];
        maskView.clipsToBounds   = YES;
        maskView.contentMode     = UIViewContentModeScaleAspectFill;
        [_tableView addSubview:maskView];
    }
    
    [_tableView addSubview:_touXiangImageView];
    
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect f     = _bigImageView.frame;
    f.size.width = _tableView.frame.size.width;
    _bigImageView.frame  = f;
    
    if (scrollView.contentOffset.y<0) {
        CGFloat offset = (scrollView.contentOffset.y + scrollView.contentInset.top) * -1;
        
        initFrame.origin.x    = - offset /2;
        initFrame.origin.y    = - offset;
        initFrame.size.width  = _tableView.frame.size.width+offset;
        initFrame.size.height = defaultViewHeight+offset;
        _bigImageView.frame   = initFrame;
        maskView.frame        = initFrame;
        
        [self viewDidLayoutSubviews:offset/2];
        
        
    }
    
    
}
- (void)viewDidLayoutSubviews:(CGFloat)offset
{
}
- (void)resizeView
{
    initFrame.size.width = _tableView.frame.size.width;
    _bigImageView.frame  = initFrame;
    
}

@end
