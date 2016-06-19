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


@interface MasterAndTudiViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *optionList;




@property(nonatomic,copy) NSString * shareUrl;


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

@property(nonatomic,strong) NSArray * opt;

@property(nonatomic,strong) NSArray * optImage;
@end

@implementation MasterAndTudiViewController


- (NSArray *)optImage{
    if (_optImage == nil) {
        _optImage = @[@"chb",@"cll",@"czf"];
    }
    return _optImage;
}

- (NSArray *)opt{
    if (_opt == nil) {
        _opt = @[@"伙伴总数",@"昨日/历史浏览量",@"昨日/历史转发量"];
    }
    return _opt;
}

+(instancetype)pushMaster:(UIViewController*)controller{
    MasterAndTudiViewController * mc = [[self alloc] init];
    [controller.navigationController pushViewController:mc animated:YES];
    return mc;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    LWLog(@"%s---%@",__func__,NSStringFromCGRect(self.iconView.frame));
    self.masterRuleDes.hidden = YES;
    self.iconView.layer.borderWidth = 2;
    self.iconView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.optionList.dataSource = self;
    self.optionList.delegate = self;
    self.optionList.rowHeight = 60;
    self.optionList.scrollEnabled = NO;
    [self shareBtn];
}


- (void)shareBtn{
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
//    btn.layer.cornerRadius = 16;
////    btn.layer.masksToBounds = YES;
//    btn.layer.borderColor = [UIColor whiteColor].CGColor;
//    btn.layer.borderWidth = 1;
    
    [btn setImage:[UIImage imageNamed:@"main_title_left_refresh"] forState:UIControlStateNormal];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = left;

    //    [btn sd_setImageWithURL:[NSURL URLWithString:userInfo.userHead] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"geren"]];
    [btn addTarget:self action:@selector(shareBtnclick) forControlEvents:UIControlEventTouchDown];
}

- (void)shareBtnclick{
    LWLog(@"%@",self.shareUrl);
    NewShareModel * aa = [[NewShareModel alloc] init];
    aa.taskInfo = self.shareUrl;
    aa.taskName = self.des;
    aa.taskSmallImgUrl = nil;
    [UserLoginTool LoginToShareTextMessageByShareSdk:self.des andUrl:self.shareUrl success:^(int json) {
        [MBProgressHUD showSuccess:@"分享成功"];
        LWLog(@"%d",json);
    } failure:nil];
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
        [MBProgressHUD hideHUD];
        wself.nameLable.text = [NSString stringWithFormat:@"%@",json[@"resultData"][@"inviteCode"]];
        self.tuDiCount.text = [NSString stringWithFormat:@"%ld",[json[@"resultData"][@"prenticeAmount"] integerValue]];
        self.firstLable.text = [NSString xiaoshudianweishudeal:[json[@"resultData"][@"totalScore"] floatValue]];
        self.secondLable.text = [NSString xiaoshudianweishudeal:[json[@"resultData"][@"yesterdayTotalScore"] floatValue]];
        self.thirdLable.text = [NSString stringWithFormat:@"%ld/%ld",[json[@"resultData"][@"yesterdayBrowseAmount"] integerValue],[json[@"resultData"][@"historyTotalBrowseAmount"] integerValue]];
        
        self.fourthLable.text = [NSString stringWithFormat:@"%ld/%ld",[json[@"resultData"][@"yesterdayTurnAmount"] integerValue],[json[@"resultData"][@"historyTotalTurnAmount"] integerValue]];
        LWLog(@"%@",json);
        
        if (json[@"resultData"][@"desc"]) {
            
           
            self.masterRuleDes.hidden = NO;
            self.masterRuleDes.text =[NSString stringWithFormat:@"  %@",json[@"resultData"][@"desc"]] ;
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
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (IBAction)shareYaoqinMa:(id)sender {
    LWLog(@"%@",self.shareUrl);
    NewShareModel * aa = [[NewShareModel alloc] init];
    aa.taskInfo = self.shareUrl;
    aa.taskName = self.des;
    aa.taskSmallImgUrl = nil;
    [UserLoginTool LoginToShareTextMessageByShareSdk:self.des andUrl:self.shareUrl success:^(int json) {
        [MBProgressHUD showSuccess:@"分享成功"];
        LWLog(@"%d",json);
    } failure:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.opt.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"123"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = [self.opt objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[self.optImage objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
