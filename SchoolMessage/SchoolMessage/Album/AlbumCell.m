//
//  AlbumCell.m
//  VXiaoYuan
//
//  Created by YanShuJ on 14-8-19.
//  Copyright (c) 2014年 XianTe. All rights reserved.
//

#import "AlbumCell.h"
#import "UIImageView+WebCache.h"
#import "RosterManager.h"
#import "FriendInfo.h"

@implementation AlbumCell
@synthesize photoImageView,nameLabel,publishLabel,numbaerLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        photoImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(4,4, 87, 87)];
        photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        photoImageView.clipsToBounds = YES;
        [self addSubview:photoImageView];
//        
//        UIImageView *signImageView = [[UIImageView alloc] initWithFrame:CGRectMake(95, 45, 10, 10)];
//        signImageView.image = [UIImage imageNamed:@"album_sign"];
//        [self addSubview:signImageView];
        
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(108,16, 200, 16)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = [UtilManager getColorWithHexString:@"#323232"];;
        nameLabel.font = [UIFont systemFontOfSize:15.0f];
        [self addSubview:nameLabel];
        
        numbaerLabel = [[UILabel alloc] initWithFrame:CGRectMake(108,60, 200, 16)];
        numbaerLabel.backgroundColor = [UIColor clearColor];
        numbaerLabel.textColor = [UtilManager getColorWithHexString:@"#8e8e8e"];;
        numbaerLabel.font = [UIFont systemFontOfSize:15.0f];
        [self addSubview:numbaerLabel];
        
        self.backgroundColor = [UIColor clearColor];
        
        publishLabel = [[UILabel alloc ] initWithFrame:CGRectMake(0,60,SCREEN_WIDTH-33, 15)];
        publishLabel.font = [UIFont systemFontOfSize:14.0f];
        publishLabel.textColor = [UtilManager getColorWithHexString:@"#323232"];
        publishLabel.backgroundColor = [UIColor clearColor];
        publishLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:publishLabel];
        
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-17.5,41,9, 12.5)];
        iv.contentMode = UIViewContentModeScaleAspectFit;
        iv.image = [UtilManager imageNamed:@"jinru"];
        [self.contentView addSubview:iv];
        
        UIView *div = [[UIView alloc] initWithFrame:CGRectMake(0,95, SCREEN_WIDTH,1.5)];
        div.backgroundColor = [UtilManager getColorWithHexString:@"#e7e7e7"];
        [self addSubview:div];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
