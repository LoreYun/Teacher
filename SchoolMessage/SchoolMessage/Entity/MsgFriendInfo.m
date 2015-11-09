//
//  MsgFriendInfo.m
//  VXiaoYuan
//

//  Created by wulin on 14/12/14.
//  Copyright (c) 2014年 XianTe. All rights reserved.
//

#import "MsgFriendInfo.h"
#import <objc/runtime.h>

static const void * NickNameKey =&NickNameKey;

static const void * HeadUrleKey =&HeadUrleKey;

static const void * finishKey =&finishKey;

@implementation MessageModel(MsgFriendInfo)
@dynamic friendNickName;
@dynamic friendHeadUrl;
@dynamic finish;

-(NSString *)friendHeadUrl
{
    return objc_getAssociatedObject(self, HeadUrleKey);
}

-(NSString *)friendNickName
{
    return objc_getAssociatedObject(self, NickNameKey);
}

-(NSNumber *)finish
{
    return objc_getAssociatedObject(self, finishKey);
}

-(void)setFriendHeadUrl:(NSString *)friendHeadUrl
{
    objc_setAssociatedObject(self, HeadUrleKey, friendHeadUrl, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(void)setFriendNickName:(NSString *)friendNickName
{
    objc_setAssociatedObject(self, HeadUrleKey, friendNickName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(void)setFinish:(NSNumber *)finish
{
    objc_setAssociatedObject(self, finishKey, finish, OBJC_ASSOCIATION_ASSIGN);
}

@end
