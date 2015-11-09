    //
//  AccountManager.m
//  SchoolMessage
//
//  Created by wulin on 15/1/27.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "AccountManager.h"
#import "LoginInfo.h"
#import "GexinSdk.h"
#import "AppDelegate.h"

@implementation AccountManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


-(void)login:(NSString *)username pwd:(NSString *)pwd callback:(void (^)(BOOL, NSString *))callback
{
    BOOL succed = NO;
    self.loginSucced = NO;
    NSString *msg =@"";
    
    if (username.length==0) {
        msg = @"请输入用户名";
        
        callback(succed,msg);
        return;
    }else if (pwd.length==0) {
        msg = @"请输入密码";
        callback(succed,msg);
         return;
    }
    username = [username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *pswd = [[UtilManager md5:[NSString stringWithFormat:@"%@%@",[pwd stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],PWDSTRING]] uppercaseString];
    NSDictionary *dic =@{@"1":username,@"2":pswd};
    [self getCloudConfig:username callback:^(BOOL s, NSDictionary *result) {
        if (s) {
            NSString *account = [[result objectForKey:S_OBJ] objectForKey:@"Account"];
            NSDictionary *accdic = @{@"1":account,@"2":pswd};
            [self requestDataOnGet:accdic ByFlag:@"100" callback:^(BOOL success, NSDictionary *data) {
                if (success) {
                    self.LoginInfos = [[LoginInfo alloc] initByLogin:[data objectForKey:@"Obj"]];
                    
                    [self setPushTag:data];
                    [self uploadClientId:[self.LoginInfos getTeacherId]];
                    [[NSUserDefaults standardUserDefaults] setValue:username forKey:USER_NAME_SAVE];
                    [[NSUserDefaults standardUserDefaults] setValue:account forKey:USER_NAME_REAL_SAVE];
                    [[NSUserDefaults standardUserDefaults] setValue:pwd forKey:[NSString stringWithFormat:@"%@--%@",USER_NAME_SAVE,username]];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [RosterManager sharedInstance].myInfo = [[FriendInfo alloc] init];
                    [RosterManager sharedInstance].myInfo.nickName = [self.LoginInfos getNickName];
                    [RosterManager sharedInstance].myInfo.headPhotoUrl = [self.LoginInfos getHeadUrl];
                    self.loginSucced = YES;
                }
                callback(success,data?[data objectForKey:@"Msg"]:@"操作失败，请检查网络");
            }];
        }else
        {
            callback(NO,@"操作失败，请检查网络");
        }
    }];
}

-(void)setPushTag:(NSDictionary *)data
{
    NSArray *temp = [[data objectForKey:@"Obj"] objectForKey:@"Biaoqian"];
    NSLog(@"temp :%@",temp);
    if (temp.count>0) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary * dic in temp) {
            [array addObject:[dic objectForKey:@"BiaoQianName"]];
        }
        NSLog(@"array :%@",array);
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (appDelegate.gexinPusher) {
            [appDelegate.gexinPusher setTags:array];
        }
    }
    
}

-(void)uploadClientId:(NSString *)accountId
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.gexinPusher) {
        NSString *ccc = [[NSUserDefaults standardUserDefaults] objectForKey:USER_CLIEND_SAVE];
        if (ccc.length>0) {
            NSDictionary *dic =@{@"1":accountId,@"2":ccc};
            [self requestDataOnPost:dic ByFlag:@"101" callback:^(BOOL result, NSDictionary *data) {
                if (result) {
                    
                }
            }];
        }
    }
}

-(NSString *)getAllClassString
{
    NSString *result = @"";
    for(NSDictionary *dic in [self.LoginInfos getTeacherClassesArray])
    {
        result = [NSString stringWithFormat:@"%@,%@",result,[dic objectForKey:S_ClASSID]];
    }
    result = result.length>0?[result substringFromIndex:1]:@"";
    
    return result;
}


-(void)reNickname:(NSString *)nickname
{
    [self.LoginInfos setNickName:nickname];
}

-(void)reHead:(NSString *)headUrl
{
    [self.LoginInfos setHeadNewUrl:headUrl];
}

@end
