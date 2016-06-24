//
//  TudiTableViewController.m
//  loveshare
//
//  Created by lhb on 16/6/24.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "TudiTableViewController.h"
#import "MyNewTudiListcell.h"


@interface TudiTableViewController ()

@property(nonatomic,strong) MJRefreshNormalHeader * header;

@property(nonatomic,strong) MJRefreshBackNormalFooter * footer;


@property(nonatomic,strong) NSMutableArray * dateArray;
@end

@implementation TudiTableViewController

- (NSMutableArray *)dateArray{
    if (_dateArray == nil) {
        _dateArray = [NSMutableArray array];
    }
    return _dateArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"伙伴列表";
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = 109;
    [self.tableView registerNib:[UINib nibWithNibName:@"MyNewTudiListcell" bundle:nil] forCellReuseIdentifier:@"MyNewTudiListcell"];
    
    
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self AddRefresh];
}


- (void)AddRefresh{
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(NewTask)];
    _header = header;
    self.tableView.mj_header = header;
    [header beginRefreshing];
    
    MJRefreshBackNormalFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(GetMoreTask)];
    _footer = footer;
    self.tableView.mj_footer = footer;
}

- (void)getDate{
    UserModel * user =  (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"loginCode"] = user.loginCode;
    parame[@"orderType"] = @(0);
    parame[@"pageTag"] = @(0);
    parame[@"pageSize"] = @(10);
    [UserLoginTool loginRequestGet:@"PrenticeList" parame:parame success:^(id json) {
        
        LWLog(@"%@",json);
        if ([[json objectForKey:@"resultCode"] integerValue] == 1 && [[json objectForKey:@"status"] integerValue] == 1) {
            NSArray * date = [FollowModel mj_objectArrayWithKeyValuesArray:json[@"resultData"][@"list"]];
            if (date.count) {
                [self.dateArray removeAllObjects];
                [self.dateArray addObjectsFromArray:date];
                [self.tableView reloadData];
            }
            
        }
        
        [self.header endRefreshing];
    } failure:^(NSError *error) {
        [self.header endRefreshing];
    }];
    ;

}







- (void)NewTask{
    [self getDate];
    
}

- (void)GetMoreTask{
    UserModel * user =  (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"loginCode"] = user.loginCode;
    parame[@"orderType"] = @(0);
    FollowModel * model = [self.dateArray lastObject];
    parame[@"pageTag"] =[NSString stringWithFormat:@"%@",model.userId];
    parame[@"pageSize"] = @(10);
    [UserLoginTool loginRequestGet:@"PrenticeList" parame:parame success:^(id json) {
        
        LWLog(@"%@",json);
        if ([[json objectForKey:@"resultCode"] integerValue] == 1 && [[json objectForKey:@"status"] integerValue] == 1) {
            NSArray * date = [FollowModel mj_objectArrayWithKeyValuesArray:json[@"resultData"][@"list"]];
            if (date.count) {
                [self.dateArray addObjectsFromArray:date];
                [self.tableView reloadData];
            }
            
        }
        [self.footer endRefreshing];
    } failure:^(NSError *error) {
        [self.footer endRefreshing];
    }];
    ;
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dateArray.count == 0) {
        self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UserLoginTool LoginCreateImageWithNoDate]];
    }else{
        self.tableView.backgroundColor = [UIColor whiteColor];
    }
    return self.dateArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyNewTudiListcell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyNewTudiListcell" forIndexPath:indexPath];
    
    cell.contentView.layer.cornerRadius = 5;
    cell.contentView.layer.masksToBounds = YES;
//    cell.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    FollowModel * model = [self.dateArray objectAtIndex:indexPath.row];
    cell.model = model;
    cell.userInteractionEnabled = NO;
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
