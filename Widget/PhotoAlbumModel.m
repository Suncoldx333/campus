//
//  PhotoAlbumModel.m
//  SWCampus
//
//  Created by 11111 on 2017/3/6.
//  Copyright © 2017年 WanHang. All rights reserved.
//

#import "PhotoAlbumModel.h"

@implementation PhotoAlbumModel
- (instancetype)initWithPhotoAlbumModel:(NSDictionary *)info{
    if (self =[super init]) {
        self.ablumName =info[@"ablumName"];
        self.count =info[@"count"];
        self.headImageAsset = info[@"headImageAsset"];
        self.assetCollection = info[@"assetCollection"];
        
        self.firstImage = nil;
    }
    return self;
}

@end
