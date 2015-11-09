//
//  BulletinViewController.m
//  SchoolMessage
//
//  Created by wulin on 15/1/31.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "BulletinViewController.h"

#import "MJRefresh.h"

#import "BulletinCell.h"

#import "BulletinDetailViewController.h"

@interface BulletinViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    MJRefreshFooterView *fooder_;
    MJRefreshHeaderView *header_;
}

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray * data;

@property (nonatomic,assign) NSInteger page;



@end

@implementation BulletinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"校园公告";
    
    self.data = [NSMutableArray array];
    
    self.page = 0;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
//    [self creatRefreshFooder:self.tableView];
    [self creatRefreshHeader:self.tableView];
    [header_ beginRefreshing];
}

-(void)creatRefreshHeader:(UIScrollView *)scr
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    __weak typeof(self) weak = self;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *Refresh)
    {
        weak.page = 0;
        [self getBulletins:^(BOOL succeed, NSDictionary *result) {
            [Refresh endRefreshing];
            if (succeed) {
                if (result.count>9) {
                    [weak creatRefreshFooder:weak.tableView];
                }
                [self.data removeAllObjects];
                [self.data addObjectsFromArray:[result objectForKey:S_OBJ]];
                [self.tableView reloadData];
            }

        }];
        
    };
    header.scrollView = self.tableView;
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
        [weak getBulletins:^(BOOL succeed, NSDictionary *result) {
            [Refresh endRefreshing];
            if (succeed) {
                [self.data addObjectsFromArray:[result objectForKey:S_OBJ]];
                [self.tableView reloadData];
            }
        }];
    };
    fooder.scrollView = self.tableView;
    fooder_ = fooder;
}

-(void)getBulletins:(void(^)(BOOL succeed,NSDictionary *result))callback;
{
    NSDictionary *dic = @{@"1":@"5",@"2":[[AccountManager sharedInstance].LoginInfos getUserId],@"3":[[AccountManager sharedInstance].LoginInfos getAccount],@"4":@"10",@"5":[NSString stringWithFormat:@"%ld",(long)self.page]};
    [[ObjectManager sharedInstance] requestDataOnPost:dic ByFlag:@"403" callback:callback];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BulletinDetailViewController *vc  = [[BulletinDetailViewController alloc] init];
    vc.bulletinDetail = [self.data objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.data objectAtIndex:indexPath.row];
    NSString *content = [dic objectForKey:@"NoticeContent"];
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(tableView.frame.size.width-50, 40)];
    NSLog(@"height : %@",NSStringFromCGSize(size));
    return (size.height+55+42);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [BulletinCell identifier];
    BulletinCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[BulletinCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSDictionary *dic = [self.data objectAtIndex:indexPath.row];
    [cell setupViews:dic];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = YES;
    return cell;
}

-(void)dealloc
{
    [header_ free];
    [fooder_ free];
}


@end
