//
//  CamerView.m
//  SWCampus
//
//  Created by WH on 2017/4/22.
//  Copyright © 2017年 WanHang. All rights reserved.
//

#import "CamerView.h"

@interface CamerView ()

@property (nonatomic,strong) UIButton *takePhotoButton;
@property (nonatomic,strong) AVCaptureDevice *device;
@property (nonatomic,strong) AVCaptureDeviceInput *input;
@property (nonatomic,strong) AVCaptureStillImageOutput *imageOutput;
@property (nonatomic,strong) AVCaptureSession *session;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *preViewlayer;
@property (nonatomic,strong) UIImageView *photoTurnImage;
@property (nonatomic,strong) UIImageView *photoFlashImage;
@property (nonatomic,strong) UIView *cameraPreView;


@end


@implementation CamerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self initUI];
    }
    return self;
}
- (void)initData{
    _device = [self CamerWithPosition:AVCaptureDevicePositionBack];
    _input=[[AVCaptureDeviceInput alloc]initWithDevice:_device error:nil];
    _imageOutput=[[AVCaptureStillImageOutput alloc]init];
    _imageOutput.outputSettings=@{AVVideoCodecKey:AVVideoCodecJPEG};
    _session=[[AVCaptureSession alloc]init];
    _session.sessionPreset = AVCaptureSessionPreset1280x720;
    if([_session canAddInput:_input])
        [_session addInput:_input];
    if([_session canAddOutput:_imageOutput])
        [_session addOutput:_imageOutput];
    _cameraPreView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
    _cameraPreView.backgroundColor = [UIColor clearColor];
    [self addSubview:_cameraPreView];
    _preViewlayer =[[AVCaptureVideoPreviewLayer alloc]initWithSession:_session];
    _preViewlayer.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth);
    [_preViewlayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_cameraPreView.layer addSublayer:_preViewlayer];
    [self ChangeFlashModel:AVCaptureFlashModeOff];
    [_session startRunning];
}
- (void)initUI{
    self.backgroundColor = [YXFFTools colorWithHexString:@"#ffffff"];
    _takePhotoButton =[[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth*.5f -40.f, (ScreenHeight - 64.5 + ScreenWidth - 40.5)*.5f-40.f, 80.f, 80.f)];
    [_takePhotoButton setBackgroundImage:[UIImage imageNamed:@"takePhotos"] forState:UIControlStateNormal];
    [_takePhotoButton setBackgroundImage:[UIImage imageNamed:@"takingPhotos"] forState:UIControlStateSelected];
    [_takePhotoButton addTarget:self action:@selector(TakePhotosClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_takePhotoButton];
    
    _photoTurnImage =[[UIImageView alloc]initWithFrame:CGRectMake(15, ScreenWidth -40, 30, 30)];
    _photoTurnImage.userInteractionEnabled = YES;
    _photoTurnImage.layer.cornerRadius = 15.f;
    _photoTurnImage.layer.masksToBounds =YES;
    _photoTurnImage.image =[UIImage imageNamed:@"photoTurn"];
    [_cameraPreView addSubview:_photoTurnImage];
    
    UIControl *turnControl =[[UIControl alloc]initWithFrame:CGRectMake(-5, -5, 40, 40)];
    [turnControl addTarget:self action:@selector(TurnControl:) forControlEvents:UIControlEventTouchUpInside];
    [_photoTurnImage addSubview:turnControl];
    
    _photoFlashImage =[[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth -45, ScreenWidth -40, 30, 30)];
    _photoFlashImage.userInteractionEnabled = YES;
    _photoFlashImage.layer.cornerRadius = 15.f;
    _photoFlashImage.layer.masksToBounds =YES;
    _photoFlashImage.image =[UIImage imageNamed:@"unlighting"];
    _photoFlashImage.highlightedImage = [UIImage imageNamed:@"lighting"];
    
    [_cameraPreView addSubview:_photoFlashImage];
    UIControl *flashControl =[[UIControl alloc]initWithFrame:CGRectMake(-5, -5, 40, 40)];
    [flashControl addTarget:self action:@selector(FlashControl:) forControlEvents:UIControlEventTouchUpInside];
    [_photoFlashImage addSubview:flashControl];
    
}
- (AVCaptureDevice *)CamerWithPosition:(AVCaptureDevicePosition)position{
    AVCaptureDevice *device=nil;
    NSArray *devices=[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for(AVCaptureDevice *tmp in devices){
        if(tmp.position == position)
            device  = tmp;
    }
    return device;
}
- (void)ChangeFlashModel:(AVCaptureFlashMode)model{
    if ([_device hasTorch]) {
        [_device lockForConfiguration:nil];
        if ([_device isFlashModeSupported:model]) {
            _device.flashMode = model;
        }
        [_device unlockForConfiguration];
    }
    
}
- (void)TakePhotosClick:(UIButton *)sender{
    if (!sender.selected) {
        sender.selected = YES;
        AVCaptureConnection *connect=[_imageOutput connectionWithMediaType:AVMediaTypeVideo];
        if(!connect){
            NSLog(@"++拍照失败+++");
            sender.selected =NO;
            return;
        }else{
            [_imageOutput captureStillImageAsynchronouslyFromConnection:connect completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
                if(imageDataSampleBuffer == NULL){
                    sender.selected =NO;
                    return;
                }else{
                    NSData *imageData=[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                    sender.selected =NO;
                    [self.delegate camerShootDoneImageData:imageData];
                }
            }];
        }
        
    }
}
- (void)TurnControl:(UIControl *)sender{
    sender.selected=!sender.isSelected;
    AVCaptureDevice *newCamera = nil;
    AVCaptureDeviceInput *newInput = nil;
    //切换至前置摄像头
    if(sender.isSelected){
        newCamera = [self CamerWithPosition:AVCaptureDevicePositionFront];
        newInput=[[AVCaptureDeviceInput alloc]initWithDevice:newCamera error:nil];
    }else{
        //切换至后置摄像头
        newCamera = [self CamerWithPosition:AVCaptureDevicePositionBack];
        
        newInput=[[AVCaptureDeviceInput alloc]initWithDevice:newCamera error:nil];
    }
    if (newInput !=nil) {
        [_session beginConfiguration];
        [_session removeInput:_input];
        if([_session canAddInput:newInput]){
            [_session addInput:newInput];
            _input = newInput;
        }else{
            [_session addInput:_input];
        }
        [_session commitConfiguration];
    }
    
}
- (void)FlashControl:(UIControl *)sender{
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasFlash]){
        [device lockForConfiguration:nil];
        if (!sender.isSelected){
            //闪光灯开
            [device setFlashMode:AVCaptureFlashModeOn];
            _photoFlashImage.highlighted =YES;
        }else{
            //闪光灯关
            [device setFlashMode:AVCaptureFlashModeOff];
            _photoFlashImage.highlighted =NO;
        }
        //闪光灯自动
//        [_device setFlashMode:AVCaptureFlashModeAuto];
        [device unlockForConfiguration];
    }
    sender.selected=!sender.isSelected;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
