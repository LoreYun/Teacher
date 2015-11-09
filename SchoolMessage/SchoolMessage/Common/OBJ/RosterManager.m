//
//  RosterManager.m
//  VXiaoYuan
//
//  Created by wulin on 14/12/7.
//  Copyright (c) 2014年 XianTe. All rights reserved.
//

#import "RosterManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "FriendInfo.h"
#import "BuddyInfo.h"
#import "GroupInfo.h"


@interface RosterManager()

@property (nonatomic,strong)NSMutableDictionary *friendInfoData;

@property (nonatomic,strong)NSDictionary *startDatas;

@end


@implementation RosterManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)getFriendInfoByChatter:(NSString *)chatter callBack:(void (^)(BOOL,FriendInfo *))callBack
{
    if (!chatter || chatter.length==0) {
        callBack(NO,nil);
        return;
    }
    FriendInfo *temp = [self.friendInfoData objectForKey:chatter];
    if (temp) {
        callBack(YES,temp);
        return;
    }
    
    __weak NSString *code = chatter;
    __weak RosterManager *rost = self;
    [self getPersonInfo:chatter callback:^(BOOL succeed, NSDictionary *responseObject) {
        if (succeed) {
            NSLog(@"JSON: %@", responseObject);
            FriendInfo *info = [[FriendInfo alloc] init];
            info.nickName = [rost getNickName:responseObject];
            if(info.nickName.length==0)info.nickName = code;
            info.headPhotoUrl = [rost getHeadPhotoUrl:responseObject];
            [rost.friendInfoData setObject:info forKey:chatter];
            info.chatter = chatter;
            callBack(YES,info);
        }else
        {
            callBack(NO,nil);
        }
    }];
}

/**
 *  获取个人信息
 */
-(void) getPersonInfo:(NSString*)chatter callback:(void(^)(BOOL succeed,NSDictionary *result))callback
{
    NSDictionary *dic =@{@"1":chatter};
    [self requestDataOnPost:dic ByFlag:@"1003" callback:callback];
}

-(void)setGroupHead:(NSString *)url groupId:(NSString *)gid groupName:(NSString *)gName callBack:(void (^)(BOOL succeed,NSDictionary *result))callback
{
    NSDictionary *dic = @{@"1":gid,@"2":url,@"3":gName};
    [self requestDataOnPost:dic ByFlag:@"1001" callback:callback];
}

-(void)getFriendInfoByChatterArray:(NSArray *)chatters callBack:(void (^)(BOOL, NSArray *))callBack
{
    NSString *chatter = @"";
    for (EMBuddy *buddy in chatters) {
        chatter = [chatter stringByAppendingFormat:@"%@,",buddy.username];
    }
    chatter = [chatter substringToIndex:chatter.length-1];
    [self getPersonInfo:chatter callback:^(BOOL succeed, NSDictionary *result) {
         NSLog(@"getPersonInfo %@",result);
        if (succeed)
        {
            NSMutableArray *array = [NSMutableArray array];
            for (EMBuddy *bd in chatters) {
                BuddyInfo *binfo = [[BuddyInfo alloc] init];
                FriendInfo *info = [[FriendInfo alloc] init];
                info.chatter = bd.username;
                info.nickName = bd.username;
                binfo.friendInfo = info;
                binfo.buddy = bd;
                for (NSDictionary *dic in [result objectForKey:S_OBJ]) {
                    if ([bd.username isEqualToString:[dic objectForKey:S_ACCOUNT]]) {
                        info.nickName = [dic objectForKey:S_NICKNAME];
                        if(!info.nickName||info.nickName.length==0)info.nickName = info.chatter;
                        info.headPhotoUrl = [NSString stringWithFormat:@"%@%@",photoUrl,[dic valueForKey:S_TOUXIANG]];
                        break;
                    }
                }
                
                FriendInfo *temp = [self.friendInfoData objectForKey:info.chatter];
                if (temp) {
                    temp.nickName     = info.nickName;
                    temp.headPhotoUrl = info.headPhotoUrl;
                }else
                {
                    [self.friendInfoData setObject:info forKey:info.chatter];
                }
                
                [array addObject:binfo];
            }
            
            callBack(YES,array);
        }else
        {
            callBack(NO,nil);
        }
       
    }];
}

-(void)getGroupInfoByChatter:(EMGroup *)emgroup callBack:(void (^)(BOOL, GroupInfo *))callBack
{
    [self getGroupInfoByChatter:emgroup cache:YES callBack:callBack];
}

-(void)getGroupInfoNoCacheByChatter:(EMGroup *)emgroup callBack:(void (^)(BOOL, GroupInfo *))callBack
{
    [self getGroupInfoByChatter:emgroup cache:NO callBack:callBack];
}

-(void)getGroupInfoByChatter:(EMGroup *)emgroup cache:(BOOL)usecache callBack:(void (^)(BOOL, GroupInfo *))callBack
{
    if (!emgroup) {
        callBack(NO,nil);
        return;
    }
    GroupInfo *temp = [self.friendInfoData objectForKey:emgroup.groupId];
    if (temp && usecache) {
        callBack(YES,temp);
        return;
    }
    __weak RosterManager *rmanager = self;
    [self getGroupInfo:emgroup.groupId callback:^(BOOL succeed, NSDictionary *responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if (succeed) {
            GroupInfo *info = [[GroupInfo alloc] init];
            info.group = emgroup;
            info.groupName = emgroup.groupSubject;
            info.groupHeadPhotoUrl = [rmanager getHeadPhotoUrl:responseObject];
            [rmanager.friendInfoData setObject:info forKey:info.group.groupId];
            callBack(YES,info);
        }else
        {
            callBack(NO,nil);
        }
        
    }];
}

-(void)addPublicGroup:(NSString *)groupId gName:(NSString *)gName groupOwner:(NSString *)groupOwner groupDesc:(NSString *)groupDesc callBack:(void (^)(BOOL, NSDictionary *))callback
{
    NSDictionary *dic =@{@"1":groupId,@"2":gName,@"3":groupOwner,@"4":groupDesc,@"5":@"2"};
    [self requestDataOnPost:dic ByFlag:@"1801" callback:callback];
}

-(void)queryPublicGroup:(NSString *)groupId pageSize:(NSInteger)pageSize pageNum:(NSInteger)pageNum callBack:(void (^)(BOOL, NSDictionary *))callback
{
    NSDictionary *dic =@{@"1":groupId,@"2":[NSNumber numberWithInteger:pageSize],@"3":[NSNumber numberWithInteger:pageNum],@"4":@"2"};
    [self requestDataOnPost:dic ByFlag:@"1802" callback:callback];
}

-(void)deletePublicGroup:(NSString *)groupId callBack:(void (^)(BOOL, NSDictionary *))callback
{
    NSDictionary *dic =@{@"1":groupId,@"4":@"2"};
    [self requestDataOnPost:dic ByFlag:@"1803" callback:callback];
}

-(void)renamePublicGroup:(NSString *)groupId gName:(NSString *)gName callBack:(void (^)(BOOL, NSDictionary *))callback
{
    NSDictionary *dic =@{@"1":groupId,@"2":gName,@"3":@"2"};
    [self requestDataOnPost:dic ByFlag:@"1804" callback:callback];
}

-(void) getPersonInfoByNickName:(NSString*)nickName callback:(void(^)(BOOL succeed,NSDictionary *result))callback
{
    NSDictionary *dic =@{@"1":nickName};
    [self requestDataOnPost:dic ByFlag:@"1004" callback:callback];
}

-(void)getGroupInfo:(NSString *)groupId callback:(void (^)(BOOL, NSDictionary *))callback
{
    NSDictionary *dic =@{@"1":groupId};
    [self requestDataOnPost:dic ByFlag:@"1002" callback:callback];
}

-(NSString *)getNickName:(NSDictionary *)dic
{
    NSArray * array = [dic valueForKey:@"Obj"];
    if (array.count==0) {
        return @"";
    }
    return [[[dic valueForKey:@"Obj"] objectAtIndex:0] valueForKey:@"NickName"];
}

-(NSString *)getCode:(NSDictionary *)dic
{
    NSArray * array = [dic valueForKey:@"Obj"];
    if (array.count==0) {
        return @"";
    }
    return [[[dic valueForKey:@"Obj"] objectAtIndex:0] valueForKey:@"Account"];
}

-(NSString *)getHeadPhotoUrl:(NSDictionary *)dic
{
    NSArray * array = [dic valueForKey:@"Obj"];
    if (array.count==0) {
        return @"";
    }
    NSString *head = [[[dic valueForKey:@"Obj"] objectAtIndex:0] valueForKey:@"Touxiang"];
    head = head.length>0?head:[[[dic valueForKey:@"Obj"] objectAtIndex:0] valueForKey:@"TouXiang"];
    return [NSString stringWithFormat:@"%@%@",photoUrl,head];
}


-(NSMutableDictionary *)friendInfoData
{
    if (!_friendInfoData) {
        _friendInfoData = [NSMutableDictionary dictionary];
    }
    
    return _friendInfoData;
}

-(NSString *)getCodeNameByCodeId:(NSString *)CodeId
{
    NSArray *array = [self.startDatas objectForKey:@"AccountType"];
    for (NSDictionary * dic in array) {
        NSString *codeId = [dic objectForKey:@"CodeId"];
        if ([CodeId isEqualToString:codeId]) {
            return [dic objectForKey:@"CodeName"];
        }
    }
    
    return @"";
}

-(void)clear
{
    self.startDatas = nil;
    [self.friendInfoData removeAllObjects];
}

@end
