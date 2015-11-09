//
//  SearchGroupListViewController.m
//  VXiaoYuan
//
//  Created by wulin on 14/12/16.
//  Copyright (c) 2014年 XianTe. All rights reserved.
//

#import "SearchGroupListViewController.h"
#import "RosterManager.h"
#import "FriendInfo.h"
#import "UIImageView+WebCache.h"
#import "BaseTableViewCell.h"

@interface SearchGroupListViewController ()

@property (strong, nonatomic) EMGroup *chatGroup;

@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) NSMutableDictionary * friendDic;

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation SearchGroupListViewController

- (instancetype)initWithGroup:(EMGroup *)chatGroup
{
    self = [super init];
    if (self) {
        // Custom initialization
        _chatGroup = chatGroup;
        _dataSource = [NSMutableArray array];
        _friendDic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (instancetype)initWithGroupId:(NSString *)chatGroupId
{
    EMGroup *chatGroup = nil;
    NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
    for (EMGroup *group in groupArray) {
        if ([group.groupId isEqualToString:chatGroupId]) {
            chatGroup = group;
            break;
        }
    }
    
    if (chatGroup == nil) {
        chatGroup = [EMGroup groupWithId:chatGroupId];
    }
    
    self = [self initWithGroup:chatGroup];
    if (self) {
        //
    }
    
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
    }
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UtilManager imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self fetchGroupInfo];
}

- (void)fetchGroupInfo
{
    __weak typeof(self) weakSelf = self;
    [self showHudInView:self.view hint:@"加载数据..."];
    [[EaseMob sharedInstance].chatManager asyncFetchGroupInfo:_chatGroup.groupId completion:^(EMGroup *group, EMError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideHud];
            if (!error) {
                weakSelf.chatGroup = group;
                [weakSelf reloadDataSource];
            }
            else{
                [weakSelf showHint:@"获取群组详情失败，请稍后重试"];
            }
        });
    } onQueue:nil];
}

-(void)reloadDataSource
{
    [self.dataSource removeAllObjects];
//    [self.dataSource addObjectsFromArray:self.chatGroup.occupants];
    
    for (NSString *chatter in self.chatGroup.occupants) {
        FriendInfo *info = [[FriendInfo alloc] init];
        info.chatter = chatter;
        info.finish = NO;
        [self.dataSource addObject:info];
        [[RosterManager sharedInstance] getFriendInfoByChatter:chatter callBack:^(BOOL succeed, FriendInfo *firendInfo) {
            if (succeed) {
                info.headPhotoUrl   = firendInfo.headPhotoUrl;
                info.nickName       = firendInfo.nickName;
                info.finish         = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
        }];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self hideHud];
    });
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* indentifier = @"cell";
    BaseTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    FriendInfo *info = [self.dataSource objectAtIndex:indexPath.row];
    UIImage *image = [UIImage imageNamed:@"chatListCellHead.png"];
    if (info.finish) {
        cell.textLabel.text = info.nickName;
        [cell.imageView setImageWithURL:[NSURL URLWithString:info.headPhotoUrl] placeholderImage:image];
    }else
    {
        cell.textLabel.text = info.chatter;
        [cell.imageView setImage:image];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(SearchGroupListOnSeleted:)]) {
        FriendInfo *info = [self.dataSource objectAtIndex:indexPath.row];
        [self.delegate SearchGroupListOnSeleted:info.finish?info.nickName:info.chatter];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    [self.friendDic removeAllObjects];
}
@end
