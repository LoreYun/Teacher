//
//  SelfSettingViewController.m
//  SchoolMessage
//
//  Created by wulin on 15/1/28.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "SelfSettingViewController.h"
#import "AboutViewController.h"
#import "ChangePwdViewController.h"
#import "ApplyViewController.h"

@implementation SelfSettingViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title= @"设置";
    [self setCellView];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(32, 209, SCREEN_WIDTH-64, 45)];
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UtilManager getColorWithHexString:@"#18b3ec"];
    btn.layer.cornerRadius =5;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)setCellView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15,25,SCREEN_WIDTH-30,106)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 6;
    view.layer.masksToBounds = YES;
    [self.view addSubview:view];
    
    UIView *cell1 = [self createCell:@"修改密码" startY:0 action:@selector(push2Pwd:)];
    
    [view addSubview:cell1];
    
    UIView *div = [[UIView alloc] initWithFrame:CGRectMake(4,53.5,SCREEN_WIDTH-30-8,0.5)];
    div.backgroundColor = [UtilManager getColorWithHexString:@"4b4b4b"];
    [view addSubview:div];
    
    UIView *cell2 = [self createCell:@"关于校信通" startY:54 action:@selector(push2About:)];
    
    [view addSubview:cell2];
    
}

-(UIView *)createCell:(NSString *)title startY:(CGFloat)y action:(SEL)action
{
    UIView *cell = [[UIView alloc] initWithFrame:CGRectMake(0,y,SCREEN_WIDTH-30,53)];
    cell.backgroundColor = [UIColor clearColor];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(9,y>0?13:19,100,20)];
    label.text = title;
    label.textColor = [UtilManager getColorWithHexString:@"#353535"];
    label.font = [UIFont systemFontOfSize:19];
    [cell addSubview:label];
    
    UIImageView *ind = [[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.size.width-28, y>0?15:21,14, 19)];
    ind.image = [UtilManager imageNamed:@"jinru"];
    [cell addSubview:ind];
    
    [cell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:action]];
    
    return cell;
}

-(void)push2Pwd:(id)sender
{
    ChangePwdViewController *vc =[[ChangePwdViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)push2About:(id)sender
{
    AboutViewController *vc =[[AboutViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)logout:(id)sender
{
    if ([[EaseMob sharedInstance].chatManager isLoggedIn]) {
        __weak SelfSettingViewController *weakSelf = self;
        [self showHudInView:self.view hint:@"正在退出..."];
        [[EaseMob sharedInstance].chatManager asyncLogoffWithCompletion:^(NSDictionary *info, EMError *error) {
            [weakSelf hideHud];
            if (error) {
                [weakSelf showHint:error.description];
            }
            else{
                [[ApplyViewController shareController] clear];
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@""];
            }
        } onQueue:nil];
    }else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@""];
    }
}

@end
