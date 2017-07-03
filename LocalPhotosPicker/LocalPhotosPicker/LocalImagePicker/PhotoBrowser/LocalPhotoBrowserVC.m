//
//  PhotoBrowserVC.m
//  PhotoBrowserDemo
//
//  Created by  zengchunjun on 2017/5/13.
//  Copyright © 2017年  zengchunjun. All rights reserved.
//

#import "LocalPhotoBrowserVC.h"
#import "LocalPhotoBrowserCell.h"


@interface LocalPhotoBrowserVC ()<UICollectionViewDataSource,LocalPhotoBrowserCellDelegate,UICollectionViewDelegate>

@property (nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic,strong)UIButton *completeBtn;

@end

static NSString *photoBrowserCell = @"LocalPhotoBrowserCell";

@implementation LocalPhotoBrowserVC


- (UIButton *)completeBtn
{
    if (_completeBtn == nil) {
        // 右下角放一个完成按钮
        
        UIButton *completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        completeBtn.frame = CGRectMake(self.view.frame.size.width - 80, self.view.frame.size.height - 50 , 65, 36);
        completeBtn.backgroundColor = [UIColor orangeColor];
        completeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        
        NSString *btnTitle = [NSString stringWithFormat:@"完成(%ld)",(unsigned long)self.selectedImageIndex.count];
        [completeBtn setTitle:btnTitle forState:UIControlStateNormal];
        [completeBtn addTarget:self action:@selector(completeClick) forControlEvents:UIControlEventTouchUpInside];
        
        _completeBtn = completeBtn;
    }
    return _completeBtn;
}
//完成选中
- (void)completeClick
{
    NSMutableArray *model = [NSMutableArray array];
    for (NSString *index in self.selectedImageIndex)
    {
        ALAsset *asset = [self.picALAssets objectAtIndex:index.intValue];
        
        
        CGImageRef ref = [[asset  defaultRepresentation]fullScreenImage];
        UIImage *img = [[UIImage alloc]initWithCGImage:ref];
        [model addObject:img];
        
        
    }
    
//    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        
        LocalPhotoBrowserCollectionViewFlowLayout *layout = [[LocalPhotoBrowserCollectionViewFlowLayout alloc]init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    
    return _collectionView;
}

- (void)loadView
{
    [super loadView];
    
    CGRect frame = self.view.frame;
    frame.size.width += 20;
    self.view.frame = frame;
}

// 自定义右上角确定按钮
- (void)setRightBarButtonWithTitle:(NSString *)title
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.layer.cornerRadius = 12;
    rightButton.layer.masksToBounds = YES;
    
    [rightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [rightButton addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    rightButton.bounds = CGRectMake(0, 0, 24, 24);
    
    
    if ([self.selectedImageIndex containsObject:title]) {// 这张照片已经被选中
        NSString *total = [NSString stringWithFormat:@"%ld",(unsigned long)self.selectedImageIndex.count];
        [rightButton setTitle:total forState:UIControlStateNormal];
        rightButton.backgroundColor = [UIColor greenColor];
    }else{
        [rightButton setTitle:nil forState:UIControlStateNormal];
        rightButton.backgroundColor = [UIColor blackColor];
    }
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

// 选中或取消选中这张照片
- (void)rightBtnClick
{
    NSIndexPath *visibleIndex = [self.collectionView indexPathsForVisibleItems].firstObject;
    NSString *visibleIndexStr = [NSString stringWithFormat:@"%ld",(long)visibleIndex.row];
    
    if ([self.selectedImageIndex containsObject:visibleIndexStr]) {//已经选中过这个图片，就取消选中
        [self.selectedImageIndex removeObject:visibleIndexStr];
    }else{ // 选中这张图片
        [self.selectedImageIndex addObject:visibleIndexStr];
    }
    
    [self setRightBarButtonWithTitle:visibleIndexStr];
    
    self.callBack(self.selectedImageIndex);//回调给上一个界面，选中的图片数组有改变
    
    
    NSString *btnTitle = [NSString stringWithFormat:@"完成(%ld)",(unsigned long)self.selectedImageIndex.count];
    [self.completeBtn setTitle:btnTitle forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self setupUI];
    
    [self.collectionView scrollToItemAtIndexPath:self.indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    self.title = [NSString stringWithFormat:@"%ld/%ld",self.indexPath.row+1,(unsigned long)self.picALAssets.count];
    
    [self setRightBarButtonWithTitle:[NSString stringWithFormat:@"%ld",(long)self.indexPath.row]];
}


// 自然滑动停止时调用，若手指停止滑动的位置为最终位置则不会调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    NSArray *array = [self.collectionView indexPathsForVisibleItems];
//    NSLog(@"==%ld",array.count);
    NSIndexPath *visibleIndex = [self.collectionView indexPathsForVisibleItems].firstObject;
    self.title = [NSString stringWithFormat:@"%ld/%ld",visibleIndex.row+1,(unsigned long)self.picALAssets.count];
    
    [self setRightBarButtonWithTitle:[NSString stringWithFormat:@"%ld",(long)visibleIndex.row]];
    
    
}

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (!decelerate){
        
        //这里写上停止时要执行的代码
//        NSArray *array = [self.collectionView indexPathsForVisibleItems];
//        NSLog(@"%ld==",array.count);
        NSIndexPath *visibleIndex = [self.collectionView indexPathsForVisibleItems].firstObject;
        self.title = [NSString stringWithFormat:@"%ld/%ld",visibleIndex.row+1,(unsigned long)self.picALAssets.count];
        
        [self setRightBarButtonWithTitle:[NSString stringWithFormat:@"%ld",(long)visibleIndex.row]];
    }
    
}

- (void)setupUI
{
    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[LocalPhotoBrowserCell class] forCellWithReuseIdentifier:photoBrowserCell];
    
    
    //右下角放一个完成
//    [self.view addSubview:self.completeBtn];
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return self.picALAssets.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LocalPhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoBrowserCell forIndexPath:indexPath];
    
    cell.delegate = self;
    
    cell.aset = self.picALAssets[indexPath.item];
    
    return cell;
}




- (void)localPhotoBrowserCellimageViewClick:(LocalPhotoBrowserCell *)cell
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark;PhotoAnimationDismissDelegate
- (UIImageView *)imageViewForDismissView
{
    UIImageView *imageView = [[UIImageView alloc]init];
    LocalPhotoBrowserCell *cell = [self.collectionView visibleCells].firstObject;
    imageView.frame = cell.imageView.frame;
    imageView.image = cell.imageView.image;
    
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.clipsToBounds = YES;
    
    return imageView;
}

- (NSIndexPath *)indexPathForDismissView
{
    return [self.collectionView indexPathsForVisibleItems].firstObject;
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


@implementation LocalPhotoBrowserCollectionViewFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    
    
    // 1.设置itemSize
    self.itemSize = self.collectionView.frame.size;
    self.minimumInteritemSpacing = 0;
    self.minimumLineSpacing = 0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // 2.设置collectionView的属性
    self.collectionView.pagingEnabled = true;
    self.collectionView.showsHorizontalScrollIndicator = false;
    self.collectionView.showsVerticalScrollIndicator = false;
}

@end



