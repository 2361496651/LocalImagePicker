//
//  ZCJSelectImageViewController.m
//  imagePickerTool
//
//  Created by  zengchunjun on 16/4/26.
//  Copyright © 2016年  zengchunjun. All rights reserved.
//

#import "ZCJSelectImageViewController.h"
#import "ZCJCollectionViewCell.h"
#import "LocalPhotoBrowserVC.h"


#define screenW [UIScreen mainScreen].bounds.size.width

@interface ZCJSelectImageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,ZCJCollectionViewCellDelegate>

@property (nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic,strong)NSMutableArray *items;

@property (nonatomic,strong)NSMutableArray *imageIndex;



@end

static NSString *ID = @"collection_cell";
@implementation ZCJSelectImageViewController



// 自定义右上角确定按钮
- (void)setRightBarButtonWithTitle:(NSString *)title
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:title forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightButton addTarget:self action:@selector(doneButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    rightButton.bounds = CGRectMake(0, 0, 80, 44);
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"照片";

    [self setRightBarButtonWithTitle:@"完成(0/9)"];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成(0/9)" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonDidClick)];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelButton)];
    
    self.items = [NSMutableArray array];
    self.imageIndex = [NSMutableArray array];
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemWH = (screenW - 4*10) / 4;
    
    flowLayout.itemSize = CGSizeMake(itemWH, itemWH);
    flowLayout.minimumLineSpacing = 4;
    flowLayout.minimumInteritemSpacing = 4;
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 10, 0, 10);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.allowsMultipleSelection = YES;// 允许多选
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[ZCJCollectionViewCell class] forCellWithReuseIdentifier:ID];
    
    [self getImages];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.collectionView reloadData];
    
    NSString *title = [NSString stringWithFormat:@"完成(%ld/9)",(unsigned long)self.imageIndex.count];
    [self setRightBarButtonWithTitle:title];
}


//获取当前相册里的照片
- (void)getImages
{
    if (!self.assetsArray) {
        _assetsArray = [[NSMutableArray alloc] init];
    }
    
    if (!self.assetsLibrary) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    
    [self.assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
    
    [self.assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            
            [self.items insertObject:result atIndex:0];
            
//            NSString *urlstr = [NSString stringWithFormat:@"%@",result.defaultRepresentation.url];
//            [self.items insertObject:result.defaultRepresentation.url atIndex:0];
        }
        if (index == [self.assetsGroup numberOfAssets]) {
            [self.collectionView reloadData];

        }
        
    }];
   
}

- (void)cancelButton
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneButtonDidClick
{
    NSMutableArray *model = [NSMutableArray array];
    for (NSString *index in self.imageIndex)
    {
        ALAsset *asset = [self.items objectAtIndex:index.intValue];
        
        CGImageRef ref = [[asset  defaultRepresentation]fullScreenImage];
        UIImage *img = [[UIImage alloc]initWithCGImage:ref];
        [model addObject:img];
        
        
/*
        NSURL *url = [self.items objectAtIndex:index.intValue];
        ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
        [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
            UIImage *image = [UIImage imageWithCGImage:[[asset  defaultRepresentation]fullScreenImage]];
            [model addObject:image];
            if (model.count == self.imageIndex.count) {
                
                if ([self.delegate respondsToSelector:@selector(selectImageViewController:didFinishPickingImageWithInfo:)]) {
                    [self.delegate selectImageViewController:self didFinishPickingImageWithInfo:model];
                }
            }
            
        } failureBlock:^(NSError *error) {
            NSLog(@"1212");
        }];
 */

    }
 
    
    [self dismissViewControllerAnimated:YES completion:nil];

    if ([self.delegate respondsToSelector:@selector(selectImageViewController:didFinishPickingImageWithInfo:)]) {
        [self.delegate selectImageViewController:self didFinishPickingImageWithInfo:model];
    }

}

#pragma mark UICollectionView代理方法，数据源方法

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    NSLog(@"%ld",self.items.count);
    return self.items.count;
//    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZCJCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.delegate = self;

    ALAsset *set = self.items[indexPath.row];
    UIImage *image = [UIImage imageWithCGImage:set.thumbnail];
    cell.imageView.image = image;
    
//    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
//    NSURL *url = self.items[indexPath.row];
//    [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
//        cell.imageView.image = [UIImage imageWithCGImage:asset.thumbnail];
//    } failureBlock:^(NSError *error) {
//        
//    }];
    
    NSString *index = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    if ([_imageIndex containsObject:index])
    {
        cell.choosed = YES;
    }
    else{
        cell.choosed = NO;
    }
    
 
    return cell;
    
}

#pragma mark ZCJCollectionViewCellDelegate代理方法
- (void)collectionViewWithSelected:(ZCJCollectionViewCell *)collectionViewCell
{
   NSIndexPath *index = [self.collectionView indexPathForCell:collectionViewCell];
  
    // 把这个索引添加到数组
//    if (self.imageIndex.count < 9) {
    
    [self.imageIndex addObject:[NSString stringWithFormat:@"%ld",(long)index.row]];

//    }
    
    NSString *title = [NSString stringWithFormat:@"完成(%ld/9)",(unsigned long)self.imageIndex.count];
    [self setRightBarButtonWithTitle:title];
    
}

- (void)collectionViewWithDeSelected:(ZCJCollectionViewCell *)collectionViewCell
{
    NSIndexPath *index = [self.collectionView indexPathForCell:collectionViewCell];
    NSLog(@"%ld 未选择",index.row);
    // 从数组里删除这个索引
    [self.imageIndex removeObject:[NSString stringWithFormat:@"%ld",(long)index.row]];
    
    NSString *title = [NSString stringWithFormat:@"完成(%ld/9)",(unsigned long)self.imageIndex.count];
    [self setRightBarButtonWithTitle:title];
}




// 已经选中某个item时触发的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LocalPhotoBrowserVC *browserVC = [[LocalPhotoBrowserVC alloc] init];
    browserVC.indexPath = indexPath;
    browserVC.picALAssets = self.items;
    browserVC.selectedImageIndex = self.imageIndex;
    browserVC.callBack = ^(NSMutableArray *images) {
        self.imageIndex = images;
    };
    

//    browserVC.modalPresentationStyle = UIModalPresentationCustom;//自定义modal样式
//    browserVC.transitioningDelegate = self.photoBrowserAnimator;//转场代理
    
//    self.photoBrowserAnimator.presentedDelegate = self;
//    self.photoBrowserAnimator.indexPath = indexPath;
//    self.photoBrowserAnimator.dismissDelegate = browserVC;
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:browserVC];
//    [self presentViewController:nav animated:YES completion:nil];
    
    [self.navigationController pushViewController:browserVC animated:YES];

    
}
#pragma mark  PhotoAnimationPresentedDelegate

- (CGRect)startRect:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    CGRect startRect = [self.collectionView convertRect:cell.frame toCoordinateSpace:[UIApplication sharedApplication].keyWindow];
    return startRect;
}
- (CGRect)endRect:(NSIndexPath *)indexPath
{
//    NSURL *url = self.items[indexPath.item];
//    UIImage *image = [[[SDWebImageManager sharedManager] imageCache] imageFromDiskCacheForKey:url.absoluteString];
    
    ALAsset *set = self.items[indexPath.row];
    UIImage *image = [UIImage imageWithCGImage:[set.defaultRepresentation fullScreenImage]];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    CGFloat height = (width / image.size.width) * image.size.height;
    CGFloat y = 0.0;
    if (height > screenH) {
        y = 0.0;
    }else{
        y = (screenH - height) * 0.5;
    }
    
    return CGRectMake(0, y, width, height);
}
- (UIImageView *)imageView:(NSIndexPath *)indexPath
{
    UIImageView *imageView = [[UIImageView alloc]init];
//    NSURL *url = self.items[indexPath.item];
//    UIImage *image = [[[SDWebImageManager sharedManager] imageCache] imageFromDiskCacheForKey:url.absoluteString];
    ALAsset *set = self.items[indexPath.row];
    UIImage *image = [UIImage imageWithCGImage:[set.defaultRepresentation fullScreenImage]];
    
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.clipsToBounds = YES;
    
    return imageView;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
