/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "PublicGroupListViewController.h"

#import "EMSearchBar.h"
#import "SRRefreshView.h"
#import "EMSearchDisplayController.h"
#import "PublicGroupDetailViewController.h"
#import "RealtimeSearchUtil.h"
#import "RosterManager.h"
#import "GroupInfo.h"
#import "UIImageView+WebCache.h"

@interface PublicGroupListViewController ()<UISearchBarDelegate, UISearchDisplayDelegate, SRRefreshDelegate>

@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) SRRefreshView *slimeView;
@property (strong, nonatomic) EMSearchBar *searchBar;
@property (strong, nonatomic) EMSearchDisplayController *searchController;

@end

@implementation PublicGroupListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _dataSource = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    self.title = @"公有群组";
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.tableHeaderView = self.searchBar;
//    [self.tableView addSubview:self.slimeView];
    [self searchController];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UtilManager imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
//    [self reloadDataSource];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter

- (SRRefreshView *)slimeView
{
    if (_slimeView == nil) {
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.delegate = self;
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor grayColor];
        _slimeView.slime.skinColor = [UIColor grayColor];
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 4;
        _slimeView.slime.shadowColor = [UIColor grayColor];
    }
    
    return _slimeView;
}

- (UISearchBar *)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[EMSearchBar alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
        _searchBar.backgroundColor = [UIColor colorWithRed:0.747 green:0.756 blue:0.751 alpha:1.000];
    }
    
    return _searchBar;
}

- (EMSearchDisplayController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:nil];
//        _searchController.delegate = self;
//        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        __weak PublicGroupListViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            static NSString *CellIdentifier = @"ContactListCell";
            BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            // Configure the cell...
            if (cell == nil) {
                cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            GroupInfo *info = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            NSString *imageName = @"groupPublicHeader";
            cell.imageView.image = [UIImage imageNamed:imageName];
            [cell.imageView setImageWithURL:[NSURL URLWithString:info.groupHeadPhotoUrl] placeholderImage:[UIImage imageNamed:imageName]];
            cell.textLabel.text = info.groupName;
            
            return cell;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return 50;
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [weakSelf.searchController.searchBar endEditing:YES];
            
            GroupInfo *info = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            PublicGroupDetailViewController *detailController = [[PublicGroupDetailViewController alloc] initWithGroupId:info.groupId];
            detailController.title = info.groupName;
            [weakSelf.navigationController pushViewController:detailController animated:YES];
        }];
    }
    
    return _searchController;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GroupCell";
    BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    GroupInfo *info = [self.dataSource objectAtIndex:indexPath.row];
    [cell.imageView setImageWithURL:[NSURL URLWithString:info.groupHeadPhotoUrl] placeholderImage:[UIImage imageNamed:@"groupPublicHeader"]];
    if (info.groupName&& info.groupName.length > 0) {
        cell.textLabel.text = info.groupName;
    }
    else {
        cell.textLabel.text = info.groupId;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GroupInfo *info = [self.dataSource objectAtIndex:indexPath.row];
    PublicGroupDetailViewController *detailController = [[PublicGroupDetailViewController alloc] initWithGroupId:info.group.groupId];
    detailController.title = info.group.groupSubject;
    [self.navigationController pushViewController:detailController animated:YES];
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.dataSource searchText:(NSString *)searchText collationStringSelector:@selector(groupName) resultBlock:^(NSArray *results) {
        if (results) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.searchController.resultsSource removeAllObjects];
                [self.searchController.resultsSource addObjectsFromArray:results];
                [self.searchController.searchResultsTableView reloadData];
            });
        }
    }];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    __weak PublicGroupListViewController *weakSelf =self;
    
    [[RosterManager sharedInstance] queryPublicGroup:searchBar.text pageSize:10000 pageNum:0 callBack:^(BOOL succeed, NSDictionary *result) {
        
        if (succeed) {
            NSArray *array = [result objectForKey:S_OBJ];
            if (array && array.count>0) {
                [self.searchController.resultsSource removeAllObjects];
                for (NSDictionary *dic in array) {
                    GroupInfo *info =  [self getGroupInfo:dic];
                    [[RosterManager sharedInstance] getGroupInfoByChatter:info.group callBack:^(BOOL succeed, GroupInfo *groupInfo) {
                        info.groupHeadPhotoUrl = groupInfo.groupHeadPhotoUrl;
                        [weakSelf.searchController.searchResultsTableView reloadData];
                    }];
                    [self.searchController.resultsSource addObject:info];
                }
                [self.searchController.searchResultsTableView reloadData];
            }
        }
    }];
    
//    [[EaseMob sharedInstance].chatManager asyncSearchPublicGroupWithGroupId:searchBar.text completion:^(EMGroup *group, EMError *error) {
//        if (!error) {
//            GroupInfo *info =  [[GroupInfo alloc] init];
//            info.group = group;
//            info.groupName = group.groupSubject;
//            info.groupHeadPhotoUrl = @"";
//            [[RosterManager sharedInstance] getGroupInfoByChatter:group callBack:^(BOOL succeed, GroupInfo *groupInfo) {
//                info.groupHeadPhotoUrl = groupInfo.groupHeadPhotoUrl;
//                [weakSelf.searchController.searchResultsTableView reloadData];
//            }];
////
//            [self.searchController.resultsSource removeAllObjects];
//            [self.searchController.resultsSource addObject:info];
//            [self.searchController.searchResultsTableView reloadData];
//        }
//    } onQueue:nil];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - SRRefreshDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_slimeView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
}

- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [self reloadDataSource];
    [_slimeView endRefresh];
}

#pragma mark - data

- (void)reloadDataSource
{
    [self showHudInView:self.view hint:@"加载数据..."];
    
    __weak PublicGroupListViewController *weakSelf = self;
    
    [[RosterManager sharedInstance] queryPublicGroup:@"" pageSize:10000 pageNum:0 callBack:^(BOOL succeed, NSDictionary *result) {
        [weakSelf.dataSource removeAllObjects];
        for(NSDictionary *dic in [result objectForKey:@"Obj"])
        {
            GroupInfo *info =  [self getGroupInfo:dic];
            [[RosterManager sharedInstance] getGroupInfoByChatter:info.group callBack:^(BOOL succeed, GroupInfo *groupInfo) {
                info.groupHeadPhotoUrl = groupInfo.groupHeadPhotoUrl;
                [weakSelf.tableView reloadData];
            }];
            [weakSelf.dataSource addObject:info];
        }
        [weakSelf.tableView reloadData];
        [weakSelf hideHud];
    }];
    
//    [[EaseMob sharedInstance].chatManager asyncFetchAllPublicGroupsWithCompletion:^(NSArray *groups, EMError *error) {
//        [weakSelf.dataSource removeAllObjects];
//        for(EMGroup *emgroup in groups)
//        {
//            GroupInfo *info =  [[GroupInfo alloc] init];
//            info.group = emgroup;
//            info.groupName = emgroup.groupSubject;
//            info.groupHeadPhotoUrl = @"";
//            [[RosterManager sharedInstance] getGroupInfoByChatter:emgroup callBack:^(BOOL succeed, GroupInfo *groupInfo) {
//                info.groupHeadPhotoUrl = groupInfo.groupHeadPhotoUrl;
//                [weakSelf.tableView reloadData];
//            }];
//            [weakSelf.dataSource addObject:info];
//        }
//        [weakSelf.tableView reloadData];
//        [weakSelf hideHud];
//    } onQueue:nil];
}
        
-(GroupInfo *)getGroupInfo:(NSDictionary *)dic
{
    GroupInfo *info =  [[GroupInfo alloc] init];
    info.groupName = [dic objectForKey:@"GroupName"];
    info.groupId = [dic objectForKey:@"GroupId"];
    EMGroup *group = [EMGroup groupWithId:info.groupId];
    info.groupDesc = [dic objectForKey:@"GroupDesc"];
    info.group =group;
    info.groupHeadPhotoUrl = @"";
    
    return info;
}

@end
