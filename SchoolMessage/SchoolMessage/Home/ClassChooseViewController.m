//
//  ClassChooseViewController.m
//  SchoolMessage
//
//  Created by wulin on 15/2/1.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "ClassChooseViewController.h"
#import "ClassChooseCell.h"
#import "NotificationViewController.h"
#import "ClassStudentsViewController.h"
#import "AttdendanceViewController.h"

@interface ClassChooseViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *maintableView;

@property (nonatomic,strong) NSMutableArray * mainDataSource;

@end

@implementation ClassChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"班级列表";
    
    if (self.viewControllerType == Attendance) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in [[AccountManager sharedInstance].LoginInfos getTeacherClassesArray]) {
            NSNumber *cid = dic[@"ClassId"];
            if ([[AccountManager sharedInstance].LoginInfos isClassMaster:cid.stringValue]) {
                [array addObject:dic];
            }
        }
        
        self.mainDataSource= array;
    }else
    {
        self.mainDataSource = [[AccountManager sharedInstance].LoginInfos getTeacherClassesArray];
    }
    
    
    self.maintableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.maintableView.backgroundColor = [UIColor clearColor];
    self.maintableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.maintableView.dataSource =self;
    self.maintableView.delegate = self;
    [self.view addSubview:self.maintableView];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.mainDataSource objectAtIndex:indexPath.row];
    switch (self.viewControllerType) {
        case ClassNotification:
        {
            NotificationViewController *vc = [[NotificationViewController alloc] init];
            vc.classInfo = dic;
            [self.navigationController pushViewController:vc animated:YES];
        }
            
            break;
        case StudentReviews:
        {
            ClassStudentsViewController *vc = [[ClassStudentsViewController alloc] init];
            vc.classInfo = dic;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case Attendance:
        {
            AttdendanceViewController *vc = [[AttdendanceViewController alloc] init];
            vc.classInfo = dic;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51.5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mainDataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:[ClassChooseCell identifier]];
    if (!cell) {
        cell = [[ClassChooseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[ClassChooseCell identifier]];
    }
    NSDictionary * dic = [self.mainDataSource objectAtIndex:indexPath.row];
    
    [cell setupViews:[dic objectForKey:@"GradeName"] classString:[dic objectForKey:@"ClassName"] number:((NSNumber *)[dic objectForKey:@"StudentCount"]).stringValue];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
