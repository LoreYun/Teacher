//
//  BaseAlertView.m
//  WhistleActivity
//
//  Created by LI on 15/4/2.
//  Copyright (c) 2015年 ruijie. All rights reserved.
//

#import "BaseAlertView.h"

@implementation BaseAlertView
{
    UIView * _alertView;
    
    UIWindow * _zoneWindow;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self initViews];
    }
    
    return self;
}

-(void)initViews
{
    self.frame = [UIScreen mainScreen].bounds;
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:self.frame];
    iv.userInteractionEnabled = YES;
    iv.clipsToBounds = YES;
    iv.backgroundColor = [UIColor colorWithWhite:0 alpha:0.55f];
    
    _alertView = [self setUpContentView];
    
    _alertView.clipsToBounds = NO;//
    
    [self addSubview:iv];
    [self addSubview:_alertView];
    self.dismissEnabled = YES;
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDismiss)];
    tapGest.delegate = self;
    [self addGestureRecognizer:tapGest];
}

-(void)onDismiss
{
    if (self.dismissEnabled) {
        [self hide];
    }
}


-(UIView *)setUpContentView
{
    UIView * view = [[UIView alloc] init];
    return view;
}

- (void)show
{
    _zoneWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _zoneWindow.windowLevel = UIWindowLevelStatusBar+1;
    _zoneWindow.opaque = NO;
    [_zoneWindow addSubview:self];
    [_zoneWindow makeKeyAndVisible];
    
    self.alpha = 0.0f;
    [UIView animateWithDuration:0.125 animations:^{
        _alertView.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1.0);
        self.alpha = 0.5f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.125 animations:^{
            _alertView.layer.transform = CATransform3DIdentity;
            self.alpha = 1.0f;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)hide
{

    
    [UIView animateWithDuration:0.1 animations:^{
        _alertView.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1.0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            _alertView.layer.transform = CATransform3DIdentity;
            
            //self.backgroundColor = [UIColor redColor];
           // self.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self cleanup];
        }];
    }];
}

-(void)hideAndDismiss:(void(^)())callback
{
    [UIView animateWithDuration:0.1 animations:^{
        _alertView.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1.0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            _alertView.layer.transform = CATransform3DIdentity;
            self.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self cleanup];
            callback();
        }];
    }];
}

- (void)cleanup {
    
    _alertView.layer.transform = CATransform3DIdentity;
    _alertView.transform = CGAffineTransformIdentity;
    [_alertView removeFromSuperview];
    _alertView = nil;
    _zoneWindow = nil;
    // rekey main AppDelegate window
    [[[[UIApplication sharedApplication] delegate] window] makeKeyWindow];
}

@end
