//
//  PhotosHelper.m
//  PhotoDemo
//
//  Created by Fidetro on 2017/9/22.
//  Copyright © 2017年 Fidetro. All rights reserved.
//

#import "PhotosHelper.h"

@implementation PhotoModel
@end
@implementation PhotosHelper


+ (void)requestPhotoAuthorizationStatus:(void(^)(BOOL result))request_block
{
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            if (request_block)
            {
                if (status == PHAuthorizationStatusAuthorized) {
                    request_block(YES);
                }else{
                    request_block(NO);
                }
                
            }
        }];
        
    }];
    
}


+ (void)requestCameraAuthorizationStatus:(void(^)(BOOL result))request_block{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            if (request_block)
            {
                request_block(granted);
            }
        }];
    }];
}


+ (NSArray <PHAssetCollection *>*)allCollections
{
    NSMutableArray *collections = [NSMutableArray array];
    // 所有智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (NSInteger i = 0; i < smartAlbums.count; i++) {
        // 是否按创建时间排序
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
        PHCollection *collection = smartAlbums[i];
        //遍历获取相册
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            [collections addObject:collection];
        }
    }
    return collections;
}

+ (void)ascending:(BOOL)ascending
             size:(CGSize)size
       resizeMode:(PHImageRequestOptionsResizeMode)resizeMode
allPhotoCompletionhandler:(void(^)(NSArray <PhotoModel *>*models))completion_block
{
    for (PHCollection *collection in [self allCollections])
    {
        if ([collection.localizedTitle isEqualToString:@"All Photos"]||[collection.localizedTitle isEqualToString:@"Camera Roll"]||[collection.localizedTitle isEqualToString:@"所有照片"]||[collection.localizedTitle isEqualToString:@"相机胶卷"]) {
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
            if (fetchResult.count > 0)
            {
                NSArray *assets = [self allPhotosAssetInAblumCollection:(PHAssetCollection *)collection ascending:NO];
                NSMutableArray *models = [NSMutableArray array];
                for (PHAsset *asset in assets) {
                    PhotoModel *model = [[PhotoModel alloc]init];
                    model.asset = asset;
                    [models addObject:model];
                }
                if (completion_block)
                {
                    completion_block(models);
                }
            }
            else
            {
                if (completion_block)
                {
                    completion_block(nil);
                }
            }
        }
    }
}



+ (NSArray <PHAsset *>*)allPhotosAssetInAblumCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending
{
    // 存放所有图片对象
    NSMutableArray *assets = [NSMutableArray array];
    
    // 是否按创建时间排序
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    
    // 获取所有图片对象
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
    // 遍历
    [result enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
        [assets addObject:asset];
    }];
    return assets;
}

+ (void)accessToImageAccordingToTheAsset:(PHAsset *)asset size:(CGSize)size resizeMode:(PHImageRequestOptionsResizeMode)resizeMode completion:(void(^)(UIImage *image,NSDictionary *info))completion
{
    static PHImageRequestID requestID = -2;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat width = MIN([UIScreen mainScreen].bounds.size.width, 500);
    if (requestID >= 1 && size.width / width == scale) {
        [[PHCachingImageManager defaultManager] cancelImageRequest:requestID];
    }
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    option.resizeMode = resizeMode;
    
    requestID = [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(result,info);
        });
    }];
    
}

@end
