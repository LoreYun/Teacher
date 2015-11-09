//
//  DateChooseView.m
//  WhistleActivity
//
//  Created by LI on 15/4/17.
//  Copyright (c) 2015年 ruijie. All rights reserved.
//

#import "DateChooseView.h"


@implementation DateChooseView
{
    UIDatePicker * _datePicker;
    NSDate      * _defaultDate;
    NSDate      * _minimumDate;
}

-(instancetype)initByDefaultDate:(NSDate *)date
{
    _defaultDate = date;
    self = [super init];
    return  self;
}
-(instancetype)initByDefaultDate:(NSDate *)date minimumDate:(NSDate *)minimumDate
{
    _defaultDate = date;
    _minimumDate = minimumDate;
    self = [super init];
    return  self;
}

-(UIView *)setUpContentView
{
    UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-240, SCREEN_WIDTH, 240)];
    alertView.backgroundColor = [UIColor whiteColor];

    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(0, 0,100, 40);
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:cancel];
    
    
    UIButton *finish = [UIButton buttonWithType:UIButtonTypeCustom];
    
    finish.frame = CGRectMake(SCREEN_WIDTH-40 - 30, 0, 70, 40);
    [finish setTitle:@"完成" forState:UIControlStateNormal];
    [finish setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [finish addTarget:self action:@selector(finish:) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:finish];

    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 200)];
    _datePicker.locale = locale;
    
    if ([_defaultDate timeIntervalSinceDate:[NSDate date]] < 0) {
        _defaultDate = [NSDate date];
    }
    _datePicker.minimumDate = [NSDate date];
    if (_defaultDate) {
        _datePicker.date = _defaultDate;
    }
    if (_minimumDate) {
        _datePicker.minimumDate = _minimumDate;
    }
    _datePicker.maximumDate = [[NSDate date] dateByAddingTimeInterval:15550000];//间隔6各月
    [_datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    [alertView addSubview:_datePicker];

    return alertView;
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint currentPoint = [gestureRecognizer locationInView:_datePicker];
    if (currentPoint.x > 0 && currentPoint.y > 0) {
        return NO;
    }
    return YES;
}
-(void)finish:(id)sender
{

    if (self.delegate && [self.delegate respondsToSelector:@selector(DateChooseViewOnChoose:)]) {
        [self.delegate DateChooseViewOnChoose:_datePicker.date];
    }
    [self hide];
}

-(void)hide
{

    if (self.delegate && [self.delegate respondsToSelector:@selector(DateChooseViewOnDismiss)]) {
        [self.delegate DateChooseViewOnDismiss];
    }
    [super hide];
}

-(void)dateChange:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(DateChooseViewOnChange:)]) {
        [self.delegate DateChooseViewOnChange:_datePicker.date];
    }
}

@end
