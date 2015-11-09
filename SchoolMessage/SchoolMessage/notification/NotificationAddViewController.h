//
//  NotificationAddViewController.h
//  SchoolMessage
//
//  Created by LI on 15/2/3.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "BaseVC.h"

@protocol NotificationAddDalagate <NSObject>

-(void)NotificationOnAdd:(NSDictionary *)dic;

@end

@interface NotificationAddViewController : BaseVC

@property (nonatomic,strong) NSDictionary *classInfo;

@property (nonatomic,weak) id<NotificationAddDalagate> delegate;

@end
