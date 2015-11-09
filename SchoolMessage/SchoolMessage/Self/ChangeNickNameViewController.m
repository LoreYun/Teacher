//
//  ChangeNickNameViewController.m
//  SchoolMessage
//
//  Created by LI on 15/1/29.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "ChangeNickNameViewController.h"

@interface ChangeNickNameViewController ()<UITextFieldDelegate>

@property (nonatomic ,strong) UITextField *nameInput;

@end

@implementation ChangeNickNameViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"修改昵称";
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [backBtn setTitle:@"保存" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.rightBarButtonItem = backItem;
    
    self.nameInput = [[UITextField alloc] initWithFrame:CGRectMake(30, 45, SCREEN_WIDTH-60, 25)];
    self.nameInput.text = [[AccountManager sharedInstance].LoginInfos getNickName];
    self.nameInput.textColor = [UtilManager getColorWithHexString:@"#353535"];
    self.nameInput.font = [UIFont systemFontOfSize:18];
    self.nameInput.returnKeyType = UIReturnKeyDone;
    self.nameInput.backgroundColor = [UIColor clearColor];
    self.nameInput.delegate = self;
    [self.view addSubview:self.nameInput];
    
    UIImageView *iv  = [[UIImageView  alloc] initWithFrame:CGRectMake(26, 47, SCREEN_WIDTH-52, 25)];
    iv.image = [UtilManager imageNamed:@"nichengtianxie"];
    [self.view addSubview:iv];
}

-(void)change:(id)sender
{
    NSString *nick =  [self.nameInput.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (nick.length==0) {
        [self showHint:@"请输入昵称"];
        return;
    }
    if([[[AccountManager sharedInstance].LoginInfos getNickName] isEqualToString:nick])
    {
        [self showHint:@"请输入新昵称"];
        return;
    }
    
    [self showHudInView:self.view hint:@""];
    [[ObjectManager sharedInstance] requestDataOnPost:@{@"1":[[AccountManager sharedInstance].LoginInfos getUserId],@"2":nick} ByFlag:@"703" callback:^(BOOL succed, NSDictionary *data) {
        if (succed) {
            NSNumber *succeed = [data objectForKey:S_SUCCESS];
            if (succeed.boolValue) {
                [self showHint:@"修改成功"];
                [[AccountManager sharedInstance] reNickname:nick];
                [self.navigationController popViewControllerAnimated:YES];
            }else
            {
                [self showHint:[data objectForKey:S_Msg]];
            }
        }else
        {
            [self showHint:@"操作失败，请检查网络"];
        }
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.nameInput endEditing:YES];
    return YES;
}

@end
