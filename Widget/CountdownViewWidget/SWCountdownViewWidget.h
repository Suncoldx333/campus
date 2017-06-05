//
//  SWCountdownViewWidget.h
//  SWCampus
//
//  Created by BruceLiu on 16/6/14.
//  Copyright © 2016年 WanHang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^completeCountDownBlock)(void);

@interface SWCountdownViewWidget : UIView


@property (nonatomic,copy) completeCountDownBlock complete;

@end
