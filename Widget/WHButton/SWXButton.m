


//
//  SWXButton.m
//  test
//
//  Created by 董丽娟 on 16/3/11.
//  Copyright © 2016年 周少文. All rights reserved.
//

#import "SWXButton.h"

@interface SWXButton ()<CAAnimationDelegate>

@property (nonatomic,strong) CALayer *fadeLayer;
@property (nonatomic,strong) CAShapeLayer *shaperLayer;
@property (nonatomic,strong) NSString *myTitle;
@property (nonatomic,strong) CADisplayLink *link;

@end

@implementation SWXButton


-(void) intWithFadeLayer:(UIButton *) sender{
    
    if(self.fadeLayer.superlayer ==nil)
    {
        [sender.layer addSublayer:self.fadeLayer];
    }
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    basicAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, self.fadeLayer.bounds.size.width, self.fadeLayer.bounds.size.height)];
    basicAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, sender.bounds.size.width, sender.bounds.size.height)];
    basicAnimation.duration = 0.28f;
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    basicAnimation.delegate = self;
    [self.fadeLayer addAnimation:basicAnimation forKey:@"animation1"];

}


- (CALayer *)fadeLayer
{
    if(_fadeLayer ==nil)
    {
        _fadeLayer = [CALayer layer];
        _fadeLayer.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.35f].CGColor;
        _fadeLayer.bounds = CGRectMake(0, 0, self.bounds.size.height*1.2f, self.bounds.size.height);
        _fadeLayer.position = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
        _fadeLayer.cornerRadius = _fadeLayer.bounds.size.height/2.0;
        
    }
    
    return _fadeLayer;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.fadeLayer removeFromSuperlayer];
    
}

@end
