//
//  ImagePickerDIYVC.h
//  SWCampus
//
//  Created by 11111 on 2017/3/2.
//  Copyright © 2017年 WanHang. All rights reserved.
//

#import "BaseViewController.h"
#import "PhotoTool.h"
//#import "SwiftModule-Swift.h"
#import "PhotoAlbumModel.h"

#import "ImagePickeBgView.h"
#import "ImagePickerView.h"
#import "TopicCustomNaView.h"
#import "ImagePickBottomView.h"

@class ImagePickerDIYVC;

@interface ImagePickerDIYVC : BaseViewController<UICollectionViewDelegate,topicCustomNaViewDelegate,ImagePickBottomViewDelegate,imagePickeBgDelegate>

@property (nonatomic,strong) PhotoTool *photoTool;
@property (nonatomic,strong) NSIndexPath *lastIndex;
@property (nonatomic,strong) TopicCustomNaView *customNav;
@property (nonatomic,strong) ImagePickBottomView *bottomView;
@property (nonatomic,strong) ImagePickerView *pickView;
@property (nonatomic,strong) ImagePickeBgView *pickBgView;
@property (nonatomic,strong) void(^imageDataBlock)(ImagePickerDIYVC *filter,NSData *imageData);




@end
