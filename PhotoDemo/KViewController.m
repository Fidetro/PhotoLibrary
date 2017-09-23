//
//  KViewController.m
//  PhotoDemo
//
//  Created by Fidetro on 2017/9/22.
//  Copyright © 2017年 Fidetro. All rights reserved.
//

#import "KViewController.h"
#import "PhotoLibraryModel.h"
#import "PhotoCollectionViewCell.h"
#import "PhotosHelper.h"
@interface KViewController ()
<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong) UICollectionView *collectionView;
/** 获取相册的类 **/
@property(nonatomic,strong) NSMutableArray *allPhotos;
@end

@implementation KViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self refreshEvent];
}

- (void)refreshEvent
{
    self.allPhotos = [NSMutableArray array];

    [PhotosHelper ascending:NO size:CGSizeMake(50, 50) resizeMode:PHImageRequestOptionsResizeModeFast allPhotoCompletionhandler:^(NSArray<PhotoModel *> *models) {
        self.allPhotos = [models copy];
        [self.collectionView reloadData];
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
    PhotoModel *model = self.allPhotos[indexPath.row];
    if (model.image == nil)
    {
        [PhotosHelper accessToImageAccordingToTheAsset:model.asset size:CGSizeMake(50, 50) resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image, NSDictionary *info) {
            model.image = image;
            photoCell.imageView.image = model.image;
        }];
    }
    else
    {
        photoCell.imageView.image = model.image;
    }
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
