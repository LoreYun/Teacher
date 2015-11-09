//
//  ContactLocalManger.m
//  SchoolMessage
//
//  Created by wulin on 15/2/8.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "ContactLocalManger.h"
#import "JSONKit.h"

#define SAVE @"ContctS_List"
#define FIRST @"fffff"
#import "MBProgressHUD+Add.h"

@interface ContactLocalManger ()

@property (nonatomic,strong) NSMutableArray *data;

@end

@implementation ContactLocalManger

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.data = [NSMutableArray array];
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)uploadContactInfos:(void (^)(BOOL))callback
{
    NSDictionary * dic = @{@"1":@"5",@"2":[[AccountManager sharedInstance].LoginInfos getTeacherId],@"3":@"",@"4":@"",@"5":[[NSArray arrayWithArray:self.data] JSONString]};
    [[ObjectManager sharedInstance] requestDataOnPost:dic ByFlag:@"602" callback:^(BOOL succeed, NSDictionary *result) {
        if (succeed) {
            succeed = ((NSNumber *)[result objectForKey:S_SUCCESS]).boolValue;
        }
        callback(succeed);
    }];
}

-(void)DownloadContactInfos:(void (^)(BOOL))callback
{
    NSDictionary * dic = @{@"1":@"5",@"2":[[AccountManager sharedInstance].LoginInfos getTeacherId]};
    [[ObjectManager sharedInstance] requestDataOnPost:dic ByFlag:@"603" callback:^(BOOL succeed, NSDictionary *result) {
        if (succeed) {
            succeed = ((NSNumber *)[result objectForKey:S_SUCCESS]).boolValue;
        }
        if (succeed) {
            NSString *temp = [[result objectForKey:S_OBJ] objectForKey:@"PhoneContent"];
            NSLog(@"temp %@",temp);
            NSMutableArray *array = [NSMutableArray array];
            
            for (NSDictionary *dic in [temp objectFromJSONString]) {
                [array addObject:[NSMutableDictionary dictionaryWithDictionary:dic]];
            }
            
            if (array.count >0) {
                [self saveContactInfos:array];
            }else
            {
                [[ContactLocalManger sharedInstance] showHint:@"通讯录未备份!"];
            }
            
        }
        callback(succeed);
    }];
}

- (void)showHint:(NSString *)hint {
    if ([hint isEqualToString:@"录音没有开始"]) {
        NSLog(@"dd");
    }
    
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    hud.yOffset = IS_IPHONE_5?200.f:150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}



-(NSMutableArray *)getLoaclContactInfos
{
    if (!self.data) {
        self.data= [NSMutableArray array];
    }
    if (self.data.count ==0) {
        NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:[self getKeyString]];
        for (NSDictionary *dic in array) {
            [self.data addObject:[NSMutableDictionary dictionaryWithDictionary:dic]];
        }
    }
    
    return self.data;
}

-(void)saveContactInfos:(NSArray *)array
{
    [self.data removeAllObjects];
    for (NSDictionary *dic in array) {
        [self.data addObject:[NSMutableDictionary dictionaryWithDictionary:dic]];
    }
    [self saveLoaclContactInfos];
}

-(void)saveLoaclContactInfos
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSArray arrayWithArray:self.data] forKey:[self getKeyString]];
}

-(NSString *)getKeyString
{
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:USER_NAME_SAVE];
    return [NSString stringWithFormat:@"%@%@",username,SAVE];
}

-(BOOL)IsFirst
{
     NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:USER_NAME_SAVE];
    
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@",username,FIRST]];
    
    return number?number.boolValue:YES;
}

-(void)setFirst
{
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:USER_NAME_SAVE];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:[NSString stringWithFormat:@"%@%@",username,FIRST]];
}

-(void)addNewContactInfo:(NSString *)classId name:(NSString *)name phone:(NSString *)phone
{
    NSDictionary *dic = @{@"Mobile":phone,@"NickName":@"",@"Relation":name,@"StudentName":@""};
    [self.data addObject:[NSMutableDictionary dictionaryWithDictionary:dic]];
}

-(void)deleteContactInfo:(NSString *)classId name:(NSString *)name phone:(NSString *)phone
{
    NSDictionary *dic = [self getDataByMobile:phone];
    [self.data removeObject:dic];
}

-(void)editContactInfo:(NSString *)classId name:(NSString *)name phone:(NSString *)phone
{
    NSDictionary *dic = [self getDataByMobile:phone];
    [dic setValue:name forKey:@"Relation"];
    [dic setValue:phone forKey:@"Mobile"];
}

-(NSDictionary *)getDataByMobile:(NSString *)phone
{
    for (NSDictionary *dic in self.data) {
        if ([[dic objectForKey:@"Mobile"] isEqualToString:phone]) {
            return dic;
        }
    }
    
    return nil;
}

@end
