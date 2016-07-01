//
//  SetNewPasswdViewController.m
//  loveshare
//
//  Created by lhb on 16/6/15.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "SetNewPasswdViewController.h"
#import "PocyViewController.h"
@interface SetNewPasswdViewController ()
@property (weak, nonatomic) IBOutlet UITextField *first;

@property (weak, nonatomic) IBOutlet UITextField *second;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
- (IBAction)btnclick:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *firstRightBtn;

@property (weak, nonatomic) IBOutlet UIButton *secondRightBtn;


@property (weak, nonatomic) IBOutlet UITextField *revercode;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Containheight;

@property (weak, nonatomic) IBOutlet UIView *thirdDiv;
@property (weak, nonatomic) IBOutlet UIView *foutD;


/**用户协议和隐私政策*/
@property (weak, nonatomic) IBOutlet UILabel *optionLable;

@property (weak, nonatomic) IBOutlet UIView *optionContain;
- (IBAction)userPolicy:(id)sender;

- (IBAction)scretPolicy:(id)sender;




@end

@implementation SetNewPasswdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSString * registrationID =  [JPUSHService registrationID];
    //    LWLog(@"%@",registrationID);
    
    if (registrationID.length) {
        [[NSUserDefaults standardUserDefaults] setObject:registrationID forKey:@"DeviceToken"];
    }
    
    
    
    self.optionLable.adjustsFontSizeToFitWidth = YES;
    
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
    
    if (!_isRegist) {
        
        self.Containheight.constant = 123;
        
        self.thirdDiv.hidden = YES;
        
        
        self.foutD.hidden = YES;
        
        self.optionContain.hidden = YES;
        
    }else{
        [self.confirmBtn setTitle:@"注册" forState:UIControlStateNormal];
    }
    
//    if(!self.isInApp){
////        [self leftBtn];
//    }
    
    AppDelegate * ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ad.currentVC = self;
    
   
    
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
    }else if(self.first.text.length < 6){
        [MBProgressHUD showError:@"密码不得小于6位"];
        return;
        
    }
    
    if (self.isRegist) {
        
        
        if (!self.revercode.text.length) {
            [MBProgressHUD showError:@"邀请码为空"];
            return;
        }
        NSMutableDictionary* p = [NSMutableDictionary dictionary];
        p[@"mobile"] = self.phone;
        p[@"password"] = [MD5Encryption md5by32:self.first.text];
        p[@"verifyCode"] = self.vercode;
        p[@"invitationCode"] = self.revercode.text;
        NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"];
      
        if (token.length) {
             token =  [JPUSHService registrationID];
        }
        p[@"token"] = token;
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
            
            
//            UserModel * usermodel = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
//            NSMutableDictionary * parame = [NSMutableDictionary dictionary];
//            parame[@"loginCode"] = usermodel.loginCode;
//            parame[@"type"] = @"0";
//            parame[@"token"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"];
//            //获取支付参数
//            [UserLoginTool loginRequestGet:@"AddDeviceToken" parame:parame success:^(id json) {
//                LWLog(@"%@",json);
//            } failure:nil];
            
            
            [self SetupLoginIn];
        }else{
            
            [MBProgressHUD showError:[dict objectForKey:@"tip"]];
        }

        
    }else{
        NSMutableDictionary* p = [NSMutableDictionary dictionary];
        p[@"mobile"] = self.phone;
        p[@"password"] = [MD5Encryption md5by32:self.first.text];
        p[@"verifyCode"] = self.vercode;
        p[@"isUpdate"] = @"1";
        NSDictionary * dict = [UserLoginTool LogingetDateSyncWith:@"MobileRegister" WithParame:p];
        if ([[dict objectForKey:@"status"] integerValue] == 1 && [[dict objectForKey:@"resultCode"] integerValue] == 1) {
            [MBProgressHUD showSuccess:[dict objectForKey:@"tip"]];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else{
            
            [MBProgressHUD showError:[dict objectForKey:@"tip"]];
        }
    }
    
    
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
    
- (IBAction)userPolicy:(id)sender {
    PocyViewController * po = [[PocyViewController alloc] init];
    po.title = @"用户协议";
    po.url = @"http://task.fhsilk.com/UserAgreement.html";
    [self.navigationController pushViewController:po animated:YES];
    
}

- (IBAction)scretPolicy:(id)sender {
    PocyViewController * po = [[PocyViewController alloc] init];
    po.url = @"http://task.fhsilk.com/PrivacyPolicy.html";
     po.title = @"隐私政策";
    [self.navigationController pushViewController:po animated:YES];
}
@end
