//
//  AppDelegate.m
//  loveshare
//
//  Created by lhb on 16/3/4.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL) isFirstLoad{
    
    //版本号
    NSString *currentVersion = AppVersion;//[[[NSBundle mainBundle] infoDictionary];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastRunVersion = [defaults objectForKey:LAST_RUN_VERSION_KEY];
    
    NSString* firstFlage = [defaults objectForKey:LAST_Flage_KEY]; //true
    
    if (!lastRunVersion || !firstFlage) {
        [defaults setObject:currentVersion forKey:LAST_RUN_VERSION_KEY];
        [defaults setObject:@"yes" forKey:LAST_Flage_KEY];
        return YES;
        // App is being run for first time
    }
    else if (![lastRunVersion isEqualToString:currentVersion] || ![firstFlage isEqualToString:@"yes"])
    {
        [defaults setObject:currentVersion forKey:LAST_RUN_VERSION_KEY];
        [defaults setObject:@"yes" forKey:LAST_Flage_KEY];
        return YES;
        // App has been updated since last run
    }
    return NO;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    InitModel * initModel = [self AppInit:application];
    if ([self isFirstLoad]) {
        self.flag = YES;
       
        [self setupInitNew:initModel];
       
    }else{
        self.flag = NO;
        if (initModel) {
            if (![initModel.loginStatus intValue]) {
                [self setUp:initModel];
            }else{
                [self SetupLoginIn];
            }
        }else{
            [self setUp:initModel];
        }
        return YES;
    }
    
    return YES;
}


- (void)setupInitNew:(InitModel *) model{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];

    LWNewFeatureController * nav = [[LWNewFeatureController alloc] init];
    self.window.rootViewController = nav;
    
    
}

/**
 *  1、程序启动控制器的选择
 *
 *  @param model <#model description#>
 */
- (void)setUp:(InitModel *) model{
    [UserLoginTool LoginModelWriteToShaHe:model andFileName:InitModelCaches];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ViewController * vc = [story instantiateViewControllerWithIdentifier:@"ViewController"];
    self.window.rootViewController = vc;
}


/**
 *  2、程序启动控制器的选择
 */
- (void)SetupLoginIn{
    MMRootViewController * root = [[MMRootViewController alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = root;
}


/**
 *  初始化接口
 *
 *  @param application <#application description#>
 *
 *  @return <#return value description#>
 */
- (InitModel *)AppInit:(UIApplication *)application{

    [ShareSDK registerApp:WslShareSdkAppId
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:Sina
                                           appSecret:SinaKey
                                         redirectUri:SinaredirectUri
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:WxAppID
                                       appSecret:WxAppSecret];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:QQ
                                      appKey:QQKET
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
    
    UserModel * usermodel = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    LWLog(@"%@",[usermodel mj_keyValues]);
    NSMutableDictionary * parames =  [NSMutableDictionary dictionary];
    parames[@"userName"] = (usermodel?usermodel.userName:@"");
    parames[@"pwd"] = (usermodel?usermodel.UserPassword:@"");
    LWLog(@"%@",(usermodel?usermodel.UserPassword:@""));
    NSDictionary * dict = [UserLoginTool LogingetDateSyncWith:@"init" WithParame:parames];
    LWLog(@"%@",dict);
    InitModel * model = [InitModel mj_objectWithKeyValues:dict[@"resultData"]];
    
    LWLog(@"model _-- tesr%@",[model mj_keyValues]);
    [[NSUserDefaults standardUserDefaults] setObject:(dict[@"resultData"][@"website"]) forKey:WebSit];
    if ([model.loginStatus integerValue]) {
        NSMutableDictionary * parame = [NSMutableDictionary dictionary];
        parame[@"loginCode"] = usermodel.loginCode;

        //获取支付参数
        [UserLoginTool loginRequestGet:@"PayConfig" parame:parame success:^(id json) {
            LWLog(@"%@",json);
            NSArray * payType = [PayModel mj_objectArrayWithKeyValuesArray:json[@"resultData"]];
            NSMutableData *data = [[NSMutableData alloc] init];
            //创建归档辅助类
            NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
            //编码
            [archiver encodeObject:payType forKey:PayTypeflat];
            //结束编码
            [archiver finishEncoding];
            NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString * filename = [[array objectAtIndex:0] stringByAppendingPathComponent:PayTypeflat];
            //写入
            [data writeToFile:filename atomically:YES];
            
        } failure:nil];
        
       
        
           }
    return model;
}






@end
