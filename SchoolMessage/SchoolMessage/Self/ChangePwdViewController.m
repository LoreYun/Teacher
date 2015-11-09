//
//  ChangePwdViewController.m
//  SchoolMessage
//
//  Created by wulin on 15/1/28.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "ChangePwdViewController.h"
#import "AccountManager.h"

@interface ChangePwdViewController ()

@property (nonatomic,strong) UITextField *currentPwd;

@property (nonatomic,strong) UITextField *Passwords;

@property (nonatomic,strong) UITextField *PasswordsCheck;

@property (nonatomic,strong) UIScrollView *keybordScoller;

@end

@implementation ChangePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"设置密码";
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [backBtn setTitle:@"完成" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.rightBarButtonItem = backItem;
    self.keybordScoller = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.keybordScoller.backgroundColor = [UIColor clearColor];
    [self.keybordScoller addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)]];
    [self.view addSubview:self.keybordScoller];
    
    UITextField *account = [self creteView:@"登录号" type:NO start:27 returnKeyType:UIReturnKeyNext];
    account.text = [[AccountManager sharedInstance].LoginInfos getAccount];
    account.enabled = NO;
    
    self.currentPwd = [self creteView:@"当前密码" type:YES start:87 returnKeyType:UIReturnKeyNext];
    self.Passwords = [self creteView:@"新密码" type:YES start:147 returnKeyType:UIReturnKeyNext];
    self.PasswordsCheck = [self creteView:@"确认密码" type:YES start:207 returnKeyType:UIReturnKeyDone];
    
}

-(void)hideKeyboard
{
    [self.currentPwd endEditing:YES];
    [self.Passwords endEditing:YES];
    [self.PasswordsCheck endEditing:YES];
}

-(UITextField *)creteView:(NSString *)title type:(BOOL)isPwd start:(CGFloat)y  returnKeyType:(UIReturnKeyType)returnKeyType
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(33, y, SCREEN_WIDTH-66, 47)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius =5;
    view.layer.masksToBounds = YES;
    [self.keybordScoller addSubview:view];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 92, 47)];
    label.text = title;
    label.textColor = [UtilManager getColorWithHexString:@"#353535"];
    label.font = [UIFont systemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    UIView *div = [[UIView alloc] initWithFrame:CGRectMake(92, 0, 0.5, 47)];
    
    div.backgroundColor = [UtilManager getColorWithHexString:@"#cecece"];
    [view addSubview:div];
    
    UITextField * filed = [[UITextField alloc] initWithFrame:CGRectMake(110.5,0,SCREEN_WIDTH-66-110.5, 47)];
    filed.textColor = [UtilManager getColorWithHexString:@"#353535"];
    filed.font = [UIFont systemFontOfSize:18];
    filed.secureTextEntry = isPwd;
    filed.returnKeyType = returnKeyType;
    filed.delegate = self;
    [view addSubview:filed];
    
    return filed;
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if(textField==self.currentPwd)
    {
        [self.Passwords becomeFirstResponder];
        return NO;
    }else if(textField==self.Passwords){
        [self.PasswordsCheck becomeFirstResponder];
        return NO;
    }else if(textField==self.PasswordsCheck){
        [self.PasswordsCheck resignFirstResponder];
    }
    
    
    
    
    return YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    [self.keybordScoller setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGFloat f = (CGRectGetMaxY(self.PasswordsCheck.superview.frame)-(self.view.frame.size.height-216)+5);
    if (f>0&&self.keybordScoller.contentOffset.y==0) {
        [self.keybordScoller setContentOffset:CGPointMake(0, self.keybordScoller.contentOffset.y+f) animated:YES];//华东
    }
}

-(void)change:(id)sender
{
    if (self.currentPwd.text.length == 0) {
        [self showHint:@"请输入当前密码"];
        return;
    }
    
    if (self.Passwords.text.length == 0) {
        [self showHint:@"请输入新密码"];
        return;
    }
    
    if (self.PasswordsCheck.text.length == 0) {
        [self showHint:@"请输入确认密码"];
        return;
    }
    if(![self.Passwords.text isEqualToString:self.PasswordsCheck.text])
    {
        [self showHint:@"密码不一致"];
        return;
    }
    
    [self showHudInView:self.view hint:@""];
    
    
    
    NSString *old = [[UtilManager md5:[NSString stringWithFormat:@"%@%@",[self.currentPwd.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],PWDSTRING]] uppercaseString];
    NSString *new = [[UtilManager md5:[NSString stringWithFormat:@"%@%@",[self.Passwords.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],PWDSTRING]] uppercaseString];
    [[ObjectManager sharedInstance] requestDataOnGet:@{@"1":[[AccountManager sharedInstance].LoginInfos getUserId],@"2":old,@"3":new} ByFlag:@"701" callback:^(BOOL succeed, NSDictionary *data) {
        [self hideHud];
        if (succeed) {
            NSNumber *succeed = [data objectForKey:S_SUCCESS];
            if (succeed.boolValue) {
                [self showHint:@"修改成功"];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
