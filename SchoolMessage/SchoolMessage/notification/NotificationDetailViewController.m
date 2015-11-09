//
//  NotificationDetailViewController.m
//  SchoolMessage
//
//  Created by LI on 15/2/2.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "NotificationDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "ReadInfoCell.h"

@interface NotificationDetailViewController ()<UITableViewDataSource,UITableViewDelegate>;

@property (nonatomic,strong) NSDictionary *notificationDetail;

@property (nonatomic,strong) NSString  *classId;

@property (nonatomic,strong) UITableView *studentTableView;

@property (nonatomic,strong) NSMutableArray *readInfoData;

@property (nonatomic,strong) UITableView *readTableView;

@property (nonatomic,strong) UIScrollView *scrollview;

@property (nonatomic,strong) UIButton *detailButton;

@property (nonatomic,strong) UILabel *attdenceInfo;

@property (nonatomic,strong) UIImageView *iv;

@end

@implementation NotificationDetailViewController
@synthesize scrollview,detailButton,iv;

-(instancetype)initByClassId:(NSString *)classId detail:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.classId = classId;
        self.notificationDetail = dic;
    }
    
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"通知详情";
    [self showHudInView:self.view hint:@""];
    self.readInfoData = [NSMutableArray array];
    
    scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    scrollview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollview];
    
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 14,SCREEN_WIDTH-20,21)];
    titlelabel.font = [UIFont boldSystemFontOfSize:19];
    titlelabel.textColor = [UtilManager getColorWithHexString:@"#333333"];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.text = [self.notificationDetail objectForKey:@"Title"];
    [scrollview addSubview:titlelabel];
    
    UILabel *timelabel = [[UILabel alloc] initWithFrame:CGRectMake(20,44,SCREEN_WIDTH-17,16)];
    timelabel.font = [UIFont boldSystemFontOfSize:12];
    timelabel.textColor = [UtilManager getColorWithHexString:@"#6D6E71"];
    timelabel.text = [NSString stringWithFormat:@"%@ %@",[self.notificationDetail objectForKey:@"TeacherName"],[self.notificationDetail objectForKey:@"CreateTime"]];
    [scrollview addSubview:timelabel];
    
    NSString * content = [self.notificationDetail objectForKey:@"Content"];
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(SCREEN_WIDTH-40, CGFLOAT_MAX)];
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,65,SCREEN_WIDTH-40,size.height)];
    contentLabel.font = [UIFont systemFontOfSize:18];
    contentLabel.textColor = [UtilManager getColorWithHexString:@"#2b3431"];
    contentLabel.numberOfLines = 0;
//    contentLabel.textAlignment = NSTextAlignmentRight;
    contentLabel.text = content;
    [scrollview addSubview:contentLabel];
    
    NSString * FullName = [self.notificationDetail objectForKey:@"FullName"];
    if(FullName.length>0 && ![FullName isEqualToString:@"null"])
    {
//        contentImageView.frame = CGRectMake(10, content_label.frame.origin.y+size.height+20, SCREEN_WIDTH-20, (SCREEN_WIDTH-20.f)/16.f*9.f);
//        contentImageView.contentMode = UIViewContentModeScaleAspectFill;
//        contentImageView.clipsToBounds= YES;
//        [contentImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[RosterManager sharedInstance].myInfo.zhaopian,img1]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//
//        }];
        
        __weak typeof(self) ws = self;
        iv = [[UIImageView alloc] initWithFrame:CGRectMake(15, size.height+65+20, SCREEN_WIDTH-30, SCREEN_WIDTH-30/9*16)];
        iv.contentMode  = UIViewContentModeScaleAspectFill;
        NSURL *url      = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageUrl,[self.notificationDetail objectForKey:@"FullName"]]];
        [iv setImageWithURL:url placeholderImage:[UtilManager imageNamed:@"morentupian"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            CGFloat height =  image.size.height*(SCREEN_WIDTH-20) /image.size.width;
            if (image &&  height > (SCREEN_WIDTH-30.f)/16.f*9.f) {
                ws.iv.frame = CGRectMake(15,size.height+65+20, SCREEN_WIDTH-30,height);
                CGFloat y =  CGRectGetMaxY(ws.iv.frame);
                ws.detailButton.frame = CGRectMake(20, y+14, 74, 32);
                ws.attdenceInfo.frame = CGRectMake(105, y+24, SCREEN_WIDTH-105, 16);
                ws.readTableView.frame=CGRectMake(20, y+55, SCREEN_WIDTH-40, 10);
                ws.scrollview.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(ws.attdenceInfo.frame)+20);
            }
            [self hideHud];
        }];
        [scrollview addSubview:iv];
        scrollview.scrollEnabled = YES;
        scrollview.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(iv.frame)+32);
    }else
    {
        scrollview.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(contentLabel.frame)+32);
    }
    contentLabel.backgroundColor = [UIColor clearColor];
    CGFloat y = scrollview.contentSize.height-32;
    detailButton = [[UIButton alloc] initWithFrame:CGRectMake(20, y+14, 74, 32)];
    [detailButton setTitle:@"浏览详情" forState:0];
    [detailButton setTitleColor:[UIColor whiteColor] forState:0];
    [detailButton setBackgroundColor:[UtilManager getColorWithHexString:@"18b4ed"]];
    [detailButton addTarget:self action:@selector(attdenceInfo:) forControlEvents:UIControlEventTouchUpInside];
    detailButton.titleLabel.font = [UIFont systemFontOfSize:15];
    detailButton.layer.cornerRadius =5;
    detailButton.layer.masksToBounds = YES;
    [self.scrollview addSubview:detailButton];
    
    
    self.attdenceInfo = [[UILabel alloc] initWithFrame:CGRectMake(105, y+24, SCREEN_WIDTH-105, 16)];
    NSDictionary *readInfo =  [self.notificationDetail objectForKey:@"ReadInfo"];
    self.attdenceInfo.text = [NSString stringWithFormat:@"已读人数:%@  未读人数:%@",[readInfo objectForKey:@"YiDu"],[readInfo objectForKey:@"WeiDu"]];
    self.attdenceInfo.textColor = [UtilManager getColorWithHexString:@"#333333"];
    self.attdenceInfo.font = [UIFont systemFontOfSize:15];
    [scrollview addSubview:self.attdenceInfo];
    
    scrollview.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.attdenceInfo.frame)+20);
    
    self.readTableView = [[UITableView alloc] initWithFrame:CGRectMake(20, y+55, SCREEN_WIDTH-40, 10)];
    self.readTableView.scrollEnabled = NO;
    self.readTableView.separatorColor = [UtilManager getColorWithHexString:@"#dddddd"];
    self.readTableView.backgroundColor = [UIColor clearColor];
    self.readTableView.delegate = self;
    self.readTableView.dataSource =self;
    [scrollview addSubview:self.readTableView];
    
    UIView *div = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-40, 0.5)];
    div.backgroundColor = [UIColor blackColor];
    [self.readTableView addSubview:div];
    self.readTableView.hidden = YES;
}

-(void)attdenceInfo:(id)sender
{
    if (self.readTableView.hidden) {
        [self showHudInView:self.view hint:@"数据获取中"];
        [self getReadInfo:^(BOOL succeed) {
            [self hideHud];
            if (succeed) {
                [self.readTableView setFrame:CGRectMake(self.readTableView.frame.origin.x, self.readTableView.frame.origin.y, self.readTableView.frame.size.width, self.readInfoData.count*31.5)];
                [UIView animateWithDuration:0.2 animations:^{
                    self.readTableView.hidden = NO;
                    [scrollview setContentSize:CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.readTableView.frame)+17)];
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
            self.scrollview.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.detailButton.frame)+17);
        }];
    }
}

-(void)getReadInfo:(void(^)(BOOL succeed))callback
{
    NSDictionary *dic = @{@"1":[self.notificationDetail objectForKey:@"Id"],@"2":self.classId,@"3":@"0"};
    [[ObjectManager sharedInstance] requestDataOnPost:dic ByFlag:@"1303" callback:^(BOOL succceed, NSDictionary *data) {
        if (succceed) {
            NSNumber *su = [data objectForKey:S_SUCCESS];
            if (su.boolValue) {
                [self.readInfoData  removeAllObjects];
                [self.readInfoData addObjectsFromArray:[data objectForKey:S_OBJ]];
                NSDictionary *dic = @{@"1":[self.notificationDetail objectForKey:@"Id"],@"2":self.classId,@"3":@"1"};
                [[ObjectManager sharedInstance] requestDataOnPost:dic ByFlag:@"1303" callback:^(BOOL succeed, NSDictionary *dic) {
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

@end
