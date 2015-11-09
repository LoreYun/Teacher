//
//  EvaluationAddViewController.m
//  SchoolMessage
//
//  Created by LI on 15/2/9.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "EvaluationAddViewController.h"
#import "ClassChooseAlertView.h"
#import "EMTextView.h"

@interface EvaluationAddViewController ()<UITextViewDelegate,ClassChooseAlertViewDalegate>

@property (nonatomic,strong) UILabel * classLabel;
@property (nonatomic,strong) EMTextView * inputView;
@property (nonatomic,strong) NSString *SubjectId;

@property (nonatomic,strong) UIScrollView *keybordScoller;

@end

@implementation EvaluationAddViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [self.studentInfo objectForKey:@"StudentName"];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [backBtn setImage:[UtilManager imageNamed:@"fasong"] forState:0];
    [backBtn addTarget:self action:@selector(addnewEva:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.rightBarButtonItem = backItem;
    
    self.SubjectId = @"";
    
    self.keybordScoller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.keybordScoller.backgroundColor = [UIColor clearColor];
    [self.keybordScoller addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)]];
    [self.view addSubview:self.keybordScoller];
    
    [self createClassView];
    
//    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(9, 78, 200, 19)];
//    title.text = @"点评内容";
//    title.textColor = [UtilManager getColorWithHexString:@"#333333"];
//    title.font = [UIFont systemFontOfSize:18];
//    title.backgroundColor = [UIColor clearColor];
//    [self.keybordScoller addSubview:title];
    
    self.inputView = [[EMTextView alloc] initWithFrame:CGRectMake(8, 78, SCREEN_WIDTH-16,120)];
    self.inputView.backgroundColor = [UIColor whiteColor];
//    self.inputView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.inputView.textColor = [UtilManager getColorWithHexString:@"#333333"];
    self.inputView.font = [UIFont systemFontOfSize:18];
    [self.inputView setPlaceholder:@"请输入点评内容"];
    
    self.inputView.delegate = self;
    
    [self.keybordScoller addSubview:self.inputView];
    
    if ([[AccountManager sharedInstance].LoginInfos getTeacherSubject].count>0) {
        NSDictionary *data = [[AccountManager sharedInstance].LoginInfos getTeacherSubject].firstObject;
        self.SubjectId = ((NSNumber *)[data objectForKey:@"SubjectId"]).stringValue;
        self.classLabel.text = [data objectForKey:@"SubjectName"];
    }
}

-(void)createClassView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(8,20, SCREEN_WIDTH-16, 47)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius =5;
    view.layer.masksToBounds = YES;
    [self.keybordScoller addSubview:view];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 92, 47)];
    label.text = @"科目";
    label.textColor = [UtilManager getColorWithHexString:@"#353535"];
    label.font = [UIFont systemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    UIView *div = [[UIView alloc] initWithFrame:CGRectMake(92, 0, 0.5, 47)];
    
    div.backgroundColor = [UtilManager getColorWithHexString:@"#cecece"];
    [view addSubview:div];
    
    self.classLabel = [[UILabel alloc] initWithFrame:CGRectMake(110.5,0,SCREEN_WIDTH-16-110.5-45, 47)];
    self.classLabel.textColor = [UtilManager getColorWithHexString:@"#353535"];
    self.classLabel.font = [UIFont systemFontOfSize:18];
    [view addSubview:self.classLabel];
    
    UIView *div1 = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-16-45, 0, 0.5, 47)];
    
    div1.backgroundColor = [UtilManager getColorWithHexString:@"#cecece"];
    [view addSubview:div1];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-16-44.5, 0, 44.5, 47)];
    [button setImage:[UtilManager imageNamed:@"xiala"] forState:0];
    [button addTarget:self action:@selector(chooseSuject:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
}

-(void)addnewEva:(id)sender
{
//    if (self.classLabel.text.length==0) {
//        [self showHint:@"请选择科目！"];
//        return;
//    }
    
    if (self.inputView.text.length==0) {
        [self showHint:@"请填写评语！"];
        return;
    }
    [self showHudInView:self.view hint:@"数据传输中"];
    NSDictionary *dic = @{@"1":[self.studentInfo objectForKey:S_STUDENT_ID],@"2":[self.studentInfo objectForKey:S_STUDENT_NAME],@"3":[self.classInfos objectForKey:S_ClASSID],@"4":[self.classInfos objectForKey:S_CLASSNAME],@"5":[self.classInfos objectForKey:S_GRADEID],@"6":[self.classInfos objectForKey:S_GRADENAME],@"7":[[AccountManager sharedInstance].LoginInfos getTeacherId],@"8":[[AccountManager sharedInstance].LoginInfos getTeacherName],@"9":self.SubjectId,@"10":self.classLabel.text,@"11":self.inputView.text};
    
    [[ObjectManager sharedInstance] requestDataOnPost:dic ByFlag:@"1101" callback:^(BOOL succeed, NSDictionary *data) {
        [self hideHud];
        if (succeed) {
            succeed = ((NSNumber *)[data objectForKey:S_SUCCESS]).boolValue;
        }
        if (succeed)
        {
            [self onAddFinished];
        }else
        {
            [self showHint:@"操作失败，请检查网络"];
        }
    }];
    
}

-(void)onAddFinished
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(EvaluationAddFinished:)]) {
        NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDictionary *dic = @{@"CSId":@"0",@"CommentConent":self.inputView.text,
                              @"CommentTime":[dateFormatter stringFromDate:[NSDate date]],
                              @"SubjectId":self.SubjectId,
                              @"SubjectName":[self getSubjectNameById]};
        [self.delegate EvaluationAddFinished:dic];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSString *)getSubjectNameById
{
    for (NSDictionary *dic in [[AccountManager sharedInstance].LoginInfos getTeacherSubject]) {
        NSString * subjectId = ((NSNumber *)[dic objectForKey:S_SUBJECT_ID]).stringValue;
        if ([subjectId isEqualToString:self.SubjectId]) {
            return [dic objectForKey:S_SUBJECT_NAME];
        }
    }
    return @"";
}

-(void)chooseSuject:(id)sender
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:[[AccountManager sharedInstance].LoginInfos getTeacherSubject]];
    NSNumber *cid = [self.classInfos objectForKey:S_ClASSID];
    if ([[AccountManager sharedInstance].LoginInfos isClassMaster:cid.stringValue]) {
        [array addObject:@{@"SubjectId":@0,@"SubjectName":@""}];
    }
    
    ClassChooseAlertView * alert = [[ClassChooseAlertView alloc] initWithDic:array classID:self.SubjectId type:SujectChoose];
    alert.delegate = self;
    [alert show];
}
-(void)ClassChooseOnDisMiss:(NSDictionary *)data
{
    self.SubjectId = ((NSNumber *)[data objectForKey:@"SubjectId"]).stringValue;
    self.classLabel.text = [data objectForKey:@"SubjectName"];
}



-(void)hideKeyboard
{
    [self.inputView endEditing:YES];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (CGRectGetMaxY(textView.frame)> (SCREEN_HEIGHT-64-216)) {
        [self.keybordScoller setContentOffset:CGPointMake(0,CGRectGetMaxY(textView.frame)-(SCREEN_HEIGHT-64-216)+44) animated:YES];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [self.keybordScoller setContentOffset:CGPointMake(0, 0) animated:YES];
}

@end
