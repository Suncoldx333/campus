//
//  ImagePickerView.m
//  SWCampus
//
//  Created by 11111 on 2017/3/8.
//  Copyright © 2017年 WanHang. All rights reserved.
//

#import "ImagePickerView.h"
#import "ImagePickerCell.h"
#import "LoadingCircleView.h"

#define COLLECTIONLISTHEIGHT ScreenHeight - 70.5 - 40.5
#define HorizontalBoundray 8.000 / 15.000 * ScreenWidth
#define VerticalBoundray 4.000 / 5.000 * ScreenWidth
#define cellPlist      @"cellImagePlist"

@implementation ImagePickerView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initData];
        [self initUI];
        
    }
    return self;
}

-(void)initData{
    _isPickViewUp = NO;
    _photoManage = [PhotoTool sharePhotoTool];
    _photoAssetArr = [[NSMutableArray alloc] init];
}

-(void)initUI{
    _chosenImageBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
    _chosenImageBGView.clipsToBounds = YES;
    _chosenImageBGView.backgroundColor = hexColor(0xfcfcfc);
    UITapGestureRecognizer *bgTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewTap:)];
    [_chosenImageBGView addGestureRecognizer:bgTap];
    [self addSubview:_chosenImageBGView];
    
    _chosenImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
    _chosenImage.contentMode = UIViewContentModeScaleAspectFill;
    _chosenImage.clipsToBounds = YES;
    _chosenImage.userInteractionEnabled = YES;
    [_chosenImageBGView addSubview:_chosenImage];
    
    UIPanGestureRecognizer *chosenImagePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(imagePanInView:)];
    [_chosenImage addGestureRecognizer:chosenImagePan];
    
    UIPinchGestureRecognizer *chosenImagePin = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(imagePinInView:)];
    [_chosenImage addGestureRecognizer:chosenImagePin];
    
    
    _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
    _shadowView.backgroundColor = [hexColor(0x333333) colorWithAlphaComponent:0.8f];
    _shadowView.userInteractionEnabled = NO;
    _shadowView.hidden = YES;
    [_chosenImageBGView addSubview:_shadowView];

    //相册内图片列表
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _albumCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, ScreenWidth + 1.f, ScreenWidth, ViewHeight(self) - ScreenWidth - 1.f) collectionViewLayout:flowLayout];
    [_albumCollectionView registerClass:[ImagePickerCell class]
                   forCellWithReuseIdentifier:@"ImagePickerCell"];
    _albumCollectionView.backgroundColor = hexColor(0xffffff);
    _albumCollectionView.dataSource = self;
    _albumCollectionView.delegate = self;
    _albumCollectionView.scrollEnabled = YES;
    [self addSubview:_albumCollectionView];
    [self addSubview:self.zoomButton];
}
- (UIButton *)zoomButton{
    if (!_zoomButton) {
        _zoomButton =[[UIButton alloc]initWithFrame:CGRectMake(10, _chosenImageBGView.maxY - 45, 40, 40)];
        [_zoomButton setImage:[UIImage imageNamed:@"imageZoom"] forState:UIControlStateNormal];
        [_zoomButton addTarget:self action:@selector(ImagesZoomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _zoomButton;
}
#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//动态设置每个Item的尺寸大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((ScreenWidth - 3)/4, (ScreenWidth - 3)/4);
}

//动态设置每个分区的EdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//设置某个分区头视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(300, 0);
}

//动态设置每行的间距大小
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1.f;
}

//动态设置每列的间距大小
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1.f;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (self.photoAssetArr.count > 0) {
        return self.photoAssetArr.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImagePickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImagePickerCell" forIndexPath:indexPath];
    cell.imageCellTag = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
    if (indexPath.row == 0) {
        cell.frontView.hidden = NO;
        _lastIndex = indexPath;
    }else{
        cell.frontView.hidden = YES;
    }

    PHAsset *asset = [_photoAssetArr objectAtIndex:indexPath.row];
    [_photoManage createLittleImageBy:asset In:CGSizeMake(ScreenWidth *.35f, ScreenWidth *.35f) andBlock:^(NSData *data, NSDictionary *info) {
        cell.imageInPHAsset = [[UIImage alloc] initWithData:data];
    }];

    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ImagePickerCell *cell = (ImagePickerCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.frontView.hidden = NO;
    PHAsset *asset = [self.photoAssetArr objectAtIndex:indexPath.row];

    [_photoManage createImageBy:asset andBlock:^(NSData *data, NSDictionary *info) {
        self.chosenImage.image = [[UIImage alloc] initWithData:data];
        [self changeImageFrame:self.chosenImage];
        _preFrame = _chosenImage.frame;
        _oriFrame = _chosenImage.frame;
    }];

    if (_lastIndex && _lastIndex.row != indexPath.row) {
        ImagePickerCell *cellLast = (ImagePickerCell *)[collectionView cellForItemAtIndexPath:_lastIndex];
        cellLast.frontView.hidden = YES;
    }
    
    _lastIndex = indexPath;
    
}
- (void)setPhotoAssetArr:(NSMutableArray *)photoAssetArr{
    _photoAssetArr = photoAssetArr;
    [_albumCollectionView reloadData];
    PHAsset *asset = [_photoAssetArr firstObject];
    [_photoManage createImageBy:asset andBlock:^(NSData *data, NSDictionary *info) {
          _chosenImage.image = [[UIImage alloc]initWithData:data];
          [self changeImageFrame:self.chosenImage];
          _preFrame = _chosenImage.frame;
          _oriFrame = _chosenImage.frame;
    }];
}
- (void)ImagesZoomButtonClick:(UIButton *)sender{
    if (!sender.selected) {
        [self RecoverImageSize:self.chosenImage.image];
        sender.selected = true;
    }else{
        _chosenImage.image = _chosenImage.image;
        [self changeImageFrame:_chosenImage];
        sender.selected = false;
    }
}
- (void)RecoverImageSize:(UIImage *)curImage{
    CGFloat height = curImage.size.height;
    CGFloat width = curImage.size.width;
    CGFloat minValue = _oriFrame.size.width > _oriFrame.size.height ? _oriFrame.size.height : _oriFrame.size.width;
    if (minValue >(ceil(4.0f / 5.0f * ScreenWidth)+1.f)) {
        if (height >width) {
            [UIView animateWithDuration:0.18 animations:^{
                _chosenImage.width = ScreenWidth *.8f;
                _chosenImage.height = ScreenWidth *.8f*(height/width);
                _chosenImage.center = CGPointMake(ScreenWidth*.5f, ScreenWidth*.5f);
            }];
        }else{
            CGFloat newHeight = ceil(ScreenWidth*(8/15.f));
            CGFloat newWidth = ceil(ScreenWidth*(8/15.f)*(width/height));
            if (newWidth <=ScreenWidth) {
                newHeight = ScreenWidth*(height/width);
                newWidth = ScreenWidth;
            }
            [UIView animateWithDuration:0.18 animations:^{
                _chosenImage.height = newHeight;
                _chosenImage.width = newWidth;
                _chosenImage.center = CGPointMake(ScreenWidth*.5f, ScreenWidth*.5f);
                _chosenImage.contentMode =UIViewContentModeScaleAspectFill;
            }];
        }
    }
}
//修改选中的图片的尺寸
-(void)changeImageFrame:(UIImageView *)imageView{
    if (imageView.image) {
        UIImage *curImage = imageView.image;
        
        CGFloat width = curImage.size.width *1.000;
        CGFloat height = curImage.size.height *1.000;
        CGFloat minValue = width > height ? height : width;
        BOOL widthMin = height > width ? YES : NO;
        CGFloat newWidth =ScreenWidth;
        CGFloat newHeight =ScreenWidth;
        if (minValue <= 200.f) {
            CGFloat newOriginal = ceil(4.0f / 5.0f * ScreenWidth);
            if (widthMin) {
                newHeight = ceil(height / width * newOriginal);
                newWidth =newHeight *(width/height);
            }else{
                newWidth = ceil(width / height * newOriginal);
                newHeight = (height/width)*newWidth;
            }
        }else{
            if (widthMin){
                newWidth = ScreenWidth;
                newHeight = ceil(height / width * newWidth);
            }else{
                if (height != width) {
                    newHeight =ScreenWidth;
                    newWidth = ceil(width / height * newHeight);
                }else{
                    newHeight = ScreenWidth;
                    newWidth = ScreenWidth;
                }
            }
        }
        imageView.frame =CGRectMake(CGRectGetMidX(imageView.frame)-newWidth*.5f, CGRectGetMidY(imageView.frame)-newHeight*.5f, newWidth, newHeight);
        imageView.center =CGPointMake(ScreenWidth*.5f, ScreenWidth*.5f);
    }
}
-(void)bgViewTap:(UITapGestureRecognizer *)sender{
    CGFloat y = [sender locationInView:_chosenImageBGView].y;
    if (y > ScreenWidth - 50) {
        if (!_isPickViewUp) {
            [self pickViewUpEvent];
        }else{
            [self pickViewDownEvent];
        }
    }
}


- (void)pickViewUpEvent{
    _shadowView.hidden = NO;
    _zoomButton.highlighted =YES;
    _zoomButton.alpha =0.8f;
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.frame = CGRectMake(0, 70 - ScreenWidth - 64.5, ScreenWidth, ScreenHeight - 64.5 - 40.5 + ScreenWidth - 6.5);
                         _albumCollectionView.frame = CGRectMake(0, ScreenWidth + 0.5, ScreenWidth, ScreenHeight - 64.5 - 40.5 - 7);
                         _shadowView.backgroundColor = [hexColor(0x333333) colorWithAlphaComponent:0.8];
                     }
                     completion:^(BOOL finished) {
                         [self.delegate listViewUpState:YES];
                         _isPickViewUp = YES;
                         _chosenImage.userInteractionEnabled = NO;
                     }];
}
-(void)pickViewDownEvent{
    _zoomButton.highlighted =NO;
    _zoomButton.alpha =1.f;
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64.5 - 40.5);
                         _albumCollectionView.frame =CGRectMake(0, ScreenWidth + 1.f, ScreenWidth, self.height - ScreenWidth - 1.f);
                         _shadowView.backgroundColor = [hexColor(0x333333) colorWithAlphaComponent:0];
                     }
                     completion:^(BOOL finished) {
                         [self.delegate listViewUpState:NO];
                         _isPickViewUp = NO;
                         _shadowView.hidden = YES;
                         _chosenImage.userInteractionEnabled = YES;
                     }];
}

//选中的图片拖动事件
-(void)imagePanInView:(UIPanGestureRecognizer *)sender{
    UIImageView *imageView = (UIImageView *)sender.view;
    
    CGFloat width = imageView.frame.size.width;
    CGFloat height = imageView.frame.size.height;
    
    CGPoint oldPoint = imageView.center;
    CGPoint newPoint = [sender translationInView:_chosenImageBGView];
    
    CGFloat newX = oldPoint.x + newPoint.x;
    CGFloat newY = oldPoint.y + newPoint.y;
    
    if (newX > width/2) {
        if (width > ScreenWidth) {
            newX = width/2;
        }else{
            newX = oldPoint.x;
        }
    }else if (newX < ScreenWidth - width/2){
        if (width > ScreenWidth) {
            newX = ScreenWidth - width/2;
        }else{
            newX = width/2;
        }
    }
    
    if (newY > height/2){
        if (height > ScreenWidth) {
            newY = height/2;
        }else{
            newY = oldPoint.y;
        }
    }else if (newY < ScreenWidth - height/2){
        if (height > ScreenWidth) {
            newY = ScreenWidth - height/2;
        }else{
            newY = height/2;
        }
    }
    
    imageView.center = CGPointMake(newX, newY);
    [sender setTranslation:CGPointZero inView:_chosenImageBGView];
    
    _preFrame = imageView.frame;
}

//选中的图片缩小/放大事件
-(void)imagePinInView:(UIPinchGestureRecognizer *)sender{
    UIImageView *imageView = (UIImageView *)sender.view;
    CGFloat width = _preFrame.size.width * sender.scale;
    CGFloat height = _preFrame.size.height * sender.scale;
    BOOL widthMin = height > width ? YES : NO;
    imageView.frame = CGRectMake(CGRectGetMidX(_preFrame) - width*.5f, CGRectGetMidY(_preFrame) - height*.5f, width, height);
    
    CGFloat minValue = _oriFrame.size.height < _oriFrame.size.width ? _oriFrame.size.height : _oriFrame.size.width;
    
    CGFloat newScale;
    CGFloat newWidth;
    CGFloat newHeight;
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (minValue <= ceil(4.0f / 5.0f * ScreenWidth)+1.f) {
            if (widthMin) {
                newWidth = ceil(4.0f / 5.0f * ScreenWidth)+1.f;
                newHeight =newWidth *(height/width);
            }else{
                newHeight = ceil(4.0f / 5.0f * ScreenWidth)+1.f;
                newWidth =newHeight * (width/height);
            }
            [self UIViewAnimateWith:imageView Width:newWidth Height:newHeight];
        }else{
            if ((minValue >_oriFrame.size.width*5)||(minValue >_oriFrame.size.height*5)) {
                newWidth = _oriFrame.size.width * 5;
                newHeight = _oriFrame.size.height * 5;
                [self UIViewAnimateWith:imageView Width:newWidth Height:newHeight];
            }else{
                if (height >width) {
                    if (height<ScreenWidth){
                        newScale = ScreenWidth / imageView.frame.size.height;
                        newWidth = imageView.frame.size.width * newScale;
                        if (newWidth <VerticalBoundray) {
                            newScale = VerticalBoundray / imageView.frame.size.width;
                            newWidth = imageView.frame.size.width * newScale;
                        }
                        newHeight = imageView.frame.size.height * newScale;
                        [self UIViewAnimateWith:imageView Width:newWidth Height:newHeight];
                    }
                    if (width <VerticalBoundray) {
                        newScale = VerticalBoundray / imageView.frame.size.width;
                        newHeight = imageView.frame.size.height * newScale;
                        if (newHeight <ScreenWidth) {
                            newScale = ScreenWidth / imageView.frame.size.height;
                            newHeight = imageView.frame.size.height * newScale;
                        }
                        newWidth = imageView.frame.size.width * newScale;
                        [self UIViewAnimateWith:imageView Width:newWidth Height:newHeight];
                    }
                }else if(width > height){
                    if (width <ScreenWidth) {
                        newScale = ScreenWidth / imageView.frame.size.width;
                        newHeight = imageView.frame.size.height * newScale;
                        if (newHeight < HorizontalBoundray) {
                            newScale = HorizontalBoundray / imageView.frame.size.height;
                            newHeight = imageView.frame.size.height * newScale;
                        }
                        newWidth = imageView.frame.size.width * newScale;
                        
                        [self UIViewAnimateWith:imageView Width:newWidth Height:newHeight];
                    }
                    if (height < HorizontalBoundray) {
                        newScale = HorizontalBoundray / imageView.frame.size.height;
                        newWidth = imageView.frame.size.width * newScale;
                        if (newWidth <ScreenWidth) {
                            newScale = ScreenWidth / imageView.frame.size.width;
                            newWidth = imageView.frame.size.width * newScale;
                        }
                        newHeight = imageView.frame.size.height * newScale;
                        [self UIViewAnimateWith:imageView Width:newWidth Height:newHeight];
                    }
                }else{
                    if (width < ScreenWidth) {
                        newScale = ScreenWidth / imageView.frame.size.width;
                        newWidth = imageView.frame.size.width * newScale;
                        newHeight = imageView.frame.size.height * newScale;
                        [self UIViewAnimateWith:imageView Width:newWidth Height:newHeight];
                    }
                }
            }
        }
        _preFrame = imageView.frame;
    }
}
- (void)UIViewAnimateWith:(UIImageView *)imageView Width:(CGFloat )newWidth Height:(CGFloat )newHeight{
    [UIView animateWithDuration:.2f animations:^{
        imageView.frame =CGRectMake(CGRectGetMidX(imageView.frame) - newWidth*.5f, CGRectGetMidY(imageView.frame) - newHeight*.5f, newWidth, newHeight);
        imageView.center = CGPointMake(ViewWidth(_chosenImageBGView)*.5f, ViewWidth(_chosenImageBGView)*.5f);
    }];
}
-(NSData *)cutImageInBgView{
    
    CGFloat width = ceil(_preFrame.size.width);
    CGFloat height = ceil(_preFrame.size.height);
    
    CGFloat cutX = width > ScreenWidth ? 0 : (ScreenWidth - width)/2;
    CGFloat cutY = height > ScreenWidth ? 0 : (ScreenWidth - height)/2;
    CGFloat cutWidth = width > ScreenWidth ? ScreenWidth : width;
    CGFloat cutHeight = height > ScreenWidth ? ScreenWidth : height;
    float mutfloat =0.2f;
    
    NSData *imageData =UIImageJPEGRepresentation(_chosenImage.image, 1.f);
    CGFloat length = [imageData length]/1000;
    NSLog(@"%f++++",length);
    if (length <=1000) {
        mutfloat =1.f;
    }else{
        if (length >1000 && length <=2000) {
            mutfloat =0.9f;
        }else if(length >2000 && length <=3000){
            mutfloat =0.85f;
        }else if(length >3000 && length <=3500){
            mutfloat =0.82f;
        }else if(length >3500 && length <=4000){
            mutfloat =0.7f;
        }else if(length >4000 && length <=4500){
            mutfloat =0.6f;
        }else if(length >4500 && length <=5000){
            mutfloat =0.55f;
        }else if(length >5000 && length <=5500){
            mutfloat =0.50f;
        }else if(length >5500 && length <=6000){
            mutfloat =0.45f;
        }else if(length >6500 && length <=7000){
            mutfloat =0.4f;
        }else if(length >7000 && length <=7500){
            mutfloat =0.38f;
        }else if(length >7500 && length <=8000){
            mutfloat =0.36f;
        }else if(length >8000 && length <=8500){
            mutfloat =0.35f;
        }else if(length >8500 && length <=9000){
            mutfloat =0.33f;
        }else if (length >9000 && length <=10000){
            mutfloat =0.31f;
        }else{
            mutfloat =0.3f;
        }
    }
    
    UIImage *cuttedImage =[self BeCutImageView:self.chosenImage Rect:CGRectMake(cutX, cutY, cutWidth, cutHeight) Multiple:mutfloat];

    
    NSData *data = UIImageJPEGRepresentation(cuttedImage,0.3f);
    
    return data;
}

- (UIImage *)BeCutImageView:(UIImageView *)imageView Rect:(CGRect)rect Multiple:(float)mulfloat{
    
    CGFloat scale = (imageView.image.size.width/imageView.width);
    
    if (mulfloat >=0.5f) {
        if (scale <1.0) {
            mulfloat = mulfloat /scale;
            if (mulfloat >0.9) {
                mulfloat = 0.9;
            }
        }
    }else{
        if (mulfloat <0.6f && mulfloat>=0.4f) {
            if (scale <1.0) {
                mulfloat = mulfloat /scale;
                if (mulfloat >0.85) {
                    mulfloat = 0.85;
                }
            }else if (scale <2.0 && scale >=1.0) {
                mulfloat = mulfloat +(scale/10);
            }
        }else{
            if (scale <1.0) {
                mulfloat = mulfloat /scale;
                if (mulfloat >0.7) {
                    mulfloat = 0.7;
                }
            }else if (scale <2.5 && scale >=1.0) {
                mulfloat = mulfloat +(scale/10);
            }
        }
    }
    UIImage *image =[YXFFTools compressdeImage:imageView.image Multiple:mulfloat];
    
    CGFloat newX;
    CGFloat newY;
    CGFloat newWidth;
    CGFloat newHeight;
    if ((imageView.height <=ScreenWidth)&&(imageView.width <=ScreenWidth)) {
        newX = 0.0;
        newY = 0.0;
        newWidth =imageView.image.size.width;
        newHeight =imageView.image.size.height;
    }else if((imageView.width <=ScreenWidth)&&(imageView.height >ScreenWidth)){
        newX = 0.0;
        newY = -imageView.y *scale;
        newWidth =imageView.image.size.width;
        newHeight = ScreenWidth *scale;
    }else if ((imageView.height <=ScreenWidth)&&(imageView.width >ScreenWidth)){
        newX = -imageView.x *scale;
        newY = 0.0;
        newWidth = ScreenWidth *scale;
        newHeight =imageView.image.size.height;
    }else{
        newX = -imageView.x *scale;
        newY = -imageView.y *scale;
        newWidth = ScreenWidth *scale;
        newHeight = ScreenWidth *scale;
    }
    CGRect newRcet =CGRectMake(newX * mulfloat, newY * mulfloat, newWidth * mulfloat, newHeight * mulfloat);
    
    CGImageRef imageRef = image.CGImage;
    imageRef = CGImageCreateWithImageInRect(image.CGImage, newRcet);
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return newImage;
}
@end
