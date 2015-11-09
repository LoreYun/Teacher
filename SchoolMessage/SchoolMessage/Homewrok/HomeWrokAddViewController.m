//
//  HomeWrokAddViewController.m
//  SchoolMessage
//
//  Created by LI on 15/2/10.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "HomeWrokAddViewController.h"
#import "ClassChooseAlertView.h"
#import "UIImageView+WebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "PhotoSelectedAlertView.h"
#import "DoImagePickerController.h"
#import "EMTextView.h"

#define LIMIT_MAX 5

static NSString *identifier = @"HomeWrokAddViewController";

@interface HomeWrokAddViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,ClassChooseAlertViewDalegate,UITextViewDelegate,PhotoSelectedAlertViewDalegate,DoImagePickerControllerDelegate,UIImagePickerControllerDelegate>

@property(nonatomic,strong) UIScrollView *scroller;
@property (nonatomic,strong) NSMutableArray *imageArray;
@property (nonatomic,strong) UICollectionView *imageCollectionView;

@property (nonatomic,strong) NSMutableArray *readInfoData;

@property (nonatomic,strong) UILabel *subjectLabel;
@property (nonatomic,strong) UILabel *classNameLabel;
@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) NSDictionary *SubjectInfoData;
@property (nonatomic,strong) NSDictionary *classInfoData;

@property (nonatomic,strong) UIDatePicker * datePicker1;
@property (nonatomic,strong) UIView * dateView;

@property (nonatomic,strong) EMTextView *titleField;
@property (nonatomic,strong) EMTextView *contentField;

@property (nonatomic,assign) NSInteger          currentUploadNum;

@property (nonatomic,assign) BOOL           isSending;
@property (nonatomic,strong) NSString           *uploadString;

@end

@implementation HomeWrokAddViewController
@synthesize datePicker1,dateView;

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"添加作业";
    [self initRightImageBar:@"fasong" action:@selector(addHomewrok:)];
    self.imageArray = [NSMutableArray array];
    self.scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.scroller.backgroundColor = [UIColor clearColor];

    UIButton *btn = [[UIButton alloc] initWithFrame:self.view.frame];
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(tapScroller) forControlEvents:UIControlEventTouchUpInside];
    [self.scroller addSubview:btn];
    
    [self.view addSubview:self.scroller];
    
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    self.classInfoData = [[[AccountManager sharedInstance].LoginInfos getTeacherClassesArray] firstObject];
    self.SubjectInfoData = [[[AccountManager sharedInstance].LoginInfos getTeacherSubject] firstObject];
    
    self.subjectLabel = [self createChooseView:@selector(alertSubject:) title:@"科目" content:[self.classInfoData objectForKey:S_SUBJECT_NAME] startY:20];
    self.classNameLabel = [self createChooseView:@selector(alertClass:) title:@"年级" content:[NSString stringWithFormat:@"%@%@",[self.classInfoData objectForKey:S_GRADENAME],[self.classInfoData objectForKey:S_CLASSNAME]] startY:75];
    self.timeLabel = [self createClassView:@"上交时间" content:[dateFormatter stringFromDate:[NSDate date]] startY:130];
    self.timeLabel.userInteractionEnabled = YES;
    [self.timeLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseTime)]];
    
    [self initTitle];
    [self initContent];
    [self initCollectionView];
    
    [self.scroller setContentSize:CGSizeMake(SCREEN_WIDTH,CGRectGetMaxY(self.imageCollectionView.frame)+10)];
    [self createDatePicker];
}

-(void)initTitle
{
    UIView *title = [[UIView alloc] initWithFrame:CGRectMake(8,185,SCREEN_WIDTH-16,41)];
    title.backgroundColor = [UIColor whiteColor];
    [self.scroller addSubview:title];
    
//    UILabel *biaoti = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 41)];
//    biaoti.text = @"作业标题";
//    biaoti.font = [UIFont boldSystemFontOfSize:18];
//    biaoti.textColor = [UtilManager getColorWithHexString:@"#808080"];
//    biaoti.textAlignment = NSTextAlignmentCenter;
//    [title addSubview:biaoti];
    
    self.titleField = [[EMTextView alloc] initWithFrame:CGRectMake(1.5, 1, SCREEN_WIDTH-16-1.5, 39)];
    self.titleField.font = [UIFont systemFontOfSize:18];
    
    self.titleField.textColor = [UtilManager getColorWithHexString:@"#333333"];
    self.titleField.returnKeyType = UIReturnKeyNext;
    self.titleField.delegate =self;
    
    self.titleField.placeholder = @"作业标题";
    [title addSubview:self.titleField];
}

-(void)initContent
{
    UIView *title = [[UIView alloc] initWithFrame:CGRectMake(8,235,SCREEN_WIDTH-16,108.5)];
    title.backgroundColor = [UIColor whiteColor];
    [self.scroller addSubview:title];
    
//    UILabel *biaoti = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 108.5)];
//    biaoti.text = @"作业内容";
//    biaoti.font = [UIFont boldSystemFontOfSize:18];
//    biaoti.textColor = [UtilManager getColorWithHexString:@"#808080"];
//    biaoti.textAlignment = NSTextAlignmentCenter;
//    [title addSubview:biaoti];
    
    self.contentField = [[EMTextView alloc] initWithFrame:CGRectMake(1.5, 1, SCREEN_WIDTH-16-1.5, 106.5)];
    self.contentField.font = [UIFont systemFontOfSize:18];
    
    self.contentField.textColor = [UtilManager getColorWithHexString:@"#333333"];
    self.contentField.returnKeyType = UIReturnKeyDone;
    self.contentField.delegate =self;
    self.contentField.placeholder = @"作业内容";
    [title addSubview:self.contentField];
}

-(void)initCollectionView
{
    CGFloat length = (SCREEN_WIDTH-14.0f-14.0f-24.0f)/3.0f;
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.itemSize = CGSizeMake(length,length);
    flowLayout.minimumInteritemSpacing = 12;
    flowLayout.minimumLineSpacing = 8;
    flowLayout.sectionInset = UIEdgeInsetsMake(8, 6, 8, 6);
    self.imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(8,353, SCREEN_WIDTH-8,length+16) collectionViewLayout:flowLayout];
    self.imageCollectionView.delegate = self;
    self.imageCollectionView.dataSource = self;
    self.imageCollectionView.backgroundColor = [UIColor whiteColor];
    self.imageCollectionView.scrollEnabled = NO;
    [self.imageCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifier];
    [self.scroller addSubview:self.imageCollectionView];
}

-(void)reframeCollection
{
    CGFloat length = (SCREEN_WIDTH-14.0f-14.0f-24.0f)/3.0f;
    if (self.imageArray.count<3) {
        self.imageCollectionView.frame =CGRectMake(8,353, SCREEN_WIDTH-8,length+16);
    }else
    {
        self.imageCollectionView.frame =CGRectMake(8,353, SCREEN_WIDTH-8,length*2+12+16);
    }
    
    [self.scroller setContentSize:CGSizeMake(SCREEN_WIDTH,CGRectGetMaxY(self.imageCollectionView.frame)+10)];
}

#pragma mark textViewdelegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    CGFloat f = (CGRectGetMaxY(textView.superview.frame)-(self.view.frame.size.height-216-38)+5);
    if (f>0&&self.scroller.contentOffset.y==0) {
        [self.scroller setContentOffset:CGPointMake(0,f) animated:YES];//华东
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [self.scroller setContentOffset:CGPointMake(0,0) animated:YES];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)createDatePicker
{
    dateView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, 320, 240)];
    [dateView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:dateView];
    
    //NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    datePicker1 = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 40, 320, 200)];
    datePicker1.locale = locale;
    datePicker1.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker1 addTarget:self action:@selector(TimeChange) forControlEvents:UIControlEventValueChanged];
    [dateView addSubview:datePicker1];
    
    UIToolbar *dataPicker1Bar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    dataPicker1Bar.backgroundColor = [UIColor whiteColor];
    [dateView addSubview:dataPicker1Bar];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(265, 5, 40, 30);
    [btn2 setTitle:@"完成" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(downTimePicker) forControlEvents:UIControlEventTouchUpInside];
    [dataPicker1Bar addSubview:btn2];
    
}

-(void)chooseTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    
    datePicker1.date = [formatter dateFromString:self.timeLabel.text];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [dateView setFrame:CGRectMake(0, SCREEN_HEIGHT-64 - 240, 320, 240)];
    }];
    
}


-(void)TimeChange
{
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    formatter1.dateFormat= @"yyyy-MM-dd HH:mm";
    self.timeLabel.text = [formatter1 stringFromDate:datePicker1.date];
}

- (void)downTimePicker
{
    [UIView animateWithDuration:0.5 animations:^{
        [dateView setFrame:CGRectMake(0, SCREEN_HEIGHT, 320, 240)];
    }];
}


#pragma mark addHomewrok
-(void)addHomewrok:(id)sender
{
    if (self.subjectLabel.text.length==0) {
        [self showHint:@"请选择科目！"];
        return;
    }
    if (self.classNameLabel.text.length==0) {
        [self showHint:@"请选择班级！"];
        return;
    }
    if (self.titleField.text.length==0) {
        [self showHint:@"请填写作业标题！"];
        return;
    }
    if (self.contentField.text.length==0) {
        [self showHint:@"请填写作业内容！"];
        return;
    }
    
    if (self.isSending) {
        [self showHint:@"图片上传中"];
        return;
    }
    
    self.isSending = YES;
    __weak HomeWrokAddViewController *con = self;
    con.uploadString = @"";
    self.currentUploadNum = 0;
    [self showHudInView:self.view hint:@"请稍后"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [con UploadImages:^(BOOL result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (result) {
                    [con commitHomework];
                }else
                {
                    con.uploadString = @"";
                    con.currentUploadNum = 0;
                    con.isSending = NO;
                    
                    [con hideHud];
                    [con showHint:@"操作失败，请检查网络"];
                    
                }
            });
        }];
    });
    
    
}


-(void)commitHomework
{
    NSDictionary *dic = @{
                          @"1":self.titleField.text,
                          @"2":[[AccountManager sharedInstance].LoginInfos  getTeacherId],
                          @"3":[[AccountManager sharedInstance].LoginInfos  getTeacherName],
                          @"4":[self.classInfoData objectForKey:S_GRADEID],
                          @"5":[self.classInfoData objectForKey:S_GRADENAME],
                          @"6":[self.classInfoData objectForKey:S_ClASSID],
                          @"7":[self.classInfoData objectForKey:S_CLASSNAME],
                          @"8":[self.SubjectInfoData objectForKey:S_SUBJECT_ID],
                          @"9":[self.SubjectInfoData objectForKey:S_SUBJECT_NAME],
                          @"10":@"",//fileName1
                          @"11":[self getFullNameByIndex:0],//fullName1
                          @"12":@"",//fileName2
                          @"13":[self getFullNameByIndex:1],//fullName
                          @"14":@"",//fileName3
                          @"15":[self getFullNameByIndex:2],//fullName
                          @"16":@"",//fileName4
                          @"17":[self getFullNameByIndex:3],//fullName
                          @"18":@"",//fileName5
                          @"19":[self getFullNameByIndex:4],//fullName
                          @"20":self.contentField.text,
                          @"21":self.timeLabel.text,
                          };
    [[ObjectManager sharedInstance] requestDataOnPost:dic ByFlag:@"1501" callback:^(BOOL succeed, NSDictionary *data) {
        [self hideHud];
        if (succeed) {
            NSNumber *su = [data objectForKey:S_SUCCESS];
            if (su.boolValue) {
                [self showHint:@"添加成功！"];
                if (self.delegate && [self.delegate respondsToSelector:@selector(HomeWrokAddDelegate:)]) {
                    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                    NSDictionary *result = @{
                                             @"HomeworkTitle":self.titleField.text,
                                             @"HomeworkId":@"0",
                                             @"TeacherId":[[AccountManager sharedInstance].LoginInfos  getTeacherId],
                                             @"TeacherName":[[AccountManager sharedInstance].LoginInfos  getTeacherName],
                                             @"GradeId":[self.classInfoData objectForKey:S_GRADEID],
                                             @"GradeName":[self.classInfoData objectForKey:S_GRADENAME],
                                             @"ClassId":[self.classInfoData objectForKey:S_ClASSID],
                                             @"ClassName":[self.classInfoData objectForKey:S_CLASSNAME],
                                             @"SubjectId":[self.SubjectInfoData objectForKey:S_SUBJECT_ID],
                                             @"SubjectName":[self.SubjectInfoData objectForKey:S_SUBJECT_NAME],
                                             @"FileName1":@"",//fileName1
                                             @"FullName1":[self getFullNameByIndex:0],//fullName1
                                             @"FileName2":@"",//fileName2
                                             @"FullName2":[self getFullNameByIndex:1],//fullName
                                             @"FileName3":@"",//fileName3
                                             @"FullName3":[self getFullNameByIndex:2],//fullName
                                             @"FileName4":@"",//fileName4
                                             @"FullName4":[self getFullNameByIndex:3],//fullName
                                             @"FileName5":@"",//fileName5
                                             @"FullName5":[self getFullNameByIndex:4],//fullName
                                             @"HomeworkContent":self.contentField.text,
                                             @"SubmiteTime":self.timeLabel.text,
                                             @"CreateTime" :[dateFormatter stringFromDate:[NSDate date]],
                                             @"ReadInfo": @{@"YiDu":[NSNumber numberWithInt:0],@"WeiDu":[NSNumber numberWithInt:0]},
                                             };
                    
                    [self.delegate HomeWrokAddDelegate:result];
                }
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

-(NSString *)getFullNameByIndex:(NSInteger)index
{
    NSString *result = @"";
    if (self.uploadString.length==0) {
        return @"";
    }
    NSArray *array = [self.uploadString componentsSeparatedByString:@","];
    if (array.count>=index+1) {
        result = [array objectAtIndex:index];
    }
    
    return result;
}

-(void)UploadImages:(void (^)(BOOL))callback;
{
    __weak HomeWrokAddViewController *con = self;
    if (self.imageArray.count==0) {
        callback(YES);
        return;
    }
    UIImage *image = [self.imageArray objectAtIndex:self.currentUploadNum];
    
    NSData *data = UIImageJPEGRepresentation(image, 0.01);
    [[ObjectManager sharedInstance] uploadImage2Server:data callback:^(BOOL succeed, NSDictionary *result) {
        if (succeed) {
            succeed = ((NSNumber *)[result objectForKey:S_SUCCESS]).boolValue;
        }
        if (succeed) {
            con.currentUploadNum++;
            NSString *String = [result objectForKey:@"Msg"];
            if(self.uploadString.length==0)
            {
                self.uploadString = String;
            }else
            {
                self.uploadString = [NSString stringWithFormat:@"%@,%@",self.uploadString,String];
            }
            
            if (con.currentUploadNum == con.imageArray.count) {
                con.currentUploadNum = 0;
                callback(YES);
            }else
            {
                [con UploadImages:callback];
            }
            
        }else
        {
            con.currentUploadNum = 0;
            callback(NO);
        }
    }];
}

-(void)alertSubject:(id)sener
{
    ClassChooseAlertView *view = [[ClassChooseAlertView alloc] initWithDic:[[AccountManager sharedInstance].LoginInfos getTeacherSubject] classID:[self.SubjectInfoData objectForKey:S_SUBJECT_ID] type:SujectChoose];
    view.delegate =self;
    [view show];
}

-(void)alertClass:(id)sener
{
    ClassChooseAlertView *view = [[ClassChooseAlertView alloc] initWithDic:[[AccountManager sharedInstance].LoginInfos getTeacherClassesArray] classID:[self.classInfoData objectForKey:S_ClASSID] type:ClassChoose];
    view.delegate =self;
    [view show];
}

-(void)ClassChooseOnDisMiss:(NSDictionary *)data
{
    if([data  objectForKey:S_ClASSID])
    {
        self.classInfoData = data;
        self.classNameLabel.text = [NSString stringWithFormat:@"%@%@",[self.classInfoData objectForKey:S_GRADENAME],[self.classInfoData objectForKey:S_CLASSNAME]];
    }else
    {
        self.SubjectInfoData = data;
        self.subjectLabel.text = [self.SubjectInfoData objectForKey:S_SUBJECT_NAME];
    }
}

-(UILabel *)createChooseView:(SEL)alertAction title:(NSString *)title content:(NSString *)content startY:(CGFloat)y
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(8,y, SCREEN_WIDTH-16, 47)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius =5;
    view.layer.masksToBounds = YES;
    [self.scroller addSubview:view];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 92, 47)];
    label.text = title;
    label.textColor = [UtilManager getColorWithHexString:@"#353535"];
    label.font = [UIFont systemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    UIView *div = [[UIView alloc] initWithFrame:CGRectMake(92, 0, 0.5, 47)];
    
    div.backgroundColor = [UtilManager getColorWithHexString:@"#cecece"];
    [view addSubview:div];
    
    UILabel *classLabel = [[UILabel alloc] initWithFrame:CGRectMake(110.5,0,SCREEN_WIDTH-16-110.5-45, 47)];
    classLabel.textColor = [UtilManager getColorWithHexString:@"#353535"];
    classLabel.font = [UIFont systemFontOfSize:18];
    classLabel.text = content;
    [view addSubview:classLabel];
    
    UIView *div1 = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-16-45, 0, 0.5, 47)];
    
    div1.backgroundColor = [UtilManager getColorWithHexString:@"#cecece"];
    [view addSubview:div1];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-16-44.5, 0, 44.5, 47)];
    [button setImage:[UtilManager imageNamed:@"xiala"] forState:0];
    [button addTarget:self action:alertAction forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    return classLabel;
}

-(UILabel *)createClassView:(NSString *)title content:(NSString *)content startY:(CGFloat)y
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(8,y, SCREEN_WIDTH-16, 47)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius =5;
    view.layer.masksToBounds = YES;
    [self.scroller addSubview:view];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 92, 47)];
    label.text = title;
    label.textColor = [UtilManager getColorWithHexString:@"#353535"];
    label.font = [UIFont systemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    UIView *div = [[UIView alloc] initWithFrame:CGRectMake(92, 0, 0.5, 47)];
    
    div.backgroundColor = [UtilManager getColorWithHexString:@"#cecece"];
    [view addSubview:div];
    
    UILabel *classLabel = [[UILabel alloc] initWithFrame:CGRectMake(110.5,0,SCREEN_WIDTH-16-110.5, 47)];
    classLabel.textColor = [UtilManager getColorWithHexString:@"#353535"];
    classLabel.font = [UIFont systemFontOfSize:18];
    classLabel.text = content;
    [view addSubview:classLabel];
    
    return classLabel;
}

#pragma mark Image Collection
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  self.imageArray.count+1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    UIImageView *iv = (UIImageView *)[cell viewWithTag:5];
    if (!iv) {
        iv = [[UIImageView alloc] initWithFrame:cell.bounds];
        [cell addSubview:iv];
    }
    if (indexPath.row == self.imageArray.count) {
        iv.image = [UtilManager imageNamed:@"tianjia"];
    }else{
        UIImage *image = [self.imageArray objectAtIndex:indexPath.row];
        iv.image = image;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==self.imageArray.count) {
        if (self.imageArray.count== LIMIT_MAX) {
            [self showHint:[NSString stringWithFormat:@"最多添加%d涨图片",LIMIT_MAX]];
            return;
        }
        PhotoSelectedAlertView *view = [[PhotoSelectedAlertView alloc] init];
        view.delegate = self;
        [view show];
    }
}

-(void)PhotoSelectedAlbum
{
    DoImagePickerController *cont = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
    cont.delegate = self;
    cont.nResultType = DO_PICKER_RESULT_UIIMAGE;
    cont.nMaxCount = LIMIT_MAX-self.imageArray.count;
    
    cont.nColumnCount = 4;
    
    [self presentViewController:cont animated:YES completion:nil];
}

#pragma mark - DoImagePickerControllerDelegate
- (void)didCancelDoImagePickerController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectPhotosFromDoImagePickerController:(DoImagePickerController *)picker result:(NSArray *)aSelected
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (picker.nResultType == DO_PICKER_RESULT_UIIMAGE)
    {
        if(self.imageArray.count == LIMIT_MAX)
        {
            [self.imageArray removeAllObjects];
        }
        for (UIImage *image in aSelected) {
            [self.imageArray addObject:image];
        }
        [self reframeCollection];
        [self.imageCollectionView reloadData];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *_avatar = info[UIImagePickerControllerOriginalImage];
    [self.imageArray addObject:_avatar];
    [self reframeCollection];
    [self.imageCollectionView reloadData];
    
    //处理完毕，回到个人信息页面
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)PhotoSelectedCarema
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        if (![self getAVAuthorizationStatus]) {
            return;
        }
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

- (BOOL)getAVAuthorizationStatus{
    
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if(authStatus == AVAuthorizationStatusAuthorized || authStatus == AVAuthorizationStatusNotDetermined)
    {
        return YES;
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法使用相机" message:@"请在iPhone的\"设置-隐私-相机\"中允许访问相机。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
}


-(void)tapScroller
{
    [self.titleField    endEditing:YES];
    [self.contentField  endEditing:YES];
    [self downTimePicker];
}

@end
