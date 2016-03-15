//
//  AccountLoginViewController.m
//  Fanmore
//
//  Created by lhb on 15/12/18.
//  Copyright © 2015年 Cai Jiang. All rights reserved.
//

#import "AccountLoginViewController.h"

@interface AccountLoginViewController ()

/**邀请码*/
@property (weak, nonatomic) IBOutlet UILabel *yaoQingMa;

/**手机号*/
@property (weak, nonatomic) IBOutlet UITextField *iphoneNumber;

/**描述*/
@property (weak, nonatomic) IBOutlet UILabel *des;

/**登录点击*/
- (IBAction)LoginButtonClick:(id)sender;

/**邀请码*/
@property (weak, nonatomic) IBOutlet UITextField *yaoqingText;



@end

@implementation AccountLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手机注册登录";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    // Do any additional setup after loading the view.
    
    self.yaoQingMa.layer.borderWidth = 2;
    self.yaoQingMa.layer.cornerRadius = 2;
    self.yaoQingMa.layer.masksToBounds = YES;
    self.yaoQingMa.layer.borderColor = [UIColor orangeColor].CGColor;
    
    self.yaoQingMa.userInteractionEnabled = YES;
    __weak AccountLoginViewController * wself = self;
    [self.yaoQingMa bk_whenTapped:^{
        [wself yanzhengma];
    }];
   
    
    //设置返回按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 20, 50, 30);
    [button setTitle:@"取消" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = left;
}


- (void)buttonAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)yanzhengma{
    
    LWLog(@"xxx");
    
    if (!self.iphoneNumber.text.length) {
        [MBProgressHUD showError:@"手机号不能为空"];
        return;
    }
    
    [self.yaoqingText becomeFirstResponder];
    [self settime];
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"mobile"] = self.iphoneNumber.text;
    NSDictionary * reDict = [UserLoginTool LogingetDateSyncWith:@"sms" WithParame:dict];
    if (reDict) {
        [MBProgressHUD showSuccess:reDict[@"description"]];
    }else{
        [MBProgressHUD showError:reDict[@"description"]];
    }
}


- (void)settime{
    __weak AccountLoginViewController * wself = self;
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
                wself.yaoQingMa.text = @"验证码";
                
                //                [captchaBtn setTitle:@"" forState:UIControlStateNormal];
                //                [captchaBtn setBackgroundImage:[UIImage imageNamed:@"resent_icon"] forState:UIControlStateNormal];
                wself.yaoQingMa.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //                NSLog(@"____%@",strTime);
                wself.yaoQingMa.text = [NSString stringWithFormat:@"%@s",strTime];
                wself.yaoQingMa.userInteractionEnabled = NO;
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)LoginButtonClick:(id)sender {
    [self.view endEditing:YES];
    
    if(self.yaoqingText.text.length == 0){
        [MBProgressHUD showError:@"验证码不能为空"];
        return;
    }else{
        NSMutableDictionary* p = [NSMutableDictionary dictionary];
        p[@"mobile"] = self.iphoneNumber.text;
        p[@"verifyCode"] = self.yaoqingText.text;
        [MBProgressHUD showMessage:nil];
        NSDictionary * dict = [UserLoginTool LogingetDateSyncWith:@"MobileLogin" WithParame:p];
        [MBProgressHUD hideHUD];
        if ([dict[@"tip"] isEqualToString:@"用户名不存在"]) {//要去注册
            LoginViewController * registVc = (LoginViewController *)[UserLoginTool LoginCreateControllerWithNameOfStory:nil andControllerIdentify:@"LoginViewController"];
            registVc.callType = 1;
            registVc.PhoneNumber = self.iphoneNumber.text;
            registVc.codeNumber = self.yaoqingText.text;
            [self.navigationController pushViewController:registVc animated:YES];
        }else{
            UserModel * userModel = [UserModel mj_objectWithKeyValues:dict[@"resultData"]];
            [UserLoginTool LoginModelWriteToShaHe:userModel andFileName:RegistUserDate];
            
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",userModel.mallUserId] forKey:ChoneMallAccount];
            [[NSUserDefaults standardUserDefaults] setObject:userModel.unionId forKey:PhoneLoginunionid];
            [self SetupLoginIn];

            
        }
        LWLog(@"%@",dict);
    }
}

/**
 *  2、程序启动控制器的选择
 */
- (void)SetupLoginIn{
    MMRootViewController * root = [[MMRootViewController alloc] init];
    UIWindow * win = [UIApplication sharedApplication].keyWindow;
    win.rootViewController = root;
}
@end
