//
//  ViewController.m
//  LocalPhotosPicker
//
//  Created by zengchunjun on 2017/7/3.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "ViewController.h"
#import "ZCJImagesViewController.h"
#import "ZCJSelectImageViewController.h"

@interface ViewController ()<ZCJSelectImageViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    ZCJImagesViewController *imagesCtr = [[ZCJImagesViewController alloc] init];
    imagesCtr.delegate = self;
    UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:imagesCtr];
    [self presentViewController:navigation animated:YES completion:nil];
}

#pragma mark:ZCJSelectImageViewControllerDelegate 选择照片的回调
- (void)selectImageViewController:(id)picker didFinishPickingImageWithInfo:(NSArray<UIImage *> *)info
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
