//
//  NotificationAddViewController.m
//  SchoolMessage
//
//  Created by LI on 15/2/3.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "NotificationAddViewController.h"
#import "EMTextView.h"

@interface NotificationAddViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic,strong) UIScrollView *scroller;
@property (nonatomic,strong) UITextField *titleField;
@property (nonatomic,strong) EMTextView *contentField;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIView *addView;

@end

@implementation NotificationAddViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"添加通知";
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(0, 0, 44, 44);
    [addBtn setTitle:@"保存" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addNotify:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
    self.navigationItem.rightBarButtonItem = addItem;
    
    self.scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.scroller.backgroundColor = [UIColor clearColor];
    [self.scroller addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allEndEditing)]];
    [self.view addSubview:self.scroller];
    
    [self initTitle];
    [self initContent];
    [self initImageView];
}

-(void)allEndEditing
{
    [self.titleField endEditing:YES];
    [self.contentField endEditing:YES];
}
#pragma mark Input
-(void) initTitle
{
    UIView *title = [[UIView alloc] initWithFrame:CGRectMake(20,10,SCREEN_WIDTH-40,45)];
    title.backgroundColor = [UIColor whiteColor];
    title.layer.cornerRadius =6;
    title.layer.masksToBounds = YES;
    [self.scroller addSubview:title];
    
    UILabel *biaoti = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
    biaoti.text = @"标题";
    biaoti.font = [UIFont boldSystemFontOfSize:18];
    biaoti.textColor = [UtilManager getColorWithHexString:@"#333333"];
    biaoti.textAlignment = NSTextAlignmentCenter;
    [title addSubview:biaoti];
    
    UIView *div = [[UIView alloc] initWithFrame:CGRectMake(100,0,0.5,45)];
    div.backgroundColor = [UtilManager getColorWithHexString:@"#d1d1d1"];
    [title addSubview:div];
    
    self.titleField = [[UITextField alloc] initWithFrame:CGRectMake(101.5, 0, SCREEN_WIDTH-40-101.5, 45)];
    self.titleField.font = [UIFont systemFontOfSize:18];
    self.titleField.textColor = [UtilManager getColorWithHexString:@"#333333"];
    self.titleField.returnKeyType = UIReturnKeyNext;
    self.titleField.delegate =self;
    [title addSubview:self.titleField];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.contentField becomeFirstResponder];
    
    return NO;
}

-(void)initContent
{
    UIView *title = [[UIView alloc] initWithFrame:CGRectMake(20,65,SCREEN_WIDTH-40,108.5)];
    title.backgroundColor = [UIColor whiteColor];
    [self.scroller addSubview:title];
    
//    UILabel *biaoti = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 108.5)];
//    biaoti.text = @"通知内容";
//    biaoti.font = [UIFont boldSystemFontOfSize:18];
//    biaoti.textColor = [UtilManager getColorWithHexString:@"#808080"];
//    biaoti.textAlignment = NSTextAlignmentCenter;
//    [title addSubview:biaoti];
    
    self.contentField = [[EMTextView alloc] initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH-40, 106.5)];
    self.contentField.font = [UIFont systemFontOfSize:18];
    [self.contentField setPlaceholder:@"请输入通知内容"];
    self.contentField.textColor = [UtilManager getColorWithHexString:@"#808080"];
    self.contentField.returnKeyType = UIReturnKeyDone;
    self.contentField.delegate =self;
    [title addSubview:self.contentField];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    CGFloat f = (CGRectGetMaxY(self.contentField.superview.frame)-(self.view.frame.size.height-216-38)+5);
    if (f>0&&self.scroller.contentOffset.y==0) {
        [self.scroller setContentOffset:CGPointMake(0, self.scroller.contentOffset.y+f) animated:YES];//华东
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [self.scroller setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark Photo
-(void)initImageView
{
    self.addView = [[UIView alloc] initWithFrame:CGRectMake(20,184,SCREEN_WIDTH-40,90)];
    self.addView.backgroundColor = [UIColor whiteColor];
    [self.scroller addSubview:self.addView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15, 5, 80, 80)];
    button.backgroundColor = [UIColor clearColor];
    [button setImage:[UtilManager imageNamed:@"tianjia"] forState:0];
    [button addTarget:self action:@selector(addPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.addView addSubview:button];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20,184,SCREEN_WIDTH-40,SCREEN_WIDTH-40/9*16)];
    self.imageView.hidden = YES;
    [self.scroller addSubview:self.imageView];
}


-(void)addPhoto:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选取图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册" otherButtonTitles:@"相机", nil];
    [actionSheet showInView:self.view];

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self album];
    }else if (buttonIndex == 1)
    {
        [self camera];
    }
}

-(void)album
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
}

-(void)camera
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    [self dismissViewControllerAnimated:YES completion:^{
        self.imageView.hidden = NO;
        [self.scroller setContentSize:CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.imageView.frame)+10)];
        self.addView.hidden = YES;
    }];
}

- (void)upload {
    NSData *data = UIImageJPEGRepresentation(self.imageView.image , 0.01);
    
    [[ObjectManager sharedInstance] uploadImage2Server:data callback:^(BOOL succeed, NSDictionary *data) {
        if (succeed) {
            NSNumber *su = [data objectForKey:S_SUCCESS];
            if (su.boolValue) {
                [self addNotifyreRuest:[data objectForKey:@"Msg"]];
            }else
            {
                [self hideHud];
                [self showHint:@"操作失败，请检查网络！"];
            }
        }else
        {
            [self hideHud];
            [self showHint:@"操作失败，请检查网络！"];
        }
    }];
    
    
}


-(void)addNotify:(id)sender
{
    if (self.titleField.text.length==0) {
        [self showHint:@"请输入标题！"];
        return;
    }
    if (self.contentField.text.length==0) {
        [self showHint:@"请输入内容！"];
        return;
    }
    [self showHudInView:self.view hint:@"数据传输中"];
    if(self.imageView.hidden)
    {
        [self addNotifyreRuest:@""];
    }else
    {
        [self upload];
    }
}

-(void)addNotifyreRuest:(NSString *)url
{
    NSString *title = [self.titleField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *content = [self.contentField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSDictionary * dic = @{@"1":[self.classInfo objectForKey:@"ClassId"],@"2":[self.classInfo objectForKey:@"ClassName"],@"3":[[AccountManager sharedInstance].LoginInfos getTeacherId],@"4":[[AccountManager sharedInstance].LoginInfos getTeacherName],@"5":title,@"6":content,@"7":url,@"8":url};
    [[ObjectManager sharedInstance] requestDataOnPost:dic ByFlag:@"1301" callback:^(BOOL succeed, NSDictionary *data) {
        [self hideHud];
        if (succeed) {
            NSNumber *su = [data objectForKey:S_SUCCESS];
            [self showHint:su.boolValue?@"发送成功！":@"操作失败，请检查网络！"];
            [self exeDelegate:url];
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [self showHint:@"操作失败，请检查网络！"];
        }
    }];
}

-(void)exeDelegate:(NSString *)url
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(NotificationOnAdd:)]) {
        NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDictionary *dic = @{
            @"Content": [self.contentField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
            @"CreateTime": [dateFormatter stringFromDate:[NSDate date]],
            @"FileName" : url,
            @"FullName" : url,
            @"Id" : @"9999999",
            @"ReadInfo" :@{
                @"WeiDu" : @"0",
                @"YiDu" : @"0"
            },
            @"TeacherId" : [[AccountManager sharedInstance].LoginInfos getTeacherId],
            @"TeacherName" : [[AccountManager sharedInstance].LoginInfos getTeacherName],
            @"Title" : [self.titleField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
        };
        [self.delegate NotificationOnAdd:dic];
    }
}

@end
