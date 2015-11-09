//
//  AppDelegate.h
//  SchoolMessage
//
//  Created by LI on 15-1-23.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GexinSdk.h"
#import "MainViewController.h"
#import "ApplyViewController.h"

@class HomeViewController;

typedef enum {
    SdkStatusStoped,
    SdkStatusStarting,
    SdkStatusStarted
} SdkStatus;

@interface AppDelegate : UIResponder <UIApplicationDelegate,IChatManagerDelegate,EMChatManagerBuddyDelegate,GexinSdkDelegate>

{
@private
    NSString *_deviceToken;

    EMConnectionState _connectionState;
}

@property (strong, nonatomic) UIWindow *window;


@property (strong, nonatomic) MainViewController *mainController;
@property (strong, nonatomic) HomeViewController *homeController;


@property (strong, nonatomic) GexinSdk *gexinPusher;

@property (retain, nonatomic) NSString *appKey;
@property (retain, nonatomic) NSString *appSecret;
@property (retain, nonatomic) NSString *appID;
@property (retain, nonatomic) NSString *clientId;
@property (assign, nonatomic) SdkStatus sdkStatus;
@property (strong, nonatomic) NSMutableArray *pushArray;

@property (assign, nonatomic) int lastPayloadIndex;
@property (retain, nonatomic) NSString *payloadId;

- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret;
- (void)stopSdk;

- (void)setDeviceToken:(NSString *)aToken;
- (BOOL)setTags:(NSArray *)aTag error:(NSError **)error;
- (NSString *)sendMessage:(NSData *)body error:(NSError **)error;

- (void)bindAlias:(NSString *)aAlias;
- (void)unbindAlias:(NSString *)aAlias;

@end

