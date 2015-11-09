//
//  BaseVC.m
//  SchoolMessage
//
//  Created by LI on 15-1-23.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "BaseVC.h"

@interface BaseVC ()

@end

@implementation BaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    self.view.backgroundColor = [UtilManager getColorWithHexString:@"#e4f4f7"];
    [self.navigationController setNavigationBarHidden:NO];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [backBtn setImage:[UtilManager imageNamed:@"back"] forState:UIControlStateNormal];
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [backBtn addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    self.view.backgroundColor = [UtilManager getColorWithHexString:@"e4f3f6"];
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"  style:UIBarButtonItemStyleBor  target:self  action:nil];
//    [backButton setTintColor:[UIColor whiteColor]];
//    self.navigationItem.leftBarButtonItem = backButton;
//    [self.navigationController set]
    
}

-(void)initRightTitleBar:(NSString *)title action:(SEL)action
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [backBtn setTitle:title forState:0];
    [backBtn setTitleColor:[UIColor whiteColor] forState:0];
    [backBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.rightBarButtonItem = backItem;
}

-(void)initRightImageBar:(NSString *)image action:(SEL)action
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [backBtn setImage:[UtilManager imageNamed:image] forState:0];
    [backBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.rightBarButtonItem = backItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
