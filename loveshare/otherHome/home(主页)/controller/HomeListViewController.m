//
//  HomeViewController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/5/25.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "HomeListViewController.h"
#import "detailViewController.h"
#import <MJRefresh.h>



#define pageSize 10

@interface HomeListViewController ()


/**分组模型*/
@property(nonatomic,strong) NSMutableArray *taskGroup;

@property(nonatomic,strong) MJRefreshNormalHeader * head;
@property(nonatomic,strong) MJRefreshAutoFooter * footer;
@end


@implementation HomeListViewController

static NSString * homeCellidentify = @"homeCellId";


- (NSMutableArray *)taskGroup
{
    if (_taskGroup == nil) {
        
        _taskGroup = [NSMutableArray array];
    }
    return _taskGroup;
}



- (void)RefreshJicheng{
    _head = [MJRefreshNormalHeader  headerWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    self.tableView.mj_header = _head;
    
   _footer =  [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    self.tableView.tableFooterView = _footer;
}

- (void)headRefresh{
    
    [self getDate:0];
}

- (void)footRefresh{
    TaskGrouoModel * group =  [self.taskGroup lastObject];
    NewTaskDataModel * model = [group.tasks lastObject];
    [self getDate:model.taskId];
}


- (void)getDate:(int)taskId{
    __weak HomeListViewController * wself = self;
    UserModel * user =  (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"loginCode"] = user.loginCode;
    parame[@"screenType"] = @(0);
    parame[@"oldTaskId"] = @(taskId);
    parame[@"pageSize"] = @(10);
    [UserLoginTool loginRequestGet:@"AllTasK220" parame:parame success:^(id json) {
        LWLog(@"%@",json);
        if ([json[@"status"] integerValue]==1 && [json[@"resultCode"] integerValue] == 1) {
           NSArray * tasks  =  [NewTaskDataModel mj_objectArrayWithKeyValuesArray:json[@"resultData"][@"taskData"]];
           if (tasks.count) {
                if (taskId == 0) {
                    [_head endRefreshing];
                    [wself.taskGroup removeAllObjects];
                }else{
                    [_footer endRefreshing];
                }
                [wself toGroupsByTime:tasks];
            }else{
                if (taskId == 0) {
                    [_head endRefreshing];
                }else{
                    [MBProgressHUD showMessage:@"没有更多数据"];
                    [_footer endRefreshing];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUD];
                    });
                }
            }
        }
    } failure:^(NSError *error) {
        if (taskId == 0) {
            [_head endRefreshing];
        }else{
            [_footer endRefreshing];
        }

    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"任务领取";
    

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectController:) name:@"backToHomeView" object:nil];
    
    [self RefreshJicheng];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeCell" bundle:nil] forCellReuseIdentifier:homeCellidentify];
    self.tableView.rowHeight = 150;
    
//    self.tableView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
    //    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.tableView.backgroundColor = [UIColor colorWithRed:0.884 green:0.890 blue:0.832 alpha:1.000]
    ;
 }
/**
 *  控制器选择
 *
 *  @param note <#note description#>
 */
- (void)selectController:(NSNotification *) note{
    
    if([note.userInfo[@"option"] integerValue] == 0){//首页
        [self.navigationController popToRootViewControllerAnimated:NO];
        
    }else if([note.userInfo[@"option"] integerValue] == 1){//历史收益
       
        HostTableViewController * vc = [[HostTableViewController alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:vc animated:NO];
        
        
    }else if([note.userInfo[@"option"] integerValue] == 2){//积分兑换
        JiFenToMallController * vc = (JiFenToMallController *)[UserLoginTool LoginCreateControllerWithNameOfStory:nil andControllerIdentify:@"JiFenToMallController"];
        [self.navigationController pushViewController:vc animated:NO];
        
    }else if([note.userInfo[@"option"] integerValue] == 3){//进入商城
        
#warning 缺商城账号选中
       HomeViewController * vc =  (HomeViewController *)[UserLoginTool LoginCreateControllerWithNameOfStory:nil andControllerIdentify:@"HomeViewController"];
      [self.navigationController pushViewController:vc animated:NO];
    }else if([note.userInfo[@"option"] integerValue] == 4){//最新预告
        
        TodayForesController * vc =  (TodayForesController *)[UserLoginTool LoginCreateControllerWithNameOfStory:nil andControllerIdentify:@"TodayForesController"];
        [self.navigationController pushViewController:vc animated:NO];
        
    }else if([note.userInfo[@"option"] integerValue] == 5){//师徒联盟
        MasterAndTudiViewController * vc = (MasterAndTudiViewController *)[UserLoginTool LoginCreateControllerWithNameOfStory:nil andControllerIdentify:@"MasterAndTudiViewController"];
        [self.navigationController pushViewController:vc animated:NO];
    }else if([note.userInfo[@"option"] integerValue] == 6){
        MoreSetTableViewController * vc = (MoreSetTableViewController *)[UserLoginTool LoginCreateControllerWithNameOfStory:nil andControllerIdentify:@"MoreSetTableViewController"];
        [self.navigationController pushViewController:vc animated:NO];
    }else if([note.userInfo[@"option"] integerValue] == 7){
        
        VipAccountViewController * vip = [[VipAccountViewController alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:vip animated:NO];
        
    }else{
        PersonMessageTableViewController * pers = (PersonMessageTableViewController *)[UserLoginTool LoginCreateControllerWithNameOfStory:nil andControllerIdentify:@"PersonMessageTableViewController"];
        [self.navigationController pushViewController:pers animated:NO];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    [_head beginRefreshing];
    
}
/**
 *  把首页数据进行分组
 */
- (void)toGroupsByTime:(NSArray *)tasks{
    NewTaskDataModel * aaas = nil;
    TaskGrouoModel * bbbs = [self.taskGroup lastObject];
    for (NewTaskDataModel * task in tasks) {
        LWLog(@"%@",task.orderTime);
        LWLog(@"%@",[bbbs mj_keyValues]);
        NSString * aaaaaa =  [[bbbs.timeSectionTitle componentsSeparatedByString:@" "] firstObject];
        NSString * bbbbbb =  [[task.orderTime componentsSeparatedByString:@" "] firstObject];
        if ([aaaaaa  isEqualToString:bbbbbb]) {//一样
            aaas = task;
            [bbbs.tasks addObject:task];
        }else{//不一样
            aaas = task;
            TaskGrouoModel * group = [[TaskGrouoModel alloc] init];
            group.timeSectionTitle = task.orderTime;
            [group.tasks addObject:task];
            bbbs = group;
            [self.taskGroup addObject:group];
        }
    }
    [self.tableView reloadData];
}


#pragma mark 协议方法


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.taskGroup.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    TaskGrouoModel * taskGroup  = self.taskGroup[section];
    return taskGroup.tasks.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:homeCellidentify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeCell" owner:nil options:nil] lastObject];
    }
    
    TaskGrouoModel * taskGroup  = self.taskGroup[indexPath.section];
    NewTaskDataModel *task = taskGroup.tasks[indexPath.row];
    cell.model = task;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LWLog(@"%@",indexPath);
    TaskGrouoModel * taskGroup  = self.taskGroup[indexPath.section];
    NewTaskDataModel *task = taskGroup.tasks[indexPath.row];
    
    detailViewController * vc =(detailViewController *)[UserLoginTool LoginCreateControllerWithNameOfStory:nil andControllerIdentify:@"detailViewController"];
  
    vc.taskModel = task;
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    TaskGrouoModel * aaaa = self.taskGroup[section];
    return [[aaaa.timeSectionTitle componentsSeparatedByString:@" "] firstObject];;
    
}


@end
