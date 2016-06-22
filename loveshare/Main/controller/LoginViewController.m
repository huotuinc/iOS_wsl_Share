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
#import "RAYNewFunctionGuideVC.h"
#import "LoginChangePasswdViewController.h"

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
    textAttr[NSForegroundColorAttributeName] = [UIColor blackColor];
    [self.navigationController.navigationBar setTitleTextAttributes:textAttr];
    
}



- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    NSString * phoneNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"localPhoneNumber"];
    if (phoneNumber.length) {
        self.phoneNumberText.text = phoneNumber;
    }
    
   
//    //判断是否为第一次进入
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    
//    NSString *isFirstDatail = [defaults stringForKey:@"isFirstDatail"];
//    if (![isFirstDatail isEqualToString:@"1"]){
//        [defaults setObject:@"1" forKey:@"isFirstDatail"];
//        [defaults synchronize];
//        [self makeGuideView];
//    }
}

//- (void)makeGuideView{
//    RAYNewFunctionGuideVC *vc = [[RAYNewFunctionGuideVC alloc]init];
//    vc.titles = @[@"分享: 点击分享按钮可以对你喜欢的文章进行分享文章进行分享"];
//    //这个页面的.y传1000就行  内部已算好
//    
//    
//    
//    vc.frames = @[@"{{310, 10},{50,50}}"];
//    
//    [self presentViewController:vc animated:YES completion:nil];
//    
//}

- (IBAction)forgetButton:(id)sender {
    LoginChangePasswdViewController * login = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginChangePasswdViewController"];
    login.IsRegist = NO;
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
    
    [[NSUserDefaults standardUserDefaults] setObject:self.phoneNumberText.text forKey:@"localPhoneNumber"];
    
    NSMutableDictionary* p = [NSMutableDictionary dictionary];
    p[@"userName"] = self.phoneNumberText.text;
    p[@"pwd"] = [MD5Encryption md5by32:self.passwdText.text];
    [MBProgressHUD showMessage:@"登陆中"];
    NSDictionary * dict = [UserLoginTool LogingetDateSyncWith:@"Login" WithParame:p];
    LWLog(@"%@",dict);
    [MBProgressHUD hideHUD];
    if ([[dict objectForKey:@"status"] integerValue] == 1 && [[dict objectForKey:@"resultCode"] integerValue] == 1) {
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

    LoginChangePasswdViewController * login = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginChangePasswdViewController"];
    login.IsRegist = YES;
    [self.navigationController pushViewController:login animated:YES];
    LWLog(@"忘记密码");
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (void)dealloc{
    
    LWLog(@"%s",__func__);
}
@end
