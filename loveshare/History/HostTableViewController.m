//
//  HostTableViewController.m
//  loveshare
//
//  Created by lhb on 16/3/16.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "HostTableViewController.h"
#import "HostTableViewCell.h"


@interface HostTableViewController ()
@property(nonatomic,strong) MJRefreshNormalHeader * head;
@property(nonatomic,strong) MJRefreshAutoFooter * footer;


@property(nonatomic,strong)NSMutableArray * dateArray;
@end

@implementation HostTableViewController





- (NSMutableArray *)dateArray{
    if (_dateArray == nil) {
        
        _dateArray = [NSMutableArray array];
    }
    
    return _dateArray;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"历史收益";
    
    self.tableView.rowHeight = 167;
    
    self.tableView.userInteractionEnabled = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HostTableViewCell" bundle:nil] forCellReuseIdentifier:@"HostTableViewCell"];
    
    //集成刷新控件
    [self setupRefresh];

}
/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    _head = [MJRefreshNormalHeader  headerWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    self.tableView.mj_header = _head;
    
    [_head beginRefreshing];
    _footer =  [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    self.tableView.tableFooterView = _footer;
    
    
    //    [self be]
}


#pragma mark 开始进入刷新状态
//头部刷新
- (void)headRefresh  //加载最新数据
{
    [self GetDateWithOldTaskidPageSize:10];
}

//尾部刷新
- (void)footRefresh  //加载最新数据
{
    TodayAdvance * model =  [self.dateArray lastObject];
    [self GetDateWithOldTaskidPageSize:10];
}



- (void)GetDateWithOldTaskidPageSize:(int)Pagesize{
    
    __weak HostTableViewController * wself = self;
    UserModel * user =  (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"loginCode"] = user.loginCode;
    parame[@"date"] = @"";
    parame[@"pageSize"] = @(Pagesize);
    [UserLoginTool loginRequestGet:@"NewTotalScoreList" parame:parame success:^(id json) {
        LWLog(@"%@",json);
        if ([json[@"resultCode"] integerValue] == 1 && [json[@"resultCode"] integerValue] == 1) {
            NSArray * array = [HistoryModel mj_objectArrayWithKeyValuesArray:json[@"resultData"][@"itemData"]];
            LWLog(@"%lu",(unsigned long)array.count);
            if (array.count) {
                [wself.dateArray removeAllObjects];
                [wself.dateArray addObjectsFromArray:array];
                [wself.head endRefreshing];
                [wself.tableView reloadData];
            }
            [wself.head endRefreshing];
        }
        
        
    } failure:^(NSError *error) {
        [wself.head endRefreshing];
    }];
    
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  self.dateArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    HistoryModel * model =  self.dateArray[section];
    return model.awardList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HostTableViewCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HostTableViewCell" owner:nil options:nil] lastObject];
    }
    HistoryModel * model =  self.dateArray[indexPath.section];
    AwardList * models = model.awardList[indexPath.row];
    LWLog(@"%@", [models mj_keyValues]);
    cell.model = models;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HistoryModel * model =  self.dateArray[section];
    LWLog(@"%@",[model mj_keyValues]);
    NSString * time = [NSString stringWithFormat:@"%@ 收益",[[model.date componentsSeparatedByString:@" "] firstObject]];
    TitleHead * view = [[[NSBundle mainBundle] loadNibNamed:@"TitleHead" owner:nil options:nil] lastObject];
    view.timeLable.text = time;
    LWLog(@"--------%d",model.browseAmount);
    time = [NSString stringWithFormat:@" 浏览量: %d 总积分: %@ ",model.browseAmount,[NSString xiaoshudianweishudeal:[model.totalScore floatValue]]];
    view.rightLable.text = time;
    return view;
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
