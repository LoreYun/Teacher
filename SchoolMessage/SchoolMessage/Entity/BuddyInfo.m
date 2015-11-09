//
//  BuddyInfo.m
//  VXiaoYuan
//
//  Created by LI on 14-12-8.
//  Copyright (c) 2014年 XianTe. All rights reserved.
//

#import "BuddyInfo.h"

@implementation BuddyInfo

-(NSString *)getNickName
{
    NSString *nick;
    if (self.friendInfo) {
        nick = self.friendInfo.nickName;
    }
    if (!nick || nick.length==0) {
        nick = self.buddy.username;
    }
    
    return nick;
}

@end
