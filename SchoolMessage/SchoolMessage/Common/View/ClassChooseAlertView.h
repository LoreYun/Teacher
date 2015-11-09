//
//  ZoneTagIntroduction.h
//  WhistleIm
//
//  Created by LI on 14-12-12.
//  Copyright (c) 2014年 Ruijie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ClassChooseAlertType) {
    ClassChoose,         // slow at beginning and end
    SujectChoose
};

@protocol ClassChooseAlertViewDalegate;
/**
 *   标签引导View
 */
@interface ClassChooseAlertView : UIView

@property (nonatomic,weak) id<ClassChooseAlertViewDalegate> delegate;

-(instancetype)initWithDic:(NSArray*)array classID:(NSString *)classId type:(ClassChooseAlertType)type;

-(void)show;

@end


@protocol ClassChooseAlertViewDalegate <NSObject>

-(void)ClassChooseOnDisMiss:(NSDictionary *)data;

@end