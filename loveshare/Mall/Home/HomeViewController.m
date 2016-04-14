//
//  HomeViewController.m
//  HuoBanMallBuy
//
//  Created by lhb on 15/9/5.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "HomeViewController.h"
#import <NJKWebViewProgress.h>
#import <NJKWebViewProgressView.h>

#import "UIViewController+MMDrawerController.h"

@interface HomeViewController()<UIWebViewDelegate,UIActionSheetDelegate,NJKWebViewProgressDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *homeWebView;


@property (weak, nonatomic) IBOutlet UIWebView *homeBottonWebView;

/***/
@property(nonatomic,strong) NSMutableString * debugInfo;
/**
 *  是否显示返回按钮
 *  1、表示显示
 *  2、表示不显示
 */
@property(nonatomic,assign) BOOL showBackArrows;

/**底部网页约束高度*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *homeBottonWebViewHeight;
/**图标*/
@property (nonatomic,strong) UIButton * backArrow;
/**返回按钮*/
@property (nonatomic,strong) UIButton * leftOption;

/**刷新按钮标*/
@property (nonatomic,strong) UIButton * refreshBtn;
/**分享按钮*/
@property (nonatomic,strong) UIButton * shareBtn;


/**账号提升选秀*/
@property (nonatomic,strong) UITableView * midtableView;

/**登陆后的背景遮罩*/
@property (nonatomic,strong) UIView * backView;

/**本地账号*/
@property (nonatomic,strong) NSArray * LocalAccounts;

@property(nonatomic,strong) NSString * orderNo;       //订单号
@property(nonatomic,strong) NSString * priceNumber;  //订单价格
@property(nonatomic,strong) NSString * proDes;       //订单描述
/**支付的url*/
@property(nonatomic,strong) NSString * ServerPayUrl;

@property(nonatomic,strong) PayModel * paymodel;

@property(nonatomic,strong) MJRefreshNormalHeader * header;
@property (nonatomic, strong) NJKWebViewProgressView * webViewProgressView;
@property (nonatomic, strong) NJKWebViewProgress *webViewProgress;

@end


@implementation HomeViewController


- (NSMutableString *)debugInfo{
    
    if (_debugInfo == nil) {
        
        _debugInfo = [NSMutableString string];
    }
    return _debugInfo;
}


- (UIButton *)backArrow{
    if (_backArrow == nil) {
        _backArrow = [[UIButton alloc] init];
        _backArrow.frame = CGRectMake(0, 0, 25, 25);
        [_backArrow addTarget:self action:@selector(BackToWebView) forControlEvents:UIControlEventTouchUpInside];
        [_backArrow setBackgroundImage:[UIImage imageNamed:@"main_title_left_back"] forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backArrow];
    }
    return _backArrow;
}

- (UIButton *)leftOption{
    
    if (_leftOption == nil) {
        _leftOption = [[UIButton alloc] init];
        _leftOption.frame = CGRectMake(0, 0, 25, 25);
        [_leftOption addTarget:self action:@selector(GoToLeft) forControlEvents:UIControlEventTouchUpInside];
        [_leftOption setBackgroundImage:[UIImage imageNamed:@"main_title_left_sideslip"] forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_leftOption];
    }
    return _leftOption;
}


- (void)GoToLeft{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (UIButton *)shareBtn{
    if (_shareBtn == nil) {
        _shareBtn = [[UIButton alloc] init];
        _shareBtn.frame = CGRectMake(0, 0, 25, 25);
        [_shareBtn addTarget:self action:@selector(shareBtnClicks) forControlEvents:UIControlEventTouchUpInside];
        [_shareBtn setBackgroundImage:[UIImage imageNamed:@"home_title_right_share"] forState:UIControlStateNormal];
    }
    return _shareBtn;
}


-(UIButton *)refreshBtn{
    if (_refreshBtn == nil) {
        _refreshBtn = [[UIButton alloc] init];
        _refreshBtn.frame = CGRectMake(0, 0, 25, 25);
        [_refreshBtn addTarget:self action:@selector(refreshToWebViews) forControlEvents:UIControlEventTouchUpInside];
        [_refreshBtn setBackgroundImage:[UIImage imageNamed:@"main_title_left_refresh"] forState:UIControlStateNormal];
        [_refreshBtn setBackgroundImage:[UIImage imageNamed:@"loading"] forState:UIControlStateHighlighted];
    }
    return _refreshBtn;
}

/**
 *  刷新
 */
- (void)refreshToWebViews{
     [_refreshBtn setBackgroundImage:[UIImage imageNamed:@"loading"] forState:UIControlStateNormal];
    self.refreshBtn.userInteractionEnabled = NO;

    [self.homeWebView reload];
}

/**
 *  分享
 */
- (void)shareBtnClicks{
    [self shareSdkSha];
}




/**
 *  分享url处理
 */
- (NSString *) toCutew:(NSString *)urs{
    
    NSString * gduid = [[NSUserDefaults standardUserDefaults] objectForKey:@"unionid"];
    NSRange rang = [urs rangeOfString:@"?"];
    NSString * back = [urs substringFromIndex:rang.location + 1];
    NSArray * aa =  [back componentsSeparatedByString:@"&"];
    __block NSMutableArray * todelete = [NSMutableArray arrayWithArray:aa];
    NSArray * key = @[@"unionid",@"appid",@"sign"];
    [aa enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [key enumerateObjectsUsingBlock:^(NSString * key, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj containsString:key]) {
                [todelete removeObject:obj];
            }
        }];
    }];
    NSMutableString * cc = [[NSMutableString alloc] init];
    [todelete enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *  stop) {
        
        [cc appendFormat:@"%@&",obj];
    }];
    [cc appendFormat:@"gduid=%@",gduid];
    NSString * ee = [urs substringToIndex:rang.location+1];
    NSString * dd = [NSString stringWithFormat:@"%@%@",ee,cc];
    return dd;
}

- (void)shareSdkSha{
    if(self.homeWebView.isLoading){
        [MBProgressHUD showError:@"商城加载中.."];
        return;
    }
    
//    NSString * urs =  self.homeWebView.request.URL.absoluteString;
    NewShareModel * newshare= [[NewShareModel alloc] init];
    newshare.taskInfo = [[NSUserDefaults standardUserDefaults] objectForKey:WebSit];
    newshare.taskName = @"万事利商城";
    newshare.taskSmallImgUrl = nil;
    [UserLoginTool LoginToShareMessageByShareSdk:newshare success:^(int json) {
        LWLog(@"%d",json);
    } failure:^(id error) {
    
    }];
        
}

- (void)SelectMoreAccount{
    
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * filename = [[array objectAtIndex:0] stringByAppendingPathComponent:MallUesrList];
    NSData *data = [NSData dataWithContentsOfFile:filename];
    // 2.创建反归档对象
    NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    // 3.解码并存到数组中
    NSArray *namesArray = [unArchiver decodeObjectForKey:MallUesrList];
    if (namesArray.count) {
        
        LWLog(@"namesArray.count");
    }
    LWLog(@"namesArray.count");
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self SelectMoreAccount];
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
    
    InitModel * initM = (InitModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:InitModelCaches];
    NSString * ddd = [NSString stringWithFormat:@"%@/%@/index.aspx?back=1",[[NSUserDefaults standardUserDefaults] objectForKey:WebSit],initM.customerId];
    LWLog(@"%@",ddd);
    NSURL * urlStr = [NSURL URLWithString:[NSDictionary ToSignUrlWithString:ddd]];
    NSURLRequest * req = [[NSURLRequest alloc] initWithURL:urlStr];
    self.homeWebView.scalesPageToFit = YES;
    self.homeWebView.tag = 100;
    self.homeWebView.delegate = _webViewProgress;
//    self.homeWebView.scrollView.bounces = NO;
    [self.homeWebView loadRequest:req];
    
    
    InitModel * ini = (InitModel * )[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:InitModelCaches];
//    NSString * uraaaaa = [[NSUserDefaults standardUserDefaults] objectForKey:AppMainUrl];
    NSString * cc = [NSString stringWithFormat:@"%@%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:WebSit],@"/bottom.aspx?customerid=",ini.customerId];
    LWLog(@"%@",cc);
    NSURLRequest * Bottomreq = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:cc]];
    self.homeBottonWebView.scalesPageToFit = YES;
    self.homeBottonWebView.delegate = self;
    self.homeBottonWebView.tag = 20;
//    self.homeBottonWebView.hidden = YES;
    self.homeBottonWebView.scrollView.bounces = NO;
    self.homeBottonWebView.scrollView.scrollEnabled = NO;
    [self.homeBottonWebView loadRequest:Bottomreq];

    //集成刷新控件
    [self AddMjRefresh];
    
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.shareBtn]];

}



- (void)AddMjRefresh{

//    // 添加下拉刷新控件
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    header.stateLabel.hidden = YES;
    header.arrowView.image= nil;
    _header = header;
    self.homeWebView.scrollView.mj_header = header;

}



/*
 *网页下拉刷新
 */
- (void)loadNewData{
    [self.homeWebView reload];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    
    MMRootViewController * root = (MMRootViewController *)self.mm_drawerController;
    [root setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [root setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    
}




/**
 *  网页
 */
- (void)BackToWebView{
    if ([self.homeWebView canGoBack]) {
        [self.homeWebView goBack];
    }
}


- (void)LeftbackToHome:(NSNotification *) note{
    
    NSString * backUrl = [note.userInfo objectForKey:@"url"];
    NSURL * newUrl = [NSURL URLWithString:backUrl];
    NSURLRequest * req = [[NSURLRequest alloc] initWithURL:newUrl];
    [self.homeWebView loadRequest:req];
}

- (UIView *)ReturnNavPictureWithName:(NSString *)name andTwo:(NSString *)share{
 
    return nil;
}

- (UIView *)ReturnNavPictureWithName:(NSString *)name{
    
    UIButton *leftbutton = [[UIButton alloc] init];
    if ([name isEqualToString:@"home_title_left_menu"]) {
        leftbutton.tag = 0;
    }else{
        leftbutton.tag = 1;
    }
    leftbutton.frame = CGRectMake(0, 0, 25, 25);
    [leftbutton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    [leftbutton setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    return leftbutton;
}

- (void)presentLeftMenuViewController:(UIButton *)item{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    if (webView.tag == 100) {
        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        if (_showBackArrows) {//返回按钮
            [UIView animateWithDuration:0.05 animations:^{
                self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftOption];
            }];
        }else{
            [UIView animateWithDuration:0.05 animations:^{
                self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backArrow];
            }];
        }
    }
    
    [self.homeWebView.scrollView.mj_header endRefreshing];
}



- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    
    LWLog(@"%ld",(long)webView.tag);
    NSString *url = request.URL.absoluteString;
    LWLog(@"%@",url);
    if ([url isEqualToString:@"about:blank"]) {
        return NO;
    }
    if (webView.tag == 100) {
        if ([url rangeOfString:@"/UserCenter/Login.aspx"].location !=  NSNotFound) {
            UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController * login =  [main instantiateViewControllerWithIdentifier:@"LoginViewController"];
            UINavigationController * root = [[UINavigationController alloc] initWithRootViewController:login];
            [self presentViewController:root animated:YES completion:nil];
            
        }else if([url rangeOfString:@"AppAlipay.aspx"].location != NSNotFound){
                self.ServerPayUrl = [url copy];
                NSRange trade_no = [url rangeOfString:@"trade_no="];
                NSRange customerID = [url rangeOfString:@"customerID="];
                //            NSRange paymentType = [url rangeOfString:@"paymentType="];
                NSRange trade_noRange = {trade_no.location + 9,customerID.location-trade_no.location-10};
                NSString * trade_noss = [url substringWithRange:trade_noRange];//订单号
                self.orderNo = trade_noss;
                //            NSString * payType = [url substringFromIndex:paymentType.location+paymentType.length];
                // 1.得到data
                NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString * filename = [[array objectAtIndex:0] stringByAppendingPathComponent:PayTypeflat];
                NSData *data = [NSData dataWithContentsOfFile:filename];
                // 2.创建反归档对象
                NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
                // 3.解码并存到数组中
                NSArray *namesArray = [unArchiver decodeObjectForKey:PayTypeflat];
//                NSMutableString * url = [NSMutableString stringWithString:MainUrl];
//                [url appendFormat:@"%@?orderid=%@",@"/order/GetOrderInfo",trade_noss];
//                NSString * to = [NSDictionary ToSignUrlWithString:url];
            NSMutableDictionary * dict =[NSMutableDictionary dictionary];
            dict[@"orderNo"] = trade_noss;
            [UserLoginTool loginRequestGet:@"OrderInfo" parame:dict success:^(id json) {
                LWLog(@"%@",json);
                if ([json[@"status"] integerValue] == 1 && [json[@"resultCode"] integerValue] == 1) {
                    self.priceNumber = json[@"resultData"][@"Final_Amount"];
                    //                    NSLog(@"%@",self.priceNumber);
                    NSString * des =  json[@"resultData"][@"ToStr"]; //商品描述
                    //                    NSLog(@"%@",json[@"data"][@"ToStr"]);
                    self.proDes = [des copy];
                        if(namesArray.count == 1){
                            PayModel * pay =  namesArray.firstObject;  //300微信  400支付宝
                            self.paymodel = pay;
                            if ([pay.payType integerValue] == 300) {//300微信
                                UIActionSheet * aa =  [[UIActionSheet alloc] initWithTitle:@"支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信", nil];
                                aa.tag = 500;//单个微信支付
                                [aa showInView:self.view];
                            }
                            if ([pay.payType integerValue] == 400) {//400支付宝
                                UIActionSheet * aa =  [[UIActionSheet alloc] initWithTitle:@"支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝", nil];
                                aa.tag = 700;//单个支付宝支付
                                [aa showInView:self.view];
                            }
                        }else if(namesArray.count == 2){
                            UIActionSheet * aa =  [[UIActionSheet alloc] initWithTitle:@"支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝",@"微信", nil];
                            aa.tag = 900;//两个都有的支付
                            [aa showInView:self.view];
                        }
                        
                    }

                } failure:^(NSError *error) {
                    LWLog(@"%@",error.description);
                }];
                return NO;
         

            
        }else{
            NSRange range = [url rangeOfString:@"__newframe"];
            if (range.location != NSNotFound) {
                UIStoryboard * mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                PushWebViewController * funWeb =  [mainStory instantiateViewControllerWithIdentifier:@"PushWebViewController"];
                funWeb.funUrl = url;
                [self.navigationController pushViewController:funWeb animated:YES];
                return NO;
            }else{
                
                NSRange range = [url rangeOfString:@"back"];
                if (range.location != NSNotFound) {
                    self.showBackArrows = YES;
                }else{
                    self.showBackArrows = NO;
                }
                return YES;
            }
            
            
        }
        
        
    }else if(webView.tag == 20){
        InitModel * ini = (InitModel * )[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:InitModelCaches];
        NSString * uraaaaa = [[NSUserDefaults standardUserDefaults] objectForKey:WebSit];
        NSString * cc = [NSString stringWithFormat:@"%@%@%@",uraaaaa,@"/bottom.aspx?customerid=",ini.customerId];
        if ([url isEqualToString:cc]) {
            return YES;
        }else if([url rangeOfString:@"http://wpa.qq.com/msgrd?v=3&uin"].location != NSNotFound){
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]]; //拨号
            }else{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/cn/app/qq/id451108668?mt=12"]]; //拨号
            }
            return NO;
        }else {

            NSRange range = [url rangeOfString:@"back"];
            NSString * newUrls = nil;
            if (range.location != NSNotFound) {
                
                newUrls = [url stringByReplacingCharactersInRange:range withString:@"back=1"];
            }else{
                newUrls = [NSString stringWithFormat:@"%@&back=1",url];
            }
           
            NSRange ran = [newUrls rangeOfString:@"aspx"];
            NSString * newUrl = nil;
            if (ran.location != NSNotFound) {
                NSRange cc = NSMakeRange(ran.location+ran.length, 1);
                newUrl = [newUrls stringByReplacingCharactersInRange:cc withString:@"?"];
            }
            NSString * dddd = [NSDictionary ToSignUrlWithString:newUrl];
            NSURL * urlStr = [NSURL URLWithString:dddd];
            NSURLRequest * req = [[NSURLRequest alloc] initWithURL:urlStr];
            [self.homeWebView loadRequest:req];
            return NO;
        }
    }
    return YES;
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == 500) {//单个微信支付
        NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * filename = [[array objectAtIndex:0] stringByAppendingPathComponent:PayTypeflat];
        NSData *data = [NSData dataWithContentsOfFile:filename];
        // 2.创建反归档对象
        NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        // 3.解码并存到数组中
        NSArray *namesArray = [unArchiver decodeObjectForKey:PayTypeflat];
        [self WeiChatPay:namesArray[0]];
    }else if (actionSheet.tag == 700){// 单个支付宝支付
        //NSLog(@"支付宝%ld",(long)buttonIndex);
        //        [self MallAliPay:self.paymodel];
    }else if(actionSheet.tag == 900){//两个都有的支付
        //0
        //1
        NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * filename = [[array objectAtIndex:0] stringByAppendingPathComponent:PayTypeflat];
        NSData *data = [NSData dataWithContentsOfFile:filename];
        // 2.创建反归档对象
        NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        // 3.解码并存到数组中
        NSArray *namesArray = [unArchiver decodeObjectForKey:PayTypeflat];
        if (buttonIndex==0) {//支付宝
            PayModel * paymodel =  namesArray[0];
            PayModel *cc =  [paymodel.payType integerValue] == 400?namesArray[0]:namesArray[1];
            if (cc.webPagePay) {//网页支付
                NSRange parameRange = [self.ServerPayUrl rangeOfString:@"?"];
                NSString * par = [self.ServerPayUrl substringFromIndex:(parameRange.location+parameRange.length)];
                NSArray * arr = [par componentsSeparatedByString:@"&"];
                __block NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                [arr enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
                    NSArray * aa = [obj componentsSeparatedByString:@"="];
                    NSDictionary * dt = [NSDictionary dictionaryWithObject:aa[1] forKey:aa[0]];
                    [dict addEntriesFromDictionary:dt];
                }];
                NSString * js = [NSString stringWithFormat:@"utils.Go2Payment(%@, %@, 1, false)",dict[@"customerID"],dict[@"trade_no"]];
                [self.homeWebView stringByEvaluatingJavaScriptFromString:js];
            }else{
                [self MallAliPay:cc];
            }
        }
        if (buttonIndex==1) {//微信
            PayModel * paymodel =  namesArray[0];
            if ([paymodel.payType integerValue] == 300) {
                [self WeiChatPay:namesArray[0]];
            }else{
                [self WeiChatPay:namesArray[1]];//微信
            }
            
        }
        
    }
    
}

/**
 *  商城支付宝支付
 */
- (void)MallAliPay:(PayModel *)pay{
    
//    NSString *privateKey = pay.appKey;
//    // @"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAMCul0XS9X/cVMkmrSeaZXnSvrs/bK5EiZf3d3/lTwHx165wAX/UIz4AcZHbKkYKKzmZKrRsu3tLRKFuflooKSVmWxk2hmeMqRETPZ/t8rKf8UONZIpOlOXEmJ/rYwxhnMeVhbJJxsko2so/jc+XAPLyv0tsfoI/TsJuhaGQ569ZAgMBAAECgYAK4lHdOdtwS4vmiO7DC++rgAISJbUH6wsysGHpsZRS8cxTKDSNefg7ql6/9Hdg2XYznLlS08mLX2cTD2DHyvj38KtxLEhLP7MtgjFFeTJ5Ta1UuBRERcmy0xSLh2zayiSwGTM8Bwu7UD6LUSTGwrgRR2Gg4EDpSG08J5OCThKF4QJBAPOO6WKI/sEuoRDtcIJqtv58mc4RSmit/WszkvPlZrjNFDU6TrOEnPU0zi3f8scxpPxVYROBceGj362m+02G2I0CQQDKhlq4pIM2FLNoDP4mzEUyoXIwqn6vIsAv8n49Tr9QnBjCrKt8RiibhjSEvcYqM/1eocW0j2vUkqR17rNuVVz9AkBq+Z02gzdpwEJMPg3Jqnd/pViksuF8wtbo6/kimOKaTrEOg/KnVJrf9HaOnatzpDF0B0ghGhzb329SRWJhddXNAkAkjrgVmGyu+HGiGKZP7pOXHhl0u3H+vzEd9pHfEzXpoSO/EFgsKKXv3Pvh8jexKo1T5bPAchsu1gGl4B63jeUpAkBbgUalUpZWZ4Aii+Mfts+S2E5RooZfVFqVBIsK47hjcoqLw4JJenyjFu+Skl2jOQ8+I5y1Ggeg6fpBMr2rbVkf";
//    
//    Order *order = [[Order alloc] init];
//    order.service = @"mobile.securitypay.pay";
//    order.partner = pay.partnerId;
//    order.inputCharset = @"utf-8";
//    NSMutableString * urls = [NSMutableString stringWithString:MainUrl];
//    [urls appendString:pay.notify];
//    order.notifyURL = urls;
//    order.tradeNO = self.orderNo;
//    order.productName = self.proDes;;
//    order.productDescription = self.proDes;;
//    order.amount = [NSString stringWithFormat:@"%.2f",[self.priceNumber floatValue]];  //订单总金额，只能为整数，详见支付金额;
//    order.paymentType = @"1";
//    order.seller = pay.partnerId;
//    //将商品信息拼接成字符串
//    NSString *orderSpec = [order description];
//    id<DataSigner> signer = CreateRSADataSigner(privateKey);
//    NSString *signedString = [signer signString:orderSpec];
//    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
//    NSDictionary *infoPlist =[NSDictionary dictionaryWithContentsOfFile:path];
//    NSString * appScheme = [[[[infoPlist objectForKey:@"CFBundleURLTypes"] firstObject] objectForKey:@"CFBundleURLSchemes"] lastObject];
//    
//    //将签名成功字符串格式化为订单字符串,请严格按照该格式
//    NSString *orderString = nil;
//    if (signedString != nil) {
//        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                       orderSpec, signedString, @"RSA"];
//        
//        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:nil];
//    }
    
}


/**
 *  微信支付
 */
- (void)WeiChatPay:(PayModel *)model{
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [self PayByWeiXinParame:model];
    if(dict != nil){
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        [WXApi sendReq:req];
    }else{
        NSLog(@"提示信息----微信预支付失败");
    }
}


/**
 *  微信支付预zhifu
 */
- (NSMutableDictionary *)PayByWeiXinParame:(PayModel *)paymodel{
    LWLog(@"%@",[paymodel mj_keyValues]);
    payRequsestHandler * payManager = [[payRequsestHandler alloc] init];
    [payManager setKey:paymodel.appKey];
    BOOL isOk = [payManager init:self.paymodel.appId mch_id:self.paymodel.partnerId];
    if (isOk) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSString *noncestr  = [NSString stringWithFormat:@"%d", rand()];
        params[@"appid"] = paymodel.appId;
        params[@"mch_id"] = paymodel.partnerId;     //微信支付分配的商户号
        params[@"nonce_str"] = noncestr; //随机字符串，不长于32位。推荐随机数生成算法
        params[@"trade_type"] = @"APP";   //取值如下：JSAPI，NATIVE，APP，WAP,详细说明见参数规定
        params[@"body"] = @"万事利商城";//MallName; //商品或支付单简要描述
        NSMutableString * urls = [[NSUserDefaults standardUserDefaults] objectForKey:WebSit];
        LWLog(@"%@",urls);
        NSString * URL = [NSString stringWithFormat:@"%@%@",urls,paymodel.notify];
        LWLog(@"%@",URL);
        params[@"notify_url"] = URL;  //接收微信支付异步通知回调地址
        InitModel * initmod =  (InitModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:InitModelCaches];
        NSString * order = [NSString stringWithFormat:@"%@_%@_%d",self.orderNo,initmod.customerId,(arc4random() % 900 + 100)];
        params[@"out_trade_no"] = order; //订单号
        params[@"spbill_create_ip"] = @"192.168.1.1"; //APP和网页支付提交用户端ip，Native支付填调用微信支付API的机器IP。
        params[@"total_fee"] = [NSString stringWithFormat:@"%.f",[self.priceNumber floatValue] * 100];  //订单总金额，只能为整数，详见支付金额
        params[@"device_info"] = ([[UIDevice currentDevice].identifierForVendor UUIDString]);
        params[@"attach"] = [NSString stringWithFormat:@"%@_0",initmod.customerId];
        //获取prepayId（预支付交易会话标识）
        NSString * prePayid = nil;
        prePayid  = [payManager sendPrepay:params];
        LWLog(@"xcaccasc%@",[payManager getDebugifo]);
        if ( prePayid != nil) {
            //获取到prepayid后进行第二次签名
            NSString    *package, *time_stamp, *nonce_str;
            //设置支付参数
            time_t now;
            time(&now);
            time_stamp  = [NSString stringWithFormat:@"%ld", now];
            nonce_str	= [WXUtil md5:time_stamp];
            //重新按提交格式组包，微信客户端暂只支持package=Sign=WXPay格式，须考虑升级后支持携带package具体参数的情况
            //package       = [NSString stringWithFormat:@"Sign=%@",package];
            package         = @"Sign=WXPay";
            //第二次签名参数列表
            NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
            [signParams setObject: paymodel.appId  forKey:@"appid"];
            [signParams setObject: nonce_str    forKey:@"noncestr"];
            [signParams setObject: package      forKey:@"package"];
            [signParams setObject: paymodel.partnerId   forKey:@"partnerid"];
            [signParams setObject: time_stamp   forKey:@"timestamp"];
            [signParams setObject: prePayid     forKey:@"prepayid"];
            //生成签名
            NSString *sign  = [payManager createMd5Sign:signParams];
            //添加签名
            [signParams setObject: sign forKey:@"sign"];
            [_debugInfo appendFormat:@"第二步签名成功，sign＝%@\n",sign];
            //返回参数列表
            return signParams;
        }else{
            [_debugInfo appendFormat:@"获取prepayid失败！\n"];
        }
        
    }
    return nil;
}


#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_webViewProgressView setProgress:progress animated:YES];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [_webViewProgressView removeFromSuperview];

}

@end


