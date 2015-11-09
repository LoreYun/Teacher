//
//  AppDelegate.m
//  SchoolMessage
//
//  Created by LI on 15-1-23.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+EaseMob.h"
#import "LoginViewController.h"
#import "HomeViewController.h"
#import "UINavigationBar+customBar.h"

#import "MainViewController.h"

#import "MobClick.h"
#import "EMError.h"

#import "EMChatManagerDefs.h"
#import "BulletinViewController.h"

#define kAppId           @"bBgJEfYCfk8X5ZdECB5dy4"
#define kAppKey          @"oxos69nlrc64OjW0GGOqY7"
#define kAppSecret       @"OPvywZIet36Ikyk3I3qwe3"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

UIBackgroundTaskIdentifier taskID;
static BOOL isRegisterLocalNotify_ = NO;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    if (IOS7) {
        [[UINavigationBar appearance] setBarTintColor:[UtilManager getColorWithHexString:@"18b4ed"]];
    }else
    {
        [[UINavigationBar appearance] setTintColor:[UtilManager getColorWithHexString:@"18b4ed"]];
    }
    
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor whiteColor],NSForegroundColorAttributeName, [UIFont fontWithName:@ "HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil];
    
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    
    // 初始化环信SDK，详细内容在AppDelegate+EaseMob.m 文件中
    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions];
    
//#warning 如果使用MagicalRecord, 要加上这句初始化MagicalRecord
    //demo coredata, .pch中有相关头文件引用
    [MagicalRecord setupCoreDataStackWithStoreNamed:[NSString stringWithFormat:@"%@.sqlite", @"UIDemo"]];
    
    [self loginStateChange:nil];
    
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [self startSdkWith:kAppId appKey:kAppKey appSecret:kAppSecret];
    [self registerRemoteNotification];
    
    return YES;
}

- (void)registerRemoteNotification{
#if !TARGET_IPHONE_SIMULATOR
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
    
#endif
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // [EXT] 切后台关闭SDK，让SDK第一时间断线，让个推先用APN推送
    [self stopSdk];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
//#warning SDK方法调用
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // [EXT] 重新上线
    [self startSdkWith:kAppId appKey:kAppKey appSecret:kAppSecret];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userinfo
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // [4-EXT]:处理APN
    NSString *payloadMsg = [userinfo objectForKey:@"payload"];
    NSString *record = [NSString stringWithFormat:@"[APN]%@, %@", [NSDate date], payloadMsg];
    
    NSLog(@"%@",record);
    NSLog(@"sdkStatus ::%d",_sdkStatus);
    
    if (!payloadMsg) {
        return;
    }
    
    if ([self isSystemPush:[self getPushMsgType:payloadMsg]]) {
        [self.pushArray addObject:payloadMsg];
        return;
    }
    
    if (_mainController) {
        [_mainController jumpToChatList];
    }
#warning SDK方法调用
    [[EaseMob sharedInstance] application:application didReceiveRemoteNotification:userinfo];
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if (_mainController) {
        [_mainController jumpToChatList];
    }
}



#pragma mark - IChatManagerDelegate 好友变化

- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message
{
    if (!username) {
        return;
    }
    if (!message) {
        message = [NSString stringWithFormat:@"%@ 添加你为好友", username];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":username, @"username":username, @"applyMessage":message, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleFriend]}];
    [[ApplyViewController shareController] addNewApply:dic];
    if (_mainController) {
        [_mainController setupUntreatedApplyCount];
    }
}

#pragma mark - private

-(void)loginStateChange:(NSNotification *)notification
{
    
    NSLog(@"%@",notification.object);
    UINavigationController *nav = nil;
    
    //BOOL isAutoLogin = [[[EaseMob sharedInstance] chatManager] isAutoLoginEnabled];
    NSString *loginSuccess = notification.object;
    
    if ([loginSuccess isEqualToString:@"1"])
    {
        [[ApplyViewController shareController] loadDataSourceFromLocalDB];
        if (_mainController == nil) {
            _mainController = [[MainViewController alloc] init];
            nav = [[UINavigationController alloc] initWithRootViewController:_mainController];
        }else{
            nav  = _mainController.navigationController;
        }
    }else if([loginSuccess isEqualToString:@"0"]){
        _mainController = nil;
        HomeViewController *loginController = [[HomeViewController alloc] init];
        nav = [[UINavigationController alloc] initWithRootViewController:loginController];
    }else
    {
        LoginViewController * lvc = [[LoginViewController alloc] init];
        nav = [[UINavigationController alloc] initWithRootViewController:lvc];
    }
    
    self.window.rootViewController = nav;
}

#pragma mark Gexin 


- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret
{
    if (!_gexinPusher) {
        _sdkStatus = SdkStatusStoped;
        
        self.appID = appID;
        self.appKey = appKey;
        self.appSecret = appSecret;
        
        _clientId = nil;
        
        NSError *err = nil;
        _gexinPusher = [GexinSdk createSdkWithAppId:_appID
                                             appKey:_appKey
                                          appSecret:_appSecret
                                         appVersion:@"0.0.0"
                                           delegate:self
                                              error:&err];
        if (!_gexinPusher) {
//            [_viewController logMsg:[NSString stringWithFormat:@"%@", [err localizedDescription]]];
        } else {
            _sdkStatus = SdkStatusStarting;
        }
        
//        [_viewController updateStatusView:self];
    }
}

- (void)stopSdk
{
    if (_gexinPusher) {
        [_gexinPusher destroy];
        _gexinPusher = nil;
        
        _sdkStatus = SdkStatusStoped;
        
        _clientId = nil;
    }
}

- (BOOL)checkSdkInstance
{
    if (!_gexinPusher) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"SDK未启动" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return NO;
    }
    return YES;
}

- (void)setDeviceToken:(NSString *)aToken
{
    if (![self checkSdkInstance]) {
        return;
    }
    
    [_gexinPusher registerDeviceToken:aToken];
}

- (BOOL)setTags:(NSArray *)aTags error:(NSError **)error
{
    if (![self checkSdkInstance]) {
        return NO;
    }
    
    return [_gexinPusher setTags:aTags];
}

- (NSString *)sendMessage:(NSData *)body error:(NSError **)error {
    if (![self checkSdkInstance]) {
        return nil;
    }
    
    return [_gexinPusher sendMessage:body error:error];
}

- (void)bindAlias:(NSString *)aAlias {
    if (![self checkSdkInstance]) {
        return;
    }
    
    return [_gexinPusher bindAlias:aAlias];
}

- (void)unbindAlias:(NSString *)aAlias {
    if (![self checkSdkInstance]) {
        return;
    }
    
    return [_gexinPusher unbindAlias:aAlias];
}

#pragma mark - GexinSdkDelegate
- (void)GexinSdkDidRegisterClient:(NSString *)clientId
{
    // [4-EXT-1]: 个推SDK已注册
    _sdkStatus = SdkStatusStarted;
    _clientId = clientId;
    
    if (clientId.length>0) {
        [[NSUserDefaults standardUserDefaults] setObject:clientId forKey:USER_CLIEND_SAVE];
    }
    
    //    [self stopSdk];
}

- (void)GexinSdkDidReceivePayload:(NSString *)payloadId fromApplication:(NSString *)appId
{
    // [4]: 收到个推消息
    _payloadId = payloadId;
    
    NSData *payload = [_gexinPusher retrivePayloadById:payloadId];
    NSString *payloadMsg = nil;
    if (payload) {
        payloadMsg = [[NSString alloc] initWithBytes:payload.bytes
                                              length:payload.length
                                            encoding:NSUTF8StringEncoding];
        [self pushVCByData:payloadMsg];
    }
//    NSString *record = [NSString stringWithFormat:@"%d, %@, %@", ++_lastPaylodIndex, [NSDate date], payloadMsg];
//    [_viewController logMsg:record];
//    [payloadMsg release];
}

- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    // [EXT]:通知SDK运行状态
    _sdkStatus = aStatus;
}


-(void)pushVCByData:(NSString *)payloadMsg
{
    UINavigationController *root = (UINavigationController *)self.window.rootViewController;
    NSLog(@"self.window.rootViewController %@",root.viewControllers.firstObject);
    
    if([root.viewControllers.firstObject isKindOfClass:[LoginViewController class]] || !self.window || !self.window.rootViewController)
    {
        return;
    }
    if ([self isFromRemoat:payloadMsg]) {
        
        [self removeData:payloadMsg];
    }else
    {
        AudioServicesPlaySystemSound(1007); //系统的通知声音
    }
    
    payloadMsg = [self getPushMsgType:payloadMsg];
    if (!payloadMsg || payloadMsg.length==0) {
        return;
    }
    
    
    if([payloadMsg isEqualToString:@"校园公告"] && ![root.viewControllers.lastObject isKindOfClass:[BulletinViewController class]])
    {
        BulletinViewController *vc = [BulletinViewController new];
        [root pushViewController:vc animated:NO];
    }
}

-(BOOL)isSystemPush:(NSString *)payloadMsg
{
    return [payloadMsg isEqualToString:@"校园公告"];
}


-(NSString *)getPushMsgType:(NSString *)payloadMsg
{
    return [payloadMsg componentsSeparatedByString:@"@`"].count>0?[[payloadMsg componentsSeparatedByString:@"@`"] objectAtIndex:0]:@"";
}

-(BOOL)isFromRemoat:(NSString *)payloadMsg
{
    for (NSString *msg  in self.pushArray) {
        if ([payloadMsg isEqualToString:msg]) {
            return YES;
        }
    }
    return NO;
}

-(void)removeData:(NSString *)payloadMsg
{
    for (NSInteger i = self.pushArray.count-1; i>=0; i--) {
        NSString *msg = [self.pushArray objectAtIndex:i];
        if ([payloadMsg isEqualToString:msg]) {
            [self.pushArray removeObjectAtIndex:i];
            break;
        }
    }
}



- (void)GexinSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // [4-EXT]:发送上行消息结果反馈
    NSString *record = [NSString stringWithFormat:@"Received sendmessage:%@ result:%d", messageId, result];
}

- (void)GexinSdkDidOccurError:(NSError *)error
{
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
//    [_viewController logMsg:[NSString stringWithFormat:@">>>[GexinSdk error]:%@", [error localizedDescription]]];
}

-(NSMutableArray *)pushArray
{
    if (!_pushArray) {
        _pushArray = [NSMutableArray array];
    }
    
    return _pushArray;
}


@end
