//
//  BuddyInfo.h
//  VXiaoYuan
//
//  Created by LI on 14-12-8.
//  Copyright (c) 2014年 XianTe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendInfo.h"

@interface BuddyInfo : NSObject

@property (nonatomic,strong) EMBuddy *buddy;

@property (nonatomic,strong) FriendInfo *friendInfo;

@property (nonatomic) BOOL finish;


-(NSString *)getNickName;

@end
