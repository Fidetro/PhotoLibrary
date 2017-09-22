//
//  PhotoLibraryModel.h
//  PhotoDemo
//
//  Created by Fidetro on 2017/9/22.
//  Copyright © 2017年 Fidetro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface PhotoLibraryModel : NSObject

@property(nonatomic,strong) ALAsset *asset;
@property(nonatomic,strong) UIImage *image;
@end
