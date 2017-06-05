//
//  ImagePickBottomView.h
//  SWCampus
//
//  Created by WH on 2017/4/23.
//  Copyright © 2017年 WanHang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ImagePickBottomViewDelegate <NSObject>

- (void)albumIconClick;
- (void)cameraIconClick;

@end

@interface ImagePickBottomView : UIView
@property (nonatomic,weak) id<ImagePickBottomViewDelegate> delegate;
@property (nonatomic,assign) NSInteger bottomViewTypeOpen;

@end
