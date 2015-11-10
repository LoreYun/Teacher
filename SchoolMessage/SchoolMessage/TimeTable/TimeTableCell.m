//
//  TimeTableCell.m
//  SchoolMessage
//
//  Created by LI on 15/2/9.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "TimeTableCell.h"

static NSString *iden = @"TimeTableCell.h";

@interface TimeTableCell ()

@property (nonatomic,strong) UIButton *titleLabel;

@end

@implementation TimeTableCell

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self initViews];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initViews];
    }
    
    return self;
}

-(void)initViews
{
    self.layer.shouldRasterize    = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    CGFloat w =(SCREEN_WIDTH-10.0f)/8.0f;
    CGFloat h = w /85.0f *139.0f;
    self.titleLabel = [[UIButton alloc] initWithFrame:CGRectMake(2.5, 5.5, w-5, h-11)];
    self.titleLabel.layer.cornerRadius = 6.5;
    self.titleLabel.layer.masksToBounds = YES;
    self.titleLabel.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.backgroundColor = [UtilManager getColorWithHexString:@"#18b4ed"];
    self.titleLabel.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.enabled = NO;
    self.titleLabel.titleEdgeInsets = UIEdgeInsetsMake(self.titleLabel.titleEdgeInsets.top, (w-5-15)/2, self.titleLabel.titleEdgeInsets.bottom, (w-5-15)/2);
    self.titleLabel.titleLabel.numberOfLines =2;
//    self.titleLabel
    
    
    [self.contentView addSubview:self.titleLabel];
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = [UtilManager getColorWithHexString:@"#aaaaaa"].CGColor;
    self.layer.borderWidth = 0.5;
}

-(void)setContent:(NSString *)content color:(NSString *)webColor
{
//    self.titleLabel.text = content;
    [self.titleLabel setTitle:content forState:0];
    [self.titleLabel setTitleColor:[UtilManager getColorWithHexString:webColor] forState:0];
    self.titleLabel.backgroundColor = [UtilManager getColorWithHexString:@"#18b4ed"];
}

-(void)setBlankContent:(NSString *)number
{
//    self.titleLabel.text = number;
    [self.titleLabel setTitle:number forState:0];
    [self.titleLabel setTitleColor:[UtilManager getColorWithHexString:@"#333333"] forState:0];
    self.titleLabel.backgroundColor = [UIColor whiteColor];
///
}

+(NSString *)identifier
{
    return iden;
}
@end
