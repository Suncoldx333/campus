//
//  ImagePickerFilterVC.h
//  SWCampus
//
//  Created by 11111 on 2017/3/7.
//  Copyright © 2017年 WanHang. All rights reserved.
//

#import "BaseViewController.h"
#import "SwiftModule-Swift.h"
#import <CoreImage/CoreImage.h>

#import "TopicCustomNaView.h"
#import "ImagePickBottomView.h"

@class ImagePickerFilterVC;

@protocol imageFilterDelegate <NSObject>

-(void)imageFilterIn:(ImagePickerFilterVC *)filter filtedData:(NSData *)imageData;

@end
@interface ImagePickerFilterVC : BaseViewController<topicCustomNaViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>


@property (nonatomic,strong) TopicCustomNaView *customNav;
@property (nonatomic,strong) ImagePickBottomView *bottomView;
@property (nonatomic,weak) id<imageFilterDelegate> delegate;
@property (nonatomic,strong) void(^imageBlock)(ImagePickerFilterVC *filter,NSData *imageData);
@property (nonatomic,strong) void(^filterCancelBlock)(ImagePickerFilterVC *filter);

@property (nonatomic,assign) BOOL photosBooL;


-(void)fillBGViewWith:(NSData *)imageData;

@end
