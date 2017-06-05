//
//  TopicCustomNaView.h
//  SWCampus
//
//  Created by WH on 2017/4/23.
//  Copyright © 2017年 WanHang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol topicCustomNaViewDelegate <NSObject>

-(void)leftIconClick;
-(void)centerIconClick;
-(void)rightIconClick;

@end

@interface TopicCustomNaView : UIView

@property (nonatomic,weak) id<topicCustomNaViewDelegate> delegate;

@property (nonatomic,strong) NSString *leftImage;
@property (nonatomic,strong) UIButton *leftButton;

@property (nonatomic,strong) UILabel  *centerLabel;
@property (nonatomic,strong) UIButton *rightButton;
@property (nonatomic,assign) NSInteger contentExitTag;

- (void)ChangeRightTitle:(NSString *)title and:(BOOL)imageBool;

@end
