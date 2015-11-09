//
//  NetworkManager.m
//  VXiaoYuan
//
//  Created by wulin on 14/12/14.
//  Copyright (c) 2014年 XianTe. All rights reserved.
//

#import "NetworkManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "UtilManager.h"
#import "RosterManager.h"
#import "FriendInfo.h"
#import "DataAccess.h"

#define DEVICE @"ios"

#define DEVICE_CODE @"ping"

#define DIV @"@`"

#define MIDDLE_CODE @"0"

#define END_CODE @"-1"

#define VERSION  [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] stringByReplacingOccurrencesOfString:@"." withString:@""]

#define FLAG @"flag"

#define FLAG_LOGIN @"yonghuLogin"

#define FLAG_GET_VERSION @"getBanbenInfo"

#define FLAG_GET_FRIEND_INFO @"queryHuanxinrenyuanByBianma"

#define FLAG_GET_MY_CONTACTS @"queryGaoxiaoInfoLiuyan"

#define FLAG_GET_MY_CONTACTS_LIST @"queryJiaoshiInfoLiuyan_1"

#define FLAG_GET_NEWS_V13 @"queryXinwen_V13"

#define FLAG_GET_NEWS @"queryXinwen"

#define FLAG_GET_NOTICE_LIST @"queryGonggao"

#define FLAG_GET_INBOX_LIST @"getLiuyanShou"

#define FLAG_GET_OUTBOX_LIST @"getLiuyanFa"

#define FLAG_DELETE_INBOX @"setLiuyanDelShou"

#define FLAG_DELETE_OUTBOX @"setLiuyanDelFa"

#define FLAG_SEND_EMAIL @"saveLiuyan_1"

#define FLAG_GET_ACTIVITY_ESSENCE @"queryHuodongJx"

#define FLAG_GET_ACTIVITY_NORMAL @"queryHuodong_V13"

#define FLAG_CREATE_ACTIVITY_NORMAL @"addHuodongbuluo_V13"

#define FLAG_GET_PERSON_INFO @"queryHuanxinrenyuanByBianma"

#define FLAG_GET_PERSON_INFO_NICK @"queryHuanxinrenyuanByNicheng"

#define FLAG_GET_GROUP_INFO @"queryHuanxinqunzuByQzId"

#define FLAG_GET_CLASS_ALBUM @"queryXiangceMuluAndMx"

#define FLAG_GET_CLASS_ALBUM_DETIAL @"getXiangcemingxiBymulu"

#define FLAG_GET_ACTIVITY_MEMBERS @"queryBuluoChengyuan"

#define FLAG_JION_ACTIVITY @"jiarubuluo"

#define FLAG_EXIT_ACTIVITY @"tuichubuluo"

#define FLAG_ADD_PHOTO_TO_CLASS_ALBUM @"addXiangcemingxi_V13"

#define FLAG_ADD_CLASS_ALBUM @"addXiangcemulu"

#define FLAG_GET_PWD_QUESTION @"wangjiMima"

#define FLAG_UPDATE_TELEPHONE @"updateShoujihao"

#define FLAG_RWSET_PWD @"updatePwd"

@implementation NetworkManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

//-(void)loggin:(NSString *)userName pwd:(NSString *)password callback:(void (^)(BOOL, NSDictionary *))callback
//{
//    NSDictionary *parameters = @{@"b":userName,@"c":password};
//    [self requestDataOnPost:parameters ByFlag:FLAG_LOGIN callback:callback];
//    
//    
//}
//
//-(void)getCurrentNewVersion:(void (^)(BOOL, NSDictionary *))callback
//{
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setValue:@"pingguo " forKey:@"arg0"];
//    [self requestDataOnPost:dic ByFlag:FLAG_GET_VERSION callback:callback];
//}
//
//-(void)getPwdQuestion:(NSString *)chatter callback:(void (^)(BOOL, NSDictionary *))callback
//{
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setValue:chatter forKey:@"arg0"];
//    [self requestDataOnPost:dic ByFlag:FLAG_GET_PWD_QUESTION callback:callback];
//}
//
//-(void)getMyHighSchoolMembersInfo:(void(^)(BOOL succeed,NSDictionary *result))callback;
//{
//    FriendInfo *info = [RosterManager sharedInstance].myInfo;
//    NSDictionary *parameters = @{@"b":[info getLevelName],@"c":[info getLevelId]};
//    [self requestDataOnPost:parameters ByFlag:FLAG_GET_MY_CONTACTS callback:callback];
//}
//
//-(void)getMyHighSchoolMembersInfoList:(NSString *)type contactId:(NSString *)contactId level:(NSString*)level callback:(void(^)(BOOL succeed,NSDictionary *result))callback
//{
//    NSDictionary *parameters = @{@"b":type,@"c":contactId,@"d":level};
//    [self requestDataOnPost:parameters ByFlag:FLAG_GET_MY_CONTACTS_LIST callback:callback];
//}
//
//-(void)getNewsList:(NSInteger)pageNumber callback:(void (^)(BOOL, NSDictionary *))callback
//{
//    FriendInfo *info = [RosterManager sharedInstance].myInfo;
//    NSString *page = [NSString stringWithFormat:@"%ld",(long)pageNumber];
//    NSString *levelName = [info getLevelName];
//    NSString *lid = [info getLevelId];
//    if ( ![levelName isEqualToString:V_JIAOWEI] && ![levelName isEqualToString:V_GAOXIAO]) {
//        levelName = V_YUANXI;
//        lid = [RosterManager sharedInstance].myInfo.yuanxiid;
//    }
//    
//    NSDictionary *dic =@{@"a":levelName,@"b":lid,@"c":@"10",@"d":page};
//    [self requestDataOnPost:dic ByFlag:FLAG_GET_NEWS_V13 callback:callback];
//}
//
//-(void)getActivityEssenceList:(NSInteger)pageNumber callback:(void (^)(BOOL, NSDictionary *))callback
//{
//    NSString *page = [NSString stringWithFormat:@"%ld",(long)pageNumber];
//    NSDictionary *dic =@{@"arg0":@"2",@"arg1":[RosterManager sharedInstance].myInfo.xuexiaoid,@"arg2":@"10",@"arg3":page};
//    [self requestDataOnPost:dic ByFlag:FLAG_GET_ACTIVITY_ESSENCE callback:callback];
//}
//
//-(void)getActivityEssenceAD:(void (^)(BOOL, NSDictionary *))callback
//{
//    NSDictionary *dic =@{@"arg0":@"1",@"arg1":[RosterManager sharedInstance].myInfo.xuexiaoid,@"arg2":@"5",@"arg3":@"1"};
//    [self requestDataOnPost:dic ByFlag:FLAG_GET_ACTIVITY_ESSENCE callback:callback];
//}
//
//-(void)getActivityNorList:(NSInteger)pageNumber type:(NSString *)type callback:(void (^)(BOOL, NSDictionary *))callback
//{
//    NSString *lid = [[RosterManager sharedInstance].myInfo.leixing isEqualToString:V_XUESHENG]?[RosterManager sharedInstance].myInfo.banjiid:[[RosterManager sharedInstance].myInfo getLevelId];
//    
//    NSString *lname = [[RosterManager sharedInstance].myInfo getLevelName];
//    if ([[RosterManager sharedInstance].myInfo.leixing isEqualToString:V_XUESHENG]) {
//        lname=  V_BANJI;
//    }
//    
//    NSDictionary *dic =@{@"arg0":lname,@"arg1":lid,@"arg2":[RosterManager sharedInstance].myInfo.leixing,@"arg3":@"1",@"arg4":type,@"arg5":[RosterManager sharedInstance].myInfo.gaoxiaoid,@"arg6":@"10",@"arg7":[NSString stringWithFormat:@"%ld",(long)pageNumber]};
//    [self requestDataOnPost:dic ByFlag:FLAG_GET_ACTIVITY_NORMAL callback:callback];
//}
//
//-(void) getActivityCheckedList:(NSInteger)pageNumber type:(NSString *)tname callback:(void (^)(BOOL, NSDictionary *))callback
//{
//    NSString *page = [NSString stringWithFormat:@"%ld",(long)pageNumber];
//    NSDictionary *dic =@{@"arg0":[[RosterManager sharedInstance].myInfo getLevelName],@"arg1":V_BANJI,@"arg2":[RosterManager sharedInstance].myInfo.leixing,@"arg3":@"0",@"arg4":tname,@"arg5":@"10",@"arg6":page};
//    [self requestDataOnPost:dic ByFlag:FLAG_GET_ACTIVITY_ESSENCE callback:callback];
//}
//
//-(void)getActivityEnrollInfo:(NSString *)acId pageNumber:(NSInteger)pageNumber callback:(void (^)(BOOL, NSDictionary *))callback
//{
//    NSString *page = [NSString stringWithFormat:@"%ld",(long)pageNumber];
//    NSDictionary *dic =@{@"1":acId,@"2":@"100",@"3":page};
//    [self requestDataOnPost:dic ByFlag:FLAG_GET_ACTIVITY_MEMBERS callback:callback];
//}
//
//-(void)createdActivity:(NSString *)title content:(NSString *)content fileName:(NSString *)fileName endTime:(NSString *)endTime acType:(NSString *)acType callback:(void (^)(BOOL, NSDictionary *))callback
//{
//    FriendInfo *my = [RosterManager sharedInstance].myInfo;
//    NSString *banjiid = my.banjiid;
//    if ([my.leixing isEqualToString:V_FUDAOYUAN]||[my.leixing isEqualToString:V_JIAOSHI]) {
//        banjiid = @"0";
//    }
//    
//    
//    NSDictionary *dic =@{@"0":my.leixing,@"1":my.chatter,
//                         @"2":title,@"3":content,@"4":fileName,@"5":endTime,
//                         @"6":acType,@"7":banjiid,@"8":my.yuanxiid,@"9":my.xuexiaoid,@"10":my.jiaoweiid,@"11":my.gaoxiaoid};
//
//    [self requestDataOnPost:dic ByFlag:FLAG_CREATE_ACTIVITY_NORMAL callback:callback];
//}
//
//-(void)joinActivity:(NSString *)acId callback:(void (^)(BOOL, NSDictionary *))callback
//{
//    NSDictionary *dic =@{@"1":[RosterManager sharedInstance].myInfo.chatter,@"2":acId};
//    [self requestDataOnPost:dic ByFlag:FLAG_JION_ACTIVITY callback:callback];
//}
//
//-(void)exitActivity:(NSString *)acId callback:(void (^)(BOOL, NSDictionary *))callback
//{
//    NSDictionary *dic =@{@"1":[RosterManager sharedInstance].myInfo.chatter,@"2":acId};
//    [self requestDataOnPost:dic ByFlag:FLAG_EXIT_ACTIVITY callback:callback];
//
//}
//
//-(void)getNoticeList:(void (^)(BOOL, NSDictionary *))callback
//{
//    NSDictionary *dic =@{@"arg0":[RosterManager sharedInstance].myInfo.chatter};
//    [self requestDataOnPost:dic ByFlag:FLAG_GET_NOTICE_LIST callback:callback];
//}
//
//-(void)getInboxList:(void (^)(BOOL, NSDictionary *))callback
//{
//    NSDictionary *dic =@{@"arg0":[RosterManager sharedInstance].myInfo.getLevelCode};
//    [self requestDataOnPost:dic ByFlag:FLAG_GET_INBOX_LIST callback:callback];
//}
//
//-(void)getOutboxList:(void (^)(BOOL, NSDictionary *))callback
//{
//    NSDictionary *dic =@{@"arg0":[RosterManager sharedInstance].myInfo.getLevelCode};
//    [self requestDataOnPost:dic ByFlag:FLAG_GET_OUTBOX_LIST callback:callback];
//}
//
//-(void)deleteInboxById:(NSString *)outboxId callback:(void (^)(BOOL, NSDictionary *))callback
//{
//    NSDictionary *dic =@{@"delid":outboxId};
//    [self requestDataOnPost:dic ByFlag:FLAG_DELETE_INBOX callback:callback];
//}
//
//-(void)deleteOutboxById:(NSString *)outboxId callback:(void (^)(BOOL, NSDictionary *))callback
//{
//    NSDictionary *dic =@{@"delid":outboxId};
//    [self requestDataOnPost:dic ByFlag:FLAG_DELETE_OUTBOX callback:callback];
//
//}
//
//-(void)sendEmail:(NSString *)code name:(NSString *)name title:(NSString *)title content:(NSString *)content typeId:(NSString *)typeId typeName:(NSString *)typeName psotType:(NSString *)postType faleName:(NSString *)fileName recieveCode:(NSString *)recieveCode recieveName:(NSString *)recieveName realFileName:(NSString *)realFileName callback:(void (^)(BOOL, NSDictionary *))callback
//{
//    NSDictionary *dic =@{@"1":code,@"2":name,@"3":title,@"4":content,@"5":typeId,@"6":postType,@"7":code,@"8":fileName,@"9":recieveCode,@"10":recieveName,@"11":realFileName};
//    [self requestDataOnPost:dic ByFlag:FLAG_SEND_EMAIL callback:callback];
//}
//
//
//-(void)getPersonInfo:(NSString *)chatter callback:(void (^)(BOOL, NSDictionary *))callback
//{
//    NSDictionary *dic =@{@"1":chatter};
//    [self requestDataOnPost:dic ByFlag:FLAG_GET_PERSON_INFO callback:callback];
//}
//
//-(void) getPersonInfoByNickName:(NSString*)nickName callback:(void(^)(BOOL succeed,NSDictionary *result))callback
//{
//    NSDictionary *dic =@{@"1":nickName};
//    [self requestDataOnPost:dic ByFlag:FLAG_GET_PERSON_INFO_NICK callback:callback];
//}
//
//-(void)getGroupInfo:(NSString *)groupId callback:(void (^)(BOOL, NSDictionary *))callback
//{
//    NSDictionary *dic =@{@"1":groupId};
//    [self requestDataOnPost:dic ByFlag:FLAG_GET_GROUP_INFO callback:callback];
//}
//
//
//-(void)getClassAlbum:(NSInteger)pageNumber callback:(void (^)(BOOL, NSDictionary *))callback
//{
//    NSString *page = [NSString stringWithFormat:@"%ld",(long)pageNumber];
//    FriendInfo *my = [RosterManager sharedInstance].myInfo;
//    NSString *jiaoweiId = my.jiaoweiid;
//    NSString *xuexiaoId = my.xuexiaoid;
//    NSString *yuanxiId = my.yuanxiid;
//    NSString *banjiId = @"";
//    if ([my.leixing isEqualToString:V_JIAOWEI]) {
//        xuexiaoId= @"-1";
//        yuanxiId= @"-1";
//    }
//    if ([my.leixing isEqualToString:@"xuexiao"]) {
//        xuexiaoId= @"-1";
//    }
//    
//    if (![my.leixing isEqualToString:V_JIAOWEI] &&![my.leixing isEqualToString:@"xuexiao"]&&  ![my.leixing isEqualToString:V_YUANXI]) {
//        banjiId= my.banjiid;
//    }
//    
//    NSDictionary *didddd =@{@"1":jiaoweiId,@"2":xuexiaoId,@"3":yuanxiId,@"4":banjiId,@"5":@"10",@"6":page};
//    [self requestDataOnPost:didddd ByFlag:FLAG_GET_CLASS_ALBUM callback:callback];
//}
//
//-(void)getClassAlbumDetailInfo:(NSString *)albumId classId:(NSString *)classId callback:(void (^)(BOOL, NSDictionary *))callback
//{
//    NSDictionary *didddd =@{@"1":albumId,@"2":classId,@"3":@"100",@"4":@"1"};
//    [self requestDataOnPost:didddd ByFlag:FLAG_GET_CLASS_ALBUM_DETIAL callback:callback];
//
//}
//
//-(void)AddClassAlbum:(NSString *)AlbumName callback:(void (^)(BOOL, NSDictionary *))callback
//{
//    NSDictionary *didddd =@{@"1":[RosterManager sharedInstance].myInfo.yonghuid,@"2":[RosterManager sharedInstance].myInfo.banjiid,@"3":[RosterManager sharedInstance].myInfo.yuanxiid,@"4":[RosterManager sharedInstance].myInfo.xuexiaoid,@"5":[RosterManager sharedInstance].myInfo.jiaoweiid,@"6":AlbumName};
//    [self requestDataOnPost:didddd ByFlag:FLAG_ADD_CLASS_ALBUM callback:callback];
//}
//
//-(void)AddClassPhoto:(NSString *)realFileName url:(NSString *)url albumID:(NSString *)albumID photoDetail:(NSString *)detail callback:(void (^)(BOOL, NSDictionary *))callback
//{
//    NSDictionary *didddd = @{@"1":[RosterManager sharedInstance].myInfo.yonghuid,@"2":[RosterManager sharedInstance].myInfo.banjiid,@"3":realFileName,@"4":url,@"5":albumID,@"6":detail};
//    [self requestDataOnPost:didddd ByFlag:FLAG_ADD_PHOTO_TO_CLASS_ALBUM callback:callback];
//}
//
//-(void)updateTelephone:(NSString *)number callback:(void (^)(BOOL, NSDictionary *))callback
//{
//    NSDictionary *dic = @{@"1":[RosterManager sharedInstance].myInfo.leixing,@"2":[RosterManager sharedInstance].myInfo.yonghuid,@"3":number};
//    
//    [self requestDataOnPost:dic ByFlag:FLAG_UPDATE_TELEPHONE callback:callback];
//}
//
//-(void)resetPwd:(NSString *)oldPwd newPwd:(NSString *)newPwd callback:(void (^)(BOOL, NSDictionary *))callback
//{
//    NSDictionary *dic = @{@"1":[RosterManager sharedInstance].myInfo.chatter,@"2":oldPwd,@"3":newPwd,@"4":[RosterManager sharedInstance].myInfo.leixing};
//    
//    [self requestDataOnPost:dic ByFlag:FLAG_RWSET_PWD callback:callback];
//}
//
//-(void)feedBack:(NSString *)content type:(NSString *)type callback:(void (^)(BOOL, NSDictionary *))callback
//{
//    NSDictionary *dic = @{@"1":[RosterManager sharedInstance].myInfo.yonghuid,@"2":content,@"3":type};
//    
//    [self requestDataOnPost:dic ByFlag:@"addFankui" callback:callback];
//}
//
//-(void)initPwdInfo:(NSString *)question answer:(NSString *)answer telePhone:(NSString *)number newPwd:(NSString *)pwd callback:(void (^)(BOOL, NSDictionary *))callback
//{
//    NSDictionary *dic = @{@"1":[RosterManager sharedInstance].myInfo.chatter,@"2":question,@"3":answer,@"4":[RosterManager sharedInstance].myInfo.leixing,@"5":pwd,@"6":number};
//    
//    [self requestDataOnPost:dic ByFlag:@"addMimaxinxi_1" callback:callback];
//}
//
//-(void)getClassNameById:(NSString *)classid callback:(void (^)(BOOL, NSDictionary *))callback
//{
//    NSDictionary *dic = @{@"1":classid};
//    
//    [self requestDataOnPost:dic ByFlag:@"querySingleGaoxiaoInfo" callback:callback];
//}
//
//#pragma mark request method
//-(void)requestDataOnPost:(NSDictionary *)data ByFlag:(NSString *)flag callback:(void (^)(BOOL, NSDictionary *))callback
//{
//    NSString *time = [NSString stringWithFormat:@"%d",(int)[[NSDate date] timeIntervalSince1970]];
//    NSString *bparam = [[NetworkManager sharedInstance] Encode2B:data time:time flag:flag];
//    NSString *cparam = [[NetworkManager sharedInstance] Encode2C:data time:time flag:flag];
//    NSDictionary *parameters = @{@"b":bparam,@"c":cparam};
////    NSLog(@"result b %@  c %@",bparam,cparam);
//    [self requestDataOnPost:parameters callback:callback];
//}
//
//-(void)requestDataOnPost:(NSDictionary *)parameters callback:(void (^)(BOOL, NSDictionary *))cb
//{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    manager.requestSerializer.timeoutInterval = 10;
//    [manager POST:rootUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *dic = responseObject;
//        cb(YES,dic);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        cb(NO,nil);
//    }];
//}
//
//-(NSString *)Encode2B:(NSDictionary *)dic time:(NSString *)time flag:(NSString *)flag
//{
//    NSString *name = [RosterManager sharedInstance].myInfo.chatter?[RosterManager sharedInstance].myInfo.chatter:@"";
//    
//    NSString *result = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@",flag,DIV,name,DIV,time,DIV,DEVICE,DIV,VERSION,DIV,MIDDLE_CODE];
//    
////    for (int i = 0; i<dic.allKeys; i++) {
////        i
////    }
//    NSArray *sortedArray = [[dic allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//        
//        return [obj1 compare:obj2 options:NSNumericSearch];
//    }];
//    for (NSString* key in sortedArray) {
//        result = [NSString stringWithFormat:@"%@%@%@",result,DIV,[dic objectForKey:key]];
//    }
//    
//    result = [NSString stringWithFormat:@"%@%@%@",result,DIV,END_CODE];
//    
////    NSLog(@"Encode2B:%@",result);
//    return __BASE64(result);
//}
//
//-(NSString *)Encode2C:(NSDictionary *)dic time:(NSString *)time flag:(NSString *)flag
//{
//    int number = (time.intValue %100000 & 0xfff)*99;
//    time = [NSString stringWithFormat:@"%d",number];
//    NSString *name = [RosterManager sharedInstance].myInfo.chatter?[RosterManager sharedInstance].myInfo.chatter:@"";
//    NSString *result = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@",DEVICE_CODE,flag,DIV,name,DIV,time,DIV,DEVICE,DIV,VERSION,DIV,MIDDLE_CODE];
//    
//    NSArray *sortedArray = [[dic allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//        
//        return [obj1 compare:obj2 options:NSNumericSearch];
//    }];
//    for (NSString* key in sortedArray) {
//        result = [NSString stringWithFormat:@"%@%@%@",result,DIV,[dic objectForKey:key]];
//    }
//    
//    result = [NSString stringWithFormat:@"%@%@%@",result,DIV,END_CODE];
////    NSLog(@"Encode2C:%@",result);
//    return __MD5(result);
//}
//
//-(void)uploadImage2Server:(NSData *)data callback:(void (^)(BOOL, NSDictionary *))callback
//{
//    NSURL *url = [NSURL URLWithString:uploadImageUrl];
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    
//    [manager POST:uploadImageUrl parameters:@{@"flag":@"123"} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileData:data name:@"img" fileName:@"1234567.jpeg" mimeType:@"image/jpeg"];
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        callback(YES,responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        callback(YES,nil);
//    }];
//}




@end

