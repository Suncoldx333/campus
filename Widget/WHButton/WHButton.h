//
//  WHButton.h
//  test
//
//  Created by 周少文 on 16/3/11.
//  Copyright © 2016年 周少文. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WHButton;

@protocol WHButtonClickDelegate <NSObject>

- (void)buttonClicked:(WHButton *)sender;

@end

@interface WHButton : UIButton

@property (nonatomic,assign) id<WHButtonClickDelegate> delegate;

- (void)doBackAnimation;
- (void)doBackAnimation:(double) time;
@end
