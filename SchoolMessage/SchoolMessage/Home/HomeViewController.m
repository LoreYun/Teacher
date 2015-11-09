//
//  HomeViewController.m
//  SchoolMessage
//
//  Created by LI on 15/1/26.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCollectionViewCell.h"
#import "SelfViewController.h"
#import "BulletinViewController.h"
#import "AlbumViewController.h"
#import "NotificationViewController.h"
#import "ClassChooseViewController.h"
#import "ContactViewController.h"
#import "TimeTableViewController.h"
#import "HomeWorkViewController.h"
#import "LeaveViewController.h"
#import "EducationViewController.h"
#import "StudyViewController.h"

@interface HomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView * collectView;
@property (nonatomic,strong) NSArray     * iconArray;
@property (nonatomic,strong) NSArray     * iconTextArray;

@end

@implementation HomeViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""  style:UIBarButtonItemStylePlain  target:self  action:nil];;
    self.title = [NSString stringWithFormat:@"欢迎：%@",[[AccountManager sharedInstance].LoginInfos getTeacherName]];
    [self createMain];
    [self createDoc];
}

-(void)createMain
{
    CGFloat bottom = iphone5?100:50;
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(25, 25, self.view.frame.size.width-50, SCREEN_HEIGHT-64-55-bottom)];//self.view.frame.size.width-50.0/1034.0f*1221.0f
    image .image = [UtilManager imageNamed:@"home_bg"];
//    image.contentMode = UIViewContentModeScaleAspectFit;
    image.clipsToBounds = YES;
    image.backgroundColor = [UIColor clearColor];
    [self.view addSubview:image];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
//    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.headerReferenceSize = CGSizeZero;
    flowLayout.footerReferenceSize = CGSizeZero;
    flowLayout.sectionInset = UIEdgeInsetsMake(50, 20, 25, 20);
    
    self.collectView = [[UICollectionView alloc] initWithFrame:image.frame collectionViewLayout:flowLayout];
    self.collectView.backgroundColor = [UIColor clearColor];
    self.collectView.delegate = self;
    self.collectView.dataSource = self;
    
    flowLayout.minimumInteritemSpacing = 18;//iphone5?20:19.5;
    CGFloat length = (self.collectView.frame.size.width-40-flowLayout.minimumInteritemSpacing*2)/3.0f;
    flowLayout.minimumLineSpacing = (self.collectView.frame.size.height-75-length*3)/2;//(self.view.frame.size.height-(SCREEN_WIDTH*9/16)-64-(74*3)-10)/2;
    
    flowLayout.itemSize = CGSizeMake(length,length);//;
    NSLog(@"flowLayout.itemSize %@",NSStringFromCGSize(flowLayout.itemSize));
    NSLog(@"flowLayout.minimumInteritemSpacing %f",flowLayout.minimumInteritemSpacing);
    NSLog(@"flowLayout.minimumLineSpacing %f",flowLayout.minimumLineSpacing);
    [self.collectView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:[HomeCollectionViewCell identyfier]];
    [self.view addSubview:self.collectView];
    
    self.iconArray = @[@"gonggao",@"dianping",@"tongxunlu",@"xiangce",@"tongzhi",@"xuexi",@"jiaoyu",@"kaoqin",@"leave"];
    self.iconTextArray =@[@"校园公告",@"学生点评",@"通讯录",@"班级相册",@"班级通知",@"学习",@"津城教育",@"考勤",@"请假条"];
    
    
    
}
//底栏
-(void)createDoc
{
    UIView *doc = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-55-64, self.view.frame.size.width, 55)];
    [self.view addSubview:doc];
    UIButton *Community = [self createDocBtn:0 title:@"社区" titleColor:[UtilManager getColorWithHexString:@"#18b4ed"] image:@"shequ" bgColor:[UIColor whiteColor] action:@selector(push2Community:)];
    [doc addSubview:Community];
    
    UIButton *home = [self createDocBtn:CGRectGetWidth(self.view.frame)/3.0f title:@"主页" titleColor:[UIColor whiteColor] image:@"zhuye" bgColor:[UtilManager getColorWithHexString:@"#18b4ed"] action:nil];
    [doc addSubview:home];
    
    UIButton *me = [self createDocBtn:CGRectGetWidth(self.view.frame)/3.0f*2 title:@"我" titleColor:[UtilManager getColorWithHexString:@"#18b4ed"] image:@"wo" bgColor:[UIColor whiteColor] action:@selector(push2Me:)];
    [doc addSubview:me];
}

-(UIButton *)createDocBtn:(CGFloat)startx title:(NSString *)title titleColor:(UIColor *)color image:(NSString *)imageName bgColor:(UIColor *)bgcolor action:(SEL)action
{
    UIButton *btn= [[UIButton alloc] initWithFrame:CGRectMake(startx,0 ,self.view.frame.size.width/3.0f, 55)];
    [btn setImage:[UtilManager imageNamed:imageName] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color  forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn setBackgroundColor:bgcolor];
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -btn.imageView.frame.size.width, -btn.imageView.frame.size.height, 0);
    btn.imageEdgeInsets = UIEdgeInsetsMake(-btn.titleLabel.intrinsicContentSize.height, 0, 0, -btn.titleLabel.intrinsicContentSize.width);
    
    if (action) {
        [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}

#pragma mark collectionView
//-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return 3;
//}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[HomeCollectionViewCell identyfier] forIndexPath:indexPath];
    
    cell.iconName = [self.iconArray objectAtIndex:indexPath.row];
    cell.iconText = [self.iconTextArray objectAtIndex:indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    switch (indexPath.row) {
        case 0:
            [self push2Bulletin];
            break;
        case 1:
            [self push2Evaluation];
            break;
        case 2:
            [self push2Contact];
            break;
        case 3:
            [self push2Album];
            break;
        case 4:
            [self push2Notification];
            break;
        case 5:
            [self push2Study];
            break;
        case 6:
            [self push2Education];
            break;
        case 7:
            [self push2Attdence];
            break;
        case 8:
            [self push2Leave];
            break;
            
        default:
            break;
    }
}

-(void)push2Leave
{
    LeaveViewController * vc = [[LeaveViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)push2Attdence
{
    ClassChooseViewController * vc = [[ClassChooseViewController alloc] init];
    vc.viewControllerType = Attendance;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)push2Homework
{
    HomeWorkViewController *vc = [[HomeWorkViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)push2Education
{
    EducationViewController *vc = [[EducationViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)push2Evaluation
{
    ClassChooseViewController * vc = [[ClassChooseViewController alloc] init];
    vc.viewControllerType = StudentReviews;
    vc.title = @"学生点评";
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)push2Contact
{
    ContactViewController *vc = [[ContactViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)push2Bulletin
{
    BulletinViewController *vc = [[BulletinViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)push2ReView
{
    ClassChooseViewController * vc = [[ClassChooseViewController alloc] init];
    vc.viewControllerType = StudentReviews;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)push2Attendance
{
    ClassChooseViewController * vc = [[ClassChooseViewController alloc] init];
    vc.viewControllerType = Attendance;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)push2Album
{
    AlbumViewController *vc = [[AlbumViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)push2Notification
{
    ClassChooseViewController * vc = [[ClassChooseViewController alloc] init];
    vc.viewControllerType = ClassNotification;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)push2TimeTable
{
    TimeTableViewController *vc = [[TimeTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

}

-(void)push2Study
{
    StudyViewController *vc = [[StudyViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)push2Community:(id)sender
{
    NSLog(@"push2Community");
    
    NSString * username = [[NSUserDefaults standardUserDefaults] objectForKey:USER_NAME_REAL_SAVE];
    [self loginWithUsername:username password:username];
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password
{
    [self showHudInView:self.view hint:@"正在登录..."];
    NSLog(@"username:%d",[[EaseMob sharedInstance].chatManager isLoggedIn]);
    NSLog(@"username:%@",[[EaseMob sharedInstance].chatManager loginInfo]);
    
    if([[EaseMob sharedInstance].chatManager isLoggedIn] && [[[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:USER_NAME_REAL_SAVE]])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@"1"];
    }else
    {
        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:username
                                                            password:password
                                                          completion:
         ^(NSDictionary *loginInfo, EMError *error) {
             [self hideHud];
             if (loginInfo && !error) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@"1"];
                 //                [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
             }else {
                 switch (error.errorCode) {
                     case EMErrorServerNotReachable:
                         TTAlertNoTitle(@"连接服务器失败!");
                         break;
                     case EMErrorServerAuthenticationFailure:
                         TTAlertNoTitle(@"用户名或密码错误");
                         break;
                     case EMErrorServerTimeout:
                         TTAlertNoTitle(@"连接服务器超时!");
                         break;
                     default:
                         TTAlertNoTitle(@"登录失败");
                         break;
                 }
             }
         } onQueue:nil];
    }
    
}

-(void)push2Me:(id)sender
{
    NSLog(@"push2Me");
    SelfViewController *vc = [[SelfViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
