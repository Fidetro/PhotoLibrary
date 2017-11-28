//
//  AssetLibraryHelper.m
//  PhotoDemo
//
//  Created by Fidetro on 2017/9/22.
//  Copyright © 2017年 Fidetro. All rights reserved.
//

#import "AssetLibraryHelper.h"
#import <Messages/Messages.h>
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@interface AssetLibraryHelper ()
@property(nonatomic,strong,readwrite) ALAssetsLibrary *assetsLibrary;
@end

@implementation AssetLibraryHelper

+ (BOOL)authorizationStatus
{
    ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
    // 如果没有获取访问授权，或者访问授权状态已经被明确禁止，则显示提示语，引导用户开启授权
    if (authorizationStatus == ALAuthorizationStatusRestricted || authorizationStatus == ALAuthorizationStatusDenied) {

        return NO;
    }
    else
    {
        return YES;
    }
}


- (void)allALAssetsGroupCompletionhandler:(void(^)(NSArray <ALAssetsGroup *>*groups))assetsGroups_block failureBlock:(void (^)(NSError *error))error_block
{
    //关闭监听共享照片流产生的频繁通知信息,防止出现异常
    [ALAssetsLibrary disableSharedPhotoStreamsSupport];
    NSMutableArray *albumsArray = [[NSMutableArray alloc] init];
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            if (group.numberOfAssets > 0) {
                // 把相册储存到数组中，方便后面展示相册时使用
                [albumsArray addObject:group];
            }
        } else {
            if ([albumsArray count] > 0) {
                if (assetsGroups_block) {// 把所有的相册储存完毕，可以展示相册列表
                    assetsGroups_block(albumsArray);
                }
                
            } else {
                if (error_block) {
                    NSError *error = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:400 userInfo:@{NSLocalizedFailureReasonErrorKey:@"没有任何有资源的相册"}];
                    error_block(error);
                }
                // 没有任何有资源的相册，输出提示
            }
        }
    } failureBlock:^(NSError *error) {
        if (error_block) {
            NSError *error = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:404 userInfo:@{NSLocalizedFailureReasonErrorKey:@"Asset group not found!"}];
            error_block(error);
        }
    }];
}


- (void)assetsResultWithALAssetsGroup:(ALAssetsGroup *)group completionhandler:(void(^)(NSArray <ALAsset *>*imagesAssets))imagesAssets_block
{
    NSMutableArray *imagesAssetArray = [[NSMutableArray alloc] init];
    [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            [imagesAssetArray addObject:result];
        } else {
            // result 为 nil，即遍历相片或视频完毕，可以展示资源列表
            if (imagesAssets_block) {
                imagesAssets_block(imagesAssetArray);
            }
        }
    }];
}

- (void)allAssetsResultCompletionhandler:(void(^)(NSArray <ALAsset *>*imagesAssets))imagesAssets_block
                            failureBlock:(void (^)(NSError *error))error_block
{
    [self allALAssetsGroupCompletionhandler:^(NSArray<ALAssetsGroup *> *groups) {
        NSMutableArray *allImagesAssets = [NSMutableArray array];
        for (ALAssetsGroup *group in groups) {
            [self assetsResultWithALAssetsGroup:group completionhandler:^(NSArray<ALAsset *> *imagesAssets) {
                [allImagesAssets addObjectsFromArray:imagesAssets];
            }];
        }
        for (NSInteger i = 0; i<allImagesAssets.count; ++i)
        {
            for (NSInteger j = 0; j<allImagesAssets.count-1; ++j)
            {
                NSDate *lastDate = [allImagesAssets[j] valueForProperty:ALAssetPropertyDate];
                NSDate *nextDate = [allImagesAssets[j+1] valueForProperty:ALAssetPropertyDate];
                if (lastDate.timeIntervalSince1970 < nextDate.timeIntervalSince1970)
                {
                    [allImagesAssets exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                }
                
            }
        }
        
        if (imagesAssets_block) {
            imagesAssets_block(allImagesAssets);
        }
    } failureBlock:error_block];
}

+ (UIImage *)assetToImage:(ALAsset *)asset isHighQuality:(BOOL)isHighQuality
{
    // 获取资源图片的详细资源信息，其中 imageAsset 是某个资源的 ALAsset 对象
    ALAssetRepresentation *representation = [asset defaultRepresentation];
    
    if (isHighQuality == YES)
    {
        return [UIImage imageWithCGImage:[representation fullResolutionImage]];
    }
    else
    {
        return [UIImage imageWithCGImage:[representation fullScreenImage]];
    }
}

- (ALAssetsLibrary *)assetsLibrary
{
    if(!_assetsLibrary)
    {
        _assetsLibrary = [[ALAssetsLibrary alloc]init];
    }
    return _assetsLibrary;
}
#pragma clang diagnostic pop

@end

