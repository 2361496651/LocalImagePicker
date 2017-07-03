//
//  PhotoBrowserCell.m
//  PhotoBrowserDemo
//
//  Created by  zengchunjun on 2017/5/13.
//  Copyright © 2017年  zengchunjun. All rights reserved.
//

#import "LocalPhotoBrowserCell.h"

@interface LocalPhotoBrowserCell ()

@property (nonatomic,strong)UIScrollView *scrollView;

@end

@implementation LocalPhotoBrowserCell

- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
        CGRect frame = _scrollView.frame;
        frame.size.width -= 20;
        _scrollView.frame = frame;
    }
    return _scrollView;
}


- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewClick)];
        _imageView.userInteractionEnabled = YES;
        [_imageView addGestureRecognizer:tap];
    }
    return _imageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
    }
    return self;
}


- (void)setupUI
{
    
    [self.contentView addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.imageView];
    
}

- (void)imageViewClick
{
    if ([self.delegate respondsToSelector:@selector(localPhotoBrowserCellimageViewClick:)]) {
        [self.delegate localPhotoBrowserCellimageViewClick:self];
    }
}


- (void)setAset:(ALAsset *)aset
{
    _aset = aset;
    
    UIImage *image = [UIImage imageWithCGImage:aset.defaultRepresentation.fullScreenImage];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    CGFloat height = (width / image.size.width) * image.size.height;
    CGFloat y = 0.0;
    if (height > screenH) {
        y = 0.0;
    }else{
        y = (screenH - height) * 0.5;
    }
    
    self.imageView.frame = CGRectMake(0, y, width, height);
    
    self.imageView.image = image;
    
    self.scrollView.contentSize = CGSizeMake(width, height);

}





















@end
