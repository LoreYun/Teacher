//
//  GroupInfo.h
//  VXiaoYuan
//
//  Created by LI on 14-12-9.
//  Copyright (c) 2014年 XianTe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupInfo : NSObject

@property (nonatomic,copy) NSString * groupName;

@property (nonatomic,copy) NSString * groupHeadPhotoUrl;

@property (nonatomic,strong) EMGroup  * group;

@property (nonatomic,copy) NSString * groupId;

@property (nonatomic,copy) NSString * groupDesc;

@end
