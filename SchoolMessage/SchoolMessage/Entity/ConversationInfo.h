//
//  ConversationInfo.h
//  VXiaoYuan
//
//  Created by wulin on 14/12/8.
//  Copyright (c) 2014年 XianTe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendInfo.h"
#import "GroupInfo.h"

@interface ConversationInfo : NSObject

@property (nonatomic,strong) EMConversation *conversation;

@property (nonatomic,strong) FriendInfo *friendInfo;

@property (nonatomic,strong) GroupInfo *groupInfo;


-(NSString *)getNickName;

@end
