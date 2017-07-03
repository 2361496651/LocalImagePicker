//
//  PhotoBrowserVC.h
//  PhotoBrowserDemo
//
//  Created by  zengchunjun on 2017/5/13.
//  Copyright © 2017年  zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>


typedef void(^selectedImageBlock)(NSMutableArray *images);

@interface LocalPhotoBrowserVC : UIViewController


@property (nonatomic,strong)NSIndexPath *indexPath;

//查看本地图片
@property (nonatomic,strong)NSArray<ALAsset *> *picALAssets;

// 传入已经选中了的图片的索引
@property (nonatomic,strong)NSMutableArray *selectedImageIndex;

//在这个界面选中照片的回调
@property (nonatomic,strong)selectedImageBlock callBack;

@end



@interface LocalPhotoBrowserCollectionViewFlowLayout : UICollectionViewFlowLayout

@end
