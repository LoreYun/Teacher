//
//  ContactViewController.m
//  SchoolMessage
//
//  Created by wulin on 15/2/8.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "ContactViewController.h"
#import "ContactDetailViewController.h"
#import "EMSearchDisplayController.h"
#import "RealtimeSearchUtil.h"
#import "EMSearchBar.h"
#import "ContactCell.h"
#import "ChineseToPinyin.h"
#import "ContactAddViewController.h"
#import "ContactLocalManger.h"
#import "NSDictory+CellData.h"
#import "ContactAnycAlertView.h"
#import "ContactDeleteAlertView.h"

@interface ContactViewController ()<ContactDeleteAlertViewDalegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate, UISearchDisplayDelegate,ContactAnycAlertViewDalegate>
{
    NSMutableArray *mainDataSource;
}

@property (strong, nonatomic) EMSearchDisplayController *searchController;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) EMSearchBar *searchBar;

@property (strong, nonatomic) NSMutableArray *contactsSource;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *sectionTitles;

@property (nonatomic,strong) NSMutableDictionary *contactInfos;

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [NSMutableArray array];
    self.contactsSource = [NSMutableArray array];
    self.sectionTitles = [NSMutableArray array];
    self.title = @"通讯录";
    mainDataSource = [NSMutableArray array];
    
    [self initRightTitleBar:@"同步" action:@selector(alertAysnc)];
    
    [self searchController];
    self.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    [self.view addSubview:self.searchBar];
    
    self.tableView.frame = CGRectMake(0, self.searchBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.searchBar.frame.size.height-50);
    [self.view addSubview:self.tableView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-50, SCREEN_WIDTH, 50)];
    [button setImage:[UtilManager imageNamed:@"contact_add"] forState:0];
    [button setTitle:@"新建联系人" forState:0];
    [button setTitleColor:[UtilManager getColorWithHexString:@"18b4ed"] forState:0];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    button.backgroundColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(push2AddContact:) forControlEvents:UIControlEventTouchUpInside];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -button.imageView.frame.size.width, -button.imageView.frame.size.height, 0);
    button.imageEdgeInsets = UIEdgeInsetsMake(-button.titleLabel.intrinsicContentSize.height, 0, 0, -button.titleLabel.intrinsicContentSize.width);
    [self.view addSubview:button];
}

-(void)alertAysnc
{
    ContactAnycAlertView *view = [[ContactAnycAlertView alloc] init];
    view.delegate =self;
    [view show];
}

-(void)ContactAnycAlertViewDownload
{
    [self showHudInView:self.view hint:@"下载中"];
    [[ContactLocalManger sharedInstance] DownloadContactInfos:^(BOOL succeed) {
        [self hideHud];
        if (succeed) {
            [self reloadDataSource];
        }else
        {
            [self showHint:@"操作失败，请检查网络！"];
        }
    }];
}

-(void)ContactAnycAlertViewUpload
{
    [self showHudInView:self.view hint:@"上传中"];
    [[ContactLocalManger sharedInstance] uploadContactInfos:^(BOOL succeed) {
        [self hideHud];
        if (succeed) {
            [self showHint:@"上传成功！"];
        }else
        {
            [self showHint:@"操作失败，请检查网络！"];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self reloadDataSource];
}

-(void)push2AddContact:(id)sender
{
    ContactAddViewController* Controller = [[ContactAddViewController alloc] init];
    
    [self.navigationController pushViewController:Controller animated:YES];
}

-(void)getContactInfo:(void(^)(BOOL succeed, NSDictionary *result))callback
{
    
    NSString *classId = [[AccountManager sharedInstance] getAllClassString];
    if ([[ContactLocalManger sharedInstance] IsFirst]) {
        [[ObjectManager sharedInstance] requestDataOnPost:@{@"1":classId} ByFlag:@"601" callback:^(BOOL succeed, NSDictionary *data) {
            if (succeed) {
                succeed = ((NSNumber *)[data objectForKey:S_SUCCESS]).boolValue;
            }
            if (succeed) {
                [[ContactLocalManger sharedInstance] setFirst];
                [[ContactLocalManger sharedInstance] saveContactInfos:[data objectForKey:S_OBJ]];
            }
            callback(succeed , data);
        }];
    }else
    {
        NSDictionary * dic = @{S_OBJ:[[ContactLocalManger sharedInstance] getLoaclContactInfos]};
        callback(YES,dic);
    }
    
}

#pragma mark - private

- (NSMutableArray *)sortDataArray:(NSArray *)dataArray
{
    //建立索引的核心
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    
    [self.sectionTitles removeAllObjects];
    [self.sectionTitles addObjectsFromArray:[indexCollation sectionTitles]];
    
    //返回27，是a－z和＃
    NSInteger highSection = [self.sectionTitles count];
    //tableView 会被分成27个section
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i <= highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }
    
    //名字分section
    for (NSDictionary *info in dataArray) {
        //getUserName是实现中文拼音检索的核心，见NameIndex类
        NSString *firstLetter = [ChineseToPinyin pinyinFromChineseString:[info objectForKey:@"Relation"]];
        NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
        
        NSMutableArray *array = [sortedArray objectAtIndex:section];
        [array addObject:info];
    }
    
    //每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
            NSString *firstLetter1 = [ChineseToPinyin pinyinFromChineseString:[obj1 objectForKey:@"Relation"]];
            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
            
            NSString *firstLetter2 = [ChineseToPinyin pinyinFromChineseString:[obj2 objectForKey:@"Relation"]];
            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
            
            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
        }];
        
        
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
    }
    
    return sortedArray;
}

#pragma mark - dataSource

- (void)reloadDataSource
{
    __weak ContactViewController * controller = self;
    
    
    //有可能重连后好友数据获取为0个 就删除以前的数据了
    //    [self.dataSource removeAllObjects];
    //    [self.contactsSource removeAllObjects];
    [self showHudInView:self.view hint:@""];
    [self getContactInfo:^(BOOL succeed, NSDictionary *result) {
        [controller hideHud];
        if (succeed) {
            NSArray * array = [result objectForKey:S_OBJ];
            [controller.contactsSource removeAllObjects];
            [controller.contactsSource addObjectsFromArray:array];
            [controller.dataSource removeAllObjects];
            [controller.dataSource addObjectsFromArray:[controller sortDataArray:controller.contactsSource]];
            [controller.tableView reloadData];
        }else
        {
            [controller showHint:@"操作失败，请检查网络！"];
        }
    }];
    
}

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UtilManager getColorWithHexString:@"#e4f4f7"];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    
    return _tableView;
}

- (UISearchBar *)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[EMSearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
        _searchBar.backgroundColor = [UIColor colorWithRed:0.747 green:0.756 blue:0.751 alpha:1.000];
    }
    
    return _searchBar;
}

- (EMSearchDisplayController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchController.delegate = self;
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        __weak ContactViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:[ContactCell identifier]];
            if (!cell) {
                cell = [[ContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[ContactCell identifier]];
            }
            NSDictionary *dic = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            
            [cell setRelation:[dic objectForKey:@"Relation"] studentName:[dic objectForKey:@"StudentName"]];
            return cell;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return 50;
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
//            BuddyInfo *info = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            
            [weakSelf.searchController.searchBar endEditing:YES];
            ContactDetailViewController *chatVC = [[ContactDetailViewController alloc]init];
            chatVC.contactInfos = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            
            [weakSelf.navigationController pushViewController:chatVC animated:YES];
        }];
    }
    
    return _searchController;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.dataSource objectAtIndex:section] count];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"delete");
        self.contactInfos = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [self deleteContactInfo:nil];
    }
}

-(void)deleteContactInfo:(id)sender
{
    ContactDeleteAlertView *view = [[ContactDeleteAlertView alloc] init];
    view.delegate =self;
    [view show];
}

-(void)ContactDeleteAlertViewOnDelete
{
    [[ContactLocalManger sharedInstance] deleteContactInfo:@"" name:[self.contactInfos objectForKey:@"Relation"] phone:[self.contactInfos objectForKey:@"Mobile"]];
    [[ContactLocalManger sharedInstance] saveLoaclContactInfos];
    self.contactInfos = nil;
    
    [self reloadDataSource];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:[ContactCell identifier]];
    if (!cell) {
        cell = [[ContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[ContactCell identifier]];
    }
    NSDictionary *dic = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    [cell setRelation:[dic objectForKey:@"Relation"] studentName:[dic objectForKey:@"StudentName"]];
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([[self.dataSource objectAtIndex:section] count] == 0)
    {
        return 0;
    }
    else{
        return 22;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([[self.dataSource objectAtIndex:section] count] == 0)
    {
        return nil;
    }
    
    UIView *contentView = [[UIView alloc] init];
    [contentView setBackgroundColor:[UtilManager getColorWithHexString:@"#e7e7e7"]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 22)];
    label.backgroundColor = [UIColor clearColor];
    [label setText:[self.sectionTitles objectAtIndex:(section)]];
    [label setTextColor:[UtilManager getColorWithHexString:@"#333333"]];
    [contentView addSubview:label];
    return contentView;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray * existTitles = [NSMutableArray array];
    //section数组为空的title过滤掉，不显示
    for (int i = 0; i < [self.sectionTitles count]; i++) {
        if(self.dataSource.count==0)continue;
        if ([[self.dataSource objectAtIndex:i] count] > 0) {
            [existTitles addObject:[self.sectionTitles objectAtIndex:i]];
        }
    }
    return existTitles;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ContactDetailViewController *chatVC = [[ContactDetailViewController alloc] init];
    chatVC.contactInfos = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:chatVC animated:YES];
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.contactsSource searchText:(NSString *)searchText collationStringSelector:@selector(getContactNstring) resultBlock:^(NSArray *results) {
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
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
