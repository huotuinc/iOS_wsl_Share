//
//  MMRootViewController.m
//  loveshare
//
//  Created by lhb on 16/3/6.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "MMRootViewController.h"


@interface MMRootViewController ()

@end

@implementation MMRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   LeftOfRootViewController * leftVc =  (LeftOfRootViewController *)[UserLoginTool LoginCreateControllerWithNameOfStory:nil andControllerIdentify:@"LeftOfRootViewController"];
    LWNavigationController * NAV =[[LWNavigationController alloc] initWithRootViewController:leftVc];
    self.leftDrawerViewController = NAV;
    
    self.rightDrawerViewController = nil;
    
    
    self.centerViewController =[[LWNavigationController alloc] initWithRootViewController:[[HomeListViewController alloc] initWithStyle:UITableViewStylePlain]];
    
    //设置手势范围
    [self setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    
    [self setShowsShadow:YES];
    
    self.shadowOpacity = 0.1;
    self.maximumLeftDrawerWidth =  ScreenWidth*0.8;
//    // 6.设置动画切换
//    // 01.配置动画
//    [self setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
//        MMDrawerControllerDrawerVisualStateBlock block = [[MMExampleDrawerVisualStateManager sharedManager] drawerVisualStateBlockForDrawerSide:drawerSide];
//        if (block != nil) {
//            block(drawerController,drawerSide,percentVisible);
//        }
//        
//    }];
//    
//    [self setShowsShadow:NO];
//    [MMExampleDrawerVisualStateManager sharedManager].leftDrawerAnimationType = MMDrawerAnimationTypeSlideAndScale;
    
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
