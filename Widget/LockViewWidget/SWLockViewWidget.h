//
//  SWLockViewWidget.h
//  SWCampus
//
//  Created by BruceLiu on 16/6/13.
//  Copyright © 2016年 WanHang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  SWLockViewWidgetDelegate <NSObject>

@required
-(void)unlockSuccessEvent;
-(void)changeMaskViewWidth:(CGFloat)width;

@end
@interface SWLockViewWidget : UIView

@property (nonatomic,weak) id<SWLockViewWidgetDelegate> delegate;
@property (nonatomic,copy) void (^changeMaskViewAlphaBlock) (CGFloat alphaFloat);
@property (nonatomic,copy) void (^removeGestureRecognizerBlock)(void);

@end
