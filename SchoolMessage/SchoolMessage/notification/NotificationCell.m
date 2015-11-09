//
//  NotificationCell.m
//  SchoolMessage
//
//  Created by LI on 15/2/5.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "NotificationCell.h"

@interface NotificationCell ()

@property (nonatomic , strong)UILabel *title ;
@property (nonatomic , strong)UILabel *content ;
@property (nonatomic , strong)UILabel *creator;
@property (nonatomic , strong)UILabel *time;
@property (nonatomic , strong)UIImageView *bgView;

@end

@implementation NotificationCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bgView = [[UIImageView alloc] initWithImage:[[UtilManager imageNamed:@"bullentin_bg"] stretchableImageWithLeftCapWidth:30 topCapHeight:50]];
        [self addSubview:self.bgView];
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(25, 20, 130, 16)];
        self.title.numberOfLines = 1;
        self.title.font = [UIFont systemFontOfSize:15];
        self.title.clipsToBounds = YES;
        [self addSubview:self.title];
        
        self.content = [[UILabel alloc] initWithFrame:CGRectMake(25, 42, self.frame.size.width-50, 32)];
        self.content.numberOfLines = 2;
        self.content.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.content];
        
        self.creator= [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-100-25, 23, 100, 16)];
        self.creator.numberOfLines = 1;
        self.creator.font = [UIFont systemFontOfSize:12];
        self.creator.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.creator];
        
        self.time= [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-100-25, 23, 100, 16)];
        self.time.numberOfLines = 1;
        self.time.textColor = [UtilManager getColorWithHexString:@"333333"];
        self.time.font = [UIFont systemFontOfSize:12];
        self.time.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.time];
    }
    return self;
}
-(void)setupNotificationViews:(NSDictionary *)dic
{
    self.title.text = [dic objectForKey:@"Title"];
    self.content.text = [dic objectForKey:@"Content"];
    self.creator.text = [NSString stringWithFormat:@"发件人：%@",[dic objectForKey:@"TeacherName"]];
    self.time.text = [dic objectForKey:@"CreateTime"];
    
    CGSize size = [self.content.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(SCREEN_WIDTH-50, 35)];
    self.content.frame = CGRectMake(25, 42, size.width, size.height);
    self.creator.frame = CGRectMake(SCREEN_WIDTH-150-55, 20, 170, 16);
    self.bgView.frame = CGRectMake(0,10,SCREEN_WIDTH,size.height+55+32);
    self.time.frame = CGRectMake(SCREEN_WIDTH-150-25, CGRectGetMaxY(self.content.frame)+25, 150, 16);
}

+(NSString *)identifier
{
    return @"BulletinCell";
}

@end
