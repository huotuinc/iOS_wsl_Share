//
//  detailViewController.m
//  fanmore---
//
//  Created by lhb on 15/5/26.
//  Copyright (c) 2015年 HT. All rights reserved.
//  ss
#import "detailViewController.h"


@interface detailViewController ()<UIWebViewDelegate>

@property(nonatomic,strong)IBOutlet UIWebView * contentWebView;

@property(nonatomic,strong)IBOutlet UIButton * ShareBtn;

- (IBAction)shareBtnClick:(id)sender;


@property(nonatomic,strong) NewShareModel * shareModel;


@property(nonatomic,strong) UILabel * left;
@property(nonatomic,strong) UILabel * right;



@end

@implementation detailViewController

- (NewShareModel *)shareModel{
    if (_shareModel == nil) {
        _shareModel = [[NewShareModel alloc] init];
    }
    return _shareModel;
}

- (void) setup{
   
    _contentWebView.delegate = self;
    _ShareBtn.layer.cornerRadius = 5;
    _ShareBtn.layer.masksToBounds = YES;
//    _ShareBtn.hidden = YES;
    _contentWebView.scrollView.bounces = NO;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    
    if (self.loi==1) {
        
        self.ShareBtn.hidden = YES;
    }
    
    self.contentWebView.scrollView.backgroundColor = [UIColor whiteColor];
    
    [self.contentWebView.scrollView setShowsHorizontalScrollIndicator:NO];
    [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor whiteColor];
    
    self.contentWebView.scrollView.contentInset =
    UIEdgeInsetsMake(40, 0, 0, 0);
    self.title = @"任务详情";
    
    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, -40, ScreenWidth, 40)];
    topView.backgroundColor = [UIColor whiteColor];
    
    UIView * left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth*0.5-2, 39)];
//    left.backgroundColor = [UIColor lightGrayColor];
    UIImageView * leftImage = [[UIImageView alloc] init];
//    leftImage.backgroundColor = [UIColor redColor];
    leftImage.image = [UIImage imageNamed:@"iconfont-liulan"];
    leftImage.contentMode = UIViewContentModeScaleAspectFit;
    leftImage.frame = CGRectMake(left.frame.size.width *0.25-5, 5, 30, 30);
    [left addSubview:leftImage];
    
    UILabel* ji= [[UILabel alloc] init];
    ji.adjustsFontSizeToFitWidth = YES;
    ji.frame = CGRectMake(CGRectGetMaxX(leftImage.frame)+2, 5, left.frame.size.width -CGRectGetMaxX(leftImage.frame) , 30);
    ji.text = @"xxxxxxx";
    _left = ji;
     ji.font = [UIFont systemFontOfSize:13];
    ji.textColor = [UIColor lightGrayColor];
    [left addSubview:ji];
    
    
    
//    left.backgroundColor = [UIColor blueColor];
    UIView * right = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth*0.5+2, 0, ScreenWidth*0.5-0.5, 39)];

    UIImageView * rightImage = [[UIImageView alloc] init];
//    rightImage.backgroundColor = [UIColor redColor];
    rightImage.image = [UIImage imageNamed:@"iconfont-huijijiayuanzhuanfaicon01"];
    rightImage.contentMode = UIViewContentModeScaleAspectFit;
    rightImage.frame = CGRectMake(right.frame.size.width *0.25-5, 5, 30, 30);
    [right addSubview:rightImage];

    UILabel* jixi= [[UILabel alloc] init];
    jixi.textColor = [UIColor lightGrayColor];
    jixi.adjustsFontSizeToFitWidth = YES;
    jixi.frame = CGRectMake(CGRectGetMaxX(rightImage.frame)+2, 5, right.frame.size.width -CGRectGetMaxX(rightImage.frame) , 30);
    jixi.text = @"xxxxxxx";
    jixi.font = [UIFont systemFontOfSize:13];
    _right = jixi;
    [right addSubview:jixi];
    

    UIView *mid = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth*0.5+0.5, 2, 1, 38)];
    mid.backgroundColor = [UIColor lightGrayColor];
     mid.alpha = 0.8;
    
    UIView * bottom = [[UIView alloc] initWithFrame:CGRectMake(0, 39, ScreenWidth, 1)];
    bottom.backgroundColor = [UIColor lightGrayColor];
    bottom.alpha = 0.8;
    [topView addSubview:bottom];
    
    [topView addSubview:left];
    [topView addSubview:mid];
    [topView addSubview:right];
    [self.contentWebView.scrollView addSubview:topView];
    
//    
//    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage imageNamed:@"iconfont-jiantou"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
//    UIBarButtonItem * it = [UIBarButtonItem appearance]
//    
    [self setup];
    
}


- (void)setTaskModel:(NewTaskDataModel *)taskModel{
    _taskModel = taskModel;
    
    
    
    
//    if(taskModel.isSend){
//        [_ShareBtn setTitle:@"已转发" forState:UIControlStateNormal];
//        [_ShareBtn setBackgroundColor:[UIColor lightGrayColor]];
//        _ShareBtn.userInteractionEnabled = NO;
//    }
//    
//    if (taskModel.lastScore<= 0.01) {
//        [_ShareBtn setTitle:@"已转发" forState:UIControlStateNormal];
//        [_ShareBtn setBackgroundColor:[UIColor lightGrayColor]];
//        _ShareBtn.userInteractionEnabled = NO;
//        
//    }
    __weak detailViewController * wself = self;
    UserModel * user =  (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"loginCode"] = user.loginCode;
    parame[@"taskId"] = @(taskModel.taskId);
    [UserLoginTool loginRequestGet:@"TaskDetail" parame:parame success:^(id json) {
        
        LWLog(@"%@",json);
        if ([json[@"status"] integerValue] == 1 && [json[@"resultCode"] integerValue] == 1) {
            wself.shareModel.taskInfo = json[@"resultData"][@"taskInfo"];
            wself.shareModel.taskSmallImgUrl = json[@"resultData"][@"taskSmallImgUrl"];
            wself.shareModel.taskName = json[@"resultData"][@"taskName"];
           
            wself.left.text = [NSString stringWithFormat:@"浏览奖励:%@",json[@"resultData"][@"awardScan"]];
            wself.right.text = [NSString stringWithFormat:@"转发奖励:%@",[NSString xiaoshudianweishudeal:[json[@"resultData"][@"awardSend"] floatValue]]];
//            _ShareBtn.hidden = NO;
            
            NSURL * url = [NSURL URLWithString:json[@"resultData"][@"taskInfo"]];
            NSURLRequest * req = [NSURLRequest requestWithURL:url];
            [_contentWebView loadRequest:req];
            
        }
    } failure:^(NSError *error) {
        
    }];
    
}
- (IBAction)shareBtnClick:(id)sender {
    
    [UserLoginTool LoginToShareMessageByShareSdk:_shareModel success:^(int json) {
        NSMutableDictionary * parame = [NSMutableDictionary dictionary];
        UserModel *user =  (UserModel * )[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
        parame[@"loginCode"] = user.loginCode;
        parame[@"type"] = @(json);
        parame[@"taskId"] = @(_taskModel.taskId);
        [UserLoginTool loginRequestGet:@"TurnTask" parame:parame success:^(id json) {
            LWLog(@"%@",json);
            if ([json[@"status"] integerValue] == 1 && [json[@"resultCode"] integerValue] == 1){
                [MBProgressHUD showSuccess:@"分享成功"];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"分享失败"];
        }];
     } failure:^(id error) {
        [MBProgressHUD showError:@"分享失败"];
    }];
}


@end
