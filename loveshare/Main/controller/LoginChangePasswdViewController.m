//
//  LoginChangePasswdViewController.m
//  loveshare
//
//  Created by lhb on 16/6/15.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "LoginChangePasswdViewController.h"

@interface LoginChangePasswdViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberText;

@property (weak, nonatomic) IBOutlet UITextField *phomecode;


@property (weak, nonatomic) IBOutlet UIButton *nextBtnClick;

@property (weak, nonatomic) IBOutlet UILabel *yanzheng;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

- (IBAction)btnclick:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *first;
@property (weak, nonatomic) IBOutlet UIView *second;
@property (weak, nonatomic) IBOutlet UIView *third;

@end

@implementation LoginChangePasswdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupInit];
    
    AppDelegate * ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ad.currentVC = self;
    
}


- (void) setupInit{
    
    self.title = @"获取验证码";
    
    self.phoneNumberText.delegate = self;
    
    self.first.alpha = 0.7;
    self.second.alpha = 0.7;
    self.third.alpha = 0.7;
    
    self.yanzheng.layer.cornerRadius = 5;
    self.yanzheng.layer.masksToBounds = YES;
    
    
    self.nextBtn.layer.cornerRadius = 5;
    self.nextBtn.layer.masksToBounds = YES;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(yanzhengma)];
    self.yanzheng.userInteractionEnabled = YES;
    
    [self.yanzheng addGestureRecognizer:tap];
    
    

    
    
//    if (!self.isInapp) {
//        // 左上角
//        [self leftBtn];
//    }
//    
    
    
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (!self.isInapp) {
        if (textField.text.length == 11) {
            NSMutableDictionary* p = [NSMutableDictionary dictionary];
            p[@"mobile"] = self.phoneNumberText.text;
            [UserLoginTool loginRequestGet:@"VerifyMobile" parame:p success:^(id json) {
                
                LWLog(@"%@",json);
                if ([[json objectForKey:@"status"] integerValue] == 54001 && [[json objectForKey:@"resultCode"] integerValue] == 1)
                    [MBProgressHUD showError:json[@"tip"]];
            } failure:^(NSError *error) {
                
            }];
        }
        
    }
    
}


- (void)leftBtn{
    // 左上角
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"Nav_Left_Return_White_Back"] forState:UIControlStateNormal];
    //    [backButton setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //        [backButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [backButton sizeToFit];
    // 这句代码放在sizeToFit后面
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    [backButton addTarget:self action:@selector(backss) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)backss{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    NSString * phoneNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"localPhoneNumber"];
//    if (phoneNumber.length) {
//        self.phoneNumberText.text = phoneNumber;
//    }
}

- (void)backdismiss{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) yanzhengma{
    if (!self.phoneNumberText.text.length) {
        [MBProgressHUD showError:@"手机号为空"];
        return;
    }
    
    [self.phomecode becomeFirstResponder];
    [self settime];
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"mobile"] = self.phoneNumberText.text;
    NSDictionary * reDict = [UserLoginTool LogingetDateSyncWith:@"sms" WithParame:dict];
    if (reDict) {
        [MBProgressHUD showSuccess:reDict[@"description"]];
    }else{
        [MBProgressHUD showError:reDict[@"description"]];
    }
    
}


- (void)settime{
    __weak LoginChangePasswdViewController * wself = self;
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
                wself.yanzheng.text = @"验证码";
                
                //                [captchaBtn setTitle:@"" forState:UIControlStateNormal];
                //                [captchaBtn setBackgroundImage:[UIImage imageNamed:@"resent_icon"] forState:UIControlStateNormal];
                wself.yanzheng.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //                NSLog(@"____%@",strTime);
                wself.yanzheng.text = [NSString stringWithFormat:@"%@s",strTime];
                wself.yanzheng.userInteractionEnabled = NO;
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (IBAction)btnclick:(id)sender {
    
    if (!self.phoneNumberText.text.length) {
        [MBProgressHUD showError:@"手机号不能为空"];
        return;
    }
    
    if (!self.phomecode.text.length) {
        [MBProgressHUD showError:@"验证码不能为空"];
        return;
    }
    NSMutableDictionary* p = [NSMutableDictionary dictionary];
    p[@"mobile"] = self.phoneNumberText.text;
    p[@"verifyCode"] = self.phomecode.text;
    NSDictionary * dict = [UserLoginTool LogingetDateSyncWith:@"CHECKVERIFYCODE" WithParame:p];
    LWLog(@"%@",dict);
    if ([[dict objectForKey:@"status"] integerValue] == 1 && [[dict objectForKey:@"resultCode"] integerValue] == 1) {
        
       [[NSUserDefaults standardUserDefaults] setObject:self.phoneNumberText.text forKey:@"localPhoneNumber"];
        
        SetNewPasswdViewController * con =  [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"SetNewPasswdViewController"];
        con.phone = self.phoneNumberText.text;
        con.vercode = self.phomecode.text;
        con.isRegist = self.IsRegist;
        con.isInApp = self.isInapp;
        [self.navigationController pushViewController:con animated:YES];
    }else{
        
        
        [MBProgressHUD showError:[dict objectForKey:@"tip"]];
    }

    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}
@end
