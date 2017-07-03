//
//  ZCJCollectionViewCell.m
//  imagePickerTool
//
//  Created by  zengchunjun on 16/4/26.
//  Copyright © 2016年  zengchunjun. All rights reserved.
//

#import "ZCJCollectionViewCell.h"

@implementation ZCJCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        
        //[modified by wanglang:只是让点击区域变大,图片保持原尺寸保证清晰度,而不是换一张更大的图片
        /*
        self.selectedBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 30, 0, 30, 30)];
        
        UIImage *imaged = [UIImage imageNamed:@"disk_check"];
        [self.selectedBtn setBackgroundImage:imaged forState:UIControlStateNormal];
        */
        self.selectedBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 36, 0, 36, 36)];
        self.selectedBtn.contentMode = UIViewContentModeTopRight;
        UIImage *imaged = [UIImage imageNamed:@"selected"];
        [self.selectedBtn setImage:imaged forState:UIControlStateNormal];
        //]
        
        [self.selectedBtn addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.selectedBtn];
    }
    return self;
}

- (void)setChoosed:(BOOL)choosed
{
    _choosed = choosed;
    
    //[modified by wanglang:同上
    /*
    if (_choosed){
        UIImage *imaged = [UIImage imageNamed:@"disk_check_in"];
        [self.selectedBtn setBackgroundImage:imaged forState:UIControlStateNormal];
    }else{
        UIImage *imaged = [UIImage imageNamed:@"disk_check"];
        [self.selectedBtn setBackgroundImage:imaged forState:UIControlStateNormal];
     */
    if (_choosed){
        UIImage *imaged = [UIImage imageNamed:@"selected"];
        [self.selectedBtn setImage:imaged forState:UIControlStateNormal];
    }else{
        UIImage *imaged = [UIImage imageNamed:@"unselected"];
        [self.selectedBtn setImage:imaged forState:UIControlStateNormal];
    }
    //]
}

- (void)selected:(UIButton *)sender
{
    
    self.choosed = !_choosed;
    
    if (self.choosed) {
        if ([self.delegate respondsToSelector:@selector(collectionViewWithSelected:)]) {
            
            [self.delegate collectionViewWithSelected:self];
        }

    }else{
        if ([self.delegate respondsToSelector:@selector(collectionViewWithDeSelected:)]) {
            
            [self.delegate collectionViewWithDeSelected:self];
        }

        
    }    
}
@end
