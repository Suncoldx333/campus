//
//  TopicCustomNaView.m
//  SWCampus
//
//  Created by WH on 2017/4/23.
//  Copyright © 2017年 WanHang. All rights reserved.
//

#import "TopicCustomNaView.h"
@interface TopicCustomNaView ()
@property (nonatomic,strong) UIButton *centerButton;
@end

@implementation TopicCustomNaView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}
- (void)initUI{
    self.frame =CGRectMake(0, 20, ScreenWidth, 44.5);
    self.backgroundColor =hexColor(0xfafafa);
    _leftButton =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44.f, 44.f)];
    [_leftButton addTarget:self action:@selector(navCloseTap:) forControlEvents:UIControlEventTouchUpInside];
    [_leftButton setImage:[UIImage imageNamed:@"downMark"] forState:UIControlStateNormal];
    _leftButton.adjustsImageWhenHighlighted =NO;
    [self addSubview:_leftButton];
    
    _centerLabel =[[UILabel alloc]initWithFrame:CGRectMake(50, 0, ScreenWidth -50-50, 44.f)];
    _centerLabel.userInteractionEnabled = YES;
    _centerLabel.textColor =hexColor(0x333333);
    _centerLabel.font = [UIFont boldSystemFontOfSize:13.f];
    _centerLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_centerLabel];
    
    _centerButton =[[UIButton alloc]initWithFrame:CGRectMake(50, 0, ScreenWidth -50-50, 44.f)];
    [_centerButton addTarget:self action:@selector(centerTap:) forControlEvents:UIControlEventTouchUpInside];
    [_centerLabel addSubview:_centerButton];
    
    _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-46, 0, 44.f, 44.f)];
    [_rightButton setTitleColor:hexColor(0x333333) forState:UIControlStateNormal];
    _rightButton.titleLabel.font =[UIFont systemFontOfSize:13.f];
    _rightButton.titleLabel.textAlignment =NSTextAlignmentRight;
    
    [_rightButton setImage:[UIImage imageNamed:@"sureMark"] forState:UIControlStateNormal];
    _rightButton.adjustsImageWhenHighlighted =NO;
    [_rightButton addTarget:self action:@selector(navRightTap:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rightButton];
    
    UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth, .5f)];
    lineView.backgroundColor =hexColor(0xcccccc);
    [self addSubview:lineView];
}
- (void)navCloseTap:(UIButton *)sender{
    [self.delegate leftIconClick];
}
- (void)centerTap:(UIButton *)sender{
    if ([_centerLabel.text isEqualToString:@"拍摄照片"]) {
    }else{
        [self.delegate centerIconClick];
    }
}
- (void)navRightTap:(UIButton *)sender{
    [self.delegate rightIconClick];
}
- (void)ChangeRightTitle:(NSString *)title and:(BOOL)imageBool{
    if (imageBool) {
        _rightButton.hidden =NO;
        _rightButton.titleLabel.hidden =YES;
    }else{
        _rightButton.hidden =YES;
        _rightButton.titleLabel.hidden =NO;
    }
}
- (void)setLeftImage:(NSString *)leftImage{
    [_leftButton setImage:[UIImage imageNamed:leftImage] forState:UIControlStateNormal];
}
- (void)setContentExitTag:(NSInteger)contentExitTag{
    if (contentExitTag == 0) {
        _rightButton.titleLabel.textColor =hexColorWithAlpha(0x333333, 0.3f);
    }else{
        _rightButton.titleLabel.textColor =hexColorWithAlpha(0x333333, 1.f);
    }
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
