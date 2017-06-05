//
//  PanGesCpuntDownView.h
//  SWCampus
//
//  Created by 11111 on 2017/2/12.
//  Copyright © 2017年 WanHang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol panCountDownDelegate <NSObject>

-(void)timeCountDownDone;

@end

@interface PanGesCpuntDownView : UIView

@property (nonatomic,strong) NSTimer *panGesTimer;
@property (nonatomic,strong) UILabel *leftTimeLabel;
@property (nonatomic) NSInteger goneTime;
@property (nonatomic,strong) NSString *givenLeftTime;
@property (nonatomic,strong) NSString *locLeftTime;
@property (nonatomic,weak) id<panCountDownDelegate> delegate;

-(void)start;
-(void)stop;

@end
