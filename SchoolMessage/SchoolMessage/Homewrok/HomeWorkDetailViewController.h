//
//  HomeWorkDetailViewController.h
//  SchoolMessage
//
//  Created by wulin on 15/2/10.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "BaseVC.h"

@protocol HomeWrokDeleteDalegate <NSObject>

-(void)HomeWrokDelete:(NSString *)homeworkId;

@end

@interface HomeWorkDetailViewController : BaseVC

@property (nonatomic,strong) NSDictionary *homeWorkInfo;

@property (nonatomic,weak) id<HomeWrokDeleteDalegate> delegate;

@end
