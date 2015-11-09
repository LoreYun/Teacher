//
//  HelpFeedViewController.m
//  SchoolMessage
//
//  Created by LI on 15/4/28.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "HelpFeedViewController.h"
#import "HelpViewController.h"
#import "FeedBackViewController.h"

@interface HelpFeedViewController ()

@end

@implementation HelpFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title= @"帮助与反馈";
    [self setCellView];
}

-(void)setCellView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15,25,SCREEN_WIDTH-30,106)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 6;
    view.layer.masksToBounds = YES;
    [self.view addSubview:view];
    
    UIView *cell1 = [self createCell:@"帮助" startY:0 action:@selector(push2Pwd:)];
    
    [view addSubview:cell1];
    
    UIView *div = [[UIView alloc] initWithFrame:CGRectMake(4,53.5,SCREEN_WIDTH-30-8,0.5)];
    div.backgroundColor = [UtilManager getColorWithHexString:@"4b4b4b"];
    [view addSubview:div];
    
    UIView *cell2 = [self createCell:@"意见反馈" startY:54 action:@selector(push2About:)];
    
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
    HelpViewController *vc =[[HelpViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)push2About:(id)sender
{
    FeedBackViewController *vc =[[FeedBackViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
