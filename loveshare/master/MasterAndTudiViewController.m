//
//  MasterAndTudiViewController.m
//  Fanmore
//
//  Created by lhb on 15/12/10.
//  Copyright © 2015年 Cai Jiang. All rights reserved.
//

#import "MasterAndTudiViewController.h"
#import "TudiTableViewController.h"
//#import "FollowerListController.h"
#import "FollowListTableViewController.h"

#import "MastListMenu.h"


@interface MasterAndTudiViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *optionList;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHead;


@property(nonatomic,copy) NSString * shareUrl;

@property(nonatomic,copy) NSString *  shareTitkedes;
@property(nonatomic,copy) NSString *  des;

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

@property(nonatomic,strong) NSArray * optlist;


@end

@implementation MasterAndTudiViewController



- (NSArray *)optlist{
    if (_optlist == nil) {
        
        MastListMenu * me = [[MastListMenu alloc] init];
        me.imageName = @"chb";
        me.nameLable = @"伙伴总数";
        
//        MastListMenu * me1 = [[MastListMenu alloc] init];
//        me1.imageName = @"cll";
//        me1.nameLable = @"昨日/历史浏览量";
//        
//        MastListMenu * me2 = [[MastListMenu alloc] init];
//        me2.imageName = @"czf";
//        me2.nameLable = @"昨日/历史转发量";
        
        _optlist = @[me];
    }
    return _optlist;
}


+(instancetype)pushMaster:(UIViewController*)controller{
    MasterAndTudiViewController * mc = [[self alloc] init];
    [controller.navigationController pushViewController:mc animated:YES];
    return mc;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate * ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ad.currentVC = self;
    
    self.title = @"我要推荐";
    
    if (ScreenHeight == 736) {
        self.topViewHead.constant -= 20;
    }else if(ScreenHeight == 568){
        self.topViewHead.constant += 20;
    }else if(ScreenHeight == 480){
        self.topViewHead.constant += 40;
    }
    LWLog(@"%s---%@",__func__,NSStringFromCGRect(self.iconView.frame));
    self.masterRuleDes.hidden = YES;
    self.iconView.layer.borderWidth = 2;
    self.iconView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.optionList.dataSource = self;
    self.optionList.delegate = self;
    self.optionList.rowHeight = 60;
    self.optionList.scrollEnabled = NO;
    [self shareBtn];
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}


- (void)shareBtn{
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [btn setImage:[UIImage imageNamed:@"home_title_right_share"] forState:UIControlStateNormal];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = left;
    [btn addTarget:self action:@selector(shareBtnclick) forControlEvents:UIControlEventTouchDown];
}

- (void)shareBtnclick{
    LWLog(@"%@",self.shareUrl);
    NewShareModel * aa = [[NewShareModel alloc] init];
    aa.taskInfo = self.shareUrl;
    aa.taskName = self.des;
    aa.taskSmallImgUrl = nil;
    aa.taskTitle = self.shareTitkedes;
    [UserLoginTool LoginToShareTextMessageByShareSdkWithShareTitle:self.shareTitkedes withShareDes:self.des andUrl:self.shareUrl success:^(int json) {
        [MBProgressHUD showSuccess:@"分享成功"];
        LWLog(@"%d",json);
    } failure:^(id json) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setup];
    self.iconView.layer.cornerRadius = self.iconView.frame.size.height * 0.5;
    [self.iconView layoutIfNeeded];
    self.iconView.layer.masksToBounds = YES;
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
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
        LWLog(@"%@",json);
        wself.des =json[@"resultData"][@"shareDesc"];
        wself.shareUrl = json[@"resultData"][@"shareUrl"];
        wself.shareTitkedes = json[@"resultData"][@"shareTitle"];
        [MBProgressHUD hideHUD];
        MastListMenu * me = [self.optlist firstObject];
        me.rightDes = [NSString stringWithFormat:@"%ld人",[json[@"resultData"][@"prenticeAmount"] integerValue]];
        wself.nameLable.text = [NSString stringWithFormat:@"%@",json[@"resultData"][@"inviteCode"]];
        self.tuDiCount.text = [NSString stringWithFormat:@"%ld",[json[@"resultData"][@"prenticeAmount"] integerValue]];
        self.firstLable.text = [NSString xiaoshudianweishudeal:[json[@"resultData"][@"totalScore"] floatValue]];
        self.secondLable.text = [NSString xiaoshudianweishudeal:[json[@"resultData"][@"yesterdayTotalScore"] floatValue]];
//        MastListMenu * me1 = [self.optlist objectAtIndex:1];
//        me1.rightDes =  [NSString stringWithFormat:@"%d/%d次",[json[@"resultData"][@"yesterdayBrowseAmount"] intValue],[json[@"resultData"][@"historyTotalBrowseAmount"] intValue]];
//        MastListMenu * me2 = [self.optlist lastObject];
//        me2.rightDes =  [NSString stringWithFormat:@"%d/%d次",[json[@"resultData"][@"yesterdayTurnAmount"] intValue],[json[@"resultData"][@"historyTotalTurnAmount"] intValue]];
        if (json[@"resultData"][@"desc"]) {
            self.masterRuleDes.hidden = NO;
            self.masterRuleDes.text =[NSString stringWithFormat:@"  %@",json[@"resultData"][@"desc"]] ;
        }else{
            self.masterRuleDes.hidden = YES;
        }
        
        [self.optionList reloadData];
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
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (IBAction)shareYaoqinMa:(id)sender {
//    LWLog(@"%@",self.shareUrl);
//    NewShareModel * aa = [[NewShareModel alloc] init];
//    aa.taskInfo = self.shareUrl;
//    aa.taskName = self.des;
//    aa.taskSmallImgUrl = nil;
//    [UserLoginTool LoginToShareTextMessageByShareSdk:self.des andUrl:self.shareUrl success:^(int json) {
//        [MBProgressHUD showSuccess:@"分享成功"];
//        LWLog(@"%d",json);
//    } failure:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.optlist.count;
    
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"123"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"123"];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    if (indexPath.row == 0) {
        cell.userInteractionEnabled = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.userInteractionEnabled = NO;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
     MastListMenu * me1 = [self.optlist objectAtIndex:indexPath.row];
    cell.textLabel.text = me1.nameLable;
    cell.imageView.image = [UIImage imageNamed:me1.imageName];
    cell.detailTextLabel.text = me1.rightDes;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        TudiTableViewController * a = [[TudiTableViewController alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:a animated:YES];
    }
}
@end
