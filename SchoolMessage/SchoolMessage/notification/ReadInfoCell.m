//
//  ReadInfoCell.m
//  SchoolMessage
//
//  Created by LI on 15/2/5.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "ReadInfoCell.h"

@interface ReadInfoCell ()

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UILabel *readLabel;

@property (nonatomic,strong) UILabel *timeLabel;

@end

@implementation ReadInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self initViews];
    }
    return self;
}

-(void)initViews
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 9, 72, 16)];
    self.nameLabel.textColor = [UtilManager getColorWithHexString:@"#333333"];
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.nameLabel];
    
    self.readLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 9,SCREEN_WIDTH-60, 16)];
    self.readLabel.textColor = [UtilManager getColorWithHexString:@"#333333"];
    self.readLabel.font = [UIFont systemFontOfSize:15];
    self.readLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.readLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 9,SCREEN_WIDTH-60, 16)];
    self.timeLabel.textColor = [UtilManager getColorWithHexString:@"#333333"];
    self.timeLabel.font = [UIFont systemFontOfSize:15];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.timeLabel];
}


-(void)setupViews:(NSDictionary *)dic
{
    self.nameLabel.text = [dic objectForKey:@"StudentName"];
    NSNumber *read = [dic objectForKey:@"ReadFlag"];
    self.readLabel.text = read.intValue ==1 ?@"已读":@"未读";
    
    NSString *result = @"";
    if (read.intValue ==1) {
        NSString *temp = [dic objectForKey:@"CreateTime"];
        NSDateFormatter *formatter =  [NSDateFormatter new];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *date = [formatter dateFromString:temp];
        
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        result = [formatter stringFromDate:date];
    }
    
    self.timeLabel.text = read.intValue ==1 ?result:@"";
}

+(NSString *)identifier
{
    return @"identifier";
}
@end
