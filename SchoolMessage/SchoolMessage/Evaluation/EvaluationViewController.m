//
//  EvaluationViewController.m
//  SchoolMessage
//
//  Created by wulin on 15/2/8.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "EvaluationViewController.h"
#import "EvaluationAddViewController.h"
#import "SMAlertView.h"

@interface EvaluationViewController ()<UITableViewDataSource,UITableViewDelegate,EvaluationAddDelegate,SMAlertViewDelegate>

@property (nonatomic ,strong) UITableView *tableview;

@property (nonatomic,strong) NSMutableArray *mainData;

@end

@implementation EvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    Account = s2001;
//    Mobile = 13700000001;
//    StudentId = 36;
//    StudentName = "\U5b66\U751f20";
//    XueHao = 2001;
    self.title = [self.studentInfo objectForKey:@"StudentName"];
    self.mainData = [NSMutableArray array];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(25, 0, SCREEN_WIDTH-50, SCREEN_HEIGHT-64-57)];
    [self.view addSubview:self.tableview];
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT-64-57, SCREEN_WIDTH-20, 47)];
    [button setTitle:@"点评" forState:0];
    [button setTitleColor:[UIColor whiteColor] forState:0];
    button.backgroundColor = [UtilManager getColorWithHexString:@"#18b4ed"];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(push2Add:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [self getSutdentInfos];
}

-(void)push2Add:(id)sender
{
    EvaluationAddViewController *vc = [[EvaluationAddViewController alloc] init];
    vc.studentInfo = self.studentInfo;
    vc.classInfos = self.classInfo;
    vc.delegate =self;
    [self.navigationController pushViewController:vc  animated:YES];
}

-(void)getSutdentInfos
{
    [self showHudInView:self.view hint:@"获取学生信息"];
    [[ObjectManager sharedInstance] requestDataOnPost:@{@"2":[self.studentInfo objectForKey:@"StudentId"],@"1":[[AccountManager sharedInstance].LoginInfos getTeacherId],@"3":@"120",@"4":@"0"} ByFlag:@"1102" callback:^(BOOL succeed, NSDictionary *data) {
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

//{
//    CSId = 1;
//    CommentConent = 344444;
//    CommentTime = "2015-02-09 14:30:32";
//    SubjectId = 1;
//    SubjectName = "\U6570\U5b66";
//    TeacherId = 48;
//    TeacherName = "\U6d4b\U8bd5\U6559\U5e081";
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(0, 14, 157, 19)];
        title.textColor = [UtilManager getColorWithHexString:@"#333333"];
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont systemFontOfSize:18];
        title.tag = 1;
        [cell addSubview:title];
        
        UILabel * content = [[UILabel alloc] initWithFrame:CGRectMake(157,14, SCREEN_WIDTH-50-157, 19)];
        content.textColor = [UtilManager getColorWithHexString:@"#333333"];
        content.textAlignment = NSTextAlignmentCenter;
        content.font = [UIFont systemFontOfSize:18];
        content.tag = 2;
        [cell addSubview:content];
        
        UIView *div = [[UIView alloc] initWithFrame:CGRectMake(0, 34.5, SCREEN_WIDTH-50, 0.5)];
        div.backgroundColor = [UtilManager getColorWithHexString:@"#b7c6c9"];
        [cell addSubview:div];
        
        cell.backgroundColor = [UIColor clearColor];
    }
    UILabel * title =  (UILabel *)[cell viewWithTag:1];
    UILabel * content = (UILabel *)[cell viewWithTag:2];
    NSDictionary * dic = [self.mainData objectAtIndex:indexPath.row];
    NSString *time = [dic objectForKey:@"CommentTime"];
    title.text = [[time componentsSeparatedByString:@" "] objectAtIndex:0];
    content.text = [dic objectForKey:@"SubjectName"];
    
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(0, 14, 157, 19)];
    title.textColor = [UtilManager getColorWithHexString:@"#333333"];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:18];
    title.tag = 1;
    title.text = @"点评时间";
    [contentView addSubview:title];
    
    UILabel * content = [[UILabel alloc] initWithFrame:CGRectMake(157, 14, SCREEN_WIDTH-50-157, 19)];
    content.textColor = [UtilManager getColorWithHexString:@"#333333"];
    content.textAlignment = NSTextAlignmentCenter;
    content.font = [UIFont systemFontOfSize:18];
    content.tag = 2;
    content.text = @"科目";
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
    NSDictionary * dic = [self.mainData objectAtIndex:indexPath.row];
    
    SMAlertView*alert = [[SMAlertView alloc] initWithTitle:@"点评内容" message:[dic objectForKey:@"CommentConent"] delegate:self cancelButtonTitle:nil];
    [alert show];
    
}


-(void)EvaluationAddFinished:(NSDictionary *)result
{
    [self.mainData insertObject:result atIndex:0];
    [self.tableview reloadData];
}

@end
