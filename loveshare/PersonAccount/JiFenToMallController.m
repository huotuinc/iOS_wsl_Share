//
//  JiFenToMallController.m
//  Fanmore
//
//  Created by lhb on 15/12/15.
//  Copyright © 2015年 Cai Jiang. All rights reserved.
//

#import "JiFenToMallController.h"
#import "NSString+Encryption.h"


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
         if (![json[@"resultData"][@"lastApply"] isKindOfClass:[NSNull class]]) {
            if(json[@"lastApply"][@"ApplyTime"]){
                wself.firstRecord.text = json[@"resultData"][@"lastApply"][@"ApplyTime"];
                wself.toMakkJifen.text = [NSString stringWithFormat:@"转入钱包%@元",[NSString xiaoshudianweishudeal:[json[@"resultData"][@"lastApply"][@"ApplyMoney"] doubleValue]]];
                wself.Record.hidden = NO;
            }else{
                wself.Record.hidden = YES;
            }
        }else{
            wself.Record.hidden = YES;
        }
//        LOG(@"---%@--------%@",,error.description);
    } failure:^(NSError *error) {
        
    }];
//    
//    LoginState * a =  [AppDelegate getInstance].loadingState.userData;
//    
//    self.scoreJifen.text = [NSString stringWithFormat:@"%@",[NSString xiaoshudianweishudeal:[a.score floatValue]]];
//    __weak JiFenToMallController * wself = self;
//    [[[AppDelegate getInstance]  getFanOperations] TOGetGlodDate:nil block:^(id result, NSError *error) {
//
//        LOG(@"xxxxxxxx%@",result);
//        if(result[@"desc"]){
//            wself.Mydes.text = [NSString stringWithFormat:@" 说明：%@",result[@"desc"]];
//        }
//        if(result[@"desc"]){
//            LOG(@"000000000000%@",result[@"desc"]);
//            wself.toMallJifen.text = [NSString stringWithFormat:@"%ld",[result[@"money"] integerValue]];
//        }
//        
//        
//        if (![result[@"lastApply"] isKindOfClass:[NSNull class]]) {
//            if(result[@"lastApply"][@"ApplyTime"]){
//                wself.firstRecord.text = result[@"lastApply"][@"ApplyTime"];
//                
//                wself.toMakkJifen.text = [NSString stringWithFormat:@"转入钱包%@元",[NSString xiaoshudianweishudeal:[result[@"lastApply"][@"ApplyMoney"] doubleValue]]];
//                wself.Record.hidden = NO;
//            }else{
//                wself.Record.hidden = YES;
//            }
//        }else{
//            wself.Record.hidden = YES;
//        }
//        LOG(@"---%@--------%@",result,error.description);
//    } WithParam:self.scoreJifen.text];
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
    UITextField *tf = [alertView textFieldAtIndex:0];
    LWLog(@"%@",tf.text);
    UserModel * userModel = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    NSMutableDictionary* p = [NSMutableDictionary dictionary];
    p[@"score"] = @(userModel.score);
    p[@"cashpassword"] = [NSString MD5FromData:[tf.text dataUsingEncoding:NSUTF8StringEncoding]];
    p[@"mallUserId"] = [NSString stringWithFormat:@"%@",@(userModel.mallUserId)];
    p[@"loginCode"] = userModel.loginCode;
   
   
    NSDictionary * dict =  [UserLoginTool LogingetDateSyncWith:@"Recharge" WithParame:p];
    LWLog(@"%@",dict);
    if ([dict[@"tip"] isEqualToString:@"错误的提现密码"])  {
        [MBProgressHUD showError:@"密码错误,请去修改密码"];
    }else{
        [MBProgressHUD showSuccess:dict[@"tip"]];
        self.scoreJifen.text = [NSString stringWithFormat:@"%f",userModel.score - [self.toMallJifen.text floatValue]];
        self.toMallJifen.text = [NSString xiaoshudianweishudeal:0.001];
        
        NSMutableDictionary * parame = [NSMutableDictionary dictionary];
        parame[@"loginCode"] = userModel.loginCode;
        NSDictionary * dict = [UserLoginTool LogingetDateSyncWith:@"GETUSERINFO" WithParame:parame];
        UserModel * user = [UserModel mj_objectWithKeyValues:dict[@"resultData"]];
        if (user) {
            [UserLoginTool LoginModelWriteToShaHe:user andFileName:RegistUserDate];
        }
    }
}


@end
