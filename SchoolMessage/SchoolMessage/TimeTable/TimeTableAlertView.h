//
//  ZoneTagIntroduction.h
//  WhistleIm
//
//  Created by LI on 14-12-12.
//  Copyright (c) 2014年 Ruijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimeTableAlertViewDalegate;
/**
 *   标签引导View
 */
@interface TimeTableAlertViewView : UIView

@property (nonatomic,weak) id<TimeTableAlertViewDalegate> delegate;

-(instancetype)initWithDic:(NSDictionary*)data;

-(void)show;

@end


@protocol TimeTableAlertViewDalegate <NSObject>

-(void)TimeTableOnDisMiss:(NSDictionary *)data;

@end