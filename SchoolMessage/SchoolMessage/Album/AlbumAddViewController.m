//
//  AlbumAddViewController.m
//  SchoolMessage
//
//  Created by LI on 15/2/4.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "AlbumAddViewController.h"
#import "AlbumManager.h"

@interface AlbumAddViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UITextField *albumNameInput;
@property (nonatomic,assign) BOOL imageViewFlag;

@end

@implementation AlbumAddViewController
@synthesize albumNameInput;

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"添加相册";
    
    UIScrollView *scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    scroller.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scroller];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [backBtn setImage:[UtilManager imageNamed:@"add"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.rightBarButtonItem = backItem;
    
    UILabel * albumName = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 100, 20)];
    albumName.text = @"相册名：";
    albumName.textColor = [UtilManager getColorWithHexString:@"#8e8e8e"];
    albumName.font = [UIFont systemFontOfSize:19];
    [scroller addSubview:albumName];
    
    albumNameInput = [[UITextField  alloc] initWithFrame:CGRectMake(100, 18,SCREEN_WIDTH-100-20-1, 19)];
    albumNameInput.placeholder = @"请输入相册名字";
//    albumNameInput.textColor = [UtilManager getColorWithHexString:@"#8e8e8e"];
    albumNameInput.font = [UIFont systemFontOfSize:18];
    albumNameInput.returnKeyType = UIReturnKeyDone;
    albumNameInput.delegate = self;
    [scroller addSubview:albumNameInput];
    
    UILabel * className = [[UILabel alloc] initWithFrame:CGRectMake(20, 64, SCREEN_WIDTH-40, 20)];
    NSMutableAttributedString *temp = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"相册班级：%@",[self.classNameData objectForKey:@"ClassName"]]];
    [self addAttr2Name:temp];
    className.attributedText = temp;
    [scroller addSubview:className];
    
    UILabel * gradeName = [[UILabel alloc] initWithFrame:CGRectMake(20, 112, SCREEN_WIDTH-40, 20)];
    NSMutableAttributedString *grade = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"相册年级：%@",[self.classNameData objectForKey:@"GradeName"]]];
    [self addAttr2Name:grade];
    gradeName.attributedText = grade;
    [scroller addSubview:gradeName];
    
    [self AddDiv2View:scroller start:47];
    [self AddDiv2View:scroller start:96];
    [self AddDiv2View:scroller start:145];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(8, 179, SCREEN_WIDTH-16, 40)];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [button setTitle:@"设置封面" forState:0];
    [button setTitleColor:[UIColor whiteColor] forState:0];
    button.backgroundColor = [UtilManager getColorWithHexString:@"#18b4ed"];
    [button addTarget:self action:@selector(setCorver:) forControlEvents:UIControlEventTouchUpInside];
    [scroller addSubview:button];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(18,239,SCREEN_WIDTH-36,SCREEN_WIDTH-36)];
    self.imageView.image = [UtilManager imageNamed:@"morentupian"];
    self.imageViewFlag = NO;
    [scroller addSubview:self.imageView];
    
    scroller.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.imageView.frame)+5);
    
    [scroller addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)]];
    scroller.userInteractionEnabled = YES;
}

-(void)hideKeyboard
{
    [albumNameInput resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [albumNameInput resignFirstResponder];
    return YES;
}

-(void)addAttr2Name:(NSMutableAttributedString *)string
{
    [string addAttributes:@{NSForegroundColorAttributeName:[UtilManager getColorWithHexString:@"#8e8e8e"],NSFontAttributeName:[UIFont systemFontOfSize:19]} range:NSMakeRange(0, 5)];
    [string addAttributes:@{NSForegroundColorAttributeName:[UtilManager getColorWithHexString:@"#333333"],NSFontAttributeName:[UIFont systemFontOfSize:18]} range:NSMakeRange(5,string.length-5)];
}

-(void)AddDiv2View:(UIView *)view start:(CGFloat)startY;
{
    UIView *div = [[UIView alloc] initWithFrame:CGRectMake(20, startY, SCREEN_WIDTH-40, 2)];
    div.backgroundColor = [UtilManager getColorWithHexString:@"#e7e7e7"];
    [view addSubview:div];
}

-(void)setCorver:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"设置封面" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册" otherButtonTitles:@"相机", nil];
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
    self.imageViewFlag = YES;
    [self dismissViewControllerAnimated:YES completion:^{
//        self.imageView.hidden = NO;
//        [self.scroller setContentSize:CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.imageView.frame)+10)];
//        self.addView.hidden = YES;
    }];
}

-(void)save:(id)sender
{
    if (albumNameInput.text.length==0) {
        [self showHint:@"请输入相册名称！"];
        return;
    }
    [self showHudInView:self.view hint:@""];
    if (self.imageViewFlag) {
        [self upload];
    }else
    {
        [self AddAlubum:@""];
    }
}

- (void)upload {
    NSData *data = UIImageJPEGRepresentation(self.imageView.image , 0.01);
    
    [[ObjectManager sharedInstance] uploadImage2Server:data callback:^(BOOL succeed, NSDictionary *data) {
        if (succeed) {
            NSNumber *su = [data objectForKey:S_SUCCESS];
            if (su.boolValue) {
                [self AddAlubum:[data objectForKey:@"Msg"]];
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

-(void)AddAlubum:(NSString *)path
{
    NSString *albumeName = [self.albumNameInput.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [[AlbumManager sharedInstance] createAlbum:albumeName teacherId:[[AccountManager sharedInstance].LoginInfos getUserId] teacherName:[[AccountManager sharedInstance].LoginInfos getTeacherName] classId:[self.classNameData objectForKey:@"ClassId"] className:[self.classNameData objectForKey:@"ClassName"] gradeId:[self.classNameData objectForKey:@"GradeId"] gradeName:[self.classNameData objectForKey:@"GradeName"] fileName:path fullName:path callback:^(BOOL succeed, NSDictionary *data) {
        [self hideHud];
        if (succeed) {
            NSNumber *su = [data objectForKey:S_SUCCESS];
            if (su.boolValue) {
                [self showHint:@"创建成功！"];
                [self exeDelegate:path];
                [self.navigationController popViewControllerAnimated:YES];
            }else
            {
                [self showHint:@"操作失败，请检查网络！"];
            }
        }else
        {
            [self showHint:@"操作失败，请检查网络！"];
        }
    }];
}

-(void)exeDelegate:(NSString *)url
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(AlbumOnAdd:)]) {
        NSString * AlbumName = [self.albumNameInput.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDictionary *dic = @{@"AlbumId":@"0",
                              @"AlbumName":AlbumName,
                              @"CreateTime":[dateFormatter stringFromDate:[NSDate date]],
                              @"FileName":url,
                              @"FullName":url,
                              @"PhotoCount":@"0"
                              };
        [self.delegate AlbumOnAdd:dic];
    }
}


@end
