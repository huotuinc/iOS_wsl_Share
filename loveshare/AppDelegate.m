//
//  AppDelegate.m
//  loveshare
//
//  Created by lhb on 16/3/4.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "LBLaunchImageAdView.h"

@interface AppDelegate ()<WXApiDelegate>

@property(nonatomic,strong) UIButton * adButton;

@property(nonatomic,strong) UIImageView * adImage;



@end

@implementation AppDelegate


static NSString *channel = @"Publish channel";
static BOOL isProduction = YES;



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
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;;
    self.TodayPredictingNumber = [NSMutableDictionary dictionaryWithObject:@(0) forKey:@"today"];
    [JPUSHService setupWithOption:launchOptions appKey:JPushAppKey
                          channel:channel apsForProduction:isProduction];
    [self addAd];
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
            [self SetupLoginIn:initModel];
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
    if (self.isflag) {
        LWNewFeatureController * new = [[LWNewFeatureController alloc] init];
        self.window.rootViewController = new;
        [self.window makeKeyAndVisible];
    }else{
        UIStoryboard* story = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
        LoginViewController * login = [story instantiateViewControllerWithIdentifier:@"LoginViewController"];
        LWNavigationController * nac = [[LWNavigationController alloc] initWithRootViewController:login];
        self.window.rootViewController = nac;
        
        LWLog(@"%@",model.adimg);
        if(model.adimg.length){
            [self addAd];
        }
        [self.window makeKeyAndVisible];
    }
}


/**
 *  2、程序启动控制器的选择
 */
- (void)SetupLoginIn:(InitModel *) model{
    MMRootViewController * root = [[MMRootViewController alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = root;
    [self.window makeKeyAndVisible];
    
    LWLog(@"%@",model.adimg);
    if(model.adimg.length){
//        [self addAD:model.adimg andDetailUrl:model.adclick];
        [self addAd];
        
    }
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
    self.isHaveLogin = [model.loginStatus boolValue];
    
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
    if (myDeviceToken.length) {
        
        UserModel * usermodel = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
        NSMutableDictionary * parame = [NSMutableDictionary dictionary];
        parame[@"loginCode"] = usermodel.loginCode;
        parame[@"type"] = @"0";
        parame[@"token"] = myDeviceToken;
        //获取支付参数
        [UserLoginTool loginRequestGet:@"AddDeviceToken" parame:parame success:^(id json) {
            LWLog(@"%@",json);
        } failure:nil];
        [JPUSHService registerDeviceToken:deviceToken];
    }
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
        LWLog(@"%@",self.TodayPredictingNumber);
    }
     completionHandler(UIBackgroundFetchResultNewData);
    
}


- (void) addAd{
    InitModel * model = (InitModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:InitModelCaches];
    LWLog(@"%lu",(unsigned long)model.adimg.length);
    if (model.adimg.length) {// && [model.loginStatus intValue]
        //获取启动图片
        CGSize viewSize = self.window.bounds.size;
        //横屏请设置成 @"Landscape"
        NSString *viewOrientation = @"Portrait";
        NSString *launchImageName = nil;
        NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
        for (NSDictionary* dict in imagesDict)
        {
            CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
            if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
            {
                launchImageName = dict[@"UILaunchImageName"];
            }
            
        }
        LWLog(@"%@",launchImageName);
        UIImageView * ad = [[UIImageView alloc] initWithFrame:self.window.bounds];
        ad.userInteractionEnabled = YES;
        [ad addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(AdClick)]];
        [ad setImage:[UIImage imageNamed:launchImageName]];
        ad.contentMode = UIViewContentModeScaleAspectFit;
        [[UIApplication sharedApplication].keyWindow addSubview:ad];
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        _adButton = btn;
        _adImage = ad;
        btn.frame = CGRectMake(ScreenWidth - 80, 20, 50, 30);
        btn.alpha = 0.7;
        btn.hidden = YES;
        [btn setBackgroundColor:[UIColor blackColor]];
        [btn addTarget:self action:@selector(JumpAd) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"跳过广告" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:10];
        [[UIApplication sharedApplication].keyWindow addSubview:btn];
        SDWebImageManager * manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:model.adimg] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
         } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            [ad setImage:image];
            btn.hidden = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:1.0 animations:^{
                    ad.alpha = 0.0;
                    btn.alpha = 0.0;
                } completion:^(BOOL finished) {
                    
                    [btn removeFromSuperview];
                    [ad removeFromSuperview];
                }];
            });
            
        }];
        
        
    }

}


- (void)AdClick{
    [_adImage removeFromSuperview];
    [_adButton removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AdClick" object:self];
    
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
