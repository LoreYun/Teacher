//
//  ContactAddViewController.m
//  SchoolMessage
//
//  Created by wulin on 15/2/8.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "ContactAddViewController.h"
#import "ContactLocalManger.h"

@interface ContactAddViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) UITextField *personFiled;
@property (nonatomic,strong) UITextField *phoneFiled;
@property (nonatomic,strong) UIScrollView *keybordScoller;

@end

@implementation ContactAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新建联系人";
    
    self.keybordScoller = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.keybordScoller.backgroundColor = [UIColor clearColor];
    [self.keybordScoller addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)]];
    [self.view addSubview:self.keybordScoller];
    
    self.personFiled = [self creteView:@"联系人：" type:NO start:20 returnKeyType:UIReturnKeyNext];
    self.phoneFiled = [self creteView:@"电 话：" type:NO start:105 returnKeyType:UIReturnKeyDone];
    self.phoneFiled.keyboardType = UIKeyboardTypePhonePad;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(33, 180, SCREEN_WIDTH-66, 47)];
    button.backgroundColor = [UtilManager getColorWithHexString:@"#18b4ed"];
    [button setTitle:@"保存联系人" forState:0];
    [button setTitleColor:[UIColor whiteColor] forState:0];
    [button addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [self.keybordScoller addSubview:button];
}

-(void)save:(id)sender
{
    if(self.personFiled.text.length ==0)
    {
        [self showHint:@"请输入联系人姓名！"];
        return;
    }
    if (self.phoneFiled.text.length ==0) {
        [self showHint:@"请输入电话号码！"];
        return;
    }
    
    [[ContactLocalManger sharedInstance] addNewContactInfo:@"" name:self.personFiled.text phone:self.phoneFiled.text];
    [[ContactLocalManger sharedInstance] saveLoaclContactInfos];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)hideKeyboard
{
    [self.personFiled endEditing:YES];
    [self.phoneFiled endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField==self.personFiled)
    {
        [self.personFiled becomeFirstResponder];
        return NO;
    }else if(textField==self.phoneFiled){
        [self.phoneFiled resignFirstResponder];
    }
    return YES;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
