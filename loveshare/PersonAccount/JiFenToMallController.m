//
//  JiFenToMallController.m
//  Fanmore
//
//  Created by lhb on 15/12/15.
//  Copyright © 2015年 Cai Jiang. All rights reserved.
//

#import "JiFenToMallController.h"
#import "NSString+Encryption.h"

#import "MallBackViewController.h"
@interface JiFenToMallController ()<UIAlertViewDelegate,UITabBarDelegate,UITableViewDataSource,UITableViewDelegate>
/**万事利积分*/
@property (weak, nonatomic) IBOutlet UILabel *scoreJifen;

@property (weak, nonatomic) IBOutlet UILabel *Mydes;


/**转到商城积分*/
@property (weak, nonatomic) IBOutlet UILabel *toMallJifen;
/**第一条记录时间*/
@property (weak, nonatomic) IBOutlet UILabel *firstRecord;
/**xxx记录时间*/
@property (weak, nonatomic) IBOutlet UILabel *toMakkJifen;


/**记录展示的view*/
@property (weak, nonatomic) IBOutlet UIView *Record;

/**用户列表*/
@property (nonatomic,strong) NSMutableArray * userList;

/**遮罩*/
@property (nonatomic,strong) UIView * backView;
/**遮罩*/
@property (nonatomic,strong) UITableView * midtableView;
@end

@implementation JiFenToMallController


- (NSMutableArray *)userList{
    if (_userList == nil) {
        _userList = [NSMutableArray array];
    }
    return _userList;
}

/**
 *  获取网络数据
 */
- (void)toGetNewWorkDate{
    
    
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self toGetNewWorkDate];
    self.title = @"积分兑换";
    
//    //获取用户列表
//    [self toGetTheGlodToMallAccountList];
    
    
    
    
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    __weak JiFenToMallController * wself = self;
    
    UserModel * user = (UserModel * )[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    self.scoreJifen.text = [NSString xiaoshudianweishudeal:user.score];
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"loginCode"] = user.loginCode;
    parame[@"score"] = @(user.score);
    [UserLoginTool loginRequestGet:@"IntegralGoldInfo" parame:parame success:^(id json) {
        LWLog(@"%@",json);
        if(json[@"resultData"][@"desc"]){
            wself.Mydes.text = [NSString stringWithFormat:@" 说明：%@",json[@"resultData"][@"desc"]];
        }
        wself.toMallJifen.text = [NSString xiaoshudianweishudeal:[json[@"resultData"][@"money"] doubleValue]];
        if(json[@"resultData"][@"lastApply"][@"ApplyTime"]){
            wself.firstRecord.text = json[@"resultData"][@"lastApply"][@"ApplyTime"];
            wself.toMakkJifen.text = [NSString stringWithFormat:@"转入钱包%@元",[NSString xiaoshudianweishudeal:[json[@"resultData"][@"lastApply"][@"ApplyMoney"] doubleValue]]];
            wself.Record.hidden = NO;
        }else{
            wself.Record.hidden = YES;
        }
        
//        LOG(@"---%@--------%@",,error.description);
    } failure:^(NSError *error) {
        
    }];

}
//
//
///**
// *  获取用户列表
// */
//- (void)toGetTheGlodToMallAccountList{
////    LoginState * a =  [AppDelegate getInstance].loadingState.userData;
////    __weak JiFenToMallController * wself = self;
////    [[[AppDelegate getInstance]  getFanOperations] TOGetUserList:nil block:^(id result, NSError *error) {
////        NSLog(@"%@",result);
////        if (result) {
////           NSArray * UserList = [GlodMallUserModel objectArrayWithKeyValuesArray:result];
////            if (UserList.count) {
////                wself.userList = [NSMutableArray arrayWithArray:UserList];
////            }
////        }
////    } WithunionId:a.unionId];
//}

///**
// *  积分兑换
// *
// *  @param sender <#sender description#>
// */
- (IBAction)DuiHanJifen:(id)sender {
    if ([self.toMallJifen.text integerValue] <= 0) {
        [MBProgressHUD showError:@"当前兑换积分不足"];
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入兑换密码" message:@" " delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [alert show];
    
    
    
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //得到输入框
    
    __weak JiFenToMallController * wself =self;
    UITextField *tf = [alertView textFieldAtIndex:0];
    LWLog(@"%@",tf.text);
    UserModel * userModel = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    NSMutableDictionary* p = [NSMutableDictionary dictionary];
    p[@"score"] = @(userModel.score);
    p[@"cashpassword"] = [NSString MD5FromData:[tf.text dataUsingEncoding:NSUTF8StringEncoding]];
    p[@"mallUserId"] = [[NSUserDefaults standardUserDefaults] objectForKey:ChoneMallAccount];
    p[@"loginCode"] = userModel.loginCode;
   
   
    NSDictionary * dict =  [UserLoginTool LogingetDateSyncWith:@"Recharge" WithParame:p];
    LWLog(@"%@",dict);
    if ([dict[@"tip"] isEqualToString:@"错误的提现密码"])  {
        [MBProgressHUD showError:@"密码错误,请去修改密码"];
    }else{
        [MBProgressHUD showSuccess:dict[@"tip"]];
        self.scoreJifen.text = [NSString stringWithFormat:@"%.1f",[wself.scoreJifen.text floatValue] - [wself.toMallJifen.text floatValue]];
        
        
        MallBackViewController * aa = [[MallBackViewController alloc] initWithNibName:@"MallBackViewController" bundle:nil];
        [self.navigationController pushViewController:aa animated:NO];
        

    }
}


@end
