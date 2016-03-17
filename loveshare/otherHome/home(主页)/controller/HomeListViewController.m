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

@interface HomeListViewController ()<UITableViewDelegate,UITableViewDataSource>



@property (weak, nonatomic) IBOutlet UIView *firstView;

@property (weak, nonatomic) IBOutlet UILabel *firstLable;

@property (weak, nonatomic) IBOutlet UIView *secondView;

@property (weak, nonatomic) IBOutlet UILabel *secondLable;

@property (weak, nonatomic) IBOutlet UIView *thirdView;

@property (weak, nonatomic) IBOutlet UILabel *thirdLable;

@property (weak, nonatomic) IBOutlet UIView *fourthView;

@property (weak, nonatomic) IBOutlet UILabel *fourLable;

@property(nonatomic,strong)UIView * redView;

@property (weak, nonatomic) IBOutlet UIView *topHeadView;


@property (weak, nonatomic) IBOutlet UITableView *taskTableview;
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
    self.taskTableview.mj_header = _head;
    
   _footer =  [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    self.taskTableview.tableFooterView = _footer;
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
- (void)leftButton{
    

    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        
        
    }];
}

- (void)doselectSort{
    
    
    __weak HomeListViewController * wself = self;
    CGFloat aa  = (ScreenWidth*1.0) / 4;
    self.firstView.userInteractionEnabled = YES;
    [self.firstView bk_whenTapped:^{
        CGRect bb = wself.redView.frame;
        bb.origin.x = (aa - aa *2.0/3)*0.5;
        wself.redView.frame = bb;
        
        wself.firstLable.textColor = [UIColor orangeColor];
        wself.secondLable.textColor = [UIColor lightGrayColor];
        wself.thirdLable.textColor = [UIColor lightGrayColor];
        wself.fourLable.textColor = [UIColor lightGrayColor];

    }];
    self.secondView.userInteractionEnabled = YES;
    [self.secondView bk_whenTapped:^{
        CGRect bb = wself.redView.frame;
        bb.origin.x = (aa - aa *2.0/3)*0.5 + wself.secondView.frame.origin.x;
        wself.redView.frame = bb;
        wself.firstLable.textColor = [UIColor lightGrayColor];
        wself.secondLable.textColor = [UIColor orangeColor];
        wself.thirdLable.textColor = [UIColor lightGrayColor];
        wself.fourLable.textColor = [UIColor lightGrayColor];
    }];
    self.thirdView.userInteractionEnabled = YES;
    [self.thirdView bk_whenTapped:^{
        CGRect bb = wself.redView.frame;
        bb.origin.x = (aa - aa *2.0/3)*0.5 + wself.thirdView.frame.origin.x;
        wself.redView.frame = bb;
        
        wself.firstLable.textColor = [UIColor lightGrayColor];
        wself.secondLable.textColor = [UIColor lightGrayColor];
        wself.thirdLable.textColor = [UIColor orangeColor];
        wself.fourLable.textColor = [UIColor lightGrayColor];
    }];
    self.fourthView.userInteractionEnabled = YES;
    [self.fourthView bk_whenTapped:^{
        CGRect bb = wself.redView.frame;
        bb.origin.x = (aa - aa *2.0/3)*0.5 + wself.fourthView.frame.origin.x;
        wself.redView.frame = bb;
        
        wself.firstLable.textColor = [UIColor lightGrayColor];
        wself.secondLable.textColor = [UIColor lightGrayColor];
        wself.thirdLable.textColor = [UIColor lightGrayColor];
        wself.fourLable.textColor = [UIColor orangeColor];
    }];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"任务领取";
    
    
    self.taskTableview.delegate = self;
    self.taskTableview.dataSource = self;
    
    
    
    CGFloat aa  = (ScreenWidth*1.0) / 4;
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor orangeColor];
    self.firstLable.textColor = [UIColor orangeColor];
    view.frame = CGRectMake((aa - aa *2.0/3)*0.5, _topHeadView.frame.size.height-2, aa*2.0/3 , 2);
    [_topHeadView addSubview:view];
    _redView = view;
    
    
    //排序选择
    [self doselectSort];
    
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btn setBackgroundImage:[UIImage imageNamed:@"HomeLeftOPtion"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(leftButton) forControlEvents:UIControlEventTouchDown];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectController:) name:@"backToHomeView" object:nil];
    
    [self RefreshJicheng];
    
    [self.taskTableview registerNib:[UINib nibWithNibName:@"HomeCell" bundle:nil] forCellReuseIdentifier:homeCellidentify];
    self.taskTableview.rowHeight = 150;
    
//    self.tableView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
    //    self.tableView.tableFooterView = [[UIView alloc] init];
    self.taskTableview.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.taskTableview.backgroundColor = [UIColor colorWithRed:0.884 green:0.890 blue:0.832 alpha:1.000]
    ;
    
    
    AppDelegate * appde =  (AppDelegate * )[[UIApplication sharedApplication] delegate];
    if (!appde.isflag) {
        
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        image.userInteractionEnabled = YES;
        
        [image bk_whenTapped:^{
           
            [image removeFromSuperview];
            
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [image removeFromSuperview];
        });
        image.contentMode = UIViewContentModeScaleAspectFit;
        image.image = [UIImage imageNamed:@"万事利引导图"];
        UIWindow * win =  [UIApplication sharedApplication].keyWindow;
        [win addSubview:image];
        
    }
    
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
    [self.taskTableview reloadData];
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
