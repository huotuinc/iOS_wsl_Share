//
//  MasterAndTudiViewController.m
//  Fanmore
//
//  Created by lhb on 15/12/10.
//  Copyright © 2015年 Cai Jiang. All rights reserved.
//

#import "MasterAndTudiViewController.h"

//#import "FollowerListController.h"
#import "FollowListTableViewController.h"


@interface MasterAndTudiViewController ()

/**头像*/
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
/**用户名*/
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
/**复制邀请码*/
- (IBAction)fuzhiCode:(id)sender;
/**徒弟总数*/
@property (weak, nonatomic) IBOutlet UILabel *tuDiCount;

/**徒弟列表*/
@property (weak, nonatomic) IBOutlet UIView *tuDuLieBiao;

/**徒弟总贡献*/
@property (weak, nonatomic) IBOutlet UILabel *firstLable;
/**昨日总贡献*/
@property (weak, nonatomic) IBOutlet UILabel *secondLable;
/**昨日历史浏览量*/
@property (weak, nonatomic) IBOutlet UILabel *thirdLable;
/**昨日历史转发量*/
@property (weak, nonatomic) IBOutlet UILabel *fourthLable;

- (IBAction)tuDILiebiaoClick:(id)sender;


- (IBAction)backClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *shareSdkSha;

- (IBAction)shareYaoqinMa:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *masterRuleDes;

@end

@implementation MasterAndTudiViewController



+(instancetype)pushMaster:(UIViewController*)controller{
    MasterAndTudiViewController * mc = [[self alloc] init];
    [controller.navigationController pushViewController:mc animated:YES];
    return mc;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.masterRuleDes.hidden = YES;
    self.iconView.layer.borderWidth = 2;
    self.iconView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.iconView.layer.cornerRadius = self.iconView.frame.size.height * 0.5;
    self.iconView.layer.masksToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setup];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}



- (void) setup{
    
    UserModel * userInfo = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:userInfo.userHead] placeholderImage:[UIImage imageNamed:@"xiangxtouxiang"]];
    __weak MasterAndTudiViewController * wself = self;
    
    [MBProgressHUD showMessage:nil];
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"loginCode"] = userInfo.loginCode;
    parame[@"pageTag"] = @(0);
    parame[@"pageSize"] = @(0);
    [UserLoginTool loginRequestGet:@"ScorePrentice" parame:parame success:^(id json) {
        
        [MBProgressHUD hideHUD];
        wself.nameLable.text = [NSString stringWithFormat:@"邀请码:%@",json[@"resultData"][@"inviteCode"]];
        self.tuDiCount.text = [NSString stringWithFormat:@"%d",[json[@"resultData"][@"prenticeAmount"] integerValue]];
        self.firstLable.text = [NSString xiaoshudianweishudeal:[json[@"resultData"][@"totalScore"] floatValue]];
        self.secondLable.text = [NSString xiaoshudianweishudeal:[json[@"resultData"][@"yesterdayTotalScore"] floatValue]];
        
        self.thirdLable.text = [NSString stringWithFormat:@"%d/%d",[json[@"resultData"][@"yesterdayBrowseAmount"] integerValue],[json[@"resultData"][@"historyTotalBrowseAmount"] integerValue]];
        
        self.fourthLable.text = [NSString stringWithFormat:@"%d/%d",[json[@"resultData"][@"yesterdayTurnAmount"] integerValue],[json[@"resultData"][@"historyTotalTurnAmount"] integerValue]];
        LWLog(@"%@",json);
        
        if (json[@"resultData"][@"desc"]) {
            
            self.masterRuleDes.hidden = NO;
            self.masterRuleDes.text = json[@"resultData"][@"desc"];
        }else{
            self.masterRuleDes.hidden = YES;
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}



/**
 *  复制邀请码
 *
 *  @param sender <#sender description#>
 */
- (IBAction)fuzhiCode:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.nameLable.text;
    
    [MBProgressHUD showSuccess:@"复制成功"];
}

/**
 *  徒弟列表
 *
 *  @param sender <#sender description#>
 */
- (IBAction)tuDILiebiaoClick:(id)sender {
    FollowListTableViewController * fol = [[FollowListTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:fol animated:YES];
}

- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (IBAction)shareYaoqinMa:(id)sender {
    

    [UserLoginTool LoginToShareTextMessageByShareSdk:self.nameLable.text success:^(int json) {
        
        [MBProgressHUD showSuccess:@"分享成功"];
        LWLog(@"%d",json);
    } failure:^(id json) {
        
    }];

}
@end
