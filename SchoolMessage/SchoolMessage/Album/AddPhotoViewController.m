//
//  AddPhotoViewController.m
//  SchoolMessage
//
//  Created by LI on 15/2/4.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "AddPhotoViewController.h"
#import "EMTextView.h"
#import "AlbumManager.h"
#import "PhotoSelectedAlertView.h"
#import "AssetHelper.h"
#import "DoImagePickerController.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"



static NSString *identifier = @"clAddPhotoViewControllersl1l";

@interface AddPhotoViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,PhotoSelectedAlertViewDalegate,DoImagePickerControllerDelegate>

@property (nonatomic,strong) EMTextView *descriptionTextView;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *imageButton;

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *photoDataSource;

@property (nonatomic,assign) NSInteger          currentUploadNum;

@property (nonatomic,assign) BOOL           isSending;
@property (nonatomic,strong) NSString           *uploadString;

@end

@implementation AddPhotoViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"添加照片";
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(0, 0, 44, 44);
    [addBtn setTitle:@"保存" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
    self.navigationItem.rightBarButtonItem = addItem;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:self.view.frame];
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
//    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)]];
//    self.view.userInteractionEnabled = YES;
    
    self.photoDataSource = [NSMutableArray array];
    
    self.descriptionTextView = [[EMTextView alloc] initWithFrame:CGRectMake(20, 31, SCREEN_WIDTH-40, 136)];
    self.descriptionTextView.layer.cornerRadius = 6;
    self.descriptionTextView.layer.borderColor = [UtilManager getColorWithHexString:@"#a9b1b4"].CGColor;
    self.descriptionTextView.layer.borderWidth =1;
    self.descriptionTextView.layer.masksToBounds = YES;
    self.descriptionTextView.contentInset = UIEdgeInsetsMake(15, 4, 15, 4);
    self.descriptionTextView.textColor = [UtilManager getColorWithHexString:@"#333333"];
//    self.descriptionTextView
    self.descriptionTextView.placeholder = @"请输入图片描述";
    self.descriptionTextView.placeholderColor = [UtilManager getColorWithHexString:@"#8e8e8e"];
    self.descriptionTextView.font = [UIFont systemFontOfSize:18];
    
    [self.view addSubview:self.descriptionTextView];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH-40-11*2-14)/3,(SCREEN_WIDTH-40-11*2-14)/3);
    flowLayout.minimumInteritemSpacing = 11;
    flowLayout.minimumLineSpacing = 11;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 189, SCREEN_WIDTH-40, (SCREEN_WIDTH-40-11*2-14)/3+14) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.layer.cornerRadius = 6;
    self.collectionView.layer.borderColor = [UtilManager getColorWithHexString:@"#939999"].CGColor;
    self.collectionView.layer.borderWidth =0.5;
    self.collectionView.layer.masksToBounds = YES;
    self.collectionView.contentInset = UIEdgeInsetsMake(5, 7, 5, 7);
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifier];
    [self.view addSubview:self.collectionView];
}


-(void)commit:(id)sender
{
    if (self.photoDataSource.count==0) {
        [self showHint:@"请选择图片"];
        return;
    }
    if (self.isSending) {
        [self showHint:@"图片上传中"];
        return;
    }
    
    self.isSending = YES;
    
    [self showHudInView:self.view hint:@"图片上传中"];
    
    __weak AddPhotoViewController *con = self;
    con.uploadString = @"";
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.currentUploadNum = 0;
        [con UploadImages:^(BOOL result) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (result) {
                     NSString *describtion = [self.descriptionTextView.text isEqualToString:@"请输入图片描述"] ?@"":self.descriptionTextView.text;
                    [[AlbumManager sharedInstance] addPhotoInAlbum:[[AccountManager sharedInstance].LoginInfos getTeacherId]
                                                       teacherName:[[AccountManager sharedInstance].LoginInfos getTeacherName]
                                                           classId:[self.classNameData objectForKey:S_ClASSID]
                                                         className:[self.classNameData objectForKey:S_CLASSNAME]
                                                           gradeId:[self.classNameData objectForKey:S_GRADEID]
                                                         gradeName:[self.classNameData objectForKey:S_GRADENAME]
                                                          fileName:@""
                                                          fullName:self.uploadString
                                                       describtion:describtion
                                                           albumId:self.albumId callback:^(BOOL succeed, NSDictionary *data) {
                                                               if (succeed) {
                                                                   succeed = ((NSNumber *)[data objectForKey:S_SUCCESS]).boolValue;
                                                               }
                                                               if (succeed) {
                                                                   [con showHint:@"上传成功"];
                                                                   [con.navigationController popViewControllerAnimated:YES];
                                                               }else
                                                               {
                                                                   [con showHint:@"上传失败,请检查网络"];
                                                               }
                                                           }];
                }else
                {
                    NSLog(@"sendNewImageToServer falid");
                    con.uploadString = @"";
                    con.currentUploadNum = 0;
                    con.isSending = NO;
                    
                    [con hideHud];
                    [con showHint:@"图片上传失败，请检查网络"];
                    
                }
            });
            
        }];

    });
}

-(void)UploadImages:(void (^)(BOOL))callback;
{
    __weak AddPhotoViewController *con = self;
    UIImage *image = [self.photoDataSource objectAtIndex:self.currentUploadNum];
    
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
            
            if (con.currentUploadNum == con.photoDataSource.count) {
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  self.photoDataSource.count+1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    UIImageView *iv = (UIImageView *)[cell viewWithTag:5];
    if (!iv) {
        iv = [[UIImageView alloc] initWithFrame:cell.bounds];
        iv.tag =5;
        [cell addSubview:iv];
    }
    
    if (indexPath.row==(self.photoDataSource.count)) {
        iv.image = [UtilManager imageNamed:@"tianjia"];
    }else
    {
        iv.image = [self.photoDataSource objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==self.photoDataSource.count) {
        if (self.photoDataSource.count==9) {
            [self showHint:@"最多添加9涨图片"];
            return;
        }
        PhotoSelectedAlertView *view = [[PhotoSelectedAlertView alloc] init];
        view.delegate = self;
        [view show];
    }else
    {
//        int count = self.photoDataSource.count;
//        // 1.封装图片数据
//        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
//        for (int i = 0; i<count; i++) {
//            UIImage *imagesrc = [self.photoDataSource objectAtIndex:indexPath.row];
//            MJPhoto *photo = [[MJPhoto alloc] init];
//            photo.image = imagesrc; // 图片路径
//            photo.comment = @"";
//            [photos addObject:photo];
//        }
//        
//        // 2.显示相册
//        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
//        browser.currentPhotoIndex = indexPath.row; // 弹出相册时显示的第一张图片是？
//        browser.photos = photos; // 设置所有的图片
//        [browser show];
    }
}

-(void)PhotoSelectedAlbum
{
    DoImagePickerController *cont = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
    cont.delegate = self;
    cont.nResultType = DO_PICKER_RESULT_UIIMAGE;
    cont.nMaxCount = 9-self.photoDataSource.count;
    
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
        [self.photoDataSource removeAllObjects];
        for (UIImage *image in aSelected) {
            [self.photoDataSource addObject:image];
        }
        [self resizeCollectionView];
        [self.collectionView reloadData];
    }
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
    
    if(authStatus == AVAuthorizationStatusAuthorized)
    {
        return YES;
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法使用相机" message:@"请在iPhone的\"设置-隐私-相机\"中允许访问相机。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
}

-(void)resizeCollectionView
{
    if (self.photoDataSource.count+1<4) {
        self.collectionView.frame = CGRectMake(20, 189, SCREEN_WIDTH-40, (SCREEN_WIDTH-40-11*2-14)/3+14);
    }else
    {
        self.collectionView.frame = CGRectMake(20, 189, SCREEN_WIDTH-40, (SCREEN_WIDTH-40-11*2-14)*2/3+14+5);
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.photoDataSource addObject:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
    [self resizeCollectionView];
    [self.collectionView reloadData];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)upload {
    NSData *data = UIImageJPEGRepresentation(self.imageView.image , 0.01);
    
    [[ObjectManager sharedInstance] uploadImage2Server:data callback:^(BOOL succeed, NSDictionary *data) {
        if (succeed) {
            NSNumber *su = [data objectForKey:S_SUCCESS];
            if (su.boolValue) {
//                [self addNotifyreRuest:[data objectForKey:@"Msg"]];
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

-(void)hideKeyboard
{
    [self.descriptionTextView endEditing:YES];
}

@end
