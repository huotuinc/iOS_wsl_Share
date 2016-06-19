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


@property (weak, nonatomic) IBOutlet UIButton *firstRightBtn;

@property (weak, nonatomic) IBOutlet UIButton *secondRightBtn;

@end

@implementation SetNewPasswdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"设置密码";
    
    self.confirmBtn.layer.cornerRadius = 5;
    self.confirmBtn.layer.masksToBounds = YES;
    
    self.firstRightBtn.tag = 0;
    
    self.firstRightBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.firstRightBtn setImage:[[UIImage imageNamed:@"by30X30"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.firstRightBtn addTarget:self action:@selector(firstLeftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.secondRightBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.secondRightBtn setImage:[[UIImage imageNamed:@"by30X30"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    self.firstRightBtn.tag = 100;
    [self.secondRightBtn addTarget:self action:@selector(secondLeftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self leftBtn];
}
- (void)leftBtn{
    
    
    // 左上角
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"Nav_Left_Return_Back"] forState:UIControlStateNormal];
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

- (void)firstLeftBtnClick:(UIButton *)btn{
    
    if (btn.tag == 0) {
        [self.firstRightBtn setImage:[[UIImage imageNamed:@"zy30X30"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        self.first.secureTextEntry = NO;
        btn.tag = 1;
    }else{
        [self.firstRightBtn setImage:[[UIImage imageNamed:@"by30X30"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        self.first.secureTextEntry = YES;
        btn.tag = 0;
    }
    
}
- (void)secondLeftBtnClick:(UIButton *)btn{
    
    if (btn.tag == 100) {
        [self.secondRightBtn setImage:[[UIImage imageNamed:@"zy30X30"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        self.second.secureTextEntry = NO;
        btn.tag = 101;
    }else{
        [self.secondRightBtn setImage:[[UIImage imageNamed:@"by30X30"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        self.second.secureTextEntry = YES;
        btn.tag = 100;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



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
