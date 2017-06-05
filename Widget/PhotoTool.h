//
//  PhotoTool.h
//  SWCampus
//
//  Created by 11111 on 2017/3/3.
//  Copyright © 2017年 WanHang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PhotoAlbumModel.h"
#import "PHAssetModel.h"

@interface PhotoTool : NSObject

//初始化方法
+ (instancetype)sharePhotoTool;

@property (nonatomic,strong) PHCachingImageManager *cachingMan;

//获取相册权限允许状态
-(BOOL)getPhotoAblumJurisdictionStatus;

//获取所有相册内图片  ascending: YES-升序,NO-降序
-(NSArray<PHAsset *> *)getAllAssetInPhotoAblumByAscending:(BOOL)ascending;

//获取指定相册内图片  ascending: YES-升序,NO-降序
-(NSArray<PHAsset *> *)getAllAssetIn:(PHAssetCollection *)givenCollection ByAscending:(BOOL)ascending;


//将PHAsset转换为指定size的UIImage
-(void)createImageBy:(PHAsset *)asset andBlock:(void (^)(NSData *, NSDictionary *))completion;
- (void)createLittleImageBy:(PHAsset *)asset In:(CGSize)size andBlock:(void (^)(NSData *, NSDictionary *))completion;
//获取PHAsset的尺寸
-(CGSize)geiSizeAbout:(PHAsset *)asset;

//获取相册列表
-(NSArray<PhotoAlbumModel *> *)getPhotoAblumList;
- (NSArray<PhotoAlbumModel *> *)getFirstPhotoAblumList;
-(void)cachingAsset:(NSArray<PHAsset *> *)assetArr;
-(void)cancelCachingAsset;

@end
