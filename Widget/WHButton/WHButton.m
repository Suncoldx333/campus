//
//  WHButton.m
//  test
//
//  Created by 周少文 on 16/3/11.
//  Copyright © 2016年 周少文. All rights reserved.
//

#import "WHButton.h"

@interface WHButton ()<CAAnimationDelegate>
{
    int _count;
}
@property (nonatomic,strong) CALayer *fadeLayer;
@property (nonatomic,strong) CAShapeLayer *shaperLayer;
@property (nonatomic,getter=isCanClick) BOOL canClick;
@property (nonatomic,strong) NSString *myTitle;
@property (nonatomic,strong) CADisplayLink *link;

@end

@implementation WHButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.layer.cornerRadius = frame.size.height/2.0;
        self.canClick = YES;
        [self addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
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

- (void)btnClick:(UIButton *)sender
{
    if(!self.isCanClick)
        return;
    self.canClick = NO;
    self.fadeLayer.hidden = NO;
    if(self.fadeLayer.superlayer ==nil){
        [sender.layer addSublayer:self.fadeLayer];
    }
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    basicAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, self.fadeLayer.bounds.size.width, self.fadeLayer.bounds.size.height)];
    basicAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, sender.bounds.size.width, sender.bounds.size.height)];
    basicAnimation.duration = 0.25f;
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    basicAnimation.delegate = self;
    [self.fadeLayer addAnimation:basicAnimation forKey:@"animation1"];
    if(_delegate &&[_delegate respondsToSelector:@selector(buttonClicked:)])
    {
        [_delegate buttonClicked:self];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(flag)
    {
        CABasicAnimation *animation1 = (CABasicAnimation *)[self.fadeLayer animationForKey:@"animation1"];
        
        CABasicAnimation *animation2 = (CABasicAnimation *)[self.layer animationForKey:@"animation2"];
        
        CABasicAnimation *animation4 = (CABasicAnimation *)[self.layer animationForKey:@"animation4"];
        if(anim ==animation1)
        {
            [self setTitle:@"" forState:UIControlStateNormal];
            self.fadeLayer.hidden = YES;
            CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
            basicAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
            basicAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.height)];
            basicAnimation.duration = 0.25f;
            basicAnimation.removedOnCompletion = NO;
            basicAnimation.fillMode = kCAFillModeForwards;
            basicAnimation.delegate = self;
            [self.layer addAnimation:basicAnimation forKey:@"animation2"];
        }else if(anim ==animation2)
        {
            //            self.shaperLayer.hidden = NO;
            _shaperLayer = [CAShapeLayer layer];
            _shaperLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.bounds.size.height*0.8f, self.bounds.size.height*0.8f)].CGPath;
            _shaperLayer.fillColor = [UIColor clearColor].CGColor;
            _shaperLayer.strokeColor = [UIColor whiteColor].CGColor;
            _shaperLayer.bounds = CGRectMake(0, 0, self.bounds.size.height*0.8f, self.bounds.size.height*0.8f);
            NSLog(@"%@",NSStringFromCGRect(_shaperLayer.bounds));
            _shaperLayer.position = CGPointMake(self.bounds.size.height/2.0, self.bounds.size.height/2.0);

            self.layer.cornerRadius = self.frame.size.height/2;

            self.layer.cornerRadius=self.frame.size.height/2;

            [self.layer addSublayer:_shaperLayer];
            
            _shaperLayer.strokeStart = 0;
            _shaperLayer.strokeEnd = 0;
            
            CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            basicAnimation.fromValue = @(0);
            basicAnimation.toValue = @(M_PI*2);
            basicAnimation.repeatCount = MAXFLOAT;
            basicAnimation.duration = 1;
            basicAnimation.delegate = self;
            [_shaperLayer addAnimation:basicAnimation forKey:@"animation3"];
        }else if (anim ==animation4)
        {
            self.canClick = YES;
            [self setTitle:self.myTitle forState:UIControlStateNormal];
            //            [_shaperLayer removeAnimationForKey:@"animation3"];
            //            [_shaperLayer removeAllAnimations];
            //            [_shaperLayer removeFromSuperlayer];
            //            [self.link removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        }
    }
}

//- (CAShapeLayer *)shaperLayer
//{
//    if(_shaperLayer ==nil)
//    {
//    }
//
//    return _shaperLayer;
//}

- (void)animationDidStart:(CAAnimation *)anim
{
    CABasicAnimation *animation = (CABasicAnimation *)[_shaperLayer animationForKey:@"animation3"];
    if(anim ==animation)
    {
        
        [self.link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)displayLink:(CADisplayLink *)object
{
    _count += 1;
    CGFloat progress = _count/60.0;
    if(progress <=0.8f)
    {
        _shaperLayer.strokeEnd = progress;
    }
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    if(title.length>0)
    {
        self.myTitle = title;
    }
}

- (CADisplayLink *)link
{
    if(_link ==nil)
    {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLink:)];
    }
    
    return _link;
}

- (void)doBackAnimation
{
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    basicAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.height)];
    basicAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    basicAnimation.delegate = self;
    basicAnimation.duration = 0.25f;
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:basicAnimation forKey:@"animation4"];
    [self.shaperLayer removeAllAnimations];
    [self.shaperLayer removeFromSuperlayer];
    [self.link removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    self.layer.cornerRadius=3;
    self.link = nil;
    _count = 0;
    
}

- (void)doBackAnimation:(double) time{
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    basicAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.height)];
    basicAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    basicAnimation.delegate = self;
    basicAnimation.duration = time;
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:basicAnimation forKey:@"animation4"];
    [self.shaperLayer removeAllAnimations];
    [self.shaperLayer removeFromSuperlayer];
//    [self.link removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    self.layer.cornerRadius=3;
    self.link = nil;
    _count = 0;
}


@end
