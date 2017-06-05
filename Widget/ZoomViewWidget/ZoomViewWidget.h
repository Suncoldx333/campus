//
//  ZoomViewWidget.h
//  SWCampus
//
//  Created by BruceLiu on 16/6/12.
//  Copyright © 2016年 WanHang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ZoomViewWidget : NSObject

@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)UIView* bigImageView;
@property(nonatomic,strong)UIView* touXiangImageView;
@property (nonatomic) BOOL  isShowMaskView;
-(void)zoomViewWithTableView:(UITableView*)tableView andBackGroundView:(UIView*)view andSubviews:(UIView*)subviews;

- (void)scrollViewDidScroll:(UIScrollView*)scrollView;
- (void)resizeView;

@end
