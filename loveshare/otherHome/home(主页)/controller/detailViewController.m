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
    
    self.title = @"任务详情";
//    
//    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage imageNamed:@"iconfont-jiantou"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
//    UIBarButtonItem * it = [UIBarButtonItem appearance]
//    
    [self setup];
    
}


- (void)setTaskModel:(NewTaskDataModel *)taskModel{
    _taskModel = taskModel;
    
    if(taskModel.isSend){
        [_ShareBtn setTitle:@"已转发" forState:UIControlStateNormal];
        [_ShareBtn setBackgroundColor:[UIColor lightGrayColor]];
        _ShareBtn.userInteractionEnabled = NO;
    }
    
    if (taskModel.lastScore<= 0.01) {
        [_ShareBtn setTitle:@"已转发" forState:UIControlStateNormal];
        [_ShareBtn setBackgroundColor:[UIColor lightGrayColor]];
        _ShareBtn.userInteractionEnabled = NO;
        
    }
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
            NSURL * url = [NSURL URLWithString:@"http://www.jianshu.com/p/d4e9a4e2f639"];
            NSURLRequest * req = [NSURLRequest requestWithURL:url];
            [_contentWebView loadRequest:req];
            _ShareBtn.hidden = NO;
            
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
