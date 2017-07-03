//
//  PhotoBrowserCell.h
//  PhotoBrowserDemo
//
//  Created by  zengchunjun on 2017/5/13.
//  Copyright © 2017年  zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class LocalPhotoBrowserCell;

@protocol LocalPhotoBrowserCellDelegate <NSObject>

- (void)localPhotoBrowserCellimageViewClick:(LocalPhotoBrowserCell *)cell;


@end

@interface LocalPhotoBrowserCell : UICollectionViewCell
//本地图片的一个类
@property (nonatomic,strong)ALAsset *aset;

@property (nonatomic,weak)id<LocalPhotoBrowserCellDelegate> delegate;

@property (nonatomic,strong)UIImageView *imageView;

@end
