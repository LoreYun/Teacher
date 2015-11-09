//
//  DateChooseView.h
//  WhistleActivity
//
//  Created by LI on 15/4/17.
//  Copyright (c) 2015年 ruijie. All rights reserved.
//

#import "BaseAlertView.h"

@protocol DateChooseViewDelegate;

@interface DateChooseView : BaseAlertView

@property (nonatomic,weak) id<DateChooseViewDelegate> delegate;

/**
 * 初始化默认日期
 *  @param 默认日期
 */
-(instancetype)initByDefaultDate:(NSDate *)date;

-(instancetype)initByDefaultDate:(NSDate *)date minimumDate:(NSDate *)minimumDate;

@end


@protocol DateChooseViewDelegate <NSObject>

@optional
-(void)DateChooseViewOnDismiss;

-(void)DateChooseViewOnChoose:(NSDate *)date;

-(void)DateChooseViewOnChange:(NSDate *)date;

@end
