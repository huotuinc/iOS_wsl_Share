//
//  LoginViewController.m
//  Fanmore
//
//  Created by lhb on 15/12/4.
//  Copyright © 2015年 Cai Jiang. All rights reserved.
//  邀请码注册控制器

#import "LoginViewController.h"
#import "MD5Encryption.h"
#import "RegisterViewController.h"
@interface LoginViewController ()


@property (weak, nonatomic) IBOutlet UITextField *phoneNumberText;

@property (weak, nonatomic) IBOutlet UITextField *passwdText;

- (IBAction)forgetButton:(id)sender;


- (IBAction)loginButton:(id)sender;


- (IBAction)registerButton:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
   
}




- (void)setup{
    self.title = @"登录";
    //设置标题样式
    NSMutableDictionary * textAttr = [NSMutableDictionary dictionary];
    textAttr[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:textAttr];
    
}



- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self.phoneNumberText becomeFirstResponder];
}

- (IBAction)forgetButton:(id)sender {
    RegisterViewController * login = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    login.isForgerPasswd = YES;
    [self.navigationController pushViewController:login animated:YES];
    LWLog(@"忘记密码");
}

- (IBAction)loginButton:(id)sender {
    if (!self.phoneNumberText.text.length) {
        [MBProgressHUD showError:@"手机号为空"];
        return;
    }
    if (!self.passwdText.text.length) {
        [MBProgressHUD showError:@"密码为空"];
        return;
    }
    NSMutableDictionary* p = [NSMutableDictionary dictionary];
    p[@"userName"] = self.phoneNumberText.text;
    p[@"pwd"] = [MD5Encryption md5by32:self.passwdText.text];
    [MBProgressHUD showMessage:@"登陆中"];
    NSDictionary * dict = [UserLoginTool LogingetDateSyncWith:@"Login" WithParame:p];
    LWLog(@"%@",dict);
    [MBProgressHUD hideHUD];
    if ([[dict objectForKey:@"status"] integerValue] && [[dict objectForKey:@"resultCode"] integerValue]) {
        UserModel * userModel = [UserModel mj_objectWithKeyValues:dict[@"resultData"]];
        [UserLoginTool LoginModelWriteToShaHe:userModel andFileName:RegistUserDate];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",userModel.mallUserId] forKey:ChoneMallAccount];
        [[NSUserDefaults standardUserDefaults] setObject:userModel.unionId forKey:PhoneLoginunionid];
        MMRootViewController * root = [[MMRootViewController alloc] init];
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        window.rootViewController = root;
        [window makeKeyAndVisible];
        
    }else{
        [MBProgressHUD showError:[dict objectForKey:@"tip"]];
    }
 }

- (IBAction)registerButton:(id)sender {
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
