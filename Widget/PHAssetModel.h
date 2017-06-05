//
//  PHAssetModel.h
//  SWCampus
//
//  Created by WH on 2017/4/20.
//  Copyright © 2017年 WanHang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface PHAssetModel : NSObject
//@property (nonatomic,strong) PHAsset *Asset;

//@property (nonatomic,strong) UIImage *seetImage;
- (instancetype)initWithPHAssetModel:(PHAsset *)obj;

@end
