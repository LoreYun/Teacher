//
//  AboutViewController.m
//  SchoolMessage
//
//  Created by wulin on 15/1/28.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "AboutViewController.h"
#import "AboutUsViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于校信通";
    
    UIImageView *logoIv  = [[UIImageView alloc] initWithImage:[UtilManager imageNamed:@"logo2"]];
    
    logoIv.center = CGPointMake(self.view.center.x, 60);
    [self.view addSubview:logoIv];
    
    UILabel *version = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, CGRectGetMaxY(logoIv.frame)+7, 200, 19)];
    version.font = [UIFont systemFontOfSize:12];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    version.text = [NSString stringWithFormat:@"校信通%@",app_Version];
    version.textColor = [UtilManager getColorWithHexString:@"#353535"];
    version.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:version];
    
    [self setCellView];
}

-(void)setCellView
{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15,165,SCREEN_WIDTH-30,106)];
//    view.backgroundColor = [UIColor whiteColor];
//    view.layer.cornerRadius = 6;
//    view.layer.masksToBounds = YES;
//    [self.view addSubview:view];
    
//    UIView *cell1 = [self createCell:@"检查更新" startY:0 action:@selector(checkVersion:)];
//    
//    [view addSubview:cell1];
//    
//    UIView *div = [[UIView alloc] initWithFrame:CGRectMake(19,53.5,SCREEN_WIDTH-30-38,0.5)];
//    div.backgroundColor = [UtilManager getColorWithHexString:@"4b4b4b"];
//    [view addSubview:div];
//    
//    UIView *cell2 = [self createCell:@"关于我们" startY:54 action:@selector(push2AboutUS:)];
//    
//    [view addSubview:cell2];
    
}

-(UIView *)createCell:(NSString *)title startY:(CGFloat)y action:(SEL)action
{
    UIView *cell = [[UIView alloc] initWithFrame:CGRectMake(0,y,SCREEN_WIDTH-30,53)];
    cell.backgroundColor = [UIColor clearColor];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30,y>0?13:19,100,21)];
    label.text = title;
    label.textColor = [UtilManager getColorWithHexString:@"#353535"];
    label.font = [UIFont systemFontOfSize:15];
    [cell addSubview:label];
    
    [cell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:action]];
    
    return cell;
}

-(void)checkVersion:(id)sender
{
    [self showHudInView:self.view hint:@""];
    [[ObjectManager sharedInstance] requestDataOnGet:@{@"1":@"ios",@"2":@"teacher"} ByFlag:@"901" callback:^(BOOL succeed, NSDictionary * data) {
        [self hideHud];
        if (succeed) {
            [self showHint:@"已是最新版本"];
        }else
        {
            [self showHint:@"操作失败，请检查网络"];
        }
    }];
}

-(void)push2AboutUS:(id)sender
{
    AboutUsViewController *vc = [[AboutUsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
