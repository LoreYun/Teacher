//
//  HomeCollectionViewCell.h
//  VXiaoYuan
//
//  Created by LI on 14-12-31.
//  Copyright (c) 2014年 XianTe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) NSString        * iconName;

@property (nonatomic,strong) NSString        * iconText;

+(NSString *)identyfier;

@end
