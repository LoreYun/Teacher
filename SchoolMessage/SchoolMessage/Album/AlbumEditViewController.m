//
//  AlbumEditViewController.m
//  SchoolMessage
//
//  Created by LI on 15/2/5.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "AlbumEditViewController.h"
#import "AlbumManager.h"
#import "UIImageView+WebCache.h"
#import "SMAlertView.h"

static NSString *identifier = @"clsl1l";

@interface AlbumEditViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,SMAlertViewDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *selArray;

@end

@implementation AlbumEditViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"编辑相册";
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH-40-15*2)/3,(SCREEN_WIDTH-40-15*2)/3);
    flowLayout.minimumInteritemSpacing = 15;
    flowLayout.minimumLineSpacing = 12;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, SCREEN_HEIGHT-64-92) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(10, 0, 0, 10);
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifier];
    [self.view addSubview:self.collectionView];
    
    UIButton *delete = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-50, SCREEN_WIDTH/2, 50)];
    delete.layer.borderColor = [UtilManager getColorWithHexString:@"#808080"].CGColor;
    delete.layer.borderWidth =1;
    delete.backgroundColor = [UIColor whiteColor];
    [delete setTitle:@"删除照片" forState:0];
    [delete setTitleColor:[UtilManager getColorWithHexString:@"#18b4ed"] forState:0];
    [delete addTarget:self action:@selector(deletePhotos:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:delete];
    
    UIButton *corver = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-64-50, SCREEN_WIDTH/2, 50)];
    corver.layer.borderColor = [UtilManager getColorWithHexString:@"#808080"].CGColor;
    corver.layer.borderWidth =1;
    corver.backgroundColor = [UIColor whiteColor];
    [corver setTitle:@"设为封面" forState:0];
    [corver setTitleColor:[UtilManager getColorWithHexString:@"#18b4ed"] forState:0];
    [corver addTarget:self action:@selector(setCorver:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:corver];
    
    self.selArray = [NSMutableArray array];
    for (int i = 0; i<self.photoDataSource.count; i++) {
        [self.selArray addObject:[NSNumber numberWithBool:NO]];
    }
    
    [self.collectionView reloadData];
    
}

-(void)deletePhotos:(id)sender
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i<self.selArray.count; i++) {
        NSNumber *flag = [self.selArray objectAtIndex:i];
        if (flag.boolValue) {
            NSDictionary *dic = [self.photoDataSource objectAtIndex:i];
            [array addObject:[dic objectForKey:@"ADId"]];
        }
    }
    if (array.count==0) {
        [self showHint:@"请选择要删除的图片！"];
        return;
    }
    
    SMAlertView *alert = [[SMAlertView alloc] initWithTitle:nil message:@"删除之后将不可恢复" delegate:self cancelButtonTitle:@"取消"];
    [alert show];
}


-(void)SMAlertViewonConfirm:(SMAlertView *)alertView
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i<self.selArray.count; i++) {
        NSNumber *flag = [self.selArray objectAtIndex:i];
        if (flag.boolValue) {
            NSDictionary *dic = [self.photoDataSource objectAtIndex:i];
            [array addObject:[dic objectForKey:@"ADId"]];
        }
    }
    if (array.count==0) {
        [self showHint:@"请选择要删除的图片！"];
        return;
    }
    
    [[AlbumManager sharedInstance] deletePhotoInAlbum:array callback:^(BOOL succeed, NSDictionary *result) {
        [self hideHud];
        if (succeed) {
            succeed = ((NSNumber *)[result objectForKey:S_SUCCESS]).boolValue;
        }
        if (succeed) {
            if(self.delegate && [self.delegate respondsToSelector:@selector(AlbumOnDelete:)])
            {
                [self.delegate AlbumOnDelete:array];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [self showHint:@"操作失败，请检查网络！"];
        }
    }];
}

-(void)setCorver:(id)sender
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i<self.selArray.count; i++) {
        NSNumber *flag = [self.selArray objectAtIndex:i];
        if (flag.boolValue) {
            NSDictionary *dic = [self.photoDataSource objectAtIndex:i];
            [array addObject:[dic objectForKey:@"FullName"]];
        }
    }
    if (array.count==0) {
        [self showHint:@"请选择一张图片！"];
        return;
    }
    
    if (array.count>1) {
        [self showHint:@"只能选择一张图片！"];
        return;
    }
    
    [self showHudInView:self.view hint:@"请稍后"];
    [[AlbumManager sharedInstance] setAlbumCover:self.albumId fileName:@"" fullName:[array objectAtIndex:0] callback:^(BOOL succeed, NSDictionary *result) {
        [self hideHud];
        if (succeed) {
            succeed = ((NSNumber *)[result objectForKey:S_SUCCESS]).boolValue;
        }
        if (succeed) {
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [self showHint:@"操作失败，请检查网络！"];
        }
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  self.photoDataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    UIImageView *iv = (UIImageView *)[cell viewWithTag:5];
    if (!iv) {
        iv = [[UIImageView alloc] initWithFrame:cell.bounds];
        iv.tag =5;
        [cell addSubview:iv];
    }
    
    UIImageView *selIv = (UIImageView *)[cell viewWithTag:6];
    if (!selIv) {
        selIv = [[UIImageView alloc] initWithFrame:CGRectMake(cell.bounds.size.width-29, 1, 28, 28)];
        selIv.tag =6;
        [cell addSubview:selIv];
    }
    NSDictionary *dic = [self.photoDataSource objectAtIndex:indexPath.row];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",imageUrl,[dic objectForKey:@"FullName"]];
    [iv setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UtilManager imageNamed:@"moretupian"]];
    
    NSNumber *flag = [self.selArray objectAtIndex:indexPath.row];
    selIv.image = [UtilManager imageNamed:flag.boolValue?@"album_sel":@"album_unsel"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *flag = [self.selArray objectAtIndex:indexPath.row];
    [self.selArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:!flag.boolValue]];
    [self.collectionView reloadData];
}


@end
