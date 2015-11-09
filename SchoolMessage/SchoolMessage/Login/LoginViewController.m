//
//  LoginViewController.m
//  SchoolMessage
//
//  Created by LI on 15-1-23.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "LoginViewController.h"
#import "EMTextView.h"
#import "HomeViewController.h" 

@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) UITextField *username;

@property (nonatomic,strong) UITextField *password;

@property (nonatomic,strong) UIScrollView *scrollView;

@end

@implementation LoginViewController

@synthesize scrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:scrollView];
    
    self.view.backgroundColor = [UtilManager getColorWithHexString:@"#e4f4f7"];
    
    UIImageView *logoIv  = [[UIImageView alloc] initWithImage:[UtilManager imageNamed:@"logo2"]];
    
    logoIv.center = CGPointMake(self.view.center.x, 100);
    [scrollView addSubview:logoIv];
    
    self.username = [self createInputView:CGRectGetMaxY(logoIv.frame)+50 placeholder:@"用户名"];
    self.username.returnKeyType = UIReturnKeyNext;
    self.password = [self createInputView:CGRectGetMaxY(self.username.frame)+25 placeholder:@"密码"];
    self.password.secureTextEntry = YES;
    self.password.returnKeyType = UIReturnKeyDone;
    
    UIButton * btn =  [[UIButton alloc] initWithFrame:CGRectMake(37.5,CGRectGetMaxY(self.password.frame)+25, SCREEN_WIDTH-65, 45)];
    [btn setTitle:@"登录" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UtilManager getColorWithHexString:@"#18b4ed"]];
    [btn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 7;
    btn.layer.masksToBounds = YES;
    
    [scrollView addSubview:self.username];
    [scrollView addSubview:self.password];
    [scrollView addSubview:btn];
    
    [scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endInputing)]];
    
    self.username.text = [[NSUserDefaults standardUserDefaults] objectForKey:USER_NAME_SAVE];
    self.password.text = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@--%@",USER_NAME_SAVE,self.username.text]];
}

-(UITextField *)createInputView:(CGFloat)startY placeholder:(NSString *)placeholder
{
    UITextField * textview = [[UITextField alloc] initWithFrame:CGRectMake(37.5, startY, SCREEN_WIDTH-65, 45)];
    textview.backgroundColor = [UIColor whiteColor];
    textview.layer.cornerRadius = 7;
    textview.layer.masksToBounds = YES;
    textview.placeholder = placeholder;
    [textview setValue:[UtilManager getColorWithHexString:@"#b3b3b3"] forKeyPath:@"_placeholderLabel.textColor"];
//    textview.placeholderColor = [UtilManager getColorWithHexString:@"#b3b3b3"];
    textview.font = [UIFont systemFontOfSize:24];
//    textview.n
    textview.textAlignment = NSTextAlignmentCenter;
    [textview setTranslatesAutoresizingMaskIntoConstraints:NO];
    textview.autocorrectionType = UITextAutocorrectionTypeNo;
    textview.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textview.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textview.delegate = self;
    
    
    return textview;
}

-(void)endInputing
{
    if (scrollView.contentOffset.y>0)
    {
        [scrollView setContentOffset:CGPointMake(0,0) animated:YES];//华东
    }
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
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(void)login:(id)sender
{
    [self.username endEditing:YES];
    [self.password endEditing:YES];
    [self showHudInView:self.view hint:@"登录中……"];
    [[AccountManager sharedInstance] login:self.username.text pwd:self.password.text callback:^(BOOL succeed, NSString *errorMsg) {
        [self hideHud];
        if (succeed) {
            [self loginSucceed];
        }else
        {
            [self showHint:errorMsg];
        }
    }];
}

-(void)loginSucceed
{
//    HomeViewController *vc = [[HomeViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@"0"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if(textField==self.username)
    {
        [self.password becomeFirstResponder];
        return NO;
    }else if(textField==self.password){
        [self.username endEditing:YES];
        [self.password endEditing:YES];
    }
    
    
    
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGFloat f = (CGRectGetMaxY(self.password.frame)+25+45+10)-(SCREEN_HEIGHT-216);
    if (f>0&&scrollView.contentOffset.y==0) {
        [scrollView setContentOffset:CGPointMake(0, scrollView.contentOffset.y+f) animated:YES];//华东
    }
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
