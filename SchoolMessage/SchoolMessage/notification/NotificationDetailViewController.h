//
//  NotificationDetailViewController.h
//  SchoolMessage
//
//  Created by LI on 15/2/2.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "BaseVC.h"

@interface NotificationDetailViewController : BaseVC

-(instancetype)initByClassId:(NSString *)classId detail:(NSDictionary *)dic;

@end
