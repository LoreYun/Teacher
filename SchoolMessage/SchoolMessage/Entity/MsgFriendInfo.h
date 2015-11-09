//
//  MsgFriendInfo.h
//  VXiaoYuan
//
//  Created by wulin on 14/12/14.
//  Copyright (c) 2014年 XianTe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageModel.h"

@interface MessageModel (MsgFriendInfo)

@property(nonatomic,copy) NSString * friendNickName;

@property(nonatomic,copy) NSString * friendHeadUrl;

/**
 * 获取完成好友信息的标识
 */
@property(nonatomic) NSNumber* finish;

@end
