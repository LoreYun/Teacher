//
//  SMAlertView.m
//  SchoolMessage
//
//  Created by LI on 15/2/9.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "SMAlertView.h"

@interface SMAlertView()

@property (nonatomic,strong)UIView *alertView;

@property (nonatomic, strong) UIWindow * zoneWindow;

@end

@implementation SMAlertView

-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        [self initSelf:title message:message cancelButtonTitle:cancelButtonTitle];
    }
    return self;
}

-(void)initSelf:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle
{
    self.frame = [UIScreen mainScreen].bounds;
    
    CGFloat titleh = 17;
    CGFloat contenth = 69;
    if (title) {
        titleh = [title sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(280, MAXFLOAT)].height;
    }
    
    if (message) {
        contenth = [message sizeWithFont:[UIFont systemFontOfSize:title?14:16] constrainedToSize:CGSizeMake(260, MAXFLOAT)].height;
    }
    
    CGFloat h = 180-17-69 +titleh+contenth;
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:self.frame];
    iv.image =  [UIImage imageNamed:@"customAlertBG.png"];
    iv.userInteractionEnabled = YES;
    iv.clipsToBounds = YES;
    
    self.alertView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-280)/2,(SCREEN_HEIGHT-h)/2, 280,h)];
    self.alertView.backgroundColor = [UIColor whiteColor];

    if (title) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,9, 280, titleh)];
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.text = title;
        titleLabel.textColor = [UtilManager getColorWithHexString:@"#333333"];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.alertView addSubview:titleLabel];
    }
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,9+titleh+18, 260, contenth)];
    messageLabel.font = [UIFont systemFontOfSize:title?14:16];
    messageLabel.text = message;
    messageLabel.textColor = [UtilManager getColorWithHexString:@"#333333"];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    [self.alertView addSubview:messageLabel];
    
    self.alertView.clipsToBounds = NO;//
    
    [self addSubview:iv];
    [self addSubview:self.alertView];
    
    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
    confirm.backgroundColor = [UtilManager getColorWithHexString:@"#18b4ed"];
    [confirm setTitle:@"确定" forState:0];
    [confirm setTitleColor:[UIColor whiteColor] forState:0];
    confirm.layer.cornerRadius = 3;
    confirm.layer.masksToBounds = YES;
    [confirm addTarget:self action:@selector(onConfirm:) forControlEvents:UIControlEventTouchUpInside];
    [self.alertView addSubview:confirm];
    if (cancelButtonTitle) {
        confirm.frame = CGRectMake(150, CGRectGetMaxY(messageLabel.frame)+10, 120, 47);
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        cancel.backgroundColor = [UtilManager getColorWithHexString:@"#c0c0c0"];
        [cancel setTitle:cancelButtonTitle forState:0];
        [cancel setTitleColor:[UtilManager getColorWithHexString:@"#666666"] forState:0];
        cancel.layer.cornerRadius = 3;
        cancel.layer.masksToBounds = YES;
        [cancel addTarget:self action:@selector(onCancel:) forControlEvents:UIControlEventTouchUpInside];
        [self.alertView addSubview:cancel];
        
        cancel.frame = CGRectMake(10, CGRectGetMaxY(messageLabel.frame)+10, 120, 47);
    }else
    {
        confirm.frame = CGRectMake(10, CGRectGetMaxY(messageLabel.frame)+10, 260, 47);
    }
    
}

-(void)onConfirm:(id)sender
{
    [self hidden];
    if (self.delegate && [self.delegate respondsToSelector:@selector(SMAlertViewonConfirm:)]) {
        [self.delegate SMAlertViewonConfirm:self];
    }
}

-(void)onCancel:(id)sender
{
    [self hidden];
    if (self.delegate && [self.delegate respondsToSelector:@selector(SMAlertViewonCancel:)]) {
        [self.delegate SMAlertViewonCancel:self];
    }
}

- (void)show
{
    self.zoneWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.zoneWindow.windowLevel = UIWindowLevelStatusBar + 1;
    self.zoneWindow.opaque = NO;
    [self.zoneWindow addSubview:self];
    [self.zoneWindow makeKeyAndVisible];
    
    self.alpha = 0.0f;
    [UIView animateWithDuration:0.125 animations:^{
        self.alertView.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1.0);
        self.alpha = 0.5f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.125 animations:^{
            self.alertView.layer.transform = CATransform3DIdentity;
            self.alpha = 1.0f;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void) hide
{
    [self hidden];
}

- (void)hidden
{
    [UIView animateWithDuration:0.1 animations:^{
        self.alertView.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1.0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            self.alertView.layer.transform = CATransform3DIdentity;
            self.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self cleanup];
        }];
    }];
}

- (void)cleanup {
    self.alertView.layer.transform = CATransform3DIdentity;
    self.alertView.transform = CGAffineTransformIdentity;
    [self removeFromSuperview];
    self.zoneWindow = nil;
    // rekey main AppDelegate window
    [[[[UIApplication sharedApplication] delegate] window] makeKeyWindow];
    
}

@end
