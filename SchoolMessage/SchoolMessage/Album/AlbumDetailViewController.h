//
//  AlbumDetailViewController.h
//  VXiaoYuan
//
//  Created by YanShuJ on 14-8-20.
//  Copyright (c) 2014年 XianTe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

@interface AlbumDetailViewController : BaseVC

-(instancetype)initWithAlbumId:(NSString *)albumId AlbumName:(NSString *)AlbumName classInfos:(NSDictionary *)classInfos;;

@end
