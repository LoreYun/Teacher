//
//  HomeCollectionViewCell.m
//  VXiaoYuan
//
//  Created by LI on 14-12-31.
//  Copyright (c) 2014年 XianTe. All rights reserved.
//

#import "HomeCollectionViewCell.h"

@interface HomeCollectionViewCell ()

@property (nonatomic,strong) UIImageView    * iconIv;

@property (nonatomic,strong) UILabel    * titleLabel;

@property (nonatomic,strong) UIButton    * button;

@end

@implementation HomeCollectionViewCell


+(NSString *)identyfier
{
    return @"HomeCollectionViewCell";
}

-(void)layoutSubviews
{
    if(!self.button)
    {
        self.button = [[UIButton alloc] initWithFrame:self.bounds];
        [self.button setTitleColor:[UtilManager getColorWithHexString:@"#74717a"] forState:UIControlStateNormal];
        self.button.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [self.contentView addSubview:self.button];
    }
    //50 20 //61 61
    [self.button setImage:[UtilManager imageNamed:self.iconName] forState:UIControlStateNormal];
    [self.button setImage:[UtilManager imageNamed:self.iconName] forState:UIControlStateDisabled];
    [self.button setTitle:self.iconText forState:UIControlStateNormal];
    self.button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    CGFloat offset = 10.0f;
    self.button.titleEdgeInsets = UIEdgeInsetsMake(0, -self.button.imageView.frame.size.width, -self.button.imageView.frame.size.height-offset/2, 0);
    // button.imageEdgeInsets = UIEdgeInsetsMake(-button.titleLabel.frame.size.height-offset/2, 0, 0, -button.titleLabel.frame.size.width);
    // 由于iOS8中titleLabel的size为0，用上面这样设置有问题，修改一下即可
    self.button.imageEdgeInsets = UIEdgeInsetsMake(-self.button.titleLabel.intrinsicContentSize.height-offset/2, 0, 0, -self.button.titleLabel.intrinsicContentSize.width);
    self.button.enabled = NO;
    self.backgroundColor = [UIColor clearColor];
}

@end
