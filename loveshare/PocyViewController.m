//
//  PocyViewController.m
//  loveshare
//
//  Created by lhb on 16/6/28.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "PocyViewController.h"

@interface PocyViewController ()<UIWebViewDelegate>

@end

@implementation PocyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIWebView * web = [[UIWebView alloc] initWithFrame:self.view.bounds];
    web.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    NSURLRequest * res = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.url]];
    web.delegate = self;
    [web loadRequest:res];
    [self.view addSubview:web];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}
@end
