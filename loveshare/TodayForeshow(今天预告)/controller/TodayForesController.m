//
//  TodayForesController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/5/28.
//  Copyright (c) 2015年 HT. All rights reserved.
//  今日预告

#import "TodayForesController.h"
#import "TodayTableViewCell.h"
#import "detailViewController.h"

#define pagesize 10

@interface TodayForesController ()///**今日预告列表*/
//@property(nonatomic,strong)NSMutableArray * Notices;


@property(nonatomic,strong) MJRefreshNormalHeader * head;
@property(nonatomic,strong) MJRefreshAutoFooter * footer;


@property(nonatomic,strong)NSMutableArray * dateArray;

@end
@implementation TodayForesController

static NSString *homeCellidentify = @"TodayTableViewCell";



- (NSMutableArray *)dateArray{
    if (_dateArray == nil) {
        
        _dateArray = [NSMutableArray array];
    }
    
    return _dateArray;
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
//    MMRootViewController * root = (MMRootViewController *)self.mm_drawerController;
//    [root setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
//

  
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    self.tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 5);
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    
    self.title = @"最新预告";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TodayTableViewCell" bundle:nil] forCellReuseIdentifier:homeCellidentify];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [[UIView alloc] init];
//    self.tableView.allowsSelection = NO;

    
    
    //集成刷新控件
    [self setupRefresh];
    

}




- (void)GetDateWithOldTaskid:(int)taskId andPageSize:(int)Pagesize{
    
    __weak TodayForesController * wself = self;
    UserModel * user =  (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"loginCode"] = user.loginCode;
    parame[@"oldTaskId"] = @(taskId);
    parame[@"pageSize"] = @(Pagesize);
    [UserLoginTool loginRequestGet:@"PreviewTaskList" parame:parame success:^(id json) {
        LWLog(@"%@",json);
        if ([json[@"resultCode"] integerValue] == 1 && [json[@"resultCode"] integerValue] == 1) {
            NSArray * array = [TodayAdvance mj_objectArrayWithKeyValuesArray:json[@"resultData"][@"taskData"]];
            if (!array.count) {
                [wself.head endRefreshing];
                [wself.footer endRefreshing];
                return ;
            }
            if (taskId == 0) {
                [wself.dateArray removeAllObjects];
                [wself.dateArray addObjectsFromArray:array];
                [wself.tableView reloadData];
                [wself.head endRefreshing];
            }else{
                [wself.dateArray addObjectsFromArray:array];
                [wself.tableView reloadData];
                [wself.footer endRefreshing];
            }
            
            
        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
    
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
    [self GetDateWithOldTaskid:0 andPageSize:10];
}

//尾部刷新
- (void)footRefresh  //加载最新数据
{
    TodayAdvance * model =  [self.dateArray lastObject];
    [self GetDateWithOldTaskid:model.taskId andPageSize:10];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dateArray.count == 0) {
        self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UserLoginTool LoginCreateImageWithNoDate]];
    }else{
        self.tableView.backgroundColor = [UIColor whiteColor];
    }
    return self.dateArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TodayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:homeCellidentify];
    TodayAdvance * today = self.dateArray[indexPath.row];
    cell.model = today;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    TodayAdvance * model = self.dateArray[indexPath.row];
    
    NSDictionary * dict = [model mj_keyValues];
    NewTaskDataModel * cc = [NewTaskDataModel mj_objectWithKeyValues:dict];
    detailViewController * vc =(detailViewController *)[UserLoginTool LoginCreateControllerWithNameOfStory:nil andControllerIdentify:@"detailViewController"];
    vc.loi = 1;
    vc.taskModel = cc;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
