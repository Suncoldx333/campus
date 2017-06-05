//
//  LoadingAniView.h
//  SWCampus
//
//  Created by WangZhaoyun on 16/8/19.
//  Copyright © 2016年 WanHang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingAniView : UIView

+(instancetype)initWithTitle:(NSString *)title;

@property (nonatomic,strong) NSTimer *timer;

-(void)changUIToFit:(CGPoint)AniCenter;

@end
