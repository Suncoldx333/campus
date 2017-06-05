//
//  PhotoTool.m
//  SWCampus
//
//  Created by 11111 on 2017/3/3.
//  Copyright © 2017年 WanHang. All rights reserved.
//

#import "PhotoTool.h"

@implementation PhotoTool

static PhotoTool *sharePhotoTool = nil;
+ (instancetype)sharePhotoTool{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharePhotoTool = [[self alloc] init];
        sharePhotoTool.cachingMan = [[PHCachingImageManager alloc] init];
    });
    return sharePhotoTool;
}

-(BOOL)getPhotoAblumJurisdictionStatus{

    if (IOS8) {
         PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status != PHAuthorizationStatusAuthorized) {
            return NO;
        }else{
            return YES;
        }
    }else{
        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
        if (authStatus != ALAuthorizationStatusAuthorized) {
            return NO;
        }else{
            return YES;
        }
    }
}

///得到相册的所有照片
- (NSArray<PHAsset *> *)getAllAssetInPhotoAblumByAscending:(BOOL)ascending{
    
    NSMutableArray<PHAsset *> *assetArr = [[NSMutableArray alloc] init];
    
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    
    PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:option];
    
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAsset *asset = (PHAsset *)obj;
        [assetArr addObject:asset];
    }];
    
    PHCachingImageManager *cachingImage = [[PHCachingImageManager alloc] init];
    [cachingImage startCachingImagesForAssets:assetArr  targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit
    options:nil];
    return assetArr;
}
-(void)createImageBy:(PHAsset *)asset andBlock:(void (^)(NSData *, NSDictionary *))completion{
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    option.synchronous = YES;

    [[PHCachingImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {

        if (completion) {
           completion(imageData,info);
        }
    }];
}

-(void)createLittleImageBy:(PHAsset *)asset In:(CGSize)size andBlock:(void (^)(NSData *, NSDictionary *))completion{
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    option.synchronous = YES;
    
    [self.cachingMan requestImageForAsset:asset targetSize:size
    contentMode:PHImageContentModeAspectFill options:option  resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
       if (completion) {
           completion(UIImageJPEGRepresentation(result, 0.3f),info);
       }
    }];
    
    
}


-(CGSize)geiSizeAbout:(PHAsset *)asset{
    CGFloat width = [[NSNumber numberWithUnsignedInteger:asset.pixelWidth] floatValue];
    CGFloat height = [[NSNumber numberWithUnsignedInteger:asset.pixelHeight] floatValue];
    
    CGSize givenSize = CGSizeMake(width, height);
    return givenSize;
}

- (NSArray<PhotoAlbumModel *> *)getFirstPhotoAblumList{
    NSMutableArray<PhotoAlbumModel *> *photoAblumList = [[NSMutableArray alloc] init];

    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                          subtype:PHAssetCollectionSubtypeAlbumRegular
                                                                          options:nil];
    
    for (NSInteger i = 0; i < smartAlbums.count; i++) {
        PHAssetCollection *collection = [smartAlbums objectAtIndex:i];
        if (collection.assetCollectionSubtype != 202 && collection.assetCollectionSubtype < 212) {
            NSMutableArray *assets = [[NSMutableArray alloc] init];
            
            PHFetchOptions *option = [[PHFetchOptions alloc] init];
            option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
            PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            
            [result enumerateObjectsUsingBlock:^(id  _Nonnull obj,
                                                 NSUInteger idx,
                                                 BOOL * _Nonnull stop) {
                if (((PHAsset *)obj).mediaType == PHAssetMediaTypeImage) {
                    PHAssetModel *model = [[PHAssetModel alloc]initWithPHAssetModel:obj];
                    
                    [assets addObject:model];
                    
                }
            }];
            
            if (assets.count > 0) {
                NSMutableDictionary *dict =[NSMutableDictionary dictionary];
                [dict setObject:collection.localizedTitle forKey:@"ablumName"];
                [dict setObject:[NSString stringWithFormat:@"%lu",(unsigned long)assets.count] forKey:@"count"];
                [dict setObject:[assets firstObject] forKey:@"headImageAsset"];
                [dict setObject:collection forKey:@"assetCollection"];
                
                PhotoAlbumModel *ablum = [[PhotoAlbumModel alloc] initWithPhotoAlbumModel:dict];
                [photoAblumList addObject:ablum];
                
                break;
            }
        }
    }
    return photoAblumList;
}


- (NSArray<PhotoAlbumModel *> *)getPhotoAblumList
{
    NSMutableArray<PhotoAlbumModel *> *photoAblumList = [[NSMutableArray alloc] init];
    
    //获取所有智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    
    
    [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL *stop) {
        //过滤掉视频和最近删除
        if(collection.assetCollectionSubtype != 202 && collection.assetCollectionSubtype < 212){
            
            NSArray *assets = [NSArray array];
            
            assets =[self getAllAssetIn:collection ByAscending:NO];
            
            if (assets.count > 0) {
                NSMutableDictionary *dict =[NSMutableDictionary dictionary];
                [dict setObject:collection.localizedTitle forKey:@"ablumName"];
                [dict setObject:[NSString stringWithFormat:@"%lu",(unsigned long)assets.count] forKey:@"count"];
                [dict setObject:[assets firstObject] forKey:@"headImageAsset"];
                [dict setObject:collection forKey:@"assetCollection"];
                
                PhotoAlbumModel *ablum = [[PhotoAlbumModel alloc] initWithPhotoAlbumModel:dict];

                [photoAblumList addObject:ablum];
            }
        }
    }];
    
    //获取用户创建的相册
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
        options:nil];
    [userAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection,
                                             NSUInteger idx,
                                             BOOL * _Nonnull stop) {
        NSArray *assets = [NSArray array];
        
        assets =[self getAllAssetIn:collection ByAscending:NO];
        if (assets.count > 0) {
            NSMutableDictionary *dict =[NSMutableDictionary dictionary];
            [dict setObject:collection.localizedTitle forKey:@"ablumName"];
            [dict setObject:[NSString stringWithFormat:@"%lu",(unsigned long)assets.count] forKey:@"count"];
            [dict setObject:[assets firstObject] forKey:@"headImageAsset"];
            [dict setObject:collection forKey:@"assetCollection"];
            
            PhotoAlbumModel *ablum = [[PhotoAlbumModel alloc] initWithPhotoAlbumModel:dict];
            [photoAblumList addObject:ablum];
        }
    }];
    
    return photoAblumList;
}

-(NSArray *)getAllAssetIn:(PHAssetCollection *)givenCollection ByAscending:(BOOL)ascending{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:givenCollection options:option];
    
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (((PHAsset *)obj).mediaType == PHAssetMediaTypeImage) {
            [arr addObject:obj];
        }
    }];
//    PHCachingImageManager *cachingImage = [[PHCachingImageManager alloc] init];
//    [cachingImage startCachingImagesForAssets:arr
//    targetSize:CGSizeMake(ScreenWidth *0.35, ScreenWidth *0.35)
//    contentMode:PHImageContentModeAspectFill  options:nil];
    return arr;
}

-(void)cachingAsset:(NSArray<PHAsset *> *)assetArr{
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    option.synchronous = YES;
    
    [self.cachingMan startCachingImagesForAssets:assetArr
                                targetSize:CGSizeMake(ScreenWidth *.35f, ScreenWidth *.35f)
                               contentMode:PHImageContentModeAspectFill
                                   options:option];
}

-(void)cancelCachingAsset{
    [self.cachingMan stopCachingImagesForAllAssets];
}

@end
