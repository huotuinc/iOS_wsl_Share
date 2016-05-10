//
//  ViewController.m
//  loveshare
//
//  Created by luohaibo on 16/3/4.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "ViewController.h"





@interface ViewController ()<WXApiDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *lauchImage;

@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
- (IBAction)phoneBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *WeChatBtn;

@property (weak, nonatomic) IBOutlet UIButton *WeChatBtnClick;

- (IBAction)WeChatBtnLoginClick:(id)sender;

@end

@implementation ViewController

- (void)setUp{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
       if (status == AFNetworkReachabilityStatusNotReachable || status ==AFNetworkReachabilityStatusUnknown) {
            [MBProgressHUD showError:@"当前网络状态断开"];
        }
    }];
    
    self.phoneBtn.layer.borderWidth = 1;
    self.phoneBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.phoneBtn.layer.cornerRadius = 5;
    self.phoneBtn.layer.masksToBounds = YES;
    self.phoneBtn.hidden = YES;
    
    self.WeChatBtn.layer.borderWidth = 1;
    self.WeChatBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.WeChatBtn.layer.cornerRadius = 5;
    self.WeChatBtn.layer.masksToBounds = YES;
    self.WeChatBtn.hidden = YES;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setUp];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //没有登录的情况
    self.phoneBtn.hidden = NO;
    if ([WXApi isWXAppInstalled]) {
        self.WeChatBtn.hidden = NO;
     }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
   
}

- (IBAction)phoneBtnClick:(id)sender {
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
   AccountLoginViewController * vc = [story instantiateViewControllerWithIdentifier:@"AccountLoginViewController"];
     LWNavigationController * nav = [[LWNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)WeChatBtnLoginClick:(id)sender {
    LWLog(@"weix");
    __weak ViewController * wself = self;
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess) {
            LWLog(@"-------%@",[user.rawData mj_keyValues]);
            WeiQAuthModel * model = [WeiQAuthModel WeiQAuthModelWithDict:[user.rawData mj_keyValues]];
            [wself TodoWeChatBack:model];
//            [MBProgressHUD hideHUD];
        }else {
//            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"微信授权失败"];
            LWLog(@"%@",error);
        }
    }];
}

- (void)TodoWeChatBack:(WeiQAuthModel*)model{
    [MBProgressHUD showMessage:nil];
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    LWLog(@"%@",model.unionid);
    parame[@"unionId"] = model.unionid;
    NSDictionary * dict = [UserLoginTool LogingetDateSyncWith:@"VerifyRegister" WithParame:parame];
    LWLog(@"%s---%@",__func__,dict);
    [MBProgressHUD hideHUD];
    if (![dict[@"tip"] isEqualToString:@"未注册"]) {//已注册
        [MBProgressHUD hideHUD];
        NSMutableDictionary *parame = [NSMutableDictionary dictionary];
        //    parame[@"sex"] = [NSString stringWithFormat:@"%ld",(long)[user.sex integerValue]];
        parame[@"nickname"] = model.nickname;
        parame[@"openid"] = model.openid;
        parame[@"picUrl"] = model.headimgurl;
        parame[@"unionId"] = model.unionid;
        parame[@"invitationCode"] = @"";
        NSDictionary * dict = [UserLoginTool LogingetDateSyncWith:@"register" WithParame:parame];
        LWLog(@"%@",dict);
        if([dict[@"status"] integerValue] == 1 &&[dict[@"resultCode"] integerValue] == 1){
            [[NSUserDefaults standardUserDefaults] setObject:dict[@"resultData"][@"mallUserId"] forKey:ChoneMallAccount];
            UserModel * userInfo = [UserModel mj_objectWithKeyValues:dict[@"resultData"]];
            [UserLoginTool LoginModelWriteToShaHe:[UserModel mj_objectWithKeyValues:userInfo] andFileName:RegistUserDate];
            [self SetupLoginIn];
            NSMutableDictionary * newPareme  = [NSMutableDictionary dictionary];
            newPareme[@"loginCode"] = userInfo.loginCode;
            [UserLoginTool loginRequestGet:@"GETUSERINFO" parame:newPareme success:^(id json) {
                LWLog(@"%@",json);
                UserModel * user = [UserModel mj_objectWithKeyValues:json[@"resultData"]];
                if (user) {
                    [UserLoginTool LoginModelWriteToShaHe:user andFileName:RegistUserDate];
                    NSMutableDictionary * dc = [NSMutableDictionary dictionary];
                    dc[@"loginCode"] = user.loginCode;
                    dc[@"unionId"] = user.unionId;
                    //获取商城用户列表
                    [UserLoginTool loginRequestGet:@"GetUserList" parame:dc success:^(id json) {
                        LWLog(@"%@",json);
                        NSArray * UserList = [MallUser mj_objectArrayWithKeyValuesArray:json[@"resultData"]];
                        if (UserList.count == 1) {
                            MallUser * user =  [UserList firstObject];
                            ;
                            LWLog(@"%@",user.userid);
                            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",user.userid] forKey:ChoneMallAccount];
                            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",user.wxUnionId] forKey:PhoneLoginunionid];
                        }else{
                            //创建归档辅助类
                            NSMutableData *data = [[NSMutableData alloc] init];
                            //创建归档辅助类
                            NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
                            //编码
                            [archiver encodeObject:UserList forKey:MallUesrList];
                            //结束编码
                            [archiver finishEncoding];
                            NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                            NSString * filename = [[array objectAtIndex:0] stringByAppendingPathComponent:MallUesrList];
                            //写入
                            [data writeToFile:filename atomically:YES];
                        }
                        
                    } failure:nil];
                    
                }
            } failure:nil];
        }
        
        
    }else{//未注册
        WeiXinBackViewController * vc = [UserLoginTool LoginCreateControllerWithNameOfStory:nil andControllerIdentify:@"WeiXinBackViewController"];
        vc.model = model;
        LWNavigationController * nav = [[LWNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
        [MBProgressHUD hideHUD];
    }
}

/**
 *  2、程序启动控制器的选择
 */
- (void)SetupLoginIn{
    MMRootViewController * root = [[MMRootViewController alloc] init];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = root;
    [window makeKeyAndVisible];
}


@end
