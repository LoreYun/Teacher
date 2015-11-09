//
//  LeaveDetialViewController.m
//  SchoolMessage
//
//  Created by LI on 15/2/10.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "LeaveDetialViewController.h"

@implementation LeaveDetialViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"请假详情";
    
    UIImageView *bgIv = [[UIImageView alloc] initWithFrame:CGRectMake(10,10, SCREEN_WIDTH-20, SCREEN_HEIGHT-64-20)];
    bgIv.image = [UtilManager imageNamed:@"qingjiatiaobeijing"];
    [self.view addSubview:bgIv];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(33, 37, 200, 20)];
    title.textColor = [UtilManager getColorWithHexString:@"#333333"];
    title.font = [UIFont systemFontOfSize:19];
    title.text = @"尊敬的老师：";
    [self.view addSubview:title];
    
//    TimeFrom = "2015-09-09 17:16:00";
//    TimeTo = "2015-09-10 17:17:00";
    NSString *contentText = [NSString stringWithFormat:@"%@\n\n\n开始时间：%@\n截止时间：%@",[self.data objectForKey:@"Content"],[self.data objectForKey:@"TimeFrom"],[self.data objectForKey:@"TimeTo"]];
  
    CGSize size =[contentText sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(SCREEN_WIDTH-96, SCREEN_HEIGHT-168-75)];
    
    UIScrollView *sc = [[UIScrollView alloc] initWithFrame:CGRectMake(48, 70, SCREEN_WIDTH-96, SCREEN_HEIGHT-16-165-70)];
    [self.view addSubview:sc];
    sc.contentSize = CGSizeMake(SCREEN_WIDTH-96, size.height);
    
    UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-96, size.height)];
    content.textColor = [UtilManager getColorWithHexString:@"#333333"];
    content.font = [UIFont systemFontOfSize:15];
    content.text = contentText;
    content.numberOfLines = 0;
    content.backgroundColor = [UIColor clearColor];
    [sc addSubview:content];
    
    UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-248-30,SCREEN_HEIGHT-16-165, 248,75)];
    time.textColor = [UtilManager getColorWithHexString:@"#333333"];
    time.font = [UIFont systemFontOfSize:19];
    time.text = [NSString stringWithFormat:@"请假人：%@\n申请人：%@\n时  间：%@",[self.data objectForKey:@"StudentName"],[self.data objectForKey:@"ParentName"],[self.data objectForKey:@"CreateTime"]];
    time.numberOfLines = 0;
    [self.view addSubview:time];
}

@end
