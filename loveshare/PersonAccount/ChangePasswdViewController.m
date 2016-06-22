//
//  ChangePasswdViewController.m
//  loveshare
//
//  Created by lhb on 16/3/11.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "ChangePasswdViewController.h"
#import "NSString+Encryption.h"
@interface ChangePasswdViewController ()

@property (weak, nonatomic) IBOutlet UILabel *first;

@property (weak, nonatomic) IBOutlet UILabel *second;


@property (weak, nonatomic) IBOutlet UITextField *currentPassWD;
@property (weak, nonatomic) IBOutlet UITextField *firstnewPassWD;

@property (weak, nonatomic) IBOutlet UIButton *btn;

- (IBAction)btnckick:(id)sender;

@end

@implementation ChangePasswdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate * ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ad.currentVC = self;
    
    
    self.title = @"修改商城密码";
    self.first.layer.cornerRadius = 5;
    self.first.layer.masksToBounds = YES;
    self.second.layer.cornerRadius = 5;
    self.second.layer.masksToBounds = YES;
   
    self.btn.layer.cornerRadius = 5;
    self.btn.layer.masksToBounds = YES;
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnckick:(id)sender {
    
    __weak ChangePasswdViewController * wself = self;
    if (![self.firstnewPassWD.text isEqualToString:self.currentPassWD.text]) {
        [MBProgressHUD showError:@"请输入相同密码"];
        return;
        
    }
    UserModel * userInfo = (UserModel * )[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"loginCode"] = userInfo.loginCode;
    parame[@"withdrawalPassword"] = [NSString MD5FromData:[self.currentPassWD.text dataUsingEncoding:NSUTF8StringEncoding]];
    [UserLoginTool loginRequestGet:@"UpdateWithdrawalPassword" parame:parame success:^(id json) {
        
        if ([json[@"status"] integerValue] == 1 &&  [json[@"resultCode"] integerValue] == 1) {
            [MBProgressHUD showSuccess:@"修改成功"];
            [wself dismissViewControllerAnimated:YES completion:nil];
        }
    } failure:nil];
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
@end
