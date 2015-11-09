//
//  ClassChooseCell.m
//  SchoolMessage
//
//  Created by LI on 15/2/2.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "ClassChooseCell.h"

@interface ClassChooseCell ()

@property (nonatomic,strong) UILabel *gradeName;

@property (nonatomic,strong) UILabel *className;

@property (nonatomic,strong) UILabel *numberName;

@end

@implementation ClassChooseCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initViews];
    }
    
    return self;
}
+(NSString *)identifier
{
    return @"ClassChooseCell";
}

-(void)initViews
{
    self.gradeName = [[UILabel alloc] initWithFrame:CGRectMake(17,21, 140, 20)];
    self.gradeName.font = [UIFont systemFontOfSize:19];
    self.gradeName.textColor = [UtilManager getColorWithHexString:@"#333333"];
    [self addSubview:self.gradeName];
    
    self.className = [[UILabel alloc] initWithFrame:CGRectMake(17,21, 140, 20)];
    self.className.font = [UIFont systemFontOfSize:19];
    self.className.textAlignment = NSTextAlignmentCenter;
    self.className.textColor = [UtilManager getColorWithHexString:@"#333333"];
    self.className.center = CGPointMake(SCREEN_WIDTH/2,self.className.center.y);
    [self addSubview:self.className];
    
    self.numberName = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-17-140,21, 140, 20)];
    self.numberName.font = [UIFont systemFontOfSize:19];
    self.numberName.textAlignment = NSTextAlignmentRight;
    self.numberName.textColor = [UtilManager getColorWithHexString:@"#333333"];
    [self addSubview:self.numberName];
    
    UIView *div =  [[UIView alloc] initWithFrame:CGRectMake(16, 51, SCREEN_WIDTH-32, 0.5)];
    div.backgroundColor = [UtilManager getColorWithHexString:@"#8e8e8e"];
    [self addSubview:div];
}

-(void)setupViews:(NSString *)grade classString:(NSString *)classString number:(NSString *)number
{
    self.gradeName.text = grade;
    self.className.text = classString;
    self.numberName.text = number;
}

@end
