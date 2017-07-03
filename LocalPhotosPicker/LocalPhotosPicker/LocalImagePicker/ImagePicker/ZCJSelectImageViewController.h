//
//  ZCJSelectImageViewController.h
//  imagePickerTool
//
//  Created by  zengchunjun on 16/4/26.
//  Copyright © 2016年  zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class ZCJSelectImageViewController;

@protocol ZCJSelectImageViewControllerDelegate <NSObject>

- (void)selectImageViewController:(id)picker didFinishPickingImageWithInfo:(NSArray<UIImage *> *)info;
@end

@interface ZCJSelectImageViewController : UIViewController

@property (strong, nonatomic) ALAssetsGroup *assetsGroup;

@property (strong, nonatomic) ALAssetsLibrary   *assetsLibrary;

@property (strong, nonatomic) NSMutableArray    *assetsArray;


@property (nonatomic,assign)id<ZCJSelectImageViewControllerDelegate> delegate;
@end
