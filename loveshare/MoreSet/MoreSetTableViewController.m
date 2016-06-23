//
//  MoreSetTableViewController.m
//  loveshare
//
//  Created by lhb on 16/3/10.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "MoreSetTableViewController.h"
#import "LoginChangePasswdViewController.h"

@interface MoreSetTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *versionNum;

@property (weak, nonatomic) IBOutlet UILabel *imageCache;

@end

@implementation MoreSetTableViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate * ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ad.currentVC = self;
    
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:237.0/255 green:237/255.0 blue:237/255.0 alpha:1.000]];
//    NSMutableDictionary * textAttr = [NSMutableDictionary dictionary];
//    textAttr[NSForegroundColorAttributeName] = [UIColor blackColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:textAttr];
    
    self.title = @"更多选项";
    self.versionNum.text = [NSString stringWithFormat:@"v%@",AppVersion];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.imageCache.text = [NSString stringWithFormat:@"%@M",[NSString xiaoshudianweishudeal:([[SDImageCache sharedImageCache] getSize]) /1024.0/1024]];
}


#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, ScreenWidth-40, 44)];
    return button;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 1) {
        [[SDImageCache sharedImageCache] clearDisk];
        self.imageCache.text = [NSString stringWithFormat:@"%@M",[NSString xiaoshudianweishudeal:([[SDImageCache sharedImageCache] getSize]) /1024.0/1024]];
        LWLog(@"xxx");
    }else if(indexPath.row == 2){

        
        
        LoginChangePasswdViewController * vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginChangePasswdViewController"];
        vc.IsRegist = NO;
        vc.isInapp = YES;
//        LWNavigationController * nav = [[LWNavigationController alloc] initWithRootViewController:vc];
        
        [self.navigationController pushViewController:vc animated:YES];
//        [self presentViewController:nav animated:YES completion:nil];
        
    }else if(indexPath.row == 3){
//        LoginChangePasswdViewController * vc = (LoginChangePasswdViewController *)[UserLoginTool LoginCreateControllerWithNameOfStory:nil andControllerIdentify:@"LoginChangePasswdViewController"];
//        LWNavigationController * nav = [[LWNavigationController alloc] initWithRootViewController:vc];
//        [self presentViewController:nav animated:YES completion:nil];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
        //得到输入框
        UITextField *tf = [alertView textFieldAtIndex:0];
        LWLog(@"%@",tf.text);
        if (!tf.text.length) {
            [MBProgressHUD showError:@"手机号不能为空"];
            return;
        }else{
            UserModel * userIno = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            dict[@"loginCode"] = userIno.loginCode;
            dict[@"phone"] = tf.text;
            [UserLoginTool loginRequestGet:@"BindMobile" parame:dict success:^(id json) {
                LWLog(@"%@",json);
            } failure:nil];
            
        }

    
}



/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
