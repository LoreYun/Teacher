//
//  NotificationCell.h
//  SchoolMessage
//
//  Created by LI on 15/2/5.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationCell : UITableViewCell

-(void)setupNotificationViews:(NSDictionary *)dic;

+(NSString *)identifier;

@end
