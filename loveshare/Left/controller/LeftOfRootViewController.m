//
//  LeftOfRootViewController.m
//  loveshare
//
//  Created by lhb on 16/3/6.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "LeftOfRootViewController.h"
#import "MMRootViewController.h"
#import "RAYNewFunctionGuideVC.h"
#import <UIViewController+MMDrawerController.h>
@interface LeftOfRootViewController ()<UITableViewDelegate, UITableViewDataSource>

/**等级*/
@property (weak, nonatomic) IBOutlet UILabel *leveLable;


@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *userScore;

@property (weak, nonatomic) IBOutlet UIView *infoView;

@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;

@property (weak, nonatomic) IBOutlet UIView *ceter;

@property (weak, nonatomic) IBOutlet UITableView *optionTable;
@property (weak, nonatomic) IBOutlet UILabel *labelWatch;


@property (nonatomic, copy) NSString *watchCounts;

@property (strong, nonatomic) UILabel * aa;

@property(nonatomic,strong) NSMutableArray * optionArray;

@end

@implementation LeftOfRootViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setup];
    [self getWatchCounts];
}
- (NSMutableArray *)optionArray{
    if (_optionArray == nil) {
        _optionArray = [OptionModel OptionModelBringBackArray];
    }
    return _optionArray;
}

- (void)setup{
    self.navigationController.navigationBarHidden = YES;
    
    self.leveLable.layer.cornerRadius = 5;
    self.leveLable.layer.masksToBounds = YES;
    
    self.headImage.layer.cornerRadius = self.headImage.frame.size.height * 0.5;
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.borderWidth = 2;
    self.headImage.layer.borderColor = [UIColor whiteColor].CGColor;
    UserModel * userModel = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:userModel.userHead] placeholderImage:nil completed:nil];
    self.userName.text= userModel.UserNickName;
    self.userScore.text =[NSString stringWithFormat:@"可用分红%@",[NSString xiaoshudianweishudeal:userModel.score]] ;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UserModel * userInfo = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    if (self.optionArray.count && !userInfo.isSuper) {
        [self.optionArray removeObjectAtIndex:self.optionArray.count-2];
    }
    
    
    
    self.headImage.userInteractionEnabled = YES;
    [self.headImage bk_whenTapped:^{//个人中心
        NSDictionary * objc = [NSDictionary dictionaryWithObject:@(100) forKey:@"option"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"backToHomeView" object:nil userInfo:objc];
        MMRootViewController * root = (MMRootViewController *)self.mm_drawerController;
        [root setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        [root toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }];
    
    [self.infoView bk_whenTapped:^{
        NSDictionary * objc = [NSDictionary dictionaryWithObject:@(100) forKey:@"option"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"backToHomeView" object:nil userInfo:objc];
        MMRootViewController * root = (MMRootViewController *)self.mm_drawerController;
        [root setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        [root toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }];
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.TodayPredictingNumber addObserver:self forKeyPath:@"today" options:0 context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JifenChange) name:@"jichenChange" object:nil];
    self.ceter.hidden = YES;
    self.arrowImage.hidden = YES;
    self.optionTable.backgroundColor = [UIColor clearColor];
    self.optionTable.showsVerticalScrollIndicator = NO;
    self.optionTable.tableFooterView = [[UIView alloc] init];
    self.optionTable.rowHeight = 55;

}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    _aa.hidden = NO;
    
    
}

- (void)getWatchCounts {
    UserModel * userInfo = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"loginCode"] = userInfo.loginCode;
    [UserLoginTool loginRequestGet:@"GetUserTodayBrowseCount" parame:parame success:^(id json) {
        LWLog(@"%@",json);
        if ([json[@"status"] integerValue]==1 && [json[@"resultCode"] integerValue] == 1) {
            _watchCounts = json[@"resultData"][@"count"];
            _labelWatch.text = [NSString stringWithFormat:@"今日浏览量 : %@",_watchCounts];

        }
        LWLog(@"%@",json[@"description"]);
    }failure:^(NSError *error) {
        
    }];
}


- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    //判断是否为第一次进入
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *isFirstHome = [defaults objectForKey:@"isFirstHome"];
    NSString *isFirstSSLeft = [defaults objectForKey:@"isFirstSSLeft"];
    NSString *isShareSuccessAndGoHome = [defaults objectForKey:@"isShareSuccessAndGoHome"];
    //正常发布加个 ! [
    if ([isFirstHome isEqualToString:@"1"] && [isShareSuccessAndGoHome isEqualToString:@"YES"] && ![isFirstSSLeft isEqualToString:@"YES"]){
        [defaults setObject:@"YES" forKey:@"isFirstSSLeft"];
        [defaults synchronize];
        [self makeGuideView];
    }
 
}
- (void)makeGuideView{
    RAYNewFunctionGuideVC *vc = [[RAYNewFunctionGuideVC alloc]init];
    vc.titles = @[@"转发后在这里查看奖励"];
    //传1001
    vc.frames = @[@"{{0, 1001},{0,70}}"];
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (void)JifenChange{
    UserModel * userModel = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:userModel.userHead] placeholderImage:nil completed:nil];
    self.userName.text= userModel.userName;
    self.userScore.text =[NSString stringWithFormat:@"可用分红%@",[NSString xiaoshudianweishudeal:userModel.score]] ;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    
    
    return self.optionArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"optioncell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"optioncell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        
    }
    
    if (indexPath.row == 4) {
        LWLog(@"%@",NSStringFromCGRect(cell.accessoryView.frame));
        UILabel * aa = [[UILabel alloc] initWithFrame:CGRectMake(self.optionTable.frame.size.width - 60,25, 10, 10)];
        aa.backgroundColor = [UIColor redColor];
        aa.layer.cornerRadius = 5;
        aa.layer.masksToBounds = YES;
        [cell addSubview:aa];
        aa.hidden = YES;
        _aa = aa;
    }

    
    
    OptionModel * model  = self.optionArray[indexPath.row];
    cell.textLabel.text = model.OptionName;
    cell.imageView.image = [UIImage imageNamed:model.optionImageName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {//首页
        case 0:{
            NSDictionary * objc = [NSDictionary dictionaryWithObject:@(indexPath.row) forKey:@"option"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"backToHomeView" object:nil userInfo:objc];
            MMRootViewController * root = (MMRootViewController *)self.mm_drawerController;
            [root setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
            [root toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
            break;
        }
        case 1:{//历史浏览
            NSDictionary * objc = [NSDictionary dictionaryWithObject:@(indexPath.row) forKey:@"option"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"backToHomeView" object:nil userInfo:objc];
            MMRootViewController * root = (MMRootViewController *)self.mm_drawerController;
            [root setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
            [root toggleDrawerSide:MMDrawerSideLeft animated:NO completion:^(BOOL finished) {
            }];
            break;
        }

        case 2:{//排行榜
            NSDictionary * objc = [NSDictionary dictionaryWithObject:@(indexPath.row) forKey:@"option"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"backToHomeView" object:nil userInfo:objc];
            MMRootViewController * root = (MMRootViewController *)self.mm_drawerController;
            [root toggleDrawerSide:MMDrawerSideLeft animated:NO completion:nil];
            break;
        }
        case 3:{//本周任务
            
            _aa.hidden = YES;
            NSDictionary * objc = [NSDictionary dictionaryWithObject:@(indexPath.row) forKey:@"option"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"backToHomeView" object:nil userInfo:objc];
            self.aa.text = @"";
            MMRootViewController * root = (MMRootViewController *)self.mm_drawerController;
            [root toggleDrawerSide:MMDrawerSideLeft animated:NO completion:nil];
            break;
        }
        case 4:{//伙伴联盟
            NSDictionary * objc = [NSDictionary dictionaryWithObject:@(indexPath.row) forKey:@"option"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"backToHomeView" object:nil userInfo:objc];
            MMRootViewController * root = (MMRootViewController *)self.mm_drawerController;
            [root toggleDrawerSide:MMDrawerSideLeft animated:NO completion:nil];
            break;
        }
        case 5:{//内购商城
            NSDictionary * objc = [NSDictionary dictionaryWithObject:@(indexPath.row) forKey:@"option"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"backToHomeView" object:nil userInfo:objc];
            MMRootViewController * root = (MMRootViewController *)self.mm_drawerController;
            [root toggleDrawerSide:MMDrawerSideLeft animated:NO completion:nil];
            break;
        }
        case 6:{//监督管理
//            UserModel * userModel = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
            NSDictionary * objc = [NSDictionary dictionaryWithObject:@(indexPath.row) forKey:@"option"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"backToHomeView" object:nil userInfo:objc];
            MMRootViewController * root = (MMRootViewController *)self.mm_drawerController;
            [root toggleDrawerSide:MMDrawerSideLeft animated:NO completion:nil];
            break;
        }
        case 7:{//更多选项
            NSDictionary * objc = [NSDictionary dictionaryWithObject:@(indexPath.row) forKey:@"option"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"backToHomeView" object:nil userInfo:objc];
            MMRootViewController * root = (MMRootViewController *)self.mm_drawerController;
            [root toggleDrawerSide:MMDrawerSideLeft animated:NO completion:nil];
            break;
        }
        default:
            break;
    }
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.TodayPredictingNumber removeObserver:self forKeyPath:@"today"];
    
}

@end
