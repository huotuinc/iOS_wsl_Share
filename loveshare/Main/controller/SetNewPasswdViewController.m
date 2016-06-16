//
//  SetNewPasswdViewController.m
//  loveshare
//
//  Created by lhb on 16/6/15.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "SetNewPasswdViewController.h"

@interface SetNewPasswdViewController ()
@property (weak, nonatomic) IBOutlet UITextField *first;

@property (weak, nonatomic) IBOutlet UITextField *second;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
- (IBAction)btnclick:(id)sender;

@end

@implementation SetNewPasswdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.confirmBtn.layer.cornerRadius = 5;
    self.confirmBtn.layer.masksToBounds = YES;
    
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

- (IBAction)btnclick:(id)sender {
    
    if(!self.first.text.length || !self.second.text.length){
        [MBProgressHUD showError:@"密码不能为空"];
        return;
    }else if(![self.first.text isEqualToString:self.second.text]){
        [MBProgressHUD showError:@"两次输入密码不一致"];
        return;
    }
    
        NSMutableDictionary* p = [NSMutableDictionary dictionary];
        p[@"mobile"] = self.phone;
        p[@"password"] = [MD5Encryption md5by32:self.first.text];
        p[@"verifyCode"] = self.vercode;
        p[@"isUpdate"] = @"1";
        NSDictionary * dict = [UserLoginTool LogingetDateSyncWith:@"MobileRegister" WithParame:p];
        if ([[dict objectForKey:@"status"] integerValue] == 1 && [[dict objectForKey:@"resultCode"] integerValue] == 1) {
            [MBProgressHUD showSuccess:[dict objectForKey:@"tip"]];
//            UserModel * userModel = [UserModel mj_objectWithKeyValues:dict[@"resultData"]];
//            [UserLoginTool LoginModelWriteToShaHe:userModel andFileName:RegistUserDate];
//            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",userModel.mallUserId] forKey:ChoneMallAccount];
//            [[NSUserDefaults standardUserDefaults] setObject:userModel.unionId forKey:PhoneLoginunionid];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else{
            
            [MBProgressHUD showError:[dict objectForKey:@"tip"]];
        }
}
    
@end
