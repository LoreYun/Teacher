//
//  ClassStudentsViewController.m
//  SchoolMessage
//
//  Created by wulin on 15/2/8.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "ClassStudentsViewController.h"
#import "EvaluationViewController.h"

@interface ClassStudentsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) UITableView *tableview;

@property (nonatomic,strong) NSMutableArray *mainData;

@end

@implementation ClassStudentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@%@",[self.classInfo objectForKey:@"GradeName"],[self.classInfo objectForKey:@"ClassName"]];
    self.mainData = [NSMutableArray array];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(25, 0, SCREEN_WIDTH-50, SCREEN_HEIGHT-64)];
    [self.view addSubview:self.tableview];
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self getSutdentInfos];
}

-(void)getSutdentInfos
{
    [self showHudInView:self.view hint:@"获取学生信息"];
    NSString *classid = [self.classInfo objectForKey:@"ClassId"];
    [[ObjectManager sharedInstance] requestDataOnPost:@{@"1":classid} ByFlag:@"1201" callback:^(BOOL succeed, NSDictionary *data) {
        [self hideHud];
        if (succeed) {
            succeed = ((NSNumber *)[data objectForKey:S_SUCCESS]).boolValue;
        }
        if (succeed)
        {
            [self.mainData addObjectsFromArray:[data objectForKey:S_OBJ]];
            [self.tableview reloadData];
        }else
        {
            [self showHint:@"操作失败，请检查网络"];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mainData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(0, 14, 95, 19)];
        title.textColor = [UtilManager getColorWithHexString:@"#333333"];
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont systemFontOfSize:18];
        title.tag = 1;
        [cell addSubview:title];
        
        UILabel * content = [[UILabel alloc] initWithFrame:CGRectMake(95,14, SCREEN_WIDTH-50-95, 19)];
        content.textColor = [UtilManager getColorWithHexString:@"#333333"];
        content.textAlignment = NSTextAlignmentCenter;
        content.font = [UIFont systemFontOfSize:18];
        content.tag = 2;
        [cell addSubview:content];
        cell.backgroundColor = [UIColor clearColor];
        
        UIView *div = [[UIView alloc] initWithFrame:CGRectMake(0, 34.5, SCREEN_WIDTH-50, 0.5)];
        div.backgroundColor = [UtilManager getColorWithHexString:@"#b7c6c9"];
        [cell addSubview:div];
    }
    UILabel * title =  (UILabel *)[cell viewWithTag:1];
    UILabel * content = (UILabel *)[cell viewWithTag:2];
    NSDictionary * dic = [self.mainData objectAtIndex:indexPath.row];
    title.text = [dic objectForKey:@"StudentName"];
    content.text = [dic objectForKey:@"XueHao"];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(0, 14, 95, 19)];
    title.textColor = [UtilManager getColorWithHexString:@"#333333"];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:18];
    title.tag = 1;
    title.text = @"姓名";
    [contentView addSubview:title];
    
    UILabel * content = [[UILabel alloc] initWithFrame:CGRectMake(95, 14, SCREEN_WIDTH-50-95, 19)];
    content.textColor = [UtilManager getColorWithHexString:@"#333333"];
    content.textAlignment = NSTextAlignmentCenter;
    content.font = [UIFont systemFontOfSize:18];
    content.tag = 2;
    content.text = @"学号";
    [contentView addSubview:content];
    contentView.backgroundColor = [UtilManager getColorWithHexString:@"#e4f4f7"];
    return contentView;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EvaluationViewController *vc = [[EvaluationViewController alloc] init];
    vc.studentInfo = [self.mainData objectAtIndex:indexPath.row];
    vc.classInfo = self.classInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
