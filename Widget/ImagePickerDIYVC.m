//
//  ImagePickerDIYVC.m
//  SWCampus
//
//  Created by 11111 on 2017/3/2.
//  Copyright © 2017年 WanHang. All rights reserved.
//

#import "ImagePickerDIYVC.h"
#import <Photos/Photos.h>
#import "ImagePickerCell.h"
#import "AlbumListView.h"
#import "SWCHelpCenter.h"
#import "ImagePickerFilterVC.h"
#import "NewMomentController.h"

#define HorizontalBoundray 8.000 / 15.000 * ScreenWidth
#define VerticalBoundray 4.000 / 5.000 * ScreenWidth

@interface ImagePickerDIYVC ()<AlbumListViewDelegate>

@property (nonatomic,strong) UICollectionView *libPicsCollectionView;
@property (nonatomic) BOOL photoLibjurisdiction; //相册访问权限
@property (nonatomic,strong) NSMutableArray *photoAssetArr;
@property (nonatomic,strong) UIImageView *chosenImage;
@property (nonatomic,strong) NSString *albumName;
@property (nonatomic,strong) AlbumListView *listView;
@property (nonatomic) CGRect preFrame;
@property (nonatomic) CGRect curFrame;
@property (nonatomic,strong) UIView *chosenImageBgView;
@property (nonatomic) BOOL showListView;  //当前展示的是相册列表

@property (nonatomic,assign) BOOL onceBooL;
@property (nonatomic,assign) BOOL PhotoBooL;
@property (nonatomic,assign) BOOL upBooL;
@property (nonatomic,strong) NSArray *allPhotoSumbs;
///不同相册cell的tager值,用于plist存储删除
@property (nonatomic,assign) NSInteger plistTger;
@end

@implementation ImagePickerDIYVC


- (void)viewDidLoad {
    [super viewDidLoad];
    _onceBooL =false;
    _PhotoBooL = false;
    _upBooL = false;
    [self initData];
    [self initUI];
    _plistTger = 0;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_onceBooL) {
        [self FirstPhotosDataGetShow];
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [YXFFTools UserDefaultSetBool:NO forKey:@"blackBooL"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_photoTool cancelCachingAsset];
   
}
- (void)dealloc{
    
    _allPhotoSumbs = nil;
    
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
}
- (void)FirstPhotosDataGetShow{
    LoadingCircleView *loadingView = [LoadingCircleView initWithTitle:@"正在加载"];
    [self.view addSubview:loadingView];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        _allPhotoSumbs =[_photoTool getPhotoAblumList];
        PhotoAlbumModel *firstModel = [_allPhotoSumbs firstObject];
        if (firstModel) {
            //第一个相册的名字
            self.albumName = firstModel.ablumName;
            //第一个相册内的所有照片数据
            PHAssetCollection *firstCollection = firstModel.assetCollection;
            self.photoAssetArr =[[_photoTool getAllAssetIn:firstCollection ByAscending:NO] mutableCopy];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [loadingView dismiss];
            _onceBooL = true;
            self.customNav.centerLabel.attributedText =[self createAlbumNameAtrr:self.albumName inOpen:YES];
            [_photoTool cachingAsset:self.photoAssetArr];
            self.pickBgView.givenImageListDataArr = self.photoAssetArr;
            [self ListPhotosGetShow];
        });
    });
}
- (void)ListPhotosGetShow{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        dispatch_async(dispatch_get_main_queue(), ^{
            //相册列表
            self.listView.dataArr = [_allPhotoSumbs mutableCopy];
        });
    });
}
#pragma mark -初始化数据
-(void)initData{
    //相册管理
    _photoTool = [PhotoTool sharePhotoTool];
    if (![_photoTool getPhotoAblumJurisdictionStatus]) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            switch (status) {
                case PHAuthorizationStatusAuthorized:{
                    [self FirstPhotosDataGetShow];
                }
                    break;
                default:{}
                    break;
            }
        }];
    }
}

#pragma mark -初始化界面
-(void)initUI{
    self.view.backgroundColor = hexColor(0xe6e6e6);
    //导航栏
    [self.view addSubview:self.customNav];
    [self.view addSubview:self.pickBgView];
    [self.view addSubview:self.bottomView];
    //底部选择按钮
    self.bottomView.bottomViewTypeOpen = 0;
}
- (TopicCustomNaView *)customNav{
    if (!_customNav) {
        _customNav = [[TopicCustomNaView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, 44.5)];
        _customNav.delegate = self;
        [_customNav ChangeRightTitle:nil and:YES];
    }
    return _customNav;
}

-(ImagePickeBgView *)pickBgView{
    if (!_pickBgView) {
        _pickBgView = [[ImagePickeBgView alloc] initWithFrame:CGRectMake(0, 64.5, ScreenWidth * 2, ScreenHeight - 64.5 - 40.5)];
        _pickBgView.delegate = self;
    }
    return _pickBgView;
}

- (ImagePickerView *)pickView{
    if (!_pickView) {
        CGFloat collectionHeight = ScreenHeight - 70.5 - 40.5;
        _pickView = [[ImagePickerView alloc] initWithFrame:CGRectMake(0, 64.5, ScreenWidth * 2, ScreenWidth + 0.5 + collectionHeight)];
        [self.view addSubview:_pickView];
    }
    return _pickView;
}
- (ImagePickBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[ImagePickBottomView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 40.5, ScreenWidth, 40.5)];
        _bottomView.delegate = self;
    }
    return _bottomView;
}
- (AlbumListView *)listView{
    if (!_listView) {
        _listView = [[AlbumListView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight - 64.5)];
        _listView.delegate = self;
        [self.view addSubview:_listView];
    }
    return _listView;
}
#pragma mark -私有方法
//导航栏中间富文本设置
-(NSMutableAttributedString *)createAlbumNameAtrr:(NSString *)name inOpen:(BOOL)state{
    if (name.length<=0) {
        name =@" ";
    }
    NSString *title = [NSString stringWithFormat:@"%@ ",name];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:title];
    
    NSMutableDictionary *space = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithFloat:5.f],NSKernAttributeName, nil];
    
    [attr addAttributes:space range:NSMakeRange(title.length - 2, 1)];
    
    NSTextAttachment *imageAttch = [[NSTextAttachment alloc] init];
    if (state) {
        imageAttch.image = [UIImage imageNamed:@"1608OpenAlbum"];
    }else{
        imageAttch.image = [UIImage imageNamed:@"1608CloseAlbum"];
    }
    imageAttch.bounds = CGRectMake(0, 2.5, 8, 4);
    NSAttributedString *imageAttr = [NSAttributedString attributedStringWithAttachment:imageAttch];
    
    [attr insertAttributedString:imageAttr atIndex:title.length - 1];
    return attr;
}

#pragma mark -控件代理
//导航栏左侧点击事件
-(void)leftIconClick{
    if (!_upBooL){
        if (!self.showListView) {
            _pickBgView = nil;
            [self dismissViewControllerAnimated:YES completion:^{
            }];
        }else{
            [self.listView exitAnimation];
        }
    }else{
        [_pickBgView imagePickDownEvent];
    }
}

//导航栏中间点击事件
-(void)centerIconClick{
    if (!_PhotoBooL){
        if (!_upBooL) {
            if (!self.showListView) {
                
                [self.listView enterAnimation];
            }else{
                
                [self.listView exitAnimation];
            }
        }else{
            [_pickBgView imagePickDownEvent];
        }
    }
}
//导航栏右侧点击事件
-(void)rightIconClick{
    if (!_upBooL){
        if (!_PhotoBooL) {
            if (!self.showListView) {
                [YXFFTools FileManagerDeletePlistfile:@"CellImages"];
                NSData *data = [_pickBgView makePreFiltImage];
                ImagePickerFilterVC *filterVC = [[ImagePickerFilterVC alloc] init];
                filterVC.view.hidden = NO;
                filterVC.photosBooL = true;
                [self presentViewController:filterVC animated:NO completion:^{}];
                [filterVC fillBGViewWith:data];
                __weak typeof(self) weakSelf = self;
                filterVC.imageBlock = ^(ImagePickerFilterVC *filter, NSData *imageData) {
                    [filter dismissViewControllerAnimated:NO completion:^{
                        weakSelf.imageDataBlock(weakSelf, imageData);
                    }];
                    
                };
            }
        }
    }else{
        [_pickBgView imagePickDownEvent];
    }
}

//底部图库按钮点击事件
-(void)albumIconClick{
    _PhotoBooL = false;
    [_pickBgView showViewWithType:1];
}

//底部拍照按钮点击事件
-(void)cameraIconClick{
    [_pickBgView showViewWithType:2];
    _PhotoBooL = true;
}

//相册列表点击事件
-(void)AlbumListCellClick:(NSString *)albumTag andIntger:(NSInteger )intge{
    
    PhotoAlbumModel *chosenModel;
    
    for (PhotoAlbumModel *model in _allPhotoSumbs) {
        if ([model.ablumName isEqualToString:albumTag]) {
            chosenModel = model;
            break;
        }
    }
    
    PHAssetCollection *chosenCollection = chosenModel.assetCollection;
    self.albumName = chosenModel.ablumName;

    self.photoAssetArr =(NSMutableArray *) [_photoTool getAllAssetIn:chosenCollection ByAscending:NO];
    [_photoTool cachingAsset:self.photoAssetArr];

    _pickBgView.givenImageListDataArr =self.photoAssetArr;
    _pickBgView.cellIntger = intge;
    _plistTger =intge;
}

//相册列表出现动画完成
-(void)listEnterAnimatinDone{
    self.showListView = YES;

    [_customNav ChangeRightTitle:nil and:NO];
    _customNav.centerLabel.attributedText =[self createAlbumNameAtrr:self.albumName inOpen:NO];
}

//相册列表消失动画完成
-(void)listExitAnimatinDone{
    self.showListView = NO;

    [_customNav ChangeRightTitle:nil and:YES];
    _customNav.centerLabel.attributedText =[self createAlbumNameAtrr:self.albumName inOpen:YES];
}

-(void)bgViewMoveDoneInType:(NSInteger)type{
    if (type == 1) {

        [_customNav ChangeRightTitle:nil and:YES];
        _customNav.centerLabel.attributedText =[self createAlbumNameAtrr:self.albumName inOpen:YES];
    }else{

        _customNav.centerLabel.text = @"拍摄照片";
        [_customNav ChangeRightTitle:nil and:NO];
    }
}

-(void)shootAImageInImageData:(NSData *)imageData{
    ImagePickerFilterVC *filterVC = [[ImagePickerFilterVC alloc] init];
    filterVC.view.hidden = NO;

    filterVC.photosBooL = false;
    
    [self presentViewController:filterVC animated:NO completion:^{}];

    [filterVC fillBGViewWith:imageData];
    __weak typeof(self) weakSelf = self;
    filterVC.imageBlock = ^(ImagePickerFilterVC *filter, NSData *imageData) {
        [filter dismissViewControllerAnimated:NO completion:^{
            weakSelf.imageDataBlock(weakSelf, imageData);
        }];
    };
}

-(void)bgListUpDonwWithUpState:(BOOL)upState{
    _upBooL = upState;
}

@end
