//
//  WeekTaskTableViewController.m
//  loveshare
//
//  Created by lhb on 16/6/18.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "WeekTaskTableViewController.h"
#import "WeekModel.h"
#import "WeekTableViewCell.h"



@interface WeekTaskTableViewController ()


@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nickName;

@property (weak, nonatomic) IBOutlet UILabel *levelName;



@property(nonatomic,strong) NSArray * dateArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation WeekTaskTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.iconView.layer.cornerRadius = self.iconView.frame.size.width * 0.5;
    self.iconView.layer.masksToBounds = YES;
    
    self.levelName.layer.cornerRadius = 4;
    
    self.levelName.layer.masksToBounds = YES;

    
    UserModel * usermodel = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"loginCode"] = usermodel.loginCode;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WeekTableViewCell" bundle:nil] forCellReuseIdentifier:@"programe"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor colorWithRed:254/255.0 green:1 blue:1 alpha:1];
    self.tableView.rowHeight = 60;
    //获取支付参数
    [UserLoginTool loginRequestGet:@"WeekTask" parame:parame success:^(NSDictionary * json) {
        
        if ([[json objectForKey:@"resultCode"] integerValue] == 1 && [[json objectForKey:@"status"] integerValue] == 1) {
           _dateArray =  [WeekModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"resultData"]];
            [self.tableView reloadData];
        }
        LWLog(@"%@",json);
    } failure:nil];
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.title = @"本周任务";
   
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    UserModel * userInfo = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:userInfo.userHead] placeholderImage:[UIImage imageNamed:@"xiangxtouxiang"] completed:nil];
    
    NSString * name = nil;
    if (userInfo.RealName.length) {
        name = userInfo.RealName;
    }else if(userInfo.UserNickName.length){
        name = userInfo.UserNickName;
    }else{
        name = userInfo.userName;
    }
    self.nickName.text =  name;
    
    
    self.levelName.text = [NSString stringWithFormat:@"  %@  ",userInfo.levelName];
    
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dateArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeekTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"programe" forIndexPath:indexPath];
    WeekModel * model = [self.dateArray objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
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
