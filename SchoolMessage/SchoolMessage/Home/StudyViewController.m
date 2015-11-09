//
//  StudyViewController.m
//  SchoolMessage
//
//  Created by LI on 15/4/29.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "StudyViewController.h"
#import "TimeTableViewController.h"
#import "HomeWorkViewController.h"

@interface StudyViewController ()

@end

@implementation StudyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"学习";
    
    UIView *cell1 = [self createCell:@"kebiao" title:@"课表" startY:0.5 action:@selector(push2Timetable:)];
    
    [self.view addSubview:cell1];
    
    UIView *cell2 = [self createCell:@"zuoye" title:@"作业" startY:51.5 action:@selector(push2Homework:)];
    
    [self.view addSubview:cell2];
    
    UIView *div0 = [[UIView alloc] initWithFrame:CGRectMake(8,0,SCREEN_WIDTH-8,0.5)];
    div0.backgroundColor = [UtilManager getColorWithHexString:@"4b4b4b"];
    [self.view addSubview:div0];
    
    UIView *div1 = [[UIView alloc] initWithFrame:CGRectMake(8,51,SCREEN_WIDTH-8,0.5)];
    div1.backgroundColor = [UtilManager getColorWithHexString:@"4b4b4b"];
    [self.view addSubview:div1];
}

-(UIView *)createCell:(NSString *)imageName title:(NSString *)title startY:(CGFloat)y action:(SEL)action
{
    UIView *cell = [[UIView alloc] initWithFrame:CGRectMake(8,y,SCREEN_WIDTH-16,51)];
    cell.backgroundColor = [UIColor clearColor];
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(9, y>0?11:17, 25, 26)];
    iv.image = [UtilManager imageNamed:imageName];
    [cell addSubview:iv];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(49,y>0?13:19,100,20)];
    label.text = title;
    label.textColor = [UtilManager getColorWithHexString:@"#353535"];
    label.font = [UIFont systemFontOfSize:18];
    [cell addSubview:label];
    
    UIImageView *ind = [[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.size.width-28, y>0?15:21,14, 19)];
    ind.image = [UtilManager imageNamed:@"jinru"];
    [cell addSubview:ind];
    
    [cell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:action]];
    
    return cell;
}
-(void)push2Homework:(id)sender
{
    HomeWorkViewController *set = [[HomeWorkViewController alloc] init];
    [self.navigationController pushViewController:set animated:YES];
}

-(void)push2Timetable:(id)sender
{
    TimeTableViewController *set = [[TimeTableViewController alloc] init];
    [self.navigationController pushViewController:set animated:YES];
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
