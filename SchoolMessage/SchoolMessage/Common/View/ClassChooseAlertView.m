//
//  ZoneTagIntroduction.m
//  WhistleIm
//
//  Created by LI on 14-12-12.
//  Copyright (c) 2014年 Ruijie. All rights reserved.
//

#import "ClassChooseAlertView.h"
@interface ClassChooseAlertView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UIView *alertView;

@property (nonatomic,strong)NSArray *data;

@property (nonatomic, strong) UIWindow * zoneWindow;

@property (nonatomic, strong) NSString  * classId;

@property (nonatomic) ClassChooseAlertType type;

@end

@implementation ClassChooseAlertView


-(instancetype)initWithDic:(NSArray *)array classID:(NSString *)classId type:(ClassChooseAlertType)type
{
    self= [super init];
    if (self) {
        self.data = array;
        self.classId = classId;
        self.type = type;
        [self initSelf];
    }
    
    return self;
}

-(void)initSelf
{
    self.frame = [UIScreen mainScreen].bounds;
    CGFloat h = 53+20+(self.data.count*49.5);
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:self.frame];
    iv.image =  [UIImage imageNamed:@"customAlertBG.png"];
    iv.userInteractionEnabled = YES;
    iv.clipsToBounds = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(31,18, 100, 20)];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.text = @"年级";
    titleLabel.textColor = [UtilManager getColorWithHexString:@"#18b4ed"];
    
    UIView *div = [[UIView alloc] initWithFrame:CGRectMake(20, 51, 260,2)];
    div.backgroundColor = [UtilManager getColorWithHexString:@"#aaaaaa"];
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(20,53,260,self.data.count*49.5)];
    tableview.scrollEnabled = NO;
    tableview.dataSource = self;
    tableview.delegate =self;
    tableview.backgroundColor = [UIColor clearColor];
    
    self.alertView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-300)/2,(SCREEN_HEIGHT-h)/2, 300,h)];
    self.alertView.backgroundColor = [UIColor whiteColor];
    
    [self.alertView addSubview:titleLabel];
    [self.alertView addSubview:div];
    [self.alertView addSubview:tableview];
    self.alertView.clipsToBounds = NO;//
    
    [self addSubview:iv];
    [self addSubview:self.alertView];

}

-(NSString *)getAlertTitle
{
    switch (self.type) {
        case ClassChoose:
            
            return @"年级";
        case SujectChoose:
            
            return @"科目";
            
        default:
            break;
    }
    return @"";
}


- (void)show
{
    self.zoneWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.zoneWindow.windowLevel = UIWindowLevelStatusBar + 1;
    self.zoneWindow.opaque = NO;
    [self.zoneWindow addSubview:self];
    [self.zoneWindow makeKeyAndVisible];
    
    self.alpha = 0.0f;
    [UIView animateWithDuration:0.125 animations:^{
        self.alertView.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1.0);
        self.alpha = 0.5f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.125 animations:^{
            self.alertView.layer.transform = CATransform3DIdentity;
            self.alpha = 1.0f;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.data objectAtIndex:indexPath.row];
    [self dismiss:dic];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49.5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"UITableViewc";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 16, 200, 20)];
        titleLabel.tag = 1;
        titleLabel.font = [UIFont systemFontOfSize:19];
        [cell addSubview:titleLabel];
        
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(260-9-30,8, 30, 30)];
        iv.tag = 2;
        [cell addSubview:iv];
        
        UIView *div = [[UIView alloc] initWithFrame:CGRectMake(0,48.5, 260, 1)];
        div.backgroundColor = [UtilManager getColorWithHexString:@"d6d6d6"];
        [cell addSubview:div];
    }
    NSDictionary *dic = [self.data objectAtIndex:indexPath.row];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
    titleLabel.text = [self titleString:dic];
    
    UIImageView *iv = (UIImageView *)[cell viewWithTag:2];
    NSString *cid = [self idString:dic];
    if ([cid isEqualToString:self.classId]) {
        iv.image = [UtilManager imageNamed:@"xuanzhong"];
    }else{
        iv.image = [UtilManager imageNamed:@"weixuanzhong"];
    }
    
    return cell;
}

-(NSString *)titleString:(NSDictionary *)dic
{
    switch (self.type) {
        case ClassChoose:
            
            return [NSString stringWithFormat: @"%@%@",[dic objectForKey:@"GradeName"],[dic objectForKey:@"ClassName"]];
        case SujectChoose:
            
            return [dic objectForKey:@"SubjectName"];
            
        default:
            break;
    }
    return @"";
}

-(NSString *)idString:(NSDictionary *)dic
{
    switch (self.type) {
        case ClassChoose:
            
            return ((NSNumber *)[dic objectForKey:@"ClassId"]).stringValue;
        case SujectChoose:
            
            return ((NSNumber *)[dic objectForKey:@"SubjectId"]).stringValue;
            
        default:
            break;
    }
    return @"";
}

- (void) hide
{
    [self hidden];
}

- (void)hidden
{
    [UIView animateWithDuration:0.1 animations:^{
        self.alertView.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1.0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            self.alertView.layer.transform = CATransform3DIdentity;
            self.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self cleanup];
        }];
    }];
}

- (void)cleanup {
    self.alertView.layer.transform = CATransform3DIdentity;
    self.alertView.transform = CGAffineTransformIdentity;
    [self removeFromSuperview];
    self.zoneWindow = nil;
    // rekey main AppDelegate window
    [[[[UIApplication sharedApplication] delegate] window] makeKeyWindow];
    
}

-(void)dismiss:(NSDictionary *)dic
{
    [self hidden];
    if (self.delegate && [self.delegate respondsToSelector:@selector(ClassChooseOnDisMiss:)]) {
        [self.delegate ClassChooseOnDisMiss:dic];
    }
}

@end
