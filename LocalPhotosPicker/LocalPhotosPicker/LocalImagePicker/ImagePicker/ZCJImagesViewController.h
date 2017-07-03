//
//  ZCJImagesViewController.h
//  imagePickerTool
//
//  Created by  zengchunjun on 16/4/26.
//  Copyright © 2016年  zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@protocol ZCJSelectImageViewControllerDelegate;

@interface ZCJImagesViewController : UIViewController

@property (nonatomic,assign)id<ZCJSelectImageViewControllerDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *groupArray;

@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;

@property (nonatomic,assign)BOOL isFromMail;

@end
