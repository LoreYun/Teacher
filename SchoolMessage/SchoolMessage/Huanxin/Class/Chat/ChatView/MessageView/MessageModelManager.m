/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import "MessageModelManager.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "MessageModel.h"
#import "EaseMob.h"

@implementation MessageModelManager

+ (id)modelWithMessage:(EMMessage *)message
{
    
    NSLog(@"%@",message.ext);
    id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
    NSDictionary *userInfo = [[EaseMob sharedInstance].chatManager loginInfo];
    NSString *login = [userInfo objectForKey:kSDKUsername];
    BOOL isSender = [login isEqualToString:message.from] ? YES : NO;
    
    MessageModel *model = [[MessageModel alloc] init];
    model.isRead = message.isRead;
    model.messageBody = messageBody;
    model.message = message;
    model.type = messageBody.messageBodyType;
    model.messageId = message.messageId;
    model.isSender = isSender;
    model.isPlaying = NO;
    model.isChatGroup = message.isGroup;
    if (model.isChatGroup) {
        model.username = [message.ext valueForKey:@"renyuannicheng"];
    }
    else{
        model.username = [message.ext valueForKey:@"renyuannicheng"];
    }
    
    if (isSender) {
        NSArray *decumentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *paths = [decumentPath objectAtIndex:0];
        NSString *appFile = [paths stringByAppendingPathComponent:[@"test" stringByAppendingString:@".png"]];
        model.headImageURL =[NSURL fileURLWithPath:appFile]; //[NSURL URLWithString:[message.ext valueForKey:@"renyuannicheng"]];    //[self loadExt:login];
        model.status = message.deliveryState;
    }
    else{
        model.headImageURL = [NSURL URLWithString:[message.ext valueForKey:@"renyuantouxiang"]];
        model.status = eMessageDeliveryState_Delivered;
    }
    
    switch (messageBody.messageBodyType) {
        case eMessageBodyType_Text:
        {
            // 表情映射。
            NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
                                        convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
            model.content = didReceiveText;
        }
            break;
        case eMessageBodyType_Image:
        {
            EMImageMessageBody *imgMessageBody = (EMImageMessageBody*)messageBody;
            model.thumbnailSize = imgMessageBody.thumbnailSize;
            model.size = imgMessageBody.size;
            model.localPath = imgMessageBody.localPath;
            model.thumbnailImage = [UIImage imageWithContentsOfFile:imgMessageBody.thumbnailLocalPath];
            if (isSender)
            {
                model.image = [UIImage imageWithContentsOfFile:imgMessageBody.thumbnailLocalPath];
            }else {
                model.imageRemoteURL = [NSURL URLWithString:imgMessageBody.remotePath];
            }
        }
            break;
        case eMessageBodyType_Location:
        {
            model.address = ((EMLocationMessageBody *)messageBody).address;
            model.latitude = ((EMLocationMessageBody *)messageBody).latitude;
            model.longitude = ((EMLocationMessageBody *)messageBody).longitude;
        }
            break;
        case eMessageBodyType_Voice:
        {
            model.time = ((EMVoiceMessageBody *)messageBody).duration;
            model.chatVoice = (EMChatVoice *)((EMVoiceMessageBody *)messageBody).chatObject;
            if (message.ext) {
                NSDictionary *dict = message.ext;
                BOOL isPlayed = [[dict objectForKey:@"isPlayed"] boolValue];
                model.isPlayed = isPlayed;
            }else {
                NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@NO,@"isPlayed", nil];
                message.ext = dict;
                [[EaseMob sharedInstance].chatManager saveMessage:message];
            }
            // 本地音频路径
            model.localPath = ((EMVoiceMessageBody *)messageBody).localPath;
            model.remotePath = ((EMVoiceMessageBody *)messageBody).remotePath;
        }
            break;
        case eMessageBodyType_Video:{
            EMVideoMessageBody *videoMessageBody = (EMVideoMessageBody*)messageBody;
            model.thumbnailSize = videoMessageBody.size;
            model.size = videoMessageBody.size;
            model.localPath = videoMessageBody.thumbnailLocalPath;
            model.thumbnailImage = [UIImage imageWithContentsOfFile:videoMessageBody.thumbnailLocalPath];
            model.image = model.thumbnailImage;
        }
            break;
        default:
            break;
    }
    
    return model;
}


+(NSURL *)loadExt:(NSString *)username
{
    //第一步，创建URL
    NSURL *url = [NSURL URLWithString:rootUrl];
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSString *str = [NSString stringWithFormat:@"flag=queryHuanxinrenyuanByBianma&arg0=%@",username];//设置参数
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    //第三步，连接服务器
    NSError *error;
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSMutableDictionary *result = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"%@",result);

    
    
    
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",photoUrl,[[[result valueForKey:@"obj"] objectAtIndex:0] valueForKey:S_TOUXIANG]]];
}

@end
