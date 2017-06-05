//
//  CamerView.h
//  SWCampus
//
//  Created by WH on 2017/4/22.
//  Copyright © 2017年 WanHang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CamerView;

@protocol camerViewDelegate <NSObject>

- (void)camerShootDoneImageData:(NSData *)imageData;

@end

@interface CamerView : UIView
@property (nonatomic,weak) id<camerViewDelegate> delegate;

@end
