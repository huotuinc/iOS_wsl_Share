//
//  WeiXinBackViewController.m
//  Fanmore
//
//  Created by lhb on 15/12/4.
//  Copyright © 2015年 Cai Jiang. All rights reserved.
//

#import "WeiXinBackViewController.h"

#import "UIImageView+WebCache.h"
#import "LoginViewController.h"

@interface WeiXinBackViewController ()

/**微信头像*/
@property (weak, nonatomic) IBOutlet UIImageView *weiXInIconView;
/**微信用户名*/
@property (weak, nonatomic) IBOutlet UILabel *WeiXinUserName;


@end

@implementation WeiXinBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    
    AppDelegate * ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ad.currentVC = self;
}


- (void) setup{
    
    self.title = @"微信信息";
    
    self.weiXInIconView.layer.cornerRadius = self.weiXInIconView.frame.size.height * 0.5;
    self.weiXInIconView.layer.masksToBounds = YES;
    self.weiXInIconView.layer.borderWidth = 2;
    self.weiXInIconView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [self.weiXInIconView sd_setImageWithURL:[NSURL URLWithString:self.model.headimgurl] placeholderImage:nil completed:nil];
    
    [self.WeiXinUserName setText:self.model.nickname];
    //设置返回按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 20, 50, 30);
    [button setTitle:@"取消" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)buttonAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



/**
 *  微信后注册
 *
 *  @param sender <#sender description#>
 */
- (IBAction)NetActionStep:(id)sender {
    LoginViewController * Register =[UserLoginTool LoginCreateControllerWithNameOfStory:nil andControllerIdentify:@"LoginViewController"];
    Register.callType = 2;
    Register.model = self.model;
    [self.navigationController pushViewController:Register animated:YES];
   
}


@end
