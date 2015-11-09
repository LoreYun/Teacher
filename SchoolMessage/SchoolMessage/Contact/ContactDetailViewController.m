//
//  ContactDetailViewController.m
//  SchoolMessage
//
//  Created by wulin on 15/2/8.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "ContactDetailViewController.h"
#import "ContactEditViewController.h"
#import "ContactLocalManger.h"

@interface ContactDetailViewController ()


@end

@implementation ContactDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"联系人详情";
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [backBtn setTitle:@"编辑" forState:0];
    [backBtn setTitleColor:[UIColor whiteColor] forState:0];
    [backBtn addTarget:self action:@selector(editContactInfo:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.rightBarButtonItem = backItem;
    
    [self creteView:@"联系人：" content:[self.contactInfos objectForKey:@"Relation"] start:20];
    [self creteView:@"学 生：" content:[self.contactInfos objectForKey:@"StudentName"] start:85];
    [self creteView:@"电 话：" content:[self.contactInfos objectForKey:@"Mobile"] start:150];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(33, 215, SCREEN_WIDTH-66, 47)];
    button.backgroundColor = [UtilManager getColorWithHexString:@"#18b4ed"];
    [button setTitle:@"呼叫联系人" forState:0];
    [button setTitleColor:[UIColor whiteColor] forState:0];
    [button addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)editContactInfo:(id)sender
{
    ContactEditViewController * vc = [[ContactEditViewController alloc] init];
    vc.classId = self.classId;
    vc.contactInfos = self.contactInfos;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)call:(id)sender
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",[self.contactInfos objectForKey:@"Mobile"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}


-(void)creteView:(NSString *)title content:(NSString *)content start:(CGFloat)y
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(33, y, SCREEN_WIDTH-66, 47)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius =5;
    view.layer.masksToBounds = YES;
    [self.view addSubview:view];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 92, 47)];
    label.text = title;
    label.textColor = [UtilManager getColorWithHexString:@"#353535"];
    label.font = [UIFont systemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    UIView *div = [[UIView alloc] initWithFrame:CGRectMake(92, 0, 0.5, 47)];
    
    div.backgroundColor = [UtilManager getColorWithHexString:@"#cecece"];
    [view addSubview:div];
    
    UITextField * filed = [[UITextField alloc] initWithFrame:CGRectMake(110.5,0,SCREEN_WIDTH-66-110.5, 47)];
    filed.textColor = [UtilManager getColorWithHexString:@"#353535"];
    filed.font = [UIFont systemFontOfSize:18];
    filed.enabled = NO;
    filed.text = content;
    [view addSubview:filed];
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
