//
//  RosterManager.h
//  VXiaoYuan
//
//  Created by wulin on 14/12/7.
//  Copyright (c) 2014年 XianTe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectManager.h"
#import "EMGroup.h"
@class  FriendInfo;
@class  GroupInfo;

@interface RosterManager :ObjectManager

@property (nonatomic,strong) FriendInfo* myInfo;

@property (nonatomic,strong) NSMutableArray *rosterData;

+ (instancetype)sharedInstance;

-(void)getFriendInfoByChatter:(NSString *)chatter callBack:(void (^)(BOOL succeed, FriendInfo *firendInfo))callBack;

-(void)getFriendInfoByChatterArray:(NSArray *)chatters callBack:(void (^)(BOOL succeed, NSArray *firendArray))callBack;

-(void)getGroupInfoByChatter:(EMGroup *)emgroup callBack:(void (^)(BOOL succeed, GroupInfo *groupInfo))callBack;

-(void)getGroupInfoNoCacheByChatter:(EMGroup *)emgroup callBack:(void (^)(BOOL succeed, GroupInfo *groupInfo))callBack;


-(void)setGroupHead:(NSString *)url groupId:(NSString *)gid groupName:(NSString *)gName callBack:(void (^)(BOOL succeed,NSDictionary *result))callback;

-(void) getPersonInfoByNickName:(NSString*)nickName callback:(void(^)(BOOL succeed,NSDictionary *result))callback;

-(NSString *)getNickName:(NSDictionary*)dic;

-(NSString *)getHeadPhotoUrl:(NSDictionary *)dic;


-(NSString*)getCodeNameByCodeId:(NSString *)CodeId;

-(void)addPublicGroup:(NSString *)groupId gName:(NSString *)gName groupOwner:(NSString *)groupOwner groupDesc:(NSString *)groupDesc callBack:(void (^)(BOOL succeed,NSDictionary *result))callback;

-(void)queryPublicGroup:(NSString *)groupId pageSize:(NSInteger)pageSize pageNum:(NSInteger)pageNum callBack:(void (^)(BOOL succeed,NSDictionary *result))callback;

-(void)deletePublicGroup:(NSString *)groupId callBack:(void (^)(BOOL succeed,NSDictionary *result))callback;

-(void)renamePublicGroup:(NSString *)groupId gName:(NSString *)gName callBack:(void (^)(BOOL succeed,NSDictionary *result))callback;

-(void)clear;

@end
