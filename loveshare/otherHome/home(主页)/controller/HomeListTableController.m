//
//  HomeListTableController.m
//  loveshare
//
//  Created by lhb on 16/5/17.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "HomeListTableController.h"
#import <MJRefresh.h>
#import "HomeCell.h"
#import "UIImage+LHB.h"


@interface HomeListTableController()

/**当前索引*/
@property(nonatomic,assign) NSInteger pageIndex;


/**分组模型*/
@property(nonatomic,strong) NSMutableArray<TaskGrouoModel*> *taskGroup;

/**分组模型*/
@property(nonatomic,strong) NSMutableArray<NewTaskDataModel *> *taskLists;


@property(nonatomic,strong) MJRefreshNormalHeader * header;

@property(nonatomic,strong) MJRefreshBackNormalFooter * footer;


/**商家id*/
@property(nonatomic,assign) NSInteger storyID;

@end

@implementation HomeListTableController

- (int)type {
    return 0;
}


/**
 *  任务分组数组
 *
 *  @return 分组
 */
- (NSMutableArray *)taskGroup
{
    if (_taskGroup == nil) {
        _taskGroup = [NSMutableArray array];
    }
    return _taskGroup;
}

/**
 *  任务模型数组
 *
 *  @return 分组
 */
- (NSMutableArray *)taskLists{
    if (_taskLists == nil) {
        _taskLists =  [NSMutableArray array];
    }
    return _taskLists;
}


- (instancetype)init{
    if (self == nil) {
        self = [[HomeListTableController alloc] initWithStyle:UITableViewStyleGrouped];
    }
    return self;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.storyID = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 64, 0);
    
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    self.tableView.rowHeight = 120;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeCell" bundle:nil] forCellReuseIdentifier:@"xxxxxxx"];
    
    [self AddRefresh];
    
    LWLog(@"%@",NSStringFromCGRect(self.tableView.frame));


    
    

}


- (void)StoryRefreshDateWithStroryID:(NSInteger)stroryID{
    
    self.storyID = stroryID;
    [_header beginRefreshing];
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


/**
 *  请求数据
 *
 *  @param SortType  1按剩余积分，2按奖励积分，3按转发人数，其他默认
 *  @param orderby   1降序，0升序
 *  @param PageIndex 	页码
 *  @param taskStaus 默认1 0表示已下架任务
 *  @param storeID   	商家ID，默认为0
 */

/**刷新任务*/
- (void)NewTask{
//    LWLog(@"xxxxx%d",self.type);
    
    
    NSNumber * storyID = [[NSUserDefaults standardUserDefaults] objectForKey:@"storyID"];
    

    
    [self getDateSortType:self.type andOrderby:1 andPageIndex:1 andTaskStaus:1 andStoreID:storyID?[storyID integerValue]:0 isHead:YES];
    [_header endRefreshing];
}

/**刷新任务*/
- (void)GetMoreTask{
    LWLog(@"xxxxx");
    NSNumber * storyID = [[NSUserDefaults standardUserDefaults] objectForKey:@"storyID"];

    [self getDateSortType:self.type andOrderby:1 andPageIndex:self.pageIndex+1 andTaskStaus:1 andStoreID:storyID?[storyID integerValue]:0 isHead:NO];
    [_footer endRefreshing];
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



/**
 *  请求数据
 *
 *  @param SortType  1按剩余积分，2按奖励积分，3按转发人数，其他默认
 *  @param orderby   1降序，0升序
 *  @param PageIndex 	页码
 *  @param taskStaus 默认1 0表示已下架任务
 *  @param storeID   	商家ID，默认为0
 */
- (void)getDateSortType:(NSInteger)SortType andOrderby:(int)orderby andPageIndex:(NSInteger)PageIndex andTaskStaus:(NSInteger)taskStaus andStoreID:(NSInteger)storeID isHead:(BOOL)head{
    
    
    LWLog(@"%ld--%d---%ld---%ld",(long)SortType,orderby,(long)PageIndex,(long)storeID);
    __weak HomeListTableController * wself = self;
    UserModel * user =  (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"loginCode"] = user.loginCode;
    parame[@"orderby"] = @(orderby);
    parame[@"pageIndex"] = @(PageIndex);
    parame[@"sortType"] = @(SortType);
    parame[@"taskStaus"] = @(taskStaus);
    parame[@"storeId"] = @(storeID);
    
    [UserLoginTool loginRequestGet:@"TaskList" parame:parame success:^(NSDictionary *  json) {
        LWLog(@"%@",json);
        wself.pageIndex = [json[@"pageIndex"] integerValue];
        if ([json[@"status"] integerValue]==1 && [json[@"resultCode"] integerValue] == 1) {
            NSArray * tasks  =  [NewTaskDataModel mj_objectArrayWithKeyValuesArray:json[@"resultData"][@"taskData"]];
            if (tasks.count > 0) {
                if (head) {//头部刷新
                    [self.taskGroup  removeAllObjects];
                    [self toGroupsByTime:tasks];
                    [self showNewStatuseCounts:tasks.count andIsHead:YES];
                    [self.tableView reloadData];
                }else{
                    [wself toGroupsByTime:tasks];
                    [self showNewStatuseCounts:tasks.count andIsHead:NO];
                    [self.tableView reloadData];
                    
                }
            }else{
                [self showNewStatuseCounts:0 andIsHead:NO];
            }
            
        }
    }failure:^(NSError *error) {
        LWLog(@"%ld",(long)error.code);

    }];
    
}



#pragma tableView  datesouce

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.taskGroup.count;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    TaskGrouoModel * group = self.taskGroup[section];
    return group.tasks.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"xxxxxxx";
    HomeCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeCell" owner:nil options:nil] lastObject];
    }
    TaskGrouoModel * group = self.taskGroup[indexPath.section];
    NewTaskDataModel * model = group.tasks[indexPath.row];
    cell.model = model;
    return cell;
}


- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    TaskGrouoModel * group = self.taskGroup[section];
    return group.timeSectionTitle;
}
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LWLog(@"%@",indexPath);
    TaskGrouoModel * group = self.taskGroup[indexPath.section];
    NewTaskDataModel *task =  [group.tasks objectAtIndex:indexPath.row];
    detailViewController * vc =(detailViewController *)[UserLoginTool LoginCreateControllerWithNameOfStory:nil andControllerIdentify:@"detailViewController"];
    vc.taskModel = task;
    [self.navigationController pushViewController:vc animated:YES];
}


/**
 *  设置刷新按钮的数亮
 *
 *  @param count <#count description#>
 */
-(void)showNewStatuseCounts:(NSUInteger)count andIsHead:(BOOL)head
{
    UIButton * showBtn = [[UIButton alloc] init];
    showBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.navigationController.view insertSubview:showBtn belowSubview:self.navigationController.navigationBar];
    showBtn.userInteractionEnabled = NO;
    [showBtn setBackgroundImage:[UIImage resizedWithName:@"timeline_new_status_background"] forState:UIControlStateNormal];
//    showBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [showBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    NSString * title = nil;
    if (count) {
        if (head) {
             title = [NSString stringWithFormat:@"刷新最新%lu条资讯",(unsigned long)count];
        }else{
             title = [NSString stringWithFormat:@"加载了%lu条资讯",(unsigned long)count];
        }
       
        [showBtn setTitle:title forState:UIControlStateNormal];
    }else{
        
        [showBtn setTitle:@"没有资讯可加载" forState:UIControlStateNormal];
    }
    
    //设置Frame
    CGFloat btnX = 0;
    CGFloat btnH = 44;
    CGFloat btnY = 64 - btnH;
    CGFloat btnW = self.view.frame.size.width - 2*btnX;
    
    showBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    
    //向下走
    [UIView animateWithDuration:0.7 animations:^{
        
        showBtn.transform = CGAffineTransformMakeTranslation(0, btnH+2);
    } completion:^(BOOL finished) {
        
        [UIView  animateKeyframesWithDuration:0.7 delay:1.0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            //清空transform
            showBtn.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            
            [showBtn removeFromSuperview];
        }];
    }];
    
}

@end
