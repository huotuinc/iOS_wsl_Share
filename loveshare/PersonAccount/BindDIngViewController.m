//
//  BindDIngViewController.m
//  loveshare
//
//  Created by lhb on 16/3/15.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "BindDIngViewController.h"

@interface BindDIngViewController ()


@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UILabel *yanzhengma;
@property (weak, nonatomic) IBOutlet UITextField *yanztext;
- (IBAction)doclick:(id)sender;

@end

@implementation BindDIngViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //设置返回按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 20, 50, 30);
    [button setTitle:@"取消" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = left;
    
    
    
    __weak  BindDIngViewController *wself = self;
    
    self.yanzhengma.userInteractionEnabled = YES;
    [self.yanzhengma bk_whenTapped:^{
        [wself yanzhengmass];
    }];
}


- (void)buttonAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)yanzhengmass{
    
    LWLog(@"xxx");
    
    if (!self.phoneText.text.length) {
        [MBProgressHUD showError:@"手机号不能为空"];
        return;
    }
    
    [self.yanztext becomeFirstResponder];
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

- (void)settime{
    __weak BindDIngViewController * wself = self;
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
                wself.yanzhengma.text = @"验证码";
                
                //                [captchaBtn setTitle:@"" forState:UIControlStateNormal];
                //                [captchaBtn setBackgroundImage:[UIImage imageNamed:@"resent_icon"] forState:UIControlStateNormal];
                wself.yanzhengma.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //                NSLog(@"____%@",strTime);
                wself.yanzhengma.text = [NSString stringWithFormat:@"%@s",strTime];
                wself.yanzhengma.userInteractionEnabled = NO;
                
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

- (IBAction)doclick:(id)sender {
    
    if (!self.yanztext.text) {
        [MBProgressHUD showError:@"验证码不能为空"];
        return;
    }
    
    NSMutableDictionary * parem = [NSMutableDictionary dictionary];
    parem[@"phone"] = self.phoneText.text;
    parem[@"code"] = self.yanztext.text;
    UserModel * user = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    parem[@"loginCode"] = user.loginCode;
    NSDictionary * dict = [UserLoginTool LogingetDateSyncWith:@"BindMobile" WithParame:parem];
    LWLog(@"%@",dict);
    [MBProgressHUD showSuccess:dict[@"tip"]];
    //
    
}
@end
