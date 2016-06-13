//
//  RegisterViewController.m
//  loveshare
//
//  Created by lhb on 16/6/3.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *passwdText;

@property (weak, nonatomic) IBOutlet UITextField *yanzheng;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)LoginClick:(id)sender;

- (IBAction)login:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *login;

@property (weak, nonatomic) IBOutlet UILabel *yanzhen;

/**去控制找回密码的控制*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containViewHeight;

/**账号邀请码*/
@property (weak, nonatomic) IBOutlet UITextField *invitationCodeText;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setup];
}



- (void)setup{
    
    self.title = self.isForgerPasswd?@"忘记密码":@"注册";
    if (self.isForgerPasswd) {
        [self.loginButton setTitle:@"修改密码" forState:UIControlStateNormal];
        self.containViewHeight.constant = 136;
    }
    
    self.yanzhen.layer.cornerRadius = 5;
    self.yanzhen.layer.masksToBounds = YES;
    
    [self.phoneText becomeFirstResponder];
    
    self.login.layer.cornerRadius = 5;
    self.login.layer.masksToBounds = YES;
    
    self.loginButton.layer.cornerRadius =5;
    self.loginButton.layer.masksToBounds = YES;
    // 左上角
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"Nav_Left_Return_Back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [backButton sizeToFit];
    // 这句代码放在sizeToFit后面
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    
    self.yanzhen.userInteractionEnabled = YES;
    UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(YanZhemMaClock:)];
    [self.yanzhen addGestureRecognizer:ges];
    
}


- (void)YanZhemMaClock:(UITapGestureRecognizer *)tap{

    if (!self.phoneText.text.length) {
        [MBProgressHUD showError:@"手机号为空"];
        return;
    }
    
    [self.passwdText becomeFirstResponder];
    [self settime];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"mobile"] = self.phoneText.text;
    NSDictionary * reDict = [UserLoginTool LogingetDateSyncWith:@"sms" WithParame:dict];
    if (reDict) {
        [MBProgressHUD showSuccess:reDict[@"description"]];
    }else{
        [MBProgressHUD showError:reDict[@"description"]];
    }

}


- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)LoginClick:(id)sender {
    [self.view endEditing:YES];
    
    
    
    if(!self.yanzhen.text.length){
        [MBProgressHUD showError:@"手机验证码不能为空"];
        return;
    }else if(!self.passwdText.text.length){
        [MBProgressHUD showError:@"密码不能为空"];
        return;
    }else{
        NSMutableDictionary* p = [NSMutableDictionary dictionary];
        p[@"mobile"] = self.phoneText.text;
        p[@"password"] = [MD5Encryption md5by32:self.passwdText.text];
        p[@"verifyCode"] = self.yanzheng.text;
        if (self.isForgerPasswd) {
            p[@"isUpdate"] = @"1";
        }else{
            if (!self.invitationCodeText.text.length) {
                [MBProgressHUD showError:@"账号邀请码不能为空"];
                return;
            }
            p[@"invitationCode"] = self.invitationCodeText.text;
        }
        [MBProgressHUD showMessage:nil];
        NSDictionary * dict = [UserLoginTool LogingetDateSyncWith:@"MobileRegister" WithParame:p];
        LWLog(@"%@",dict);
        [MBProgressHUD hideHUD];
        if ([[dict objectForKey:@"status"] integerValue] == 1 && [[dict objectForKey:@"resultCode"] integerValue] == 1) {
            [MBProgressHUD showSuccess:[dict objectForKey:@"tip"]];
            UserModel * userModel = [UserModel mj_objectWithKeyValues:dict[@"resultData"]];
            [UserLoginTool LoginModelWriteToShaHe:userModel andFileName:RegistUserDate];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",userModel.mallUserId] forKey:ChoneMallAccount];
            [[NSUserDefaults standardUserDefaults] setObject:userModel.unionId forKey:PhoneLoginunionid];
            [self SetupLoginIn];
        }else{
            
            [MBProgressHUD showError:[dict objectForKey:@"tip"]];
        }
//        if ([dict[@"tip"] isEqualToString:@"用户名不存在"]) {//要去注册
//            LoginViewController * registVc = (LoginViewController *)[UserLoginTool LoginCreateControllerWithNameOfStory:nil andControllerIdentify:@"LoginViewController"];
//            registVc.callType = 1;
//            registVc.PhoneNumber = self.iphoneNumber.text;
//            registVc.codeNumber = self.yaoqingText.text;
//            [self.navigationController pushViewController:registVc animated:YES];
//        }else{
//            UserModel * userModel = [UserModel mj_objectWithKeyValues:dict[@"resultData"]];
//            [UserLoginTool LoginModelWriteToShaHe:userModel andFileName:RegistUserDate];
//            
//            
//            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",userModel.mallUserId] forKey:ChoneMallAccount];
//            [[NSUserDefaults standardUserDefaults] setObject:userModel.unionId forKey:PhoneLoginunionid];
//            [self SetupLoginIn];
//            
//            
//        }
        LWLog(@"%@",dict);
    }
}

- (IBAction)login:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (void)settime{
    __weak RegisterViewController * wself = self;
    /*************倒计时************/
    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                wself.yanzhen.text = @"验证码";
                
                //                [captchaBtn setTitle:@"" forState:UIControlStateNormal];
                //                [captchaBtn setBackgroundImage:[UIImage imageNamed:@"resent_icon"] forState:UIControlStateNormal];
                wself.yanzhen.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //                NSLog(@"____%@",strTime);
                wself.yanzhen.text = [NSString stringWithFormat:@"%@s",strTime];
                wself.yanzhen.userInteractionEnabled = NO;
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

/**
 *  2、程序启动控制器的选择
 */
- (void)SetupLoginIn{
    MMRootViewController * root = [[MMRootViewController alloc] init];
    UIWindow * win = [UIApplication sharedApplication].keyWindow;
    win.backgroundColor = [UIColor whiteColor];
    win.rootViewController = root;
}

@end
