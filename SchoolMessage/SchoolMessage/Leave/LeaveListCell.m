//
//  BulletinCell.m
//  SchoolMessage
//
//  Created by wulin on 15/1/31.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "LeaveListCell.h"

//{
//    "NoticeId": 1,
//    "NoticeTitle": "测试年级公告1",
//    "NoticeContent": "测试年级公告1测试年级公告1测试年级公告1测试年级公告1测试年级公告1测试年级公告1",
//    "FaQiRenId": 1,
//    "FaQiRenName": "管理员",
//    "CreateTime": "2014-12-31 11:44:25",
//    "CodeId": 11,
//    "SendType": "标签推",
//    "TopFlag": false,
//    "Recievers": "2014级高中"
//}

@interface LeaveListCell ()

@property (nonatomic , strong)UILabel *title ;
@property (nonatomic , strong)UILabel *content ;
@property (nonatomic , strong)UILabel *creator;
@property (nonatomic , strong)UILabel *timeLabel;
@property (nonatomic , strong)UIImageView *bgView;

@end

@implementation LeaveListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 15, SCREEN_WIDTH-24, 130)];
        self.bgView.image = [[UtilManager imageNamed:@"qinjiatiao2"] stretchableImageWithLeftCapWidth:50 topCapHeight:60];
        [self addSubview:self.bgView];
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(29, 52, SCREEN_WIDTH-24-40, 19)];
        self.title.numberOfLines = 1;
        self.title.font = [UIFont systemFontOfSize:18];
        [self addSubview:self.title];
        
        self.creator= [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-120-25,94, 120, 16)];
        self.creator.numberOfLines = 1;
        self.creator.font = [UIFont systemFontOfSize:14];
        self.creator.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.creator];
        
        self.timeLabel= [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-200-25, 120, 200, 16)];
        self.timeLabel.numberOfLines = 1;
        self.timeLabel.font = [UIFont systemFontOfSize:15];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.timeLabel];
    }
    return self;
}


-(void)setupViews:(NSDictionary *)dic
{
    self.title.text = [dic objectForKey:@"Content"];
    self.creator.text = [dic objectForKey:@"StudentName"];
    self.timeLabel.text = [dic objectForKey:@"CreateTime"];
}

+(NSString *)identifier
{
    return @"LeaveListCell";
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
