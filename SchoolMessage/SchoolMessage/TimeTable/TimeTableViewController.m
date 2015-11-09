//
//  TimeTableViewController.m
//  SchoolMessage
//
//  Created by LI on 15/2/9.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "TimeTableViewController.h"
#import "TimeTableCell.h"
#import "TimeTableAlertView.h"

@interface TimeTableViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) NSMutableArray *mainData;

@property (nonatomic,strong) UICollectionView  *collectionView;

@property (nonatomic) CGFloat cellWidth;
@property (nonatomic) CGFloat cellHegiht;

@end

@implementation TimeTableViewController
@synthesize cellHegiht,cellWidth;

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"课表";
    [self initRightImageBar:@"refresh" action:@selector(refreshTimeData:)];
    self.view.backgroundColor = [UIColor whiteColor];
    self.mainData = [NSMutableArray array];
    [self iniViews];
    
    [self refreshTimeData:nil];
}

-(void) iniViews
{
    cellWidth =(SCREEN_WIDTH-10.0f)/8.0f;
    cellHegiht = cellWidth /85.0f *100.0f;
    
    UIView *titleBar = [[UIView alloc] initWithFrame:CGRectMake(5, 20, SCREEN_WIDTH-10, cellHegiht)];
    titleBar.layer.borderColor = [UtilManager getColorWithHexString:@"#aaaaaa"].CGColor;
    titleBar.layer.borderWidth = 0.5;
    for (int i = 0; i<8; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*cellWidth, 0, cellWidth, cellHegiht)];
        [label setText:[self getWeekName:i]];
        label.textColor = [UtilManager getColorWithHexString:@"#18b4ed"];
        label.layer.borderColor = [UtilManager getColorWithHexString:@"#aaaaaa"].CGColor;
        label.layer.borderWidth = 0.5;
        label.textAlignment = NSTextAlignmentCenter;

        label.font = [UIFont systemFontOfSize:18];
        [titleBar addSubview:label];
    }
    [self.view addSubview:titleBar];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.itemSize = CGSizeMake(cellWidth,(cellWidth /85.0f *139.0f));
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5, 20+cellHegiht, SCREEN_WIDTH-10, SCREEN_HEIGHT-64-20-cellHegiht-20) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.layer.borderColor = [UtilManager getColorWithHexString:@"#aaaaaa"].CGColor;
    self.collectionView.layer.borderWidth = 0.5;
    [self.collectionView registerClass:[TimeTableCell class] forCellWithReuseIdentifier:[TimeTableCell identifier]];
    [self.view addSubview:self.collectionView];
    
}
-(NSString *)getWeekName:(int)index
{
    NSString * string = @"";
    
    switch (index) {
        case 1:
            string = @"一";
            break;
        case 2:
            string = @"二";
            break;
        case 3:
            string = @"三";
            break;
        case 4:
            string = @"四";
            break;
        case 5:
            string = @"五";
            break;
        case 6:
            string = @"六";
            break;
        case 7:
            string = @"日";
            break;
            
        default:
            break;
    }
    
    return string;
}

-(void)refreshTimeData:(id)sender
{
    [self showHudInView:self.view hint:@"获取课程信息"];
    
    NSDictionary * dic = @{@"1":[[AccountManager sharedInstance].LoginInfos getTeacherId]};
    
    [[ObjectManager sharedInstance] requestDataOnPost:dic ByFlag:@"801" callback:^(BOOL succeed, NSDictionary *data) {
        [self hideHud];
        if (succeed) {
            succeed = ((NSNumber *)[data objectForKey:S_SUCCESS]).boolValue;
        }
        if (succeed)
        {
            [self.mainData addObjectsFromArray:[data objectForKey:S_OBJ]];
            [self.collectionView reloadData];
        }else
        {
            [self showHint:@"操作失败，请检查网络"];
        }
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  64;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    TimeTableCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[TimeTableCell identifier] forIndexPath:indexPath];
    
    if (indexPath.row%8 ==0) {
        [cell setBlankContent:[NSString stringWithFormat:@"%d",(indexPath.row/8+1)]];
    }else
    {
        NSDictionary *dic = [self getDataByIndex:indexPath];
        NSString *color = [dic objectForKey:@"CellColor"];
        NSString *name = [dic objectForKey:S_SUBJECT_NAME] ;
        if (name.length==0) {
            [cell setBlankContent:@""];
        }else
        {
            [cell setContent:name color:color.length==0?@"ffffff":color];
        }
        
    }
    
    

    return cell;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%8 !=0) {
        NSDictionary *dic = [self getDataByIndex:indexPath];
        NSString *name = [dic objectForKey:S_SUBJECT_NAME] ;
        if (name.length!=0)
        {
            TimeTableAlertViewView *alerView = [[TimeTableAlertViewView alloc] initWithDic:dic];
            [alerView show];
        }
    }
}

-(NSDictionary *)getDataByIndex:(NSIndexPath *)indexPath
{
    if (self.mainData.count==0) {
        return nil;
    }
    NSDictionary * dic = [self.mainData objectAtIndex:(indexPath.row%8-1)];
    NSArray *array = [dic objectForKey:@"ScheduleCells"];
    return [array objectAtIndex:(indexPath.row/8)];
}

@end
