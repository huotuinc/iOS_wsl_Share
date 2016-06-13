//
//  AdViewController.m
//  loveshare
//
//  Created by lhb on 16/6/13.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "AdViewController.h"

@interface AdViewController ()

@end

@implementation AdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    LWLog(@"%@",self.adLink);
    UIWebView * ad = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    NSURLRequest * req = [NSURLRequest requestWithURL:[NSURL URLWithString:self.adLink]];
    [ad loadRequest:req];
    [self.view addSubview:ad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
