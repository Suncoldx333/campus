//
//  SWLockViewWidget.m
//  SWCampus
//
//  Created by BruceLiu on 16/6/13.
//  Copyright © 2016年 WanHang. All rights reserved.
//

#import "SWLockViewWidget.h"
#import "FBShimmeringView.h"
#import "WHCircleLockView.h"

@interface SWLockViewWidget()
@property (nonatomic,strong) WHCircleLockView  *gre;
@property (nonatomic,assign) CGFloat    originX;
@property (nonatomic,assign) CGFloat    maxX;
@property (nonatomic,assign) CGFloat    originCenterX;
@property (nonatomic,assign) CGFloat    maxCenterX;
@property (nonatomic,strong) UIImageView * lockImage;
@property (nonatomic,strong) UIBezierPath * maskPath;
@property (nonatomic,assign) BOOL atLeft;

@end

@implementation SWLockViewWidget
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _atLeft = YES;
        [self initUI];
    }
    return self;
}
#pragma mark -初始化界面
-(void)initUI{
    
    _gre = [[WHCircleLockView alloc]init];
    _gre.frame = CGRectMake(0, 0, 50, 40);
    _gre.backgroundColor = hexColor(0xffa800);
    
    //右圆角
    [self corenerRadisOne:UIRectCornerTopRight Two:UIRectCornerBottomRight];
    
    _originX = _gre.frame.origin.x;
    _maxX = self.bounds.size.width-_gre.bounds.size.width;
    _originCenterX = _gre.center.x;

    _maxCenterX = self.bounds.size.width - _gre.bounds.size.width + _gre.frame.size.width/2;
    [self addSubview:_gre];
    
    _lockImage = [MyUtil createIamgeViewFrame:CGRectMake(0, 0, 17, 20) imageName:@"lock"];
    _lockImage.layer.cornerRadius= 0;
    _lockImage.center = _gre.center;
    [_gre addSubview:_lockImage];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [_gre addGestureRecognizer:pan];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(runningRulesLabelClivk)];
    [_gre addGestureRecognizer:recognizer];
    
    __weak typeof(self) weakSelf = self;
    self.removeGestureRecognizerBlock = ^(){
        NSArray *allGesture = weakSelf.gre.gestureRecognizers;
        for (UIGestureRecognizer *gesture in allGesture) {
            [weakSelf.gre removeGestureRecognizer:gesture];
        }
    };
}

-(void)runningRulesLabelClivk{
    if (_atLeft) {
        [UIView animateWithDuration:0.3 animations:^{
            _gre.center = CGPointMake(_maxCenterX, self.frame.size.height/2.0);
            [self getGreX:_gre.frame.origin.x];
            _lockImage.image = [UIImage imageNamed:@"unLock"];
            //左圆角
            [self corenerRadisOne:UIRectCornerTopLeft Two:UIRectCornerBottomLeft];
        }];
        _atLeft = NO;
    }else{
        
        [UIView animateWithDuration:0.3 animations:^{
            _gre.center = CGPointMake(_originCenterX, self.frame.size.height/2.0);
            [self getGreX:_gre.frame.origin.x];
            //右圆角
            [self corenerRadisOne:UIRectCornerTopRight Two:UIRectCornerBottomRight];
            _lockImage.image = [UIImage imageNamed:@"lock"];
        }];
        _atLeft = YES;
    }
    
}

//#pragma mark滑动解锁
- (void)pan:(UIPanGestureRecognizer *)gesture{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:{
            NSLog(@"UIGestureRecognizerStateBegan");
        }
            break;
        case UIGestureRecognizerStateChanged:{
            
            NSLog(@"UIGestureRecognizerStateChanged");
            CGPoint point = [gesture translationInView:_gre];
            NSLog(@"%@",NSStringFromCGPoint(point));
            CGRect rect = _gre.frame;
            rect = CGRectOffset(rect, point.x, 0);
            if(rect.origin.x>_originX &&rect.origin.x<_maxX){
                
                _gre.frame = rect;
                _gre.progress = _gre.center.x/(self.bounds.size.width);
                
                if(_gre.center.x >self.bounds.size.width/2.0){
                    
                    
                }else{
                    
                    
                }
            }
            
            [gesture setTranslation:CGPointZero inView:_gre];

        }
            [self getGreX:_gre.frame.origin.x];
            
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            if(_gre.center.x >self.frame.size.width/2.0){//停靠在右侧
                _lockImage.image = [UIImage imageNamed:@"unLock"];
                //左圆角
                [self corenerRadisOne:UIRectCornerTopLeft Two:UIRectCornerBottomLeft];
                [UIView animateWithDuration:0.25f animations:^{
                    _gre.center = CGPointMake(_maxCenterX, self.frame.size.height/2.0);
                    [self getGreX:_gre.frame.origin.x];
                }];
                
            }else{//停靠在左侧
                //右圆角
                [self corenerRadisOne:UIRectCornerTopRight Two:UIRectCornerBottomRight];
                _lockImage.image = [UIImage imageNamed:@"lock"];
                [UIView animateWithDuration:0.25f animations:^{
                    _gre.center = CGPointMake(_originCenterX, self.frame.size.height/2.0);
                    [self getGreX:_gre.frame.origin.x];
                }];
                
            }
        }
            break;
        default:
            break;
    }

}

-(void)getGreX:(CGFloat)greX{
    
    NSLog(@"X轴坐标%f",greX);
    
    float alphaFloat = greX * (ScreenWidth/(ScreenWidth - _gre.bounds.size.width));
    self.changeMaskViewAlphaBlock(alphaFloat);
    
    if ([self.delegate respondsToSelector:@selector(changeMaskViewWidth:)]) {
        [self.delegate changeMaskViewWidth:alphaFloat];
    }
    
}

//圆角设置
-(void)corenerRadisOne:(NSUInteger)one Two:(NSUInteger)two{
    
    _maskPath = [UIBezierPath bezierPathWithRoundedRect:_gre.bounds byRoundingCorners: one | two cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _gre.bounds;
    maskLayer.path = _maskPath.CGPath;
    _gre.layer.mask = maskLayer;
}



@end
