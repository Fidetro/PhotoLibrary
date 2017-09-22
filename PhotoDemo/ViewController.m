//
//  ViewController.m
//  PhotoDemo
//
//  Created by Fidetro on 2017/9/22.
//  Copyright © 2017年 Fidetro. All rights reserved.
//

#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AssetLibraryHelper.h"
#import "PhotoLibraryModel.h"
#import "PhotoCollectionViewCell.h"
@interface ViewController ()
<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong) UICollectionView *collectionView;
/** 获取相册的类 **/
@property(nonatomic,strong) AssetLibraryHelper *libraryHelper;
@property(nonatomic,strong) NSMutableArray *allPhotos;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self refreshEvent];
}

- (void)refreshEvent
{
    [AssetLibraryHelper authorizationStatus];
    [self.libraryHelper allAssetsResultCompletionhandler:^(NSArray<ALAsset *> *imagesAssets) {
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            
            
            self.allPhotos = [NSMutableArray array];
            for (ALAsset *asset in imagesAssets)
            {
                PhotoLibraryModel *photoLibraryModel = [[PhotoLibraryModel alloc]init];
                photoLibraryModel.asset = asset;
                photoLibraryModel.image = [AssetLibraryHelper assetToImage:asset isHighQuality:NO];
                [self.allPhotos addObject:photoLibraryModel];
            }
            [self.collectionView reloadData];
        }];
    } failureBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.allPhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    PhotoLibraryModel *model = self.allPhotos[indexPath.row];
    photoCell.imageView.image = model.image;
    return photoCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(50, 50);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return CGFLOAT_MIN;
}


- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake(0, 0);
        _collectionView = [[UICollectionView alloc]initWithFrame:[[UIScreen mainScreen]bounds] collectionViewLayout:flowLayout];
        [_collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (AssetLibraryHelper *)libraryHelper
{
    if(!_libraryHelper)
    {
        _libraryHelper = [[AssetLibraryHelper alloc]init];
    }
    return _libraryHelper;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
