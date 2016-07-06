//
//  detailViewController.m
//  fanmore---
//
//  Created by lhb on 15/5/26.
//  Copyright (c) 2015年 HT. All rights reserved.
//  ss
#import "detailViewController.h"
#import "RAYNewFunctionGuideVC.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "MMRootViewController.h"

@interface detailViewController ()<UIWebViewDelegate,NJKWebViewProgressDelegate>

@property(nonatomic,strong)IBOutlet UIWebView * contentWebView;



@property(nonatomic,strong) NewTaskDataModel * modelXX;


@property (weak, nonatomic) IBOutlet UIButton *toppottn;




@property(nonatomic,strong) NewShareModel * shareModel;


@property(nonatomic,strong) UILabel * left;
@property(nonatomic,strong) UILabel * right;

@property (nonatomic, strong) NJKWebViewProgressView *webViewProgressView;
@property (nonatomic, strong) NJKWebViewProgress *webViewProgress;

@end

@implementation detailViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    LWLog(@"%d",self.taskModel.flagShowSend);
    
    
    
    
    
    //判断是否为第一次进入
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *isFirstDatail = [defaults stringForKey:@"isFirstDatail"];
    if (![isFirstDatail isEqualToString:@"1"]){
        [defaults setObject:@"1" forKey:@"isFirstDatail"];
        [defaults synchronize];
        [self makeGuideView];
    }
//    [self makeGuideView];
    
    MMRootViewController * root = (MMRootViewController *)self.mm_drawerController;
    [root setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    
    
  

}
- (void)makeGuideView{
    RAYNewFunctionGuideVC *vc = [[RAYNewFunctionGuideVC alloc]init];
    vc.titles = @[@"温馨提示: 点击分享按钮可以对你喜欢的文章进行分享"];
    //这个页面的.y传1000就行  内部已算好
   
    vc.frames = @[@"{{0, 1000},{350,100}}"];
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (NewShareModel *)shareModel{
    if (_shareModel == nil) {
        _shareModel = [[NewShareModel alloc] init];
    }
    return _shareModel;
}

- (void) setup{
   
    _contentWebView.delegate = self;
    _contentWebView.scrollView.bounces = NO;
}

- (void) addProgramess{
    _webViewProgress = [[NJKWebViewProgress alloc] init];
    _webViewProgress.webViewProxyDelegate = self;
    _webViewProgress.progressDelegate = self;
    CGRect navBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0,
                                 navBounds.size.height - 2,
                                 navBounds.size.width,
                                 2);
    _webViewProgressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _webViewProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_webViewProgressView setProgress:0 animated:YES];
    [self.navigationController.navigationBar addSubview:_webViewProgressView];
    self.contentWebView.delegate = _webViewProgress;

}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.toppottn.hidden = YES;

    AppDelegate * ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ad.currentVC = self;
    
    self.toppottn.layer.cornerRadius = 5;
    self.toppottn.layer.masksToBounds = YES;
    self.toppottn.backgroundColor = [UIColor colorWithRed:233/255.0 green:147/255.0 blue:25/255.0 alpha:1];
    
    [self.toppottn setTitle:@"分享资讯" forState:UIControlStateNormal];
    
    self.contentWebView.scalesPageToFit = YES;
    
    self.contentWebView.scrollView.backgroundColor = [UIColor lightGrayColor];
    
    [self.contentWebView.scrollView setShowsHorizontalScrollIndicator:NO];
    [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor whiteColor];
    
    self.contentWebView.scrollView.contentInset =
    UIEdgeInsetsMake(0, 0, 40, 0);
    self.title = @"资讯详情";
    
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
    
    [self addProgramess];
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
            NewTaskDataModel * model = [NewTaskDataModel mj_objectWithKeyValues:[json objectForKey:@"resultData"]];
            wself.modelXX = model;
            wself.shareModel.taskInfo = json[@"resultData"][@"taskInfo"];
            wself.shareModel.taskSmallImgUrl = json[@"resultData"][@"taskSmallImgUrl"];
            wself.shareModel.taskName = json[@"resultData"][@"taskName"];
           wself.left.text = [NSString stringWithFormat:@"浏览奖励:%@",json[@"resultData"][@"awardScan"]];
            wself.right.text = [NSString stringWithFormat:@"转发奖励:%@",[NSString xiaoshudianweishudeal:[json[@"resultData"][@"awardSend"] floatValue]]];
//            _ShareBtn.hidden = NO;
            self.toppottn.hidden =  !([json[@"resultData"][@"ShowTurnButton"] boolValue]);
            
            NSURL * url = [NSURL URLWithString:json[@"resultData"][@"taskInfo"]];
            NSURLRequest * req = [NSURLRequest requestWithURL:url];
            [_contentWebView loadRequest:req];
            
        }
    } failure:^(NSError *error) {
        
    }];
    
}
- (IBAction)shareBtnClick:(UIButton*)sender {
    
    
    LWLog(@"xxxx%@",[_shareModel mj_keyValues]);
    _shareModel.taskInfo = self.shareModel.taskInfo;
    LWLog(@"xxxx%@",[_shareModel mj_keyValues]);
    [UserLoginTool LoginToShareMessageByShareSdk:_shareModel success:^(int json) {
        NSMutableDictionary * parame = [NSMutableDictionary dictionary];
        UserModel *user =  (UserModel * )[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
        parame[@"loginCode"] = user.loginCode;
        parame[@"type"] = @(json);
        parame[@"taskId"] = @(_taskModel.taskId);
        
        LWLog(@"%@",parame);
        [UserLoginTool loginRequestGet:@"TurnTask" parame:parame success:^(id json) {
            LWLog(@"%@",json);
            if ([json[@"status"] integerValue] == 1 && [json[@"resultCode"] integerValue] == 1){
                [MBProgressHUD showSuccess:@"分享成功"];
                
                self.taskModel.isSend = 1;
//                self.modelXX.isSend = 1;
                //判断是否为第一次分享
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSString *isFirstShare = [defaults stringForKey:@"isFirstShare"];
                //正常是 ! [
                if (![isFirstShare isEqualToString:@"YES"]){
                    [defaults setObject:@"YES" forKey:@"isFirstShare"];
                    [defaults setObject:@"YES" forKey:@"isFirstShareSuccess"];
                    [defaults synchronize];
                }
            }
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"分享失败"];
        }];
     } failure:^(id error) {
        [MBProgressHUD showError:@"分享失败"];
    }];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_webViewProgressView setProgress:progress animated:YES];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [_webViewProgressView removeFromSuperview];
    
    if ([self.delegate respondsToSelector:@selector(ToRefreshDate:)]) {
        [self.delegate ToRefreshDate:self.taskModel];
    }
    
}

@end
