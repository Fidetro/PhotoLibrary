//
//  PhotosHelper.h
//  PhotoDemo
//
//  Created by Fidetro on 2017/9/22.
//  Copyright © 2017年 Fidetro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
@interface PhotoModel : NSObject

@property(nonatomic,strong) PHAsset *asset;
@property(nonatomic,strong) UIImage *image;
@end


@interface PhotosHelper : NSObject
/**
 检测相册权限是否打开，不包括相机
 
 @return 是否打开
 */
+ (BOOL)authorizationStatus;

+ (NSArray <PHAssetCollection *>*)allCollections;

/**
 获取所有照片

 @param ascending 排序方式
 @param size 图片大小
 @param resizeMode 图片模式
 @param completion_block 完成的回调
 */
+ (void)ascending:(BOOL)ascending
             size:(CGSize)size
       resizeMode:(PHImageRequestOptionsResizeMode)resizeMode
allPhotoCompletionhandler:(void(^)(NSArray <PhotoModel *>*models))completion_block;


/**
 获取传入的相册所有图片

 @param assetCollection 相册集合
 @param ascending 排序方式
 @return 返回asset数组
 */
+ (NSArray <PHAsset *>*)allPhotosAssetInAblumCollection:(PHAssetCollection *)assetCollection
                                              ascending:(BOOL)ascending;


/**
 将asset转成UIImage
 */
+ (void)accessToImageAccordingToTheAsset:(PHAsset *)asset
                                    size:(CGSize)size
                              resizeMode:(PHImageRequestOptionsResizeMode)resizeMode
                              completion:(void(^)(UIImage *image,NSDictionary *info))completion;
@end
