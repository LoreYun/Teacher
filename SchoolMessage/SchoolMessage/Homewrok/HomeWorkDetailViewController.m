//
//  HomeWorkDetailViewController.m
//  SchoolMessage
//
//  Created by wulin on 15/2/10.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "HomeWorkDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "ReadInfoCell.h"
#import "HomeWorkViewController.h"

static NSString *identifier = @"HomeWorkDetailViewController";

@interface HomeWorkDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UIScrollView *scroller;
@property (nonatomic,strong) UIButton *detailButton;
@property (nonatomic,strong) NSMutableArray *imageArray;
@property (nonatomic,strong) UITableView *readTableView;
@property (nonatomic,strong) UICollectionView *imageCollectionView;

@property (nonatomic,strong) NSMutableArray *readInfoData;

@end

@implementation HomeWorkDetailViewController
@synthesize detailButton;

//{
//    ClassId = 5;
//    ClassName = "\U4e00\U73ed";
//    CreateTime = "2015-02-04 17:44:53";
//    FileName1 = "";
//    FileName2 = "";
//    FileName3 = "";
//    FileName4 = "";
//    FileName5 = "";
//    FullName1 = "";
//    FullName2 = "";
//    FullName3 = "";
//    FullName4 = "";
//    FullName5 = "";
//    GradeId = 4;
//    GradeName = "\U4e00\U5e74\U7ea7";
//    HomeworkContent = "\U4ed6\U5566\U5566\U5566\U5566\U5566";
//    HomeworkId = 1;
//    HomeworkTitle = "\U4f60\U6211\U4ed6";
//    IsSet = 1;
//    ReadInfo =             {
//        WeiDu = 9;
//        YiDu = 1;
//    };
//    SubjectId = 1;
//    SubjectName = "\U6570\U5b66";
//    SubmiteTime = "2015-02-04 17:44:00";
//    TeacherId = 43;
//    TeacherName = "\U73ed\U4e3b\U4efb1";
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"作业";
    
    [self initRightTitleBar:@"删除" action:@selector(deleteHomeWork:)];
    self.readInfoData = [NSMutableArray array];
    self.scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.scroller.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scroller];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH-40, 20)];
    title.font = [UIFont systemFontOfSize:19];
    title.textColor = [UtilManager getColorWithHexString:@"#333333"];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = [self.homeWorkInfo objectForKey:@"HomeworkTitle"];
    [self.scroller addSubview:title];
    
    [self createClassView:@"班级" content:[NSString stringWithFormat:@"%@%@",[self.homeWorkInfo objectForKey:S_GRADENAME],[self.homeWorkInfo objectForKey:S_CLASSNAME]] startY:53];
    
    [self createClassView:@"发起人" content:[self.homeWorkInfo objectForKey:@"TeacherName"] startY:108];
    
    [self createClassView:@"上交时间" content:[self.homeWorkInfo objectForKey:@"SubmiteTime"] startY:163];
    
    
    NSString *content = [self.homeWorkInfo objectForKey:@"HomeworkContent"];
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(SCREEN_WIDTH-26, MAXFLOAT)];
    UIView *contentBgView = [[UIView alloc] initWithFrame:CGRectMake(9, 218, SCREEN_WIDTH-16, size.height+26)];
    contentBgView.backgroundColor = [UIColor whiteColor];
    [self.scroller addSubview:contentBgView];
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 13, SCREEN_WIDTH-26, size.height)];
    contentLabel.backgroundColor = [UIColor whiteColor];
    contentLabel.text = content;
    contentLabel.numberOfLines = 0;
    
    [contentBgView addSubview:contentLabel];
    CGFloat y = CGRectGetMaxY(contentBgView.frame);
    
    self.imageArray = [NSMutableArray array];
    [self addData2ImageArray];
    if (self.imageArray.count>0) {
        CGFloat length = (SCREEN_WIDTH-16.0f-16.0f-24.0f)/3.0f;
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.itemSize = CGSizeMake(length,length);
        flowLayout.minimumInteritemSpacing = 12;
        flowLayout.minimumLineSpacing = 8;
                                         flowLayout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
        CGFloat h = (self.imageArray.count/3+1)*length+16;
        self.imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(8,CGRectGetMaxY(contentBgView.frame)+10, SCREEN_WIDTH-8, h) collectionViewLayout:flowLayout];
        self.imageCollectionView.delegate = self;
        self.imageCollectionView.dataSource = self;
        self.imageCollectionView.backgroundColor = [UIColor whiteColor];
        self.imageCollectionView.scrollEnabled = NO;
        [self.imageCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifier];
        [self.scroller addSubview:self.imageCollectionView];
        y = CGRectGetMaxY(self.imageCollectionView.frame);
    }
    
    detailButton = [[UIButton alloc] initWithFrame:CGRectMake(20, y+14, 74, 32)];
    [detailButton setTitle:@"浏览详情" forState:0];
    [detailButton setTitleColor:[UIColor whiteColor] forState:0];
    [detailButton setBackgroundColor:[UtilManager getColorWithHexString:@"18b4ed"]];
    [detailButton addTarget:self action:@selector(readInfo:) forControlEvents:UIControlEventTouchUpInside];
    detailButton.titleLabel.font = [UIFont systemFontOfSize:15];
    detailButton.layer.cornerRadius =5;
    detailButton.layer.masksToBounds = YES;
    [self.scroller addSubview:detailButton];
    
    self.readTableView = [[UITableView alloc] initWithFrame:CGRectMake(20, y+55, SCREEN_WIDTH-40, 10)];
    self.readTableView.scrollEnabled = NO;
    self.readTableView.separatorColor = [UtilManager getColorWithHexString:@"#dddddd"];
    self.readTableView.backgroundColor = [UIColor clearColor];
    self.readTableView.delegate = self;
    self.readTableView.dataSource =self;
    self.readTableView.hidden=YES;
    [self.scroller addSubview:self.readTableView];
    
    
    UILabel *attdenceInfo = [[UILabel alloc] initWithFrame:CGRectMake(105, y+24, SCREEN_WIDTH-105, 16)];
    NSDictionary *readInfo =  [self.homeWorkInfo objectForKey:@"ReadInfo"];
    attdenceInfo.text = [NSString stringWithFormat:@"已读人数:%@  未读人数:%@",[readInfo objectForKey:@"YiDu"],[readInfo objectForKey:@"WeiDu"]];
    attdenceInfo.textColor = [UtilManager getColorWithHexString:@"#333333"];
    attdenceInfo.font = [UIFont systemFontOfSize:15];
    [self.scroller addSubview:attdenceInfo];
    
    [self.scroller setContentSize:CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(attdenceInfo.frame)+20)];
    
}

-(void)deleteHomeWork:(id)sender
{
    [self showHudInView:self.view hint:@"请稍后"];
    NSDictionary *dic =@{@"1":[self.homeWorkInfo objectForKey:@"HomeworkId"]};
    [[ObjectManager sharedInstance] requestDataOnPost:dic ByFlag:@"1503" callback:^(BOOL succeed, NSDictionary * data) {
        [self hideHud];
        if (succeed) {
            NSNumber *su = [data objectForKey:S_SUCCESS];
            if (su.boolValue) {
                [self showHint:@"删除成功！"];
                if (self.delegate && [self.delegate respondsToSelector:@selector(HomeWrokDelete:)]) {
                    NSNumber *hid = [self.homeWorkInfo objectForKey:@"HomeworkId"];
                    [self.delegate HomeWrokDelete:hid.stringValue];
                }
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[HomeWorkViewController class]]) {
                        [self.navigationController popToViewController:vc animated:YES];
                    }
                }
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

-(void)addData2ImageArray
{
    NSString *file1 = [self.homeWorkInfo objectForKey:@"FullName1"];
    if (file1.length ==0) {
        return;
    }
    [self.imageArray addObject:[NSString stringWithFormat:@"%@%@",imageUrl,file1]];
    
    file1 = [self.homeWorkInfo objectForKey:@"FullName2"];
    if (file1.length ==0) {
        return;
    }
    [self.imageArray addObject:[NSString stringWithFormat:@"%@%@",imageUrl,file1]];
    
    file1 = [self.homeWorkInfo objectForKey:@"FullName3"];
    if (file1.length ==0) {
        return;
    }
    [self.imageArray addObject:[NSString stringWithFormat:@"%@%@",imageUrl,file1]];
    
    file1 = [self.homeWorkInfo objectForKey:@"FullName4"];
    if (file1.length ==0) {
        return;
    }
    [self.imageArray addObject:[NSString stringWithFormat:@"%@%@",imageUrl,file1]];
    
    file1 = [self.homeWorkInfo objectForKey:@"FullName5"];
    if (file1.length ==0) {
        return;
    }
    [self.imageArray addObject:[NSString stringWithFormat:@"%@%@",imageUrl,file1]];
}

-(void)createClassView:(NSString *)title content:(NSString *)content startY:(CGFloat)y
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(8,y, SCREEN_WIDTH-16, 47)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius =5;
    view.layer.masksToBounds = YES;
    [self.scroller addSubview:view];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 92, 47)];
    label.text = title;
    label.textColor = [UtilManager getColorWithHexString:@"#353535"];
    label.font = [UIFont systemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    UIView *div = [[UIView alloc] initWithFrame:CGRectMake(92, 0, 0.5, 47)];
    
    div.backgroundColor = [UtilManager getColorWithHexString:@"#cecece"];
    [view addSubview:div];
    
    UILabel *classLabel = [[UILabel alloc] initWithFrame:CGRectMake(110.5,0,SCREEN_WIDTH-16-110.5, 47)];
    classLabel.textColor = [UtilManager getColorWithHexString:@"#353535"];
    classLabel.font = [UIFont systemFontOfSize:18];
    classLabel.text = content;
    [view addSubview:classLabel];
}

-(void)readInfo:(id)sender
{
    if (self.readTableView.hidden) {
        [self showHudInView:self.view hint:@"数据获取中"];
        [self getReadInfo:^(BOOL succeed) {
            [self hideHud];
            if (succeed) {
                [self.readTableView setFrame:CGRectMake(self.readTableView.frame.origin.x, self.readTableView.frame.origin.y, self.readTableView.frame.size.width, self.readInfoData.count*31.5)];
                [UIView animateWithDuration:0.2 animations:^{
                    self.readTableView.hidden = NO;
                    [self.scroller setContentSize:CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.readTableView.frame)+20)];
                    if (self.scroller.contentSize.height>SCREEN_HEIGHT-64) {
                        [self.scroller setContentOffset:CGPointMake(0, self.scroller.contentSize.height-(SCREEN_HEIGHT-64))  animated:YES];
                    }
                    [self.readTableView reloadData];
                }];
            }else
            {
                [self showHint:@"操作失败，请检查网络！"];
            }
        }];
    }else
    {
        [UIView animateWithDuration:0.2 animations:^{
            self.readTableView.hidden = YES;
            self.scroller.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.detailButton.frame)+20);
        }];
    }
}

-(void)getReadInfo:(void(^)(BOOL succeed))callback
{
    NSDictionary *dic = @{@"1":[self.homeWorkInfo objectForKey:@"HomeworkId"],@"2":[self.homeWorkInfo objectForKey:S_ClASSID],@"3":@"0"};
    [[ObjectManager sharedInstance] requestDataOnPost:dic ByFlag:@"1504" callback:^(BOOL succceed, NSDictionary *data) {
        if (succceed) {
            NSNumber *su = [data objectForKey:S_SUCCESS];
            if (su.boolValue) {
                [self.readInfoData  removeAllObjects];
                [self.readInfoData addObjectsFromArray:[data objectForKey:S_OBJ]];
                NSDictionary *dic = @{@"1":[self.homeWorkInfo objectForKey:@"HomeworkId"],@"2":[self.homeWorkInfo objectForKey:S_ClASSID],@"3":@"1"};
                [[ObjectManager sharedInstance] requestDataOnPost:dic ByFlag:@"1504" callback:^(BOOL succeed, NSDictionary *dic) {
                    if (succeed) {
                        NSNumber *su = [dic objectForKey:S_SUCCESS];
                        if (su.boolValue) {
                            [self.readInfoData addObjectsFromArray:[dic objectForKey:S_OBJ]];
                            callback(YES);
                        }else
                        {
                            callback(NO);
                        }
                    }else
                    {
                        callback(NO);
                    }
                }];
                
            }else
            {
                callback(NO);
            }
        }else
        {
            callback(NO);
        }
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 31.5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.readInfoData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReadInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:[ReadInfoCell identifier]];
    if (!cell) {
        cell = [[ReadInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[ReadInfoCell identifier]];
    }
    NSDictionary *dic = [self.readInfoData objectAtIndex:indexPath.row];
    [cell setupViews:dic];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Image Collection
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  self.imageArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    UIImageView *iv = (UIImageView *)[cell viewWithTag:5];
    if (!iv) {
        iv = [[UIImageView alloc] initWithFrame:cell.bounds];
        [cell addSubview:iv];
    }
   NSString *url = [self.imageArray objectAtIndex:indexPath.row];

    [iv setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UtilManager imageNamed:@"morentupian"]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    int count = self.imageArray.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        NSString *url = [self.imageArray objectAtIndex:indexPath.row];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        photo.comment = @"";
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = indexPath.row; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

@end
