//
//  ImagePickerFilterVC.m
//  SWCampus
//
//  Created by 11111 on 2017/3/7.
//  Copyright © 2017年 WanHang. All rights reserved.
//

#import "ImagePickerFilterVC.h"
#import "SWCHelpCenter.h"
#import "HorizontalFlowLayout.h"
#import "FilterListCell.h"

#define FILTERCOLLECTIONHEIGHT ScreenHeight - 64.5 - ScreenWidth - 40.5
#define FILTERCOLLECTIONCELLWIDTH ceil(ScreenWidth / 375.000 * 100.000)
#define cellPlist      @"CellImages"

@interface ImagePickerFilterVC ()

@property (nonatomic,strong) UIView *chosenImageBGView;
@property (nonatomic,strong) UIImageView *chosenImage;
@property (nonatomic,strong) UICollectionView *filterCollectionView;
@property (nonatomic,strong) NSMutableArray<NSMutableDictionary *> *filterTypeArr;
@property (nonatomic,strong) NSIndexPath *lastChosenIndex;
@property (nonatomic) BOOL firstApply;
@property (nonatomic,strong) CIContext *context;
@property (nonatomic,strong) NSData *originalImageData;
@property (nonatomic,strong) UIImage *originImage;
@property (nonatomic,strong) NSMutableArray *arrayImages;

@end
static NSString * const Identifier = @"FilterListCell";

@implementation ImagePickerFilterVC

@synthesize customNav,bottomView;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
}

-(CIContext *)context{
    if (_context == nil) {
        _context = [CIContext contextWithOptions:nil];
    }
    return _context;
}
- (void)dealloc{
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
}
-(void)initData{
    
    self.firstApply = YES;
    
    NSMutableArray<NSString *> *nameArr = [[NSMutableArray alloc] initWithObjects:@"原图",@"单色",@"色调",@"黑白",@"褪色",@"铬黄",@"冲印",@"岁月",@"怀旧", nil];
    self.filterTypeArr = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < 9; i++) {
        if (i == 0) {
            NSMutableDictionary *nameDic = [[NSMutableDictionary alloc] init];
            [nameDic setObject:[nameArr firstObject] forKey:@"name"];
            [nameDic setObject:@"1" forKey:@"color"];
            [self.filterTypeArr addObject:nameDic];
        }else{
            NSMutableDictionary *nameDic = [[NSMutableDictionary alloc] init];
            [nameDic setObject:[nameArr objectAtIndex:i] forKey:@"name"];
            [nameDic setObject:@"0" forKey:@"color"];
            [self.filterTypeArr addObject:nameDic];
        }
    }
    
}

-(void)initUI{
    
    self.view.backgroundColor = hexColor(0xffffff);
    
    customNav = [[TopicCustomNaView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, 44.5)];
    customNav.delegate = self;
    [customNav ChangeRightTitle:@"" and:YES];
    customNav.centerLabel.text = @"拍摄照片";
    customNav.leftImage =@"backMark";
    [self.view addSubview:customNav];
    
    _chosenImageBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 64.5, ScreenWidth, ScreenWidth)];
    _chosenImageBGView.clipsToBounds = YES;
    _chosenImageBGView.backgroundColor = hexColor(0xffffff);
    [self.view addSubview:_chosenImageBGView];
    
    _chosenImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
    _chosenImage.contentMode = UIViewContentModeScaleToFill;
    _chosenImage.clipsToBounds = YES;
    _chosenImage.userInteractionEnabled = NO;
    [_chosenImageBGView addSubview:_chosenImage];

    HorizontalFlowLayout *layout = [[HorizontalFlowLayout alloc]init];
    _filterCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64.5 + ScreenWidth, ScreenWidth, FILTERCOLLECTIONHEIGHT) collectionViewLayout:layout];
    _filterCollectionView.showsHorizontalScrollIndicator = NO;
    [_filterCollectionView registerClass:[FilterListCell class] forCellWithReuseIdentifier:Identifier];
    
    _filterCollectionView.delegate = self;
    _filterCollectionView.dataSource = self;
    _filterCollectionView.backgroundColor = hexColor(0xffffff);
    [self.view addSubview:_filterCollectionView];
    
    bottomView = [[ImagePickBottomView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 40.5, ScreenWidth, 40.5)];
    
    bottomView.bottomViewTypeOpen = 1;
    [self.view addSubview:bottomView];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)fillBGViewWith:(NSData *)imageData{
   
    if (!_photosBooL) {
        _originImage =[self ClippingImageSize:imageData];
        self.chosenImage.image =[YXFFTools FixImageOrientation:_originImage];
    }else{
        _originImage = [[UIImage alloc] initWithData:imageData];
        self.chosenImage.image = _originImage;
    }
    self.chosenImage.contentMode = UIViewContentModeScaleAspectFit;
    self.chosenImage.center = CGPointMake(ScreenWidth*.5f, ScreenWidth*.5f);
    
    [self.filterCollectionView reloadData];
}

///把image剪裁成正方形
- (UIImage *)ClippingImageSize:(NSData *)imageData{
    UIImage *origImage =[[UIImage alloc] initWithData:imageData];
    CGFloat Width =origImage.size.width;
    CGFloat Height =origImage.size.height;

    CGFloat minWH = Height > Width ? Width : Height;
    CGFloat rectX = Width*.5f - minWH *.5f;
    CGFloat rectY = Height*.5f - minWH *.5f;
    CGRect dianRect = CGRectMake(rectY, rectX, minWH, minWH);
    
    return [YXFFTools ClipImage:origImage WithWithImageRect:dianRect];
}


-(void)leftIconClick{
    [YXFFTools FileManagerDeletePlistfile:cellPlist];

    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}
- (void)centerIconClick{
    NSLog(@"+++什么都不需要做+++");
}
-(void)rightIconClick{

    [YXFFTools FileManagerDeletePlistfile:cellPlist];
    
    NSData *newData = UIImageJPEGRepresentation(self.chosenImage.image, 0.3f);
    if (self.imageBlock){

        __weak typeof(self) weakself = self;
        self.imageBlock(weakself, newData);

    }
}

#pragma mark -CollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 9;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FilterListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Identifier forIndexPath:indexPath];
    
    cell.filterImage = [self CollectionViewCellImage:indexPath.section];
    
    cell.cellIndex = indexPath.section;
    
    cell.filterNameLabel.text = [[self.filterTypeArr objectAtIndex:indexPath.section] objectForKey:@"name"];
    NSString *colorType = [[self.filterTypeArr objectAtIndex:indexPath.section] objectForKey:@"color"];
    if (colorType.intValue == 1) {
        cell.filterNameLabel.textColor = hexColor(0x333333);
    }else if (colorType.intValue == 0){
        cell.filterNameLabel.textColor = hexColor(0xb2b2b2);
    }
    
    if (indexPath.section == 0 && self.firstApply) {
        self.firstApply = NO;
        self.lastChosenIndex = indexPath;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(FILTERCOLLECTIONCELLWIDTH, FILTERCOLLECTIONHEIGHT);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(15, FILTERCOLLECTIONHEIGHT);
    }
    return CGSizeMake(5, FILTERCOLLECTIONHEIGHT);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section == 8) {
        return CGSizeMake(15, FILTERCOLLECTIONHEIGHT);
    }
    return CGSizeZero;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FilterListCell *cell = (FilterListCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.filterNameLabel.textColor = hexColor(0x333333);
    NSString *cellName = cell.filterNameLabel.text;
    
    [self changeChosenImageFilter:indexPath.section];
    
    //修改title颜色
    NSMutableArray<NSMutableDictionary *> *changedArr = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *nameDic in self.filterTypeArr) {
        NSMutableDictionary *changedNameDic = [nameDic mutableCopy];
        if ([[nameDic objectForKey:@"name"] isEqualToString:cellName]) {
            [changedNameDic setObject:@"1" forKey:@"color"];
        }else{
            [changedNameDic setObject:@"0" forKey:@"color"];
        }
        [changedArr addObject:changedNameDic];
    }
    self.filterTypeArr = [changedArr mutableCopy];
    
    NSInteger chosenIndex = cell.cellIndex;
    CGFloat x = collectionView.contentOffset.x;
    bool listNeedScroll = NO;
    
    NSInteger headIndex = (x - 12.5) / (FILTERCOLLECTIONCELLWIDTH + 5);
    NSInteger footIndex = (x + ScreenWidth - 12.5) / (FILTERCOLLECTIONCELLWIDTH + 5);
    if (headIndex < chosenIndex && chosenIndex < footIndex) {
        listNeedScroll = NO;
    }else{
        listNeedScroll = YES;
    }
    
    if (listNeedScroll) {
        CGFloat newX = 0;
        if (headIndex == chosenIndex) {
            if (chosenIndex == 0) {
                newX = 0;
            }else{
                newX = 10 + chosenIndex * (FILTERCOLLECTIONCELLWIDTH + 5) - 45;
            }
        }else if (chosenIndex == footIndex){
            if (chosenIndex == 8) {
                newX = 10 + (chosenIndex + 1) * (FILTERCOLLECTIONCELLWIDTH + 5) + 15 - ScreenWidth;
            }else{
                newX = 10 + (chosenIndex + 1) * (FILTERCOLLECTIONCELLWIDTH + 5) + 45 - ScreenWidth;
            }
        }
        [collectionView setContentOffset:CGPointMake(newX, 0) animated:YES];
    }
    
    if (self.lastChosenIndex && self.lastChosenIndex.section != indexPath.section) {
        FilterListCell *lastCell = (FilterListCell *)[collectionView cellForItemAtIndexPath:self.lastChosenIndex];
        lastCell.filterNameLabel.textColor = hexColor(0xb2b2b2);
    }
    
    self.lastChosenIndex = indexPath;
}
- (UIImage *)CollectionViewCellImage:(NSInteger)teger{
    UIImage *newImage;
#if 0
    if ([[YXFFTools FileReadNsArrayFromPlist:cellPlist] count]>teger) {
        NSString *strImage =[YXFFTools FileReadNsArrayFromPlist:cellPlist][teger];
        NSData *decodedImageData = [[NSData alloc]initWithBase64EncodedString:strImage options:NSDataBase64DecodingIgnoreUnknownCharacters];
        newImage = [UIImage imageWithData:decodedImageData];
    }else{
        newImage = [self filterImage:_originImage InType:teger];
        
        [YXFFTools FileWriteImageData:UIImageJPEGRepresentation([self filterImage:_originImage InType:teger], 0.4) and:teger toPlistName:cellPlist];
    }
#else
    if ([[YXFFTools FileReadNsArrayFromPlist:cellPlist] count]>0) {
        NSString *strImage =[YXFFTools FileReadNsArrayFromPlist:cellPlist][teger];
        NSData *decodedImageData = [[NSData alloc]initWithBase64EncodedString:strImage options:NSDataBase64DecodingIgnoreUnknownCharacters];
        newImage = [UIImage imageWithData:decodedImageData];
    }else{
        newImage = [self filterImage:_originImage InType:teger];

        NSMutableArray *array =[NSMutableArray array];
        for (NSInteger i=0; i<9; i++) {
            [array addObject:[YXFFTools StringBase64FromImages:[self filterImage:_originImage InType:i]]];
        }
        [YXFFTools FileNSArrayStorageToPlist:array PlistName:cellPlist];
    }
#endif
    return newImage;
}
- (UIImage *)filterImage:(UIImage *)originalImage InType:(NSInteger)type{
    CIFilter *filter;
    if (type>0) {
        switch (type) {
            case 1:{
                filter = [CIFilter filterWithName:@"CIPhotoEffectMono"];
            }
                break;
            case 2:{
                filter = [CIFilter filterWithName:@"CIPhotoEffectTonal"];
            }
                break;
            case 3:{
                filter = [CIFilter filterWithName:@"CIPhotoEffectNoir"];
            }
                break;
            case 4:{
                filter = [CIFilter filterWithName:@"CIPhotoEffectFade"];
            }
                break;
            case 5:{
                filter = [CIFilter filterWithName:@"CIPhotoEffectChrome"];
            }
                break;
            case 6:{
                filter = [CIFilter filterWithName:@"CIPhotoEffectProcess"];
            }
                break;
            case 7:{
                filter = [CIFilter filterWithName:@"CIPhotoEffectTransfer"];
            }
                break;
            case 8:
                filter = [CIFilter filterWithName:@"CIPhotoEffectInstant"];
                break;
            default:{
            }
                break;
        }
        NSData *data = UIImageJPEGRepresentation(originalImage, 0.3f);
        CIImage *inputImage = [CIImage imageWithData:data];
        [filter setValue:inputImage forKey:kCIInputImageKey];
        CIImage *outputImage = filter.outputImage;
        CGImageRef cgImge = [self.context createCGImage:outputImage fromRect:outputImage.extent];
        UIImage *newImage = [[UIImage alloc] initWithCGImage:cgImge];
        CGImageRelease(cgImge);
        if (!_photosBooL) {
            return [YXFFTools FixImageOrientation:newImage];
        }else{
            return newImage;
        }
    }else{
        if (!_photosBooL) {
            return [YXFFTools FixImageOrientation:originalImage];
        }else{
            return originalImage;
        }
    }
}
-(void)changeChosenImageFilter:(NSInteger)type{
    self.chosenImage.image = [self CollectionViewCellImage:type];
}

@end
