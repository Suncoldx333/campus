//
//  ImagePickeBgView.h
//  SWCampus
//
//  Created by WH on 2017/4/22.
//  Copyright © 2017年 WanHang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoTool.h"
#import "CamerView.h"
#import "ImagePickerView.h"


@protocol imagePickeBgDelegate <NSObject>

-(void)bgViewMoveDoneInType:(NSInteger)type;
-(void)shootAImageInImageData:(NSData * _Nonnull)imageData;
-(void)bgListUpDonwWithUpState:(BOOL)upState;

@end

@interface ImagePickeBgView : UIView <imagePickerDelegate,camerViewDelegate>


@property (nonatomic,weak) id<imagePickeBgDelegate>_Null_unspecified delegate;

@property (nonatomic, strong) NSMutableArray * _Nonnull givenImageListDataArr;

@property (nonatomic,assign) NSInteger cellIntger;

- (NSData * _Nonnull)makePreFiltImage;
- (void)showViewWithType:(NSInteger)type;
- (void)listViewUpState:(BOOL)isUpNow;
- (void)imagePickDownEvent;

@end
