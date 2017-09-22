//
//  AssetLibraryHelper.h
//  PhotoDemo
//
//  Created by Fidetro on 2017/9/22.
//  Copyright © 2017年 Fidetro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface AssetLibraryHelper : NSObject
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@property(nonatomic,strong,readonly) ALAssetsLibrary *assetsLibrary;


/**
 检测相册权限是否打开，不包括相机

 @return 是否打开
 */
+ (BOOL)authorizationStatus;


/**
 获取所有相册中的相册资源组
 */
- (void)allALAssetsGroupCompletionhandler:(void(^)(NSArray <ALAssetsGroup *>* groups))assetsGroups_block
                             failureBlock:(void (^)(NSError *error))error_block;


/**
 根据相册资源组获取图片资源

 @param group 需要获取的相册资源
 */
- (void)assetsResultWithALAssetsGroup:(ALAssetsGroup *)group
                    completionhandler:(void(^)(NSArray <ALAsset *>*imagesAssets))imagesAssets_block;

/**
 获取所有图片资源
 */
- (void)allAssetsResultCompletionhandler:(void(^)(NSArray <ALAsset *>*imagesAssets))imagesAssets_block
                            failureBlock:(void (^)(NSError *error))error_block;

/**
 将asset转成图片

 @param asset 图片资源
 @param isHighQuality 是否高质量
 @return 返回UIImage
 */
+ (UIImage *)assetToImage:(ALAsset *)asset isHighQuality:(BOOL)isHighQuality;

#pragma clang diagnostic pop
@end
