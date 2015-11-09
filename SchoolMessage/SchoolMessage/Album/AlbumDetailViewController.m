//
//  AlbumDetailViewController.m
//  VXiaoYuan
//
//  Created by YanShuJ on 14-8-20.
//  Copyright (c) 2014年 XianTe. All rights reserved.
//

#import "AlbumDetailViewController.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "AddPhotoViewController.h"
#import "AlbumEditViewController.h"
#import "AlbumManager.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"

static NSString *identifier = @"clsll";
//#import "CreateAlbumViewController.h"

@interface AlbumDetailViewController ()<MBProgressHUDDelegate,UICollectionViewDataSource,UICollectionViewDelegate,AddPhotodelegate,AlbumOnDeleteAlbumDelegate>
{
    MJRefreshFooterView *fooder_;
    MJRefreshHeaderView *header_; 
}

@property (nonatomic,strong) NSString *albumId;
@property (nonatomic,strong) NSString *albumName;
@property (nonatomic,strong) NSDictionary *classInfos;

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *photoDataSource;

@property (nonatomic) NSInteger page;

@end

@implementation AlbumDetailViewController

-(instancetype)initWithAlbumId:(NSString *)albumId AlbumName:(NSString *)AlbumName classInfos:(NSDictionary *)classInfos
{
    self = [super init];
    if (self) {
        self.albumId = albumId;
        self.albumName = AlbumName;
        self.classInfos = classInfos;
    }
    return  self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photoDataSource = [[NSMutableArray alloc] init];
    self.title = self.albumName;
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH-40-15*2)/3,(SCREEN_WIDTH-40-15*2)/3);
    flowLayout.minimumInteritemSpacing = 15;
    flowLayout.minimumLineSpacing = 12;
    
    NSNumber *cid =[self.classInfos objectForKey:@"ClassId" ] ;
    if ([[AccountManager  sharedInstance].LoginInfos isClassMaster:cid.stringValue]) {
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.frame = CGRectMake(0, 0, 44, 44);
        [addBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(editAlbum:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
        self.navigationItem.rightBarButtonItem = addItem;
        
        
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH-40, 40)];
        [button setTitle:@"上传照片" forState:0];
        [button setTitleColor:[UIColor whiteColor] forState:0];
        [button setBackgroundColor:[UtilManager getColorWithHexString:@"#18b4ed"]];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(uploadImage:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 92, SCREEN_WIDTH-20, SCREEN_HEIGHT-64-92) collectionViewLayout:flowLayout];
    }else
    {
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH-20, SCREEN_HEIGHT-64-92) collectionViewLayout:flowLayout];
    }
    
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifier];
    [self.view addSubview:self.collectionView];
    
    [self creatRefreshHeader:self.collectionView];
    [header_ beginRefreshing];
}

-(void)creatRefreshHeader:(UIScrollView *)scr
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    __weak typeof(self) weak = self;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *Refresh)
    {
        weak.page = 0;
        [weak getPhotos:^(BOOL succed) {
            [header_ endRefreshing];
            if (succed) {
                if (self.photoDataSource.count>14) {
                    [weak creatRefreshFooder:weak.collectionView];
                }
                if (self.photoDataSource.count ==0) {
                    self.navigationItem.rightBarButtonItem =nil;
                }
            }else
            {
                [weak showHint:@"操作失败，请检查网络！"];
            }
        }];
    };
    header.scrollView = scr;
    header_ = header;
}

-(void)creatRefreshFooder:(UIScrollView *)scr
{
    if (fooder_) {
        return;
    }
    MJRefreshFooterView *fooder = [MJRefreshFooterView footer];
    __weak typeof(self) weak = self;
    fooder.beginRefreshingBlock = ^(MJRefreshBaseView *Refresh)
    {
        weak.page++;
        [weak getPhotos:^(BOOL succed) {
            [fooder_ endRefreshing];
            if (succed) {
                
            }else
            {
                [weak showHint:@"操作失败，请检查网络！"];
            }
        }];
    };
    fooder.scrollView = scr;
    fooder_ = fooder;
}

-(void)getPhotos:(void(^)(BOOL succed))callback
{
    [[AlbumManager sharedInstance] getAlbumDetailList:self.page albumId:self.albumId callback:^(BOOL succeed, NSDictionary *data) {
        if (succeed) {
            NSNumber *su = [data objectForKey:S_SUCCESS];
            
            if (su.boolValue) {
                if(self.page==0)
                {
                    [self.photoDataSource removeAllObjects];
                }
                [self.photoDataSource addObjectsFromArray:[data objectForKey:S_OBJ]];
                [self.collectionView reloadData];
            }
            
            callback(su.boolValue);
        }else
        {
            callback(NO);
        }
    }];
}

-(void)editAlbum:(id)sender
{
    AlbumEditViewController *vc = [[AlbumEditViewController alloc] init];
    vc.photoDataSource = self.photoDataSource;
    vc.albumId = self.albumId;
    vc.delegate =self;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)AlbumOnDelete:(NSArray *)idData
{
    for (int i =self.photoDataSource.count-1; i>=0; i--) {
        NSDictionary *dic = [self.photoDataSource objectAtIndex:i];
        for (int j=0; j<idData.count; j++) {
            NSNumber *temp = [idData objectAtIndex:j];
            
            if ([temp.stringValue isEqualToString:((NSNumber *)[dic objectForKey:@"ADId"]).stringValue]) {
                [self.photoDataSource removeObjectAtIndex:i];
            }
        }
    }
    
    [self.collectionView reloadData];
}

-(void)uploadImage:(id)sender
{
    AddPhotoViewController *vc = [[AddPhotoViewController alloc] init];
    vc.classNameData = [NSMutableDictionary dictionaryWithDictionary:self.classInfos];
    vc.albumId = self.albumId;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)AddPhoto:(NSMutableArray *)results
{
    [self.photoDataSource insertObjects:results atIndexes:0];
    [self.collectionView reloadData];
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
        iv.contentMode = UIViewContentModeScaleAspectFill;
        iv.clipsToBounds = YES;
    }
    NSDictionary *dic = [self.photoDataSource objectAtIndex:indexPath.row];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",imageUrl,[dic objectForKey:@"FullName"]];
    [iv setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UtilManager imageNamed:@"moretupian"]];
    return cell;
}- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    int count = self.photoDataSource.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        NSDictionary *dic = [self.photoDataSource objectAtIndex:i];
        NSString *url = [NSString stringWithFormat:@"%@%@",imageUrl,[dic objectForKey:@"FullName"]];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        photo.comment = [dic objectForKey:@"Describtion"];
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = indexPath.row; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
