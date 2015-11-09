//
//  AttdendanceViewController.m
//  SchoolMessage
//
//  Created by LI on 15/2/10.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "AttdendanceViewController.h"
#import "AttendanceInfo.h"

static NSString *identifier = @"AttdendanceViewController.h";

@interface AttdendanceViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) UICollectionView *imageCollectionView;
@property (nonatomic,strong) NSMutableArray   *array;
@property (nonatomic,strong) NSArray          *levelInfos;
@property (nonatomic,strong) AttendanceInfo   *tempinfo;

@end

@implementation AttdendanceViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"考勤";
    [self initRightImageBar:@"fasong" action:@selector(checkAttdendance)];
    self.array = [NSMutableArray array];
    CGFloat length = (SCREEN_WIDTH-34.0f-68.0f)/3.0f;
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.itemSize = CGSizeMake(length,47);
    flowLayout.minimumInteritemSpacing = 34;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0,0,0,0);
    self.imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(17,0, SCREEN_WIDTH-34,SCREEN_HEIGHT-64) collectionViewLayout:flowLayout];
    self.imageCollectionView.delegate = self;
    self.imageCollectionView.dataSource = self;
    self.imageCollectionView.backgroundColor = [UIColor clearColor];
    [self.imageCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifier];
    [self.view addSubview:self.imageCollectionView];
    
    [self getAttdenceInfo];
}

-(void)getAttdenceInfo
{
    [self showHudInView:self.view hint:@""];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSLog(@"%@",self.classInfo);
    NSDictionary *dic = @{@"1":[self.classInfo objectForKey:S_ClASSID],@"2":[[AccountManager sharedInstance].LoginInfos getTeacherId],@"3":[formatter stringFromDate:[NSDate date]]};
    [[ObjectManager sharedInstance] requestDataOnPost:dic ByFlag:@"1701" callback:^(BOOL succeed, NSDictionary * data) {
        [self hideHud];
        if (succeed) {
            NSNumber *su = [data objectForKey:S_SUCCESS];
            if (su.boolValue) {
                NSDictionary *dic = [data objectForKey:S_OBJ];
                NSNumber *number  = [dic objectForKey:@"AttFlag"];
                
                if (number.intValue == 1) {
                    self.navigationItem.rightBarButtonItem = nil;
                }
                
                NSArray *stuInfos = [dic objectForKey:@"stuInfo"];
                self.levelInfos = [NSMutableArray arrayWithArray:[dic objectForKey:@"levelInfo"]];
                NSArray *attInfos = [dic objectForKey:@"attInfo"];
                
                for (NSDictionary *stu in stuInfos) {
                    AttendanceInfo *info = [[AttendanceInfo alloc] initWithData:stu];
                    [self.array addObject:info];
                    if (number.intValue == 1) {
                        for(NSDictionary *attInfo in attInfos)
                        {
                            if ( [info.StudentId isEqualToNumber:attInfo[@"StudentId"]]) {
                                info.LateFlag = [self getLateFlag:attInfo[@"LateFlag"]];
                                break;
                            }
                        }
                    }else
                    {
                        for(NSDictionary *attInfo in self.levelInfos)
                        {
                            if ( [info.StudentId isEqualToNumber:attInfo[@"StudentId"]]) {
                                info.LateFlag = Ask_For_Leave;
                                break;
                            }
                        }
                    }
                }
                [self.imageCollectionView reloadData];
            }else
            {
                [self showHint:@"操作失败，请检查网络！"];
            }
        }else
        {
            [self showHint:@"操作失败，请检查网络！"];
        }
    }];
}

-(void)checkAttdendance
{
    [self showHudInView:self.view hint:@"请稍后"];
    NSString* json = @"";
    for (AttendanceInfo *info  in self.array) {
        json = [NSString stringWithFormat:@"%@,%@",json,info.getUploadJson];
    }
    json = [NSString stringWithFormat:@"[%@]",[json substringFromIndex:1]];
    NSDictionary *dic = @{@"1":[self.classInfo objectForKey:S_ClASSID],@"2":[self.classInfo objectForKey:S_CLASSNAME],@"3":[self.classInfo objectForKey:S_GRADEID],@"4":[self.classInfo objectForKey:@"GradeName"],@"5":[[AccountManager sharedInstance].LoginInfos getTeacherId],@"6":[[AccountManager sharedInstance].LoginInfos getTeacherName],@"7":json};
    
    [[ObjectManager sharedInstance] requestDataOnPost:dic ByFlag:@"1702" callback:^(BOOL succeed, NSDictionary * data) {
        [self hideHud];
        if (succeed) {
            NSNumber *su = [data objectForKey:S_SUCCESS];
            [self showHint:su.boolValue?@"发送成功！":@"操作失败，请检查网络！"];
            self.navigationItem.rightBarButtonItem = nil;
        }else
        {
            [self showHint:@"操作失败，请检查网络！"];
        }
    }];
}

#pragma mark Image Collection
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  self.array.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    UIButton *btn = (UIButton *)[cell viewWithTag:5];
    if (!btn) {
        btn = [[UIButton alloc] initWithFrame:cell.bounds];
//        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgArrow.size.width, 0, imgArrow.size.width)];
//        
//        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, btn.titleLabel.bounds.size.width, 0, -btn.titleLabel.bounds.size.width)];
        [cell addSubview:btn];
        UIView *div = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-0.5, cell.frame.size.width, 0.5)];
        div.backgroundColor = [UIColor blackColor];
        [cell addSubview:div];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor blackColor] forState:0];
        btn.enabled = NO;
        btn.tag = 5;
    }
    AttendanceInfo *info = [self.array objectAtIndex:indexPath.item];
    [btn setTitle:info.StudentName forState:0];
    [btn setTitle:info.StudentName forState:UIControlStateDisabled];
    NSString *img = [self getLateFlagImgName:info.LateFlag];
    NSLog(@"%@ info.LateFlag%@  info.StudentName:%@",img,info.LateFlag,info.StudentName);
    [btn setImage:[UtilManager imageNamed:img] forState:0];
    [btn setImage:[UtilManager imageNamed:img] forState:UIControlStateDisabled];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -btn.imageView.frame.size.width - btn.frame.size.width + btn.titleLabel.intrinsicContentSize.width, 0, 0);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -btn.titleLabel.frame.size.width - btn.frame.size.width + btn.imageView.frame.size.width);
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AttendanceInfo *info = [self.array objectAtIndex:indexPath.row];
    if ([info.LateFlag isEqualToString:Ask_For_Leave] && [self isLeave:info.StudentId]) {
        NSDictionary *dic = [self getLeaveInfo:info.StudentId];
        NSString *msg = [NSString stringWithFormat:@"该同学已请假！\n\n起始时间：%@\n截止时间：%@\n 是否继续切换其状态？",dic[@"TimeFrom"],dic[@"TimeTo"]];
        self.tempinfo = info;
        [[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
    }else
    {
        info.LateFlag = [self changeLateFlag:info.LateFlag];
        [self.imageCollectionView reloadData];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==1) {
        self.tempinfo.LateFlag = [self changeLateFlag:self.tempinfo.LateFlag];
        [self.imageCollectionView reloadData];
    }
}

-(BOOL)isLeave:(NSNumber *)studentId
{
    for(NSDictionary *attInfo in self.levelInfos)
    {
        if ( [studentId isEqualToNumber:attInfo[@"StudentId"]]) {
            return YES;
        }
    }
    
    return NO;
}

-(NSDictionary *)getLeaveInfo:(NSNumber *)studentId
{
    for(NSDictionary *attInfo in self.levelInfos)
    {
        if ( [studentId isEqualToNumber:attInfo[@"StudentId"]]) {
            return attInfo;
        }
    }
    
    return nil;
}

-(NSString *)getLateFlag:(NSNumber *)late
{
    switch (late.intValue) {
        case 0:
            return NOTLATE;
        case 1:
            return LATE;
        case 2:
            return Ask_For_Leave;
    }
    
    return NOTLATE;
}

-(NSString *)changeLateFlag:(NSString *)late
{
    if ([late isEqualToString:NOTLATE]) {
        return LATE;
    }else if ([late isEqualToString:LATE]) {
        return Ask_For_Leave;
    }else{
        return NOTLATE;
    }
}

-(NSString *)getLateFlagImgName:(NSString *)late
{
    if ([late isEqualToString:NOTLATE]) {
        return @"yidao";
    }
    
    if ([late isEqualToString:LATE]) {
        return @"weidao";
    }
    
    if ([late isEqualToString:Ask_For_Leave]) {
        return @"chidao";
    }
    
    return @"yidao";
}

@end
