//
//  ImagePickeBgView.m
//  SWCampus
//
//  Created by WH on 2017/4/22.
//  Copyright © 2017年 WanHang. All rights reserved.
//

#import "ImagePickeBgView.h"

@interface ImagePickeBgView ()
@property (nonatomic,strong) ImagePickerView *imagePick;
@property (nonatomic,strong) CamerView *camera;
@property (nonatomic,assign) NSInteger lastType;

@end
@implementation ImagePickeBgView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}
- (void)initUI{
    _lastType =1;
    self.backgroundColor = hexColor(0xffffff);
    CGFloat bgViewHeight =ScreenHeight - 64.5 -40.5;
    _imagePick = [[ImagePickerView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, bgViewHeight)];
    _imagePick.delegate = self;
    [self addSubview:_imagePick];
    _camera = [[CamerView alloc]initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, bgViewHeight)];
    _camera.delegate = self;
    [self addSubview:_camera];
}
- (void)setGivenImageListDataArr:(NSMutableArray *)givenImageListDataArr{
    _imagePick.photoAssetArr = [givenImageListDataArr mutableCopy];
}
- (void)setCellIntger:(NSInteger)cellIntger{
    
    _imagePick.sectionTger = cellIntger;
}
- (void)camerShootDoneImageData:(NSData *)imageData{
    [self.delegate shootAImageInImageData:imageData];
}
- (NSData * _Nonnull)makePreFiltImage{
    return [_imagePick cutImageInBgView];
}


-(void)listViewUpState:(BOOL)isUpNow{
    [self.delegate bgListUpDonwWithUpState:isUpNow];
}
- (void)showViewWithType:(NSInteger)type{
    if (type == 1) {
        if (_lastType !=1) {
            [UIView animateWithDuration:0.3f animations:^{
                self.frame = CGRectMake(0, self.y,self.width , self.height);
                [self.delegate bgViewMoveDoneInType:1];
                _lastType =1;
            }];
        }
    }else{
        if (_lastType !=2) {
            [UIView animateWithDuration:0.3f animations:^{
                self.frame = CGRectMake(-ScreenWidth, self.y,self.width , self.height);
                [self.delegate bgViewMoveDoneInType:2];
                _lastType =2;
            }];
        }
    }
}
- (void)imagePickDownEvent{
    [_imagePick pickViewDownEvent];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
