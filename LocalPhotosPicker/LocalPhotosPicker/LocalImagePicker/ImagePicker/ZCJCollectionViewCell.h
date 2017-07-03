//
//  ZCJCollectionViewCell.h
//  imagePickerTool
//
//  Created by  zengchunjun on 16/4/26.
//  Copyright © 2016年  zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZCJCollectionViewCell;
@protocol ZCJCollectionViewCellDelegate <NSObject>

- (void)collectionViewWithSelected:(ZCJCollectionViewCell *)collectionViewCell;
- (void)collectionViewWithDeSelected:(ZCJCollectionViewCell *)collectionViewCell;

@end

@interface ZCJCollectionViewCell : UICollectionViewCell<UIGestureRecognizerDelegate>

@property (nonatomic,assign)BOOL choosed;

@property (nonatomic,strong)UIImageView *imageView;

@property (nonatomic,strong)UIButton *selectedBtn;


@property (nonatomic,assign)id<ZCJCollectionViewCellDelegate> delegate;
@end
