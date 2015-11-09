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

#import "ChatSendHelper.h"
#import "ConvertToCommonEmoticonsHelper.h"

#import "EMCommandMessageBody.h"

@interface ChatImageOptions : NSObject<IChatImageOptions>

@property (assign, nonatomic) CGFloat compressionQuality;

@end

@implementation ChatImageOptions

@end

@implementation ChatSendHelper

+(EMMessage *)sendTextMessageWithString:(NSString *)str
                             toUsername:(NSString *)username
                            isChatGroup:(BOOL)isChatGroup
                      requireEncryption:(BOOL)requireEncryption
{
    // 表情映射。
    NSString *willSendText = [ConvertToCommonEmoticonsHelper convertToCommonEmoticons:str];
    EMChatText *text = [[EMChatText alloc] initWithText:willSendText];
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:text];
    return [self sendMessage:username messageBody:body isChatGroup:isChatGroup requireEncryption:requireEncryption];
}

+(EMMessage *)sendImageMessageWithImage:(UIImage *)image
                             toUsername:(NSString *)username
                            isChatGroup:(BOOL)isChatGroup
                      requireEncryption:(BOOL)requireEncryption
{
    EMChatImage *chatImage = [[EMChatImage alloc] initWithUIImage:image displayName:@"image.jpg"];
    id <IChatImageOptions> options = [[ChatImageOptions alloc] init];
    [options setCompressionQuality:0.6];
    [chatImage setImageOptions:options];
    EMImageMessageBody *body = [[EMImageMessageBody alloc] initWithImage:chatImage thumbnailImage:nil];
    return [self sendMessage:username messageBody:body isChatGroup:isChatGroup requireEncryption:requireEncryption];
}

+(EMMessage *)sendVoice:(EMChatVoice *)voice
             toUsername:(NSString *)username
            isChatGroup:(BOOL)isChatGroup
      requireEncryption:(BOOL)requireEncryption
{
    EMVoiceMessageBody *body = [[EMVoiceMessageBody alloc] initWithChatObject:voice];
    return [self sendMessage:username messageBody:body isChatGroup:isChatGroup requireEncryption:requireEncryption];
}

+(EMMessage *)sendVideo:(EMChatVideo *)video
             toUsername:(NSString *)username
            isChatGroup:(BOOL)isChatGroup
      requireEncryption:(BOOL)requireEncryption
{
    EMVideoMessageBody *body = [[EMVideoMessageBody alloc] initWithChatObject:video];
    return [self sendMessage:username messageBody:body isChatGroup:isChatGroup requireEncryption:requireEncryption];
}

+(EMMessage *)sendLocationLatitude:(double)latitude
                         longitude:(double)longitude
                           address:(NSString *)address
                        toUsername:(NSString *)username
                       isChatGroup:(BOOL)isChatGroup
                 requireEncryption:(BOOL)requireEncryption
{
    EMChatLocation *chatLocation = [[EMChatLocation alloc] initWithLatitude:latitude longitude:longitude address:address];
    EMLocationMessageBody *body = [[EMLocationMessageBody alloc] initWithChatObject:chatLocation];
    return [self sendMessage:username messageBody:body isChatGroup:isChatGroup requireEncryption:requireEncryption];
}

// 发送消息
+(EMMessage *)sendMessage:(NSString *)username
              messageBody:(id<IEMMessageBody>)body
              isChatGroup:(BOOL)isChatGroup
        requireEncryption:(BOOL)requireEncryption
{
    
    NSString *name= [[NSUserDefaults standardUserDefaults] valueForKey:@"name"];
    NSString *header = [[NSUserDefaults standardUserDefaults] valueForKey:@"touxiangurl"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:name forKey:@"renyuannicheng"];
    [dic setValue:header forKey:@"renyuantouxiang"];
    
    NSLog(@"%@",dic);
    
    EMMessage *retureMsg = [[EMMessage alloc] initWithReceiver:username bodies:[NSArray arrayWithObject:body]];
    retureMsg.requireEncryption = requireEncryption;
    retureMsg.isGroup = isChatGroup;
    
    retureMsg.ext = dic;
    
    
    EMMessage *message = [[EaseMob sharedInstance].chatManager asyncSendMessage:retureMsg progress:nil];
    
//    EMChatCommand *cmd = [[EMChatCommand alloc] init];
//    EMCommandMessageBody *mbody = [[EMCommandMessageBody alloc] initWithChatObject:cmd];
//    EMMessage *msg = [[EMMessage alloc] initWithReceiver:username bodies:@[mbody]];
//    EMMessage *message = [[EaseMob sharedInstance].chatManager asyncSendMessage:msg progress:nil];
    
    return message;
}

//+(NSMutableDictionary *)loadExt:(NSString *)username
//{
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    //第一步，创建URL
//    NSURL *url = [NSURL URLWithString:rootUrl];
//    //第二步，创建请求
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
//    NSString *str = [NSString stringWithFormat:@"flag=queryHuanxinrenyuanByBianma&arg0=%@",username];//设置参数
//    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
//    [request setHTTPBody:data];
//    //第三步，连接服务器
//    NSError *error;
//    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    NSMutableDictionary *result = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableLeaves error:&error];
//    NSLog(@"%@",result);
//    if ([[result valueForKey:@"obj"] count]>0)
//    {
//        [dic setValue:[NSString stringWithFormat:@"%@%@%@",photoUrl,[[[result valueForKey:@"obj"] objectAtIndex:0] valueForKey:@"lujing"],[[[result valueForKey:@"obj"] objectAtIndex:0] valueForKey:@"touxiang"]] forKey:@"renyuantouxiang"];
//        [dic setValue: [[[result valueForKey:@"obj"] objectAtIndex:0] valueForKey:@"nicheng"] forKey:@"renyuannicheng"];
//    }else
//    {
//        [dic setValue:@"" forKey:@"renyuannicheng"];
//        [dic setValue:@"" forKey:@"renyuantouxiang"];
//    }
//    
//   
//
//    
//    return dic;
//}

@end
