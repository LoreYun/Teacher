//
//  AlbumAddViewController.h
//  SchoolMessage
//
//  Created by LI on 15/2/4.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "BaseVC.h"

@protocol AlbumAddDelegate <NSObject>

-(void) AlbumOnAdd:(NSDictionary *)dic;

@end

@interface AlbumAddViewController : BaseVC

@property (nonatomic,strong) NSMutableDictionary *classNameData;
@property (nonatomic,weak) id<AlbumAddDelegate> delegate;

@end
