//
//  ContactDeleteAlertView.m
//  SchoolMessage
//
//  Created by LI on 15/2/11.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "ContactDeleteAlertView.h"

@interface ContactDeleteAlertView ()

@property (nonatomic,strong)UIView *alertView;

@property (nonatomic, strong) UIWindow * zoneWindow;

@end

@implementation ContactDeleteAlertView

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self initSelf];
    }
    return self;
}


-(void)initSelf
{
    self.frame = [UIScreen mainScreen].bounds;
    CGFloat h = 148;
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:self.frame];
    iv.image =  [UIImage imageNamed:@"customAlertBG.png"];
    iv.userInteractionEnabled = YES;
    iv.clipsToBounds = YES;
    
    self.alertView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-300)/2,(SCREEN_HEIGHT-h)/2, 280,h)];
    self.alertView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,9, 280, 17)];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.text = @"删除后您将不再拥有此联系人信息！";
    titleLabel.textColor = [UtilManager getColorWithHexString:@"#333333"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.alertView addSubview:titleLabel];
    
    UIButton *delete = [[UIButton alloc] initWithFrame:CGRectMake(10, 46, 260, 38)];
    [delete setTitle:@"删除联系人" forState:0];
    [delete setTitleColor:[UIColor whiteColor] forState:0];
    [delete setBackgroundColor:[UtilManager getColorWithHexString:@"#18b4ed"]];
    [delete addTarget:self action:@selector(onConfirm:) forControlEvents:UIControlEventTouchUpInside];
    [self.alertView addSubview:delete];
    
    UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(10, 102, 260, 38)];
    [cancel setTitle:@"取消" forState:0];
    [cancel setTitleColor:[UtilManager getColorWithHexString:@"#919191"] forState:0];
    [cancel setBackgroundColor:[UtilManager getColorWithHexString:@"#f2f2f2"]];
    [cancel addTarget:self action:@selector(onCancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.alertView addSubview:cancel];
    
    self.alertView.clipsToBounds = NO;//
    
    [self addSubview:iv];
    [self addSubview:self.alertView];
    
    
}

-(void)onConfirm:(id)sender
{
    [self hidden];
    if (self.delegate && [self.delegate respondsToSelector:@selector(ContactDeleteAlertViewOnDelete)]) {
        [self.delegate ContactDeleteAlertViewOnDelete];
    }
}
-(void)onCancel:(id)sender
{
    [self hidden];
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
