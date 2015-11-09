//
//  ContactDeleteAlertView.m
//  SchoolMessage
//
//  Created by LI on 15/2/11.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "PhotoSelectedAlertView.h"

@interface PhotoSelectedAlertView ()

@property (nonatomic,strong)UIView *alertView;

@property (nonatomic, strong) UIWindow * zoneWindow;

@end

@implementation PhotoSelectedAlertView

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
    CGFloat h = 160;
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:self.frame];
    iv.image =  [UIImage imageNamed:@"customAlertBG.png"];
    iv.userInteractionEnabled = YES;
    iv.clipsToBounds = YES;
    
    self.alertView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-280)/2,(SCREEN_HEIGHT-h)/2, 280,h)];
    self.alertView.backgroundColor = [UIColor whiteColor];
    
    UIButton *download = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 260, 38)];
    [download setTitle:@"从相册选择" forState:0];
    [download setTitleColor:[UIColor whiteColor] forState:0];
    [download setBackgroundColor:[UtilManager getColorWithHexString:@"#18b4ed"]];
    [download addTarget:self action:@selector(onAlbum:) forControlEvents:UIControlEventTouchUpInside];
    [self.alertView addSubview:download];
    
    UIButton *upload = [[UIButton alloc] initWithFrame:CGRectMake(10, 58, 260, 38)];
    [upload setTitle:@"拍照选择" forState:0];
    [upload setTitleColor:[UIColor whiteColor] forState:0];
    [upload setBackgroundColor:[UtilManager getColorWithHexString:@"#18b4ed"]];
    [upload addTarget:self action:@selector(onCarema:) forControlEvents:UIControlEventTouchUpInside];
    [self.alertView addSubview:upload];
    
    UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(10, 114, 260, 38)];
    [cancel setTitle:@"取消" forState:0];
    [cancel setTitleColor:[UtilManager getColorWithHexString:@"#919191"] forState:0];
    [cancel setBackgroundColor:[UtilManager getColorWithHexString:@"#f2f2f2"]];
    [cancel addTarget:self action:@selector(onCancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.alertView addSubview:cancel];
    
    self.alertView.clipsToBounds = NO;//
    
    [self addSubview:iv];
    [self addSubview:self.alertView];
    
    
}

-(void)onAlbum:(id)sender
{
    [self hidden];
    if (self.delegate && [self.delegate respondsToSelector:@selector(PhotoSelectedAlbum)]) {
        [self.delegate PhotoSelectedAlbum];
    }
}

-(void)onCarema:(id)sender
{
    [self hidden];
    if (self.delegate && [self.delegate respondsToSelector:@selector(PhotoSelectedCarema)]) {
        [self.delegate PhotoSelectedCarema];
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
