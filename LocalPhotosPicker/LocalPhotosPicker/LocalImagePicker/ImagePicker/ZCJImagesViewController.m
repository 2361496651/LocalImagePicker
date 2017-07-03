//
//  ZCJImagesViewController.m
//  imagePickerTool
//
//  Created by  zengchunjun on 16/4/26.
//  Copyright © 2016年  zengchunjun. All rights reserved.
//

#import "ZCJImagesViewController.h"
#import "ZCJSelectImageViewController.h"


@interface ZCJImagesViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;

@end

@implementation ZCJImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"照片集";
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
//    self.navigationItem.leftBarButtonItem = [DiffUtil initButtonItemWithTitle:@"取消" action:@selector(cancelButtonDidClick) delegate:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonDidClick)];
    [self checkAlbumGroups];

}
- (void)cancelButtonDidClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)checkAlbumGroups
{
    if (!self.groupArray) {
        _groupArray = [[NSMutableArray alloc] init];
    }
    
    if (!self.assetsLibrary) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // !!! Notice : ALAssetsGroupAll doesn't include ALAssetsGroupLibrary.
        
        [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (group) {
                [self.groupArray addObject:group];
//                [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
            }
            if (group == nil) {//最后一个为nil 刷新
                [self reloadTableView];
            }
        } failureBlock:^(NSError *error) {
            NSLog(@"Group not found!\n");
            self.title = @"访问照片失败"; // Photo-access is disabled.
        }];
    });
}

- (void)reloadTableView
{
    [self.tableView reloadData];
}


#pragma mark tableView代理方法与数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groupArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"group_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    // 获取相册的数据
    ALAssetsGroup *group = self.groupArray[indexPath.row];
    [group setAssetsFilter:[ALAssetsFilter allPhotos]];
    NSInteger groupCount = [group numberOfAssets];
    
    NSString *groupName = [group valueForProperty:ALAssetsGroupPropertyName];
//    NSLog(@"%@",groupName);
    if ([groupName isEqualToString:@"Camera Roll"]) {
        groupName = @"相机胶卷";
    }
    cell.textLabel.text = groupName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"共%ld张",(long)groupCount];
    cell.imageView.image = [UIImage imageWithCGImage:[self.groupArray[indexPath.row] posterImage]];
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZCJSelectImageViewController *selectCtr = [[ZCJSelectImageViewController alloc] init];
    selectCtr.assetsGroup = self.groupArray[indexPath.row];
    selectCtr.delegate = self.delegate;
    [self.navigationController pushViewController:selectCtr animated:YES];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
