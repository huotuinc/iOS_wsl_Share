//
//  TopTenListTableViewController.m
//  loveshare
//
//  Created by lhb on 16/6/7.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "TopTenListTableViewController.h"
#import "TopTenModel.h"
#import "TopTenOtherTableViewCell.h"
#import "TopFitTableViewCell.h"


@interface TopTenListTableViewController ()

@property(nonatomic,strong) TopTenModel * model;
@end

@implementation TopTenListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"累计浏览排行榜";
    
//    self.tableView.userInteractionEnabled = NO;
    self.tableView.rowHeight = 60;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TopFitTableViewCell" bundle:nil]  forCellReuseIdentifier:@"first"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TopTenOtherTableViewCell" bundle:nil]  forCellReuseIdentifier:@"second"];
    
    UserModel * userInfo = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"loginCode"] = userInfo.loginCode;
    parame[@"type"] = @(1);
    [MBProgressHUD showMessage:nil];
    [UserLoginTool loginRequestGet:@"ranking" parame:parame success:^(id json) {
        LWLog(@"%@",json);
        [MBProgressHUD hideHUD];
        if ([[json objectForKey:@"resultCode"] integerValue]== 1 && [[json objectForKey:@"status"] integerValue] == 1) {
            [TopTenModel mj_setupObjectClassInArray:^NSDictionary *{
                return @{@"rankList":@"OtherTenModel"};
            }];
            self.model = [TopTenModel mj_objectWithKeyValues:[json objectForKey:@"resultData"]];
            [self.tableView reloadData];
        }
        
        
    } failure:^(NSError *error) {
       [MBProgressHUD hideHUD];
    }];
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.model.rankList.count + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        TopFitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"first" forIndexPath:indexPath];
        cell.date = self.model.myRank;
        cell.userInteractionEnabled = NO;
        cell.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
        return cell;
    }else{
        TopTenOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"second" forIndexPath:indexPath];
        
        cell.userInteractionEnabled = NO;
        if (indexPath.row < 4) {
            
            cell.number.backgroundColor = [UIColor colorWithRed:255/255.0 green:78/255.0 blue:0 alpha:1];
            cell.number.textColor = [UIColor whiteColor];
            cell.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
        }else{
            cell.number.backgroundColor = [UIColor whiteColor];
            cell.number.textColor = [UIColor lightGrayColor];
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        cell.number.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        OtherTenModel * model = [self.model.rankList objectAtIndex:indexPath.row-1];
        
        cell.date = model;
        return cell;
    }
    
}


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
