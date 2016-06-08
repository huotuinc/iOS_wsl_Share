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

@property(nonatomic,strong) UIButton * adButton;

@property(nonatomic,strong) UIImageView * adImage;


@end

@implementation AppDelegate


static NSString *channel = @"Publish channel";
static BOOL isProduction = FALSE;



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


- (void)setJPush{
    
    
    //可以添加自定义categories
    [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    
    
    
    self.TodayPredictingNumber = [NSMutableDictionary dictionaryWithObject:@(0) forKey:@"today"];
    
    [JPUSHService setupWithOption:launchOptions appKey:JPushAppKey
                          channel:channel apsForProduction:isProduction];
    
    
    
    
    InitModel * initModel = [self AppInit:application];
    
    if ([self isFirstLoad]) {
        self.isflag = YES;
    }else{
        self.isflag = NO;
        
    }
    
    LWLog(@"%@",[initModel mj_keyValues]);
    
    if (initModel) {
        if (![initModel.loginStatus intValue]) {//没登入
            [self setUp:initModel];
        }else{//登入
            [self SetupLoginIn];
        }
    }else{
        [self setUp:initModel];
    }
    return YES;
    
}


- (void)setupInitNew:(InitModel *) model{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];

    UINavigationController * nav = [[UINavigationController alloc] init];
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
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
    LoginViewController * login = [story instantiateViewControllerWithIdentifier:@"LoginViewController"];
//    XMGLoginRegisterViewController * vc = [[XMGLoginRegisterViewController alloc] init];
    UINavigationController * nac = [[UINavigationController alloc] initWithRootViewController:login];
    
//    ViewController * vc = [story instantiateViewControllerWithIdentifier:@"ViewController"];
    self.window.rootViewController = nac;
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
 *  初始化git 测试接口
 *
 *  @param application <#application description#>
 *
 *  @return <#return value description#>
 */
- (InitModel *)AppInit:(UIApplication *)application{

    //极光s推送
    [self setJPush];
    
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [ShareSDK registerApp:WslShareSdkAppId
     
          activePlatforms:@[@(SSDKPlatformTypeWechat),
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
    LWLog(@"%@",[parames mj_keyValues]);
    NSDictionary * dict = [UserLoginTool LogingetDateSyncWith:@"init" WithParame:parames];
    LWLog(@"%@---%@",dict[@"description"],dict);
    UserModel * user = [UserModel mj_objectWithKeyValues:dict[@"resultData"][@"userData"]];
    [UserLoginTool LoginModelWriteToShaHe:user andFileName:RegistUserDate];
    InitModel * model = [InitModel mj_objectWithKeyValues:dict[@"resultData"]];
    [UserLoginTool LoginModelWriteToShaHe:model andFileName:InitModelCaches];
    LWLog(@"model _-- tesr%@",[model mj_keyValues]);
    //商城地址
    if (dict[@"resultData"][@"website"]) {
        [[NSUserDefaults standardUserDefaults] setObject:(dict[@"resultData"][@"website"]) forKey:WebSit];
    }
    
    //判断登陆
    self.isHaveLogin = model.loginStatus;
    
    if ([model.loginStatus integerValue]) {//获取支付参数
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



- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    LWLog(@"%@", [deviceToken description]);
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    NSString * myDeviceToken = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"%@",myDeviceToken);
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
    LWLog(@"%@----%s",[error description],__func__);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    LWLog(@"收到通ss知:%@",[self logDic:userInfo]);
    
    LWLog(@"%@",userInfo);
    if ([[userInfo allKeys] containsObject:@"type"]) {
        
        LWLog(@"xxx");
        NSInteger a = [userInfo[@"type"] integerValue] + 1;
        [self.TodayPredictingNumber  setValue:@(a) forKey:@"today"];
        LWLog(@"%@",self.TodayPredictingNumber);
    }
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"推送通知" message:userInfo[@"aps"][@"alert"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    LWLog(@"%@",userInfo);
    if ([[userInfo allKeys] containsObject:@"type"]) {
        LWLog(@"%@",self.TodayPredictingNumber);
        NSInteger a = [userInfo[@"type"] integerValue] + 1;
        
        [self.TodayPredictingNumber setValue:[NSString stringWithFormat:@"%ld",(long)a] forKey:@"today"];
        
//        [self.TodayPredictingNumber setValue:@(a) forKey:@"type"];
        LWLog(@"%@",self.TodayPredictingNumber);
    }
     completionHandler(UIBackgroundFetchResultNewData);
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    
    
    
    UIImageView * ad = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"414x736-3"]];
    [ad sizeToFit];
    [[UIApplication sharedApplication].keyWindow addSubview:ad];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    _adButton = btn;
    _adImage = ad;
    btn.frame = CGRectMake(ScreenWidth - 100, 20, 80, 30);
    btn.alpha = 0.7;
    [btn setBackgroundColor:[UIColor blackColor]];
    [btn addTarget:self action:@selector(JumpAd) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"跳过广告" forState:UIControlStateNormal];
    [[UIApplication sharedApplication].keyWindow addSubview:btn];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:2.0 animations:^{
            ad.alpha = 0.0;
            btn.alpha = 0.0;
        } completion:^(BOOL finished) {
            
            [btn removeFromSuperview];
            [ad removeFromSuperview];
        }];
    });
}

-(void)JumpAd{
    
    [_adImage removeFromSuperview];
    [_adButton removeFromSuperview];
    
}



// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *str =
    [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:nil error:nil];
    
    return str;
}

@end
