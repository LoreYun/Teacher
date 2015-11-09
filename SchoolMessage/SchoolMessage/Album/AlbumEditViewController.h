//
//  AlbumEditViewController.h
//  SchoolMessage
//
//  Created by LI on 15/2/5.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "BaseVC.h"

@protocol AlbumOnDeleteAlbumDelegate <NSObject>

-(void)AlbumOnDelete:(NSArray *)idData;

@end

@interface AlbumEditViewController : BaseVC

@property (nonatomic,strong) NSMutableArray *photoDataSource;

@property (nonatomic,strong) NSString * albumId;

@property (nonatomic,weak) id<AlbumOnDeleteAlbumDelegate> delegate;


@end
