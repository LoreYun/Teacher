//
//  ContactCell.m
//  SchoolMessage
//
//  Created by wulin on 15/2/8.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "ContactCell.h"

@interface ContactCell ()

@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation ContactCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 14, 250, 20)];
        self.titleLabel.textColor = [UtilManager getColorWithHexString:@"#333333"];
        self.titleLabel.font = [UIFont systemFontOfSize:19];
        [self addSubview:self.titleLabel];
    }
    
    return self;
}

-(void)setRelation:(NSString *)relation studentName:(NSString *)studentName
{
    if(studentName.length>0)
    {
        self.titleLabel.text = [NSString stringWithFormat: @"%@(%@)",relation,studentName];
    }else
    {
        self.titleLabel.text = relation;
    }
    
}

+(NSString *)identifier
{
    return @"ContactCell11";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
