//
//  ConversationInfo.m
//  VXiaoYuan
//
//  Created by wulin on 14/12/8.
//  Copyright (c) 2014年 XianTe. All rights reserved.
//

#import "ConversationInfo.h"

@implementation ConversationInfo


-(NSString *)getNickName
{
    NSString *nick ;
    
    if (self.friendInfo) {
        nick =  self.friendInfo.nickName;
    }
    
    if (self.groupInfo) {
        nick = self.groupInfo.groupName;
    }
    if (!nick || nick.length==0) {
        nick = self.conversation.chatter;
    }
    
    return nick;
}

@end
