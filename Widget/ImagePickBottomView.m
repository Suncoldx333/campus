//
//  ImagePickBottomView.m
//  SWCampus
//
//  Created by WH on 2017/4/23.
//  Copyright © 2017年 WanHang. All rights reserved.
//

#import "ImagePickBottomView.h"

@interface ImagePickBottomView ()
@property (nonatomic,strong) UILabel *albumLabel;
@property (nonatomic,strong) UILabel *cameraLabel;
@property (nonatomic,strong) UILabel *filterLabel;
@property (nonatomic,assign) NSInteger bottomViewType;
@property (nonatomic,assign) NSInteger currentChose;
@end

@implementation ImagePickBottomView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}
- (void)initUI{
    _currentChose =0;
    self.frame =CGRectMake(0, ScreenHeight-40.5, ScreenWidth, 40.5);
    self.backgroundColor =hexColor(0xfafafa);
    UITapGestureRecognizer *typeTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(typeChose:)];
    [self addGestureRecognizer:typeTap];
    
    UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenHeight, .5f)];
    lineView.backgroundColor =hexColor(0xcccccc);
    [self addSubview:lineView];
    
    _filterLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, .5f, ScreenWidth, 40.f)];
    _filterLabel.textColor =hexColor(0x333333);
    _filterLabel.font =[UIFont boldSystemFontOfSize:13.f];
    _filterLabel.textAlignment =NSTextAlignmentCenter;
    _filterLabel.text = @"滤镜";
    _filterLabel.hidden =YES;
    [self addSubview:_filterLabel];
    
    _albumLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, .5f, ScreenWidth*.5f, 40.f)];
    _albumLabel.textColor =hexColor(0x333333);
    _albumLabel.font =[UIFont boldSystemFontOfSize:13.f];
    _albumLabel.textAlignment =NSTextAlignmentCenter;
    _albumLabel.text = @"图库";
    _albumLabel.hidden =YES;
    [self addSubview:_albumLabel];
    
    _cameraLabel =[[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth*.5f, .5f, ScreenWidth*.5f, 40.f)];
    _cameraLabel.textColor =hexColor(0xb2b2b2);
    _cameraLabel.font =[UIFont boldSystemFontOfSize:13.f];
    _cameraLabel.textAlignment =NSTextAlignmentCenter;
    _cameraLabel.text = @"拍照";
    _cameraLabel.hidden =YES;
    [self addSubview:_cameraLabel];
}
- (void)typeChose:(UITapGestureRecognizer *)sender{
    CGFloat tapX =[sender locationInView:self].x;
    if (_bottomViewType ==0) {
        if (tapX <ScreenWidth*.5f) {
            if (_currentChose !=0) {
                _currentChose = 0;
                _albumLabel.textColor =hexColor(0x333333);
                _cameraLabel.textColor =hexColor(0xb2b2b2);
                [self.delegate albumIconClick];
            }else{
                NSLog(@"拍照");
            }
        }else{
            if (_currentChose !=1) {
                _currentChose = 1;
                _albumLabel.textColor =hexColor(0xb2b2b2);
                _cameraLabel.textColor =hexColor(0x333333);
                [self.delegate cameraIconClick];
            }else{
                NSLog(@"图库");
            }
        }
    }else{
        NSLog(@"滤镜");
    }
}
- (void)setBottomViewTypeOpen:(NSInteger)bottomViewTypeOpen{
    _bottomViewType =bottomViewTypeOpen;
    if (bottomViewTypeOpen == 0) {
        _filterLabel.hidden = YES;
        _albumLabel.hidden = NO;
        _cameraLabel.hidden = NO;
    }else{
        _filterLabel.hidden = NO;
        _albumLabel.hidden = YES;
        _cameraLabel.hidden = YES;
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
