//
//  LoginViewController.m
//  Fanmore
//
//  Created by lhb on 15/12/4.
//  Copyright © 2015年 Cai Jiang. All rights reserved.
//  邀请码注册控制器

#import "LoginViewController.h"

@interface LoginViewController ()


/**邀请码*/
@property (weak, nonatomic) IBOutlet UITextField *InviteCode;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView * left = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    left.image = [UIImage imageNamed:@"TextField"];
    self.InviteCode.leftViewMode = UITextFieldViewModeAlways;
    self.InviteCode.leftView = left;
    
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)setup{
//    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *fileName = [path stringByAppendingPathComponent:WXQAuthBringBackUserInfo];
//    UserInfo * user = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
//    self.user = user;
}

/**
 *  注册 luohaibo
 *
 *  @param sender <#sender description#>
 */
- (IBAction)login:(id)sender {

    [self.view endEditing:YES];
    if(self.callType== 1){//手机
        if (!self.InviteCode.text) {
            [MBProgressHUD showError:@"邀请码不能为空"];
            return;
        }
        [MBProgressHUD showMessage:nil];
        NSMutableDictionary * parame = [NSMutableDictionary dictionary];
        parame[@"mobile"] = self.PhoneNumber;
        parame[@"verifyCode"] = self.codeNumber;
        parame[@"invitationCode"] = self.InviteCode.text;
        NSDictionary * dict = [UserLoginTool LogingetDateSyncWith:@"MobileRegister" WithParame:parame];
        LWLog(@"%s-----%@",__func__,dict);
        [MBProgressHUD hideHUD];
        if ([dict[@"status"] intValue] == 1 && [dict[@"resultCode"] intValue] == 1) {
            [MBProgressHUD showSuccess:@"注册成功"];
            [[NSUserDefaults standardUserDefaults] setObject:dict[@"mallUserId"] forKey:ChoneMallAccount];
             [[NSUserDefaults standardUserDefaults] setObject:dict[@"unionid"] forKey:PhoneLoginunionid];
            UserModel * userModel = [UserModel mj_objectWithKeyValues:dict[@"resultData"]];
            [UserLoginTool LoginModelWriteToShaHe:userModel andFileName:RegistUserDate];
             [self SetupLoginIn];
        }else{
            
            [MBProgressHUD showError:dict[@"tip"]];
        }
    }else{//微信
        [MBProgressHUD showMessage:nil];
        NSMutableDictionary * parame = [NSMutableDictionary dictionary];
        parame[@"nickname"] = self.model.nickname;
        parame[@"openid"] = self.model.openid;
        //    parame[@"city"] = user.city;
        //    parame[@"country"] = user.country;
        //    parame[@"province"] = user.province;
        parame[@"picUrl"] = self.model.headimgurl;
        parame[@"unionId"] = self.model.unionid;
        parame[@"invitationCode"] = self.InviteCode.text;
        NSDictionary * dict = [UserLoginTool LogingetDateSyncWith:@"register" WithParame:parame];
        [MBProgressHUD hideHUD];
        LWLog(@"%s-----%@",__func__,dict);
        if ([dict[@"status"] intValue] == 1 && [dict[@"resultCode"] intValue] == 1) {
            [MBProgressHUD showSuccess:@"注册成功"];
            [[NSUserDefaults standardUserDefaults] setObject:dict[@"mallUserId"] forKey:ChoneMallAccount];
             [[NSUserDefaults standardUserDefaults] setObject:dict[@"unionid"] forKey:PhoneLoginunionid];
            UserModel * userModel = [UserModel mj_objectWithKeyValues:dict[@"resultData"]];
            NSMutableDictionary * dc = [NSMutableDictionary dictionary];
            dc[@"loginCode"] = userModel.loginCode;
            dc[@"unionId"] = userModel.unionId;
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
            [UserLoginTool LoginModelWriteToShaHe:userModel andFileName:RegistUserDate];
            [self SetupLoginIn];
        }else{
            [MBProgressHUD showError:dict[@"tip"]];
        }
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
