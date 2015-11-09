//
//  ContactEditViewController.m
//  SchoolMessage
//
//  Created by wulin on 15/2/8.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "ContactEditViewController.h"
#import "ContactLocalManger.h"
#import "ContactViewController.h"
#import "ContactDeleteAlertView.h"

@interface ContactEditViewController ()<UITextFieldDelegate,ContactDeleteAlertViewDalegate>

@property (nonatomic,strong) UITextField * name;

@property (nonatomic,strong) UITextField * phone;

@property (nonatomic,strong) UIScrollView *keybordScoller;


@end

@implementation ContactEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"联系人详情";
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [backBtn setTitle:@"完成" forState:0];
    [backBtn setTitleColor:[UIColor whiteColor] forState:0];
    [backBtn addTarget:self action:@selector(saveContactInfo:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    self.navigationItem.rightBarButtonItem = backItem;
    
    self.keybordScoller = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.keybordScoller.backgroundColor = [UIColor clearColor];
    [self.keybordScoller addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)]];
    [self.view addSubview:self.keybordScoller];
    
    self.name = [self creteView:@"联系人：" content:[self.contactInfos objectForKey:@"Relation"] start:20];
    self.name.returnKeyType = UIReturnKeyNext;
    
    
    UITextField *tmp = [self creteView:@"学 生：" content:[self.contactInfos objectForKey:@"StudentName"] start:85];
    tmp.enabled = NO;
    
    self.phone = [self creteView:@"电 话：" content:[self.contactInfos objectForKey:@"Mobile"] start:150];
    
    self.phone.returnKeyType = UIReturnKeyDone;
    self.phone.keyboardType = UIKeyboardTypePhonePad;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(33, 215, SCREEN_WIDTH-66, 47)];
    button.backgroundColor = [UtilManager getColorWithHexString:@"#18b4ed"];
    [button setTitle:@"确定 " forState:0];//删除联系人
    [button setTitleColor:[UIColor whiteColor] forState:0];
    [button addTarget:self action:@selector(saveContactInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self.keybordScoller addSubview:button];
}

-(void)deleteContactInfo:(id)sender
{
    ContactDeleteAlertView *view = [[ContactDeleteAlertView alloc] init];
    view.delegate =self;
    [view show];
}

-(void)ContactDeleteAlertViewOnDelete
{
    [[ContactLocalManger sharedInstance] deleteContactInfo:@"" name:[self.contactInfos objectForKey:@"Relation"] phone:[self.contactInfos objectForKey:@"Mobile"]];
    [[ContactLocalManger sharedInstance] saveLoaclContactInfos];
    [self pop2View];
}

-(void)pop2View
{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[ContactViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

-(void)saveContactInfo:(id)sender
{
    if (self.name.text.length ==0 ) {
        [self showHint:@"请输入联系人姓名！"];
        return;
    }
    if (self.phone.text.length ==0 ) {
        [self showHint:@"请输入电话号码！"];
        return;
        
    }
    
//    [[ContactLocalManger sharedInstance] editContactInfo:@"" name:self.name.text phone:self.phone.text];
    [self.contactInfos setValue:self.name.text forKey:@"Relation"];
    [self.contactInfos setValue:self.phone.text forKey:@"Mobile"];
    [[ContactLocalManger sharedInstance] saveLoaclContactInfos];
    [self pop2View];
}

-(UITextField *)creteView:(NSString *)title content:(NSString *)content start:(CGFloat)y
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
    filed.text = content;
    filed.delegate = self;
    [view addSubview:filed];
    return filed;
}


-(void)hideKeyboard
{
    [self.name endEditing:YES];
    [self.phone endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField==self.name)
    {
        [self.phone becomeFirstResponder];
        return NO;
    }else if(textField==self.phone){
        [self.phone resignFirstResponder];
    }
    return YES;
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
