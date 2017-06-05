//
//  MJRefreshZYDIYFooter.m
//  SWCampus
//
//  Created by 11111 on 2016/12/18.
//  Copyright © 2016年 WanHang. All rights reserved.
//

#import "MJRefreshZYDIYFooter.h"
#import "SwiftModule-Swift.h"

@interface MJRefreshZYDIYFooter ()

@property (nonatomic,strong) UIActivityIndicatorView *footerIndi;
@property (nonatomic,strong) FooterPullProgressView *footProgress;
@property (nonatomic,strong) UILabel *noMoreLabel;
@property (assign, nonatomic) NSInteger lastRefreshCount;
@property (assign, nonatomic) CGFloat lastBottomDelta;

@end

@implementation MJRefreshZYDIYFooter

-(UIActivityIndicatorView *)footerIndi{
    if (!_footerIndi) {
        UIActivityIndicatorView *foot = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        foot.hidesWhenStopped = YES;
        [self addSubview:_footerIndi = foot];
    }
    return _footerIndi;
}

-(FooterPullProgressView *)footProgress{
    if (!_footProgress) {
        FooterPullProgressView *foot = [[FooterPullProgressView alloc] initWithFrame:CGRectMake(0, -7, ScreenWidth, 20)];
        [self addSubview:_footProgress = foot];
    }
    return _footProgress;
}

-(UILabel *)noMoreLabel{
    if (!_noMoreLabel) {
        UILabel *nomore = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        nomore.backgroundColor = [UIColor clearColor];
        nomore.text = @"暂无更多内容";
        nomore.textColor = hexColor(0xb2b2b2);
        nomore.font = [UIFont systemFontOfSize:9];
        nomore.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_noMoreLabel = nomore];
    }
    
    return _noMoreLabel;
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    
    [self scrollViewContentSizeDidChange:nil];
}

-(void)prepare{
    [super prepare];
    self.backgroundColor = hexColor(0xe6e6e6);
    [self.footerIndi stopAnimating];
    self.footProgress.hidden = NO;
    self.noMoreLabel.hidden = YES;
    self.mj_h = 60;
    self.automaticallyHidden = YES;
}

-(void)placeSubviews{
    [super placeSubviews];
    self.noMoreLabel.center = CGPointMake(self.mj_w/2, 30);
    self.footerIndi.center = CGPointMake(self.mj_w/2, 30);
}

-(void)scrollViewContentSizeDidChange:(NSDictionary *)change{
    [super scrollViewContentSizeDidChange:change];
    
    // 内容的高度
    CGFloat contentHeight = self.scrollView.mj_contentH + self.ignoredScrollViewContentInsetBottom;
    // 表格的高度
//    CGFloat scrollHeight = self.scrollView.mj_h - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom + self.ignoredScrollViewContentInsetBottom;
    CGFloat scrollHeight = self.scrollView.mj_h - 0 - self.scrollViewOriginalInset.bottom + self.ignoredScrollViewContentInsetBottom;
    // 设置位置和尺寸
    self.mj_y = MAX(contentHeight, scrollHeight);
}

-(void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    [super scrollViewContentOffsetDidChange:change];
    
    
    _scrollViewOriginalInset = self.scrollView.contentInset;
    
    // 当前的contentOffset
    CGFloat currentOffsetY = self.scrollView.mj_offsetY;
//    NSLog(@"currentOffsetY=%f",currentOffsetY);
    // 尾部控件刚好出现的offsetY
    CGFloat happenOffsetY = [self happenOffsetY];
//    NSLog(@"happen===%f",happenOffsetY);
    // 如果是向下滚动到看不见尾部控件，直接返回
    if (currentOffsetY <= happenOffsetY) return;
    CGFloat height = currentOffsetY - happenOffsetY;
    if (height <= 60) {
        self.mj_h = 60;
    }else{
        self.mj_h = height;
    }
    [self.footProgress changeDataWithOffset:height];

    // 如果正在刷新，直接返回
    if (self.state == MJRefreshStateRefreshing) return;

    
    CGFloat pullingPercent = (currentOffsetY - happenOffsetY) / 60;
    
    // 如果已全部加载，仅设置pullingPercent，然后返回
    if (self.state == MJRefreshStateNoMoreData) {
        self.pullingPercent = pullingPercent;
        return;
    }
    
    if (self.scrollView.isDragging) {
        self.pullingPercent = pullingPercent;
        // 普通 和 即将刷新 的临界点
        CGFloat normal2pullingOffsetY = happenOffsetY + 60;
        
        if (self.state == MJRefreshStateIdle && currentOffsetY > normal2pullingOffsetY) {
            // 转为即将刷新状态
            self.state = MJRefreshStatePulling;
        } else if (self.state == MJRefreshStatePulling && currentOffsetY <= normal2pullingOffsetY) {
            // 转为普通状态
            self.state = MJRefreshStateIdle;
        }
    } else if (self.state == MJRefreshStatePulling) {// 即将刷新 && 手松开
        // 开始刷新
        [self beginRefreshing];
    } else if (pullingPercent < 1) {
        self.pullingPercent = pullingPercent;
    }
}

-(void)setState:(MJRefreshState)state{
    MJRefreshCheckState
    
    // 根据状态来设置属性
    if (state == MJRefreshStateNoMoreData || state == MJRefreshStateIdle) {
        
        self.footProgress.hidden = NO;
        
        // 刷新完毕
        if (MJRefreshStateRefreshing == oldState) {
            if (state == MJRefreshStateNoMoreData) {
                self.noMoreLabel.hidden = NO;
                self.footProgress.hidden = YES;
                [self.footerIndi stopAnimating];
            }else{
                _noMoreLabel.hidden = YES;
                [self.footerIndi stopAnimating];
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                    self.scrollView.mj_insetB -= 60;
                    
                    // 自动调整透明度
                    if (self.isAutomaticallyChangeAlpha) self.alpha = 0.0;
                } completion:^(BOOL finished) {
                    self.pullingPercent = 0.0;
                    self.state = MJRefreshStateIdle;
                    self.noMoreLabel.hidden = YES;
                    if (self.endRefreshingCompletionBlock) {
                        self.endRefreshingCompletionBlock();
                    }
                }];
            });
        }
        
        CGFloat deltaH = [self heightForContentBreakView];
        // 刚刷新完毕
        if (MJRefreshStateRefreshing == oldState && deltaH > 0) {
            self.scrollView.mj_offsetY = self.scrollView.mj_offsetY;
        }
    } else if (state == MJRefreshStateRefreshing) {
        // 记录刷新前的数量
        
        self.footProgress.hidden = YES;
        [self.footerIndi startAnimating];
        
        self.lastRefreshCount = self.scrollView.mj_totalDataCount;
        
        [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
            CGFloat bottom = self.mj_h + self.scrollViewOriginalInset.bottom;
            CGFloat deltaH = [self heightForContentBreakView];
            if (deltaH < 0) { // 如果内容高度小于view的高度
                bottom -= deltaH;
            }
            self.lastBottomDelta = bottom - self.scrollView.mj_insetB;
            self.scrollView.mj_insetB = 60;
            self.scrollView.mj_offsetY = [self happenOffsetY] + 60;
        } completion:^(BOOL finished) {
            [self executeRefreshingCallback];
        }];
    }else if (state == MJRefreshStatePulling){
        self.footProgress.hidden = YES;
        [self.footerIndi startAnimating];
    }
}

- (void)endRefreshing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.state = MJRefreshStateIdle;
    });
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.state = MJRefreshStateIdle;
//    });
}

- (void)endRefreshingWithNoMoreData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.state = MJRefreshStateNoMoreData;
    });

    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.state = MJRefreshStateNoMoreData;
//    });
}

#pragma mark - 私有方法
#pragma mark 获得scrollView的内容 超出 view 的高度
- (CGFloat)heightForContentBreakView{
    CGFloat h = self.scrollView.frame.size.height - 0 - self.scrollViewOriginalInset.top;
    return self.scrollView.contentSize.height - h;
}

#pragma mark 刚好看到上拉刷新控件时的contentOffset.y
- (CGFloat)happenOffsetY{
    CGFloat deltaH = [self heightForContentBreakView];
//    NSLog(@"deltah====%f",deltaH);
    if (deltaH > 0) {
        return deltaH - self.scrollViewOriginalInset.top;
    } else {
        return - self.scrollViewOriginalInset.top;
    }
}

-(void)dealloc{
}

@end
