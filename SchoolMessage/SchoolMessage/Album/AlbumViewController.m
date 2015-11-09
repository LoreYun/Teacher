//
//  AlbumViewController.m
//  VXiaoYuan
//
//  Created by YanShuJ on 14-8-17.
//  Copyright (c) 2014年 XianTe. All rights reserved.
//

#import "AlbumViewController.h"
//#import "CreateAlbumViewController.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "DataAccess.h"
#import "AlbumCell.h"
#import "AlbumDetailViewController.h"
#import "AlbumAddViewController.h"
#import "AlbumManager.h"
//#import "AddAlbumViewController.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "ClassChooseAlertView.h"

@interface AlbumViewController ()<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate,UITextFieldDelegate,ClassChooseAlertViewDalegate,AlbumAddDelegate>
{
    UITableView *mainTableView;
    NSMutableArray *mainDataSource;
    
    MBProgressHUD *HUD;
    
    UIView *addPhotoView;
    UITextField *photoName_textField;
    
    NSMutableDictionary *photoDic;
    
    NSMutableArray *photoDataSource;
    
    MJRefreshFooterView *fooder_;
    MJRefreshHeaderView *header_;
}

@property (nonatomic) NSInteger page;

@property (nonatomic,strong) NSMutableDictionary *classNameData;
@end

@implementation AlbumViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.page = 0;
    NSArray * array = [[AccountManager sharedInstance].LoginInfos getTeacherClassesArray];
    if (array.count==0) {
        return;
    }
    self.classNameData = array.count>0?[array objectAtIndex:0]:[NSMutableDictionary dictionary];
    [self initTitleView];
    [self rightVVV];
    mainDataSource = [[NSMutableArray alloc] init];
    photoDic = [[NSMutableDictionary alloc] init];
    photoDataSource = [[NSMutableArray alloc] init];
    
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, self.view.frame.size.height-64)];
    mainTableView.backgroundColor = [UIColor clearColor];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
    
    [self creatRefreshHeader:mainTableView];
    [header_ beginRefreshing];
    
}

-(void)rightVVV
{
    NSNumber *cid =[self.classNameData objectForKey:@"ClassId" ] ;
    if ([[AccountManager  sharedInstance].LoginInfos isClassMaster:cid.stringValue]) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 0, 44, 44);
        [backBtn setImage:[UtilManager imageNamed:@"add"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(addAlbum) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        self.navigationItem.rightBarButtonItem = backItem;

    }else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
}

-(void)initTitleView
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,320, 44)];
    [titleLabel setTextColor:[UIColor whiteColor]];
    titleLabel.font = [UIFont fontWithName:@ "HelveticaNeue-CondensedBlack" size:21.0];
    titleLabel.text = [NSString stringWithFormat:@"%@%@▼",[self.classNameData objectForKey:@"GradeName"],[self.classNameData objectForKey:@"ClassName"]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.userInteractionEnabled = YES;
    [titleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTitleView)]];
    self.navigationItem.titleView = titleLabel;
}

-(void)tapTitleView
{
    ClassChooseAlertView * alert = [[ClassChooseAlertView alloc] initWithDic:[[AccountManager sharedInstance].LoginInfos getTeacherClassesArray] classID:[self.classNameData objectForKey:@"ClassId" ] type:ClassChoose];
    alert.delegate = self;
    [alert show];
}

-(void)ClassChooseOnDisMiss:(NSDictionary *)data
{
    NSString *idnew = ((NSNumber *)[data objectForKey:@"ClassId"]).stringValue;
    NSString *idold = ((NSNumber *)[self.classNameData objectForKey:@"ClassId"]).stringValue;
    if (![idnew isEqualToString:idold]) {
        self.classNameData = [NSMutableDictionary dictionaryWithDictionary:data];
        [self initTitleView];
        [self rightVVV];
        [header_ beginRefreshing];
    }
}

-(void)createAc:(id)sender
{
//    AddAlbumViewController *vc = [AddAlbumViewController new];
//    [self.navigationController pushViewController:vc animated:YES];
}

-(void)creatRefreshHeader:(UIScrollView *)scr
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    __weak typeof(self) weak = self;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *Refresh)
    {
        weak.page = 0;
        [[AlbumManager sharedInstance] getAlbumList:weak.page classId:[self.classNameData objectForKey:@"ClassId"]?[self.classNameData objectForKey:@"ClassId"]:@"" gradeId: [self.classNameData objectForKey:@"GradeId"]?[self.classNameData objectForKey:@"GradeId"]:@"" callback:^(BOOL succeed, NSDictionary *data) {
            [Refresh endRefreshing];
            [MBProgressHUD hideHUDForView:weak.view animated:YES];
            if (succeed) {
                if(data.count>14)
                {
                    [weak creatRefreshFooder:mainTableView];
                }
                [mainDataSource removeAllObjects];
                [mainDataSource addObjectsFromArray:[data objectForKey:S_OBJ]];
                [mainTableView reloadData];
            }else
            {
                [weak showHint:@"操作失败，请检查网络！"];
            }
        }];
    };
    header.scrollView = mainTableView;
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
        [[AlbumManager sharedInstance] getAlbumList:weak.page++ classId:[self.classNameData objectForKey:@"ClassId"]?[self.classNameData objectForKey:@"ClassId"]:@"" gradeId:[self.classNameData objectForKey:@"GradeId"]?[self.classNameData objectForKey:@"GradeId"]:@"" callback:^(BOOL succeed, NSDictionary *data) {
            [Refresh endRefreshing];
            if (succeed) {
                [mainDataSource removeAllObjects];
                [mainDataSource addObjectsFromArray:[data objectForKey:S_OBJ]];
                [mainTableView reloadData];
            }
        }];
    };
    fooder.scrollView = mainTableView;
    fooder_ = fooder;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mainDataSource.count;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 96.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    AlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[AlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSMutableDictionary *dic =[mainDataSource objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageUrl,[dic objectForKey:@"FullName"]]];
    [cell.photoImageView setImageWithURL:url placeholderImage:[UtilManager imageNamed:@"morentupian"]];
    
    NSString *count = ((NSNumber *)[dic objectForKey:@"PhotoCount"]).stringValue;
    
    cell.nameLabel.text = [dic objectForKey:@"AlbumName"];
    
    cell.numbaerLabel.text = [count stringByAppendingString:@"张"];
    
    cell.publishLabel.text = [dic objectForKey:@"CreateTime"];
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableDictionary *dic =[mainDataSource objectAtIndex:indexPath.row];
    AlbumDetailViewController *albumDetail = [[AlbumDetailViewController alloc] initWithAlbumId:[dic objectForKey:@"AlbumId"] AlbumName:[dic objectForKey:@"AlbumName"] classInfos:self.classNameData];
    [self.navigationController pushViewController:albumDetail animated:YES];
}



-(void)refreshUI:(NSDictionary *)dic
{
    NSLog(@"%@",[dic valueForKey:S_OBJ]);
    
    [mainDataSource addObject:[dic valueForKey:S_OBJ]];
    
    
    
    [mainTableView reloadData];
}

-(void)addAlbum
{
    AlbumAddViewController *album = [[AlbumAddViewController alloc] init];
    album.classNameData = self.classNameData;
    album.delegate =self;
    [self.navigationController pushViewController:album animated:YES];
}

-(void)AlbumOnAdd:(NSDictionary *)dic
{
    [mainDataSource insertObject:dic atIndex:0];
    [mainTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [fooder_ free];
    [header_ free];
}

@end
