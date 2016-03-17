//
//  MallBackViewController.m
//  loveshare
//
//  Created by lhb on 16/3/17.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "MallBackViewController.h"

@interface MallBackViewController ()
- (IBAction)DOClick:(id)sender;

@end

@implementation MallBackViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)DOClick:(id)sender {
    HomeViewController * vc =  (HomeViewController *)[UserLoginTool LoginCreateControllerWithNameOfStory:nil andControllerIdentify:@"HomeViewController"];
    [self.navigationController pushViewController:vc animated:NO];
}
@end
