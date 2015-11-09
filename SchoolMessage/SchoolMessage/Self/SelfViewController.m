//
//  SelfViewController.m
//  SchoolMessage
//
//  Created by LI on 15/1/28.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "SelfViewController.h"
#import "UIImageView+WebCache.h"
#import "SelfSettingViewController.h"
#import "ChangeNickNameViewController.h"
#import "HelpFeedViewController.h"
#import "GTMBase64.h"
#import "ContactViewController.h"

@interface SelfViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong) UIImageView *head;
@property (nonatomic,strong) UILabel *nameLabel;

@end

@implementation SelfViewController
@synthesize head;
@synthesize nameLabel;

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我";
    [self setTitleView];
    [self setCellView];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSString *nick = [[AccountManager sharedInstance].LoginInfos getNickName];
    nick = nick.length>0?nick:@"";
    nameLabel.text = [NSString stringWithFormat:@"昵称：%@",nick];
}

-(void)setTitleView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15,15,SCREEN_WIDTH-30,106)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 6;
    view.layer.masksToBounds = YES;
    [self.view addSubview:view];
    
    head = [[UIImageView alloc] initWithFrame:CGRectMake(9, 9,85,85)];
    [head setImageWithURL:[NSURL URLWithString:[[AccountManager sharedInstance].LoginInfos getHeadUrl]] placeholderImage:[UtilManager imageNamed:@"touxiang"]];
    head.userInteractionEnabled = YES;
    [head addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeHead)]];
    [view addSubview:head];
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(105,26,SCREEN_WIDTH-105-9,21)];
    NSString *nick = [[AccountManager sharedInstance].LoginInfos getNickName];
    nick = nick.length>0?nick:@"";
    nameLabel.text = [NSString stringWithFormat:@"昵称：%@",nick];
    nameLabel.font = [UIFont systemFontOfSize:20];
    nameLabel.textColor = [UtilManager getColorWithHexString:@"#353535"];
    [view addSubview:nameLabel];
    
    UILabel *accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(105,63,SCREEN_WIDTH-105-9,21)];
    accountLabel.text = [NSString stringWithFormat:@"帐号：%@",[[AccountManager sharedInstance].LoginInfos getAccount]];
    accountLabel.font = [UIFont systemFontOfSize:20];
    accountLabel.textColor = [UtilManager getColorWithHexString:@"#353535"];
    [view addSubview:accountLabel];
    
    UIButton *changeName = [[UIButton alloc] initWithFrame:CGRectMake(105, 0,SCREEN_WIDTH-105-9,850)];
    [changeName addTarget:self action:@selector(changeNickname) forControlEvents:UIControlEventTouchUpInside];
    changeName.backgroundColor = [UIColor clearColor];
    [view addSubview:changeName];
}

-(void)setCellView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15,136,SCREEN_WIDTH-30,160)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 6;
    view.layer.masksToBounds = YES;
    [self.view addSubview:view];
    
    UIView *cell1 = [self createCell:@"tongxunlu" title:@"通讯录" startY:0 action:@selector(push2Contact:)];

    [view addSubview:cell1];
    
    UIView *div = [[UIView alloc] initWithFrame:CGRectMake(4,53.5,SCREEN_WIDTH-30-8,0.5)];
    div.backgroundColor = [UtilManager getColorWithHexString:@"4b4b4b"];
    [view addSubview:div];
    
    UIView *cell2 = [self createCell:@"shezhi" title:@"设置" startY:54 action:@selector(push2Setting:)];
    
    [view addSubview:cell2];
    
    UIView *div1 = [[UIView alloc] initWithFrame:CGRectMake(4,107.5,SCREEN_WIDTH-30-8,0.5)];
    div1.backgroundColor = [UtilManager getColorWithHexString:@"4b4b4b"];
    [view addSubview:div1];
    
    UIView *cell3 = [self createCell:@"bangzu" title:@"帮助与反馈" startY:108 action:@selector(push2Help:)];
    
    [view addSubview:cell3];
    
}

-(UIView *)createCell:(NSString *)imageName title:(NSString *)title startY:(CGFloat)y action:(SEL)action
{
    UIView *cell = [[UIView alloc] initWithFrame:CGRectMake(0,y,SCREEN_WIDTH-30,53)];
    cell.backgroundColor = [UIColor clearColor];
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(9, y>0?11:17, 25, 26)];
    iv.image = [UtilManager imageNamed:imageName];
    [cell addSubview:iv];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(49,y>0?13:19,100,20)];
    label.text = title;
    label.textColor = [UtilManager getColorWithHexString:@"#353535"];
    label.font = [UIFont systemFontOfSize:18];
    [cell addSubview:label];
    
    UIImageView *ind = [[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.size.width-28, y>0?15:21,14, 19)];
    ind.image = [UtilManager imageNamed:@"jinru"];
    [cell addSubview:ind];
    
    [cell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:action]];
    
    return cell;
}

-(void)push2Contact:(id)sender
{
    ContactViewController *vc =[[ContactViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)push2Setting:(id)sender
{
    SelfSettingViewController *set = [[SelfSettingViewController alloc] init];
    [self.navigationController pushViewController:set animated:YES];
}

-(void)push2Help:(id)sender
{
    HelpFeedViewController *set = [[HelpFeedViewController alloc] init];
    [self.navigationController pushViewController:set animated:YES];
}

-(void)changeHead
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"设置头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册" otherButtonTitles:@"相机", nil];
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
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
}

-(void)camera
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.head.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self upload];
    }];
}

- (void)upload {
    NSData *data = UIImageJPEGRepresentation(self.head.image , 0.01);
    

    [self showHudInView:self.view hint:@"数据传输中"];
    [[ObjectManager sharedInstance] uploadPersonsImage2Server:data callback:^(BOOL succeed, NSDictionary *data) {
        if (succeed) {
            NSNumber *su = [data objectForKey:S_SUCCESS];
            if (su.boolValue) {
                [self reSetHead:[data objectForKey:@"Msg"]];
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

-(void)reSetHead:(NSString *)touxiangUrl
{
    [[ObjectManager sharedInstance] requestDataOnPost:@{@"1":[[AccountManager sharedInstance].LoginInfos getUserId],@"2":touxiangUrl} ByFlag:@"702" callback:^(BOOL succeed, NSDictionary * dic) {
        if (succeed) {
            NSNumber *su = [dic objectForKey:S_SUCCESS];
            if(su.boolValue)
            {
                [[AccountManager sharedInstance] reHead:touxiangUrl];
            }
            [self hideHud];
            [self showHint:su.boolValue?@"修改成功！":@"操作失败，请检查网络！"];
        }else
        {
            [self hideHud];
            [self showHint:@"操作失败，请检查网络！"];
        }
    }];
}

-(void)changeNickname
{
    ChangeNickNameViewController *vc = [[ChangeNickNameViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
