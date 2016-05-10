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
#import "RAYNewFunctionGuideVC.h"
#import "SearchViewController.h"

#import "MJChiBaoZiHeader.h"

#import "XYPopView.h"
#define pageSize 10

@interface HomeListViewController ()<UITableViewDelegate,UITableViewDataSource,XYPopViewDelegate>

/**第四个图片*/
@property (weak, nonatomic) IBOutlet UIImageView *fourthImage;

/**第二个图片*/
@property (weak, nonatomic) IBOutlet UIImageView *secondImage;

/**thirdImage*/
@property (weak, nonatomic) IBOutlet UIImageView *thirdImage;


@property (weak, nonatomic) IBOutlet UIView *firstView;

@property (weak, nonatomic) IBOutlet UILabel *firstLable;

@property (weak, nonatomic) IBOutlet UIView *secondView;

@property (weak, nonatomic) IBOutlet UILabel *secondLable;

@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet UIView *otherView;

@property (weak, nonatomic) IBOutlet UILabel *thirdLable;

@property (weak, nonatomic) IBOutlet UIView *fourthView;

@property (weak, nonatomic) IBOutlet UILabel *fourLable;
@property (weak, nonatomic) IBOutlet UILabel *otherLabel;
@property (nonatomic, strong) XYPopView *popView;
@property (nonatomic, strong) NSArray *otherArray;

@property(nonatomic,strong)UIView * redView;

@property (weak, nonatomic) IBOutlet UIView *topHeadView;

@property(nonatomic,strong)UIView * currentSelect;


@property(nonatomic,assign) int thirdLableNum;


@property(assign ,nonatomic) NSInteger currentTag;

@property(assign ,nonatomic) NSInteger pageIndex;


@property (weak, nonatomic) IBOutlet UITableView *taskTableview;
/**分组模型*/
@property(nonatomic,strong) NSMutableArray *taskGroup;

/**分组模型*/
@property(nonatomic,strong) NSMutableArray *taskLists;


@property(nonatomic,strong) MJRefreshGifHeader * head;
@property(nonatomic,strong) MJRefreshAutoFooter * footer;
@property(nonatomic,strong) UISegmentedControl * segmentedControl;
@property(nonatomic,strong) UIButton * searchButton;

@end


@implementation HomeListViewController

static NSString * homeCellidentify = @"homeCellId";

- (UIButton *)searchButton {
    if (_searchButton == nil) {
        _searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_searchButton setBackgroundImage:[UIImage imageNamed:@"geren"] forState:UIControlStateNormal];
        [_searchButton bk_whenTapped:^{
            if (_popView) {
                [_popView showPopView];
            }
            SearchViewController *search = [[SearchViewController alloc] init];
            [self.navigationController pushViewController:search animated:YES];
        }];
    }
    return _searchButton;
}
- (UISegmentedControl *)segmentedControl {
    if (_segmentedControl == nil) {
        _segmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        [_segmentedControl addTarget:self action:@selector(segmentedControlChange:) forControlEvents:UIControlEventValueChanged];
        //修改字体的默认颜色与选中颜色
        _segmentedControl.layer.borderWidth = 0.0;
        _segmentedControl.tintColor = [UIColor whiteColor];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:225.0/255 green:128/255.0 blue:0/255.0 alpha:1.000],UITextAttributeTextColor,  [UIFont systemFontOfSize:16.f],UITextAttributeFont ,[UIColor whiteColor],UITextAttributeTextShadowColor ,nil];
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:225.0/255 green:128/255.0 blue:0/255.0 alpha:1.000],NSForegroundColorAttributeName,  [UIFont systemFontOfSize:16.f],NSFontAttributeName ,[UIColor whiteColor],NSShadowAttributeName ,nil];
        [_segmentedControl setTitleTextAttributes:dic forState:UIControlStateSelected];
        [_segmentedControl setTitleTextAttributes:dic forState:UIControlStateSelected];
        [_segmentedControl insertSegmentWithTitle:@"已上架" atIndex:0 animated:YES];
        [_segmentedControl insertSegmentWithTitle:@"已下架" atIndex:1 animated:YES];
        _segmentedControl.selectedSegmentIndex = 0;
    }
    return _segmentedControl;
}
- (void)segmentedControlChange:(UISegmentedControl *)sgc {
    if (sgc.selectedSegmentIndex == 0) {
        if (_popView) {
            [_popView showPopView];
        }
        LWLog(@"点击了已上架");
    } else {
        if (_popView) {
            [_popView showPopView];
        }
        LWLog(@"点击了已下架");
    }
}
- (XYPopView *)popView {
    if (_popView == nil) {
        _popView = [[XYPopView alloc] initWXYPopViewWithImage:nil andTitle:nil andSuperView:self.otherView];
        _popView.delegate = self;
    }
    return _popView;
}
- (NSArray *)otherArray {
    if (_otherArray == nil) {
        _otherArray = @[@"1",@"2",@"3"];
    }
    return _otherArray;
}
- (NSMutableArray *)taskGroup
{
    if (_taskGroup == nil) {
        
        _taskGroup = [NSMutableArray array];
    }
    return _taskGroup;
}

- (NSMutableArray *)taskLists{
    if (_taskLists == nil) {
        _taskLists =  [NSMutableArray array];
    }
    return _taskLists;
}

- (void)RefreshJicheng{
    _head = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    //[MJRefreshGifHeader  headerWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    // 隐藏时间
    _head.lastUpdatedTimeLabel.hidden = YES;
    
    // 隐藏状态
    _head.stateLabel.hidden = YES;

    self.taskTableview.mj_header = _head;
    
   _footer =  [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    self.taskTableview.tableFooterView = _footer;
}

- (void)headRefresh{
    
    _pageIndex = 0;
    LWLog(@"%ld",(long)_currentTag);
    if(_currentTag == 1){ //默认
        [self getDateSortType:0 andOrderby:1 andPageIndex:_pageIndex];
    }else if(_currentTag == 2){
        [self getDateSortType:1 andOrderby:1 andPageIndex:_pageIndex];
    }else if(_currentTag == 3){//特殊处理
        if (_thirdLableNum == 1) {
           [self getDateSortType:2 andOrderby:1 andPageIndex:_pageIndex];
        }else{
            [self getDateSortType:2 andOrderby:0 andPageIndex:_pageIndex];
        }
    }else if(_currentTag == 4){
        [self getDateSortType:3 andOrderby:1 andPageIndex:_pageIndex];
    }
    
}

- (void)footRefresh{
    if(_currentTag == 1){ //默认
        [self getDateSortType:0 andOrderby:1 andPageIndex:self.pageIndex+1];
    }else if(_currentTag == 2){
        [self getDateSortType:1 andOrderby:1 andPageIndex:_pageIndex+1];
    }else if(_currentTag == 3){//特殊处理
        if (_thirdLableNum == 1) {
            [self getDateSortType:2 andOrderby:1 andPageIndex:_pageIndex+1];
        }else{
            [self getDateSortType:2 andOrderby:0 andPageIndex:_pageIndex+1];
        }
    }else if(_currentTag == 4){
        [self getDateSortType:3 andOrderby:1 andPageIndex:_pageIndex+1];
    }
}


- (void)getDateSortType:(NSInteger)SortType  andOrderby:(int)orderby andPageIndex:(NSInteger)PageIndex{
    
    
    LWLog(@"%ld--%d---%ld",(long)SortType,orderby,(long)PageIndex);
    __weak HomeListViewController * wself = self;
    UserModel * user =  (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"loginCode"] = user.loginCode;
    parame[@"orderby"] = @(orderby);
    parame[@"pageIndex"] = @(PageIndex);
    parame[@"sortType"] = @(SortType);
    [UserLoginTool loginRequestGet:@"TaskList" parame:parame success:^(id json) {
        LWLog(@"%@",json);
    
        wself.pageIndex = [json[@"pageIndex"] integerValue];
        if ([json[@"status"] integerValue]==1 && [json[@"resultCode"] integerValue] == 1) {
            NSArray * tasks  =  [NewTaskDataModel mj_objectArrayWithKeyValuesArray:json[@"resultData"][@"taskData"]];
                       if (tasks.count) {
                           if (wself.currentSelect.tag == 1) {
                               if (PageIndex == 0) {
                                   [_head endRefreshing];
                                   [wself.taskGroup removeAllObjects];
                               }else{
                                   [_footer endRefreshing];
                               }
                               [wself toGroupsByTime:tasks];
                           }else{
                               if (PageIndex ==0) {
                                   [wself.taskLists removeAllObjects];
                                   [wself.taskLists addObjectsFromArray:tasks];
                                   [wself.head endRefreshing];
                                   [wself.taskTableview reloadData];
                               }else{
                                  [wself.footer endRefreshing];
                                  [wself.taskLists addObjectsFromArray:tasks];
                                  [wself.taskTableview reloadData];
                                }
                            }
                           
                        }else{
                            if (PageIndex == 0) {
                                [_head endRefreshing];
                            }else{
                                [MBProgressHUD showMessage:@"没有更多数据"];
                                [_head endRefreshing];
                                [_footer endRefreshing];
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [MBProgressHUD hideHUD];
                                });
                            }
        }
    
        }
    }failure:^(NSError *error) {
        if (PageIndex == 0) {
            [_head endRefreshing];
        }else{
            [_footer endRefreshing];
        }
//
    }];
    
}
- (void)leftButton{
//    if (_popView) {
//        [_popView showPopView];
//    }
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
    }];
}

- (void)doselectSort{
    __weak HomeListViewController * wself = self;
    CGFloat aa  = (ScreenWidth*1.0) * (140.f/650);
    self.firstView.userInteractionEnabled = YES;
    [self.firstView bk_whenTapped:^{
        if (_popView) {
            [_popView showPopView];
        }
        LWLog(@"%ld", (long)wself.firstLable.tag);
        _currentTag = 1;
        _thirdLableNum = 0;
        wself.secondImage.image = [UIImage imageNamed:@"iconfont-jiantouxiangxiapaixu"];
        wself.fourthImage.image = [UIImage imageNamed:@"iconfont-jiantouxiangxiapaixu"];
         wself.thirdImage.image = [UIImage imageNamed:@"jt-3"];
        _currentSelect = wself.firstView;
        CGRect bb = wself.redView.frame;
        bb.origin.x = (aa - aa *4/5)*0.5;
        wself.redView.frame = bb;
        wself.firstLable.textColor = [UIColor orangeColor];
        wself.secondLable.textColor = [UIColor lightGrayColor];
        wself.thirdLable.textColor = [UIColor lightGrayColor];
        wself.fourLable.textColor = [UIColor lightGrayColor];
        [wself.head beginRefreshing];

    }];
    self.secondView.userInteractionEnabled = YES;
    [self.secondView bk_whenTapped:^{
        if (_popView) {
            [_popView showPopView];
        }
        _thirdLableNum = 0;
        wself.thirdImage.image = [UIImage imageNamed:@"jt-3"];
         wself.fourthImage.image = [UIImage imageNamed:@"iconfont-jiantouxiangxiapaixu"];
        wself.secondImage.image = [UIImage imageNamed:@"iconfont-jiantouxiangxiapaixu-1"];
        _currentSelect = wself.secondView;
        _currentTag = 2;
        CGRect bb = wself.redView.frame;
        bb.origin.x = (aa - aa *4/5)*0.5 + wself.secondView.frame.origin.x;
        wself.redView.frame = bb;
        wself.firstLable.textColor = [UIColor lightGrayColor];
        wself.secondLable.textColor = [UIColor orangeColor];
        wself.thirdLable.textColor = [UIColor lightGrayColor];
        wself.fourLable.textColor = [UIColor lightGrayColor];
        [wself.head beginRefreshing];
    }];
    self.thirdView.userInteractionEnabled = YES;
    [self.thirdView bk_whenTapped:^{
        if (_popView) {
            [_popView showPopView];
        }
        LWLog(@"xxx");
        if (_thirdLableNum == 0) {
            wself.thirdImage.image = [UIImage imageNamed:@"jt-1"];
            _thirdLableNum = 1;
        }else{
            if(_thirdLableNum == 1){
                wself.thirdImage.image = [UIImage imageNamed:@"jt-2"];
                _thirdLableNum = 2;
            }else{
                wself.thirdImage.image = [UIImage imageNamed:@"jt-1"];
                _thirdLableNum = 1;
            }
        }
        
        self.secondImage.image = [UIImage imageNamed:@"iconfont-jiantouxiangxiapaixu"];
        self.fourthImage.image = [UIImage imageNamed:@"iconfont-jiantouxiangxiapaixu"];
        _currentSelect = wself.thirdView;
        _currentTag = 3;
        CGRect bb = wself.redView.frame;
        bb.origin.x = (aa - aa *4/5)*0.5 + wself.thirdView.frame.origin.x;
        wself.redView.frame = bb;
        wself.firstLable.textColor = [UIColor lightGrayColor];
        wself.secondLable.textColor = [UIColor lightGrayColor];
        wself.thirdLable.textColor = [UIColor orangeColor];
        wself.fourLable.textColor = [UIColor lightGrayColor];
        [wself.head beginRefreshing];
    }];
    self.fourthView.userInteractionEnabled = YES;
    [self.fourthView bk_whenTapped:^{
        if (_popView) {
            [_popView showPopView];
        }
        _thirdLableNum = 0;
         wself.thirdImage.image = [UIImage imageNamed:@"jt-3"];
        wself.fourthImage.image = [UIImage imageNamed:@"iconfont-jiantouxiangxiapaixu-1"];
        wself.secondImage.image = [UIImage imageNamed:@"iconfont-jiantouxiangxiapaixu"];
        _currentSelect = wself.fourthView;
        _currentTag = 4;
        CGRect bb = wself.redView.frame;
        bb.origin.x = (aa - aa *4/5)*0.5 + wself.fourthView.frame.origin.x;
        wself.redView.frame = bb;
        wself.firstLable.textColor = [UIColor lightGrayColor];
        wself.secondLable.textColor = [UIColor lightGrayColor];
        wself.thirdLable.textColor = [UIColor lightGrayColor];
        wself.fourLable.textColor = [UIColor orangeColor];
        [wself.head beginRefreshing];
    }];
    self.otherView.userInteractionEnabled = YES;
    [self.otherView bk_whenTapped:^{
        [self.view addSubview:self.popView];
        [self.popView showPopView];
    }];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"任务领取";

    
    self.taskTableview.delegate = self;
    self.taskTableview.dataSource = self;
    self.navigationItem.titleView = self.segmentedControl;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchButton];
    _currentSelect = self.firstView;
    _currentTag = 1;
    _pageIndex = 0;
    _thirdLableNum = 0;
    
    CGFloat aa  = (ScreenWidth*1.0) * (140.f/650 );
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor orangeColor];
    self.firstLable.textColor = [UIColor orangeColor];
    view.frame = CGRectMake((aa - aa * 4/5)*0.5, _topHeadView.frame.size.height-2, aa*4/5 , 2);
    [_topHeadView addSubview:view];
    _redView = view;
    
    
    //排序选择
    [self doselectSort];
    
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btn setBackgroundImage:[UIImage imageNamed:@"geren"] forState:UIControlStateNormal];
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
    if (appde.isflag) {
        
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
        win.backgroundColor = [UIColor whiteColor];
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
    [self.view endEditing:YES];

    self.navigationController.navigationBarHidden = NO;
    [_head beginRefreshing];

}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //判断是否为第一次进入
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *isFirstHome = [defaults stringForKey:@"isFirstHome"];
    if (![isFirstHome isEqualToString:@"1"]){
        [defaults setObject:@"1" forKey:@"isFirstHome"];
        [defaults synchronize];
        [self makeGuideView];
    }
    //判断是否为第一次进入
    NSString *isFirstShareSuccess = [defaults stringForKey:@"isFirstShareSuccess"];
    //正常加个
    if ([isFirstHome isEqualToString:@"1"] && [isFirstShareSuccess isEqualToString:@"YES"]){
        [defaults setObject:@"NO" forKey:@"isFirstShareSuccess"];
        [defaults setObject:@"YES" forKey:@"isShareSuccessAndGoHome"];
        [defaults synchronize];
        [self makeGuideShareView];
    }

    

}
- (void)makeGuideShareView{
    RAYNewFunctionGuideVC *vc = [[RAYNewFunctionGuideVC alloc]init];
    vc.titles = @[@"转发成功后在这里查看奖励"];
    vc.frames = @[@"{{5,10},{50,50}}"];
    
    [self presentViewController:vc animated:YES completion:nil];
    
}
- (void)makeGuideView{
    RAYNewFunctionGuideVC *vc = [[RAYNewFunctionGuideVC alloc]init];
    vc.titles = @[@"新手任务: 首次转发即可获得积分奖励"];
    vc.frames = @[@"{{0,  140},{130,140}}"];
    
    [self presentViewController:vc animated:YES completion:nil];
    
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
#pragma mark XYPopViewDelegate


- (void)chooseItem:(NSString *)title andTag:(NSInteger)tag {
    NSLog(@"title ------ %@ title ------ %ld",title,(long)tag);
}
#pragma mark 协议方法


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.currentSelect.tag == 1) {
        return self.taskGroup.count;
    }
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (self.currentSelect.tag == 1) {
        TaskGrouoModel * taskGroup  = self.taskGroup[section];
        return taskGroup.tasks.count;
    }
    return self.taskLists.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:homeCellidentify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeCell" owner:nil options:nil] lastObject];
        cell.backgroundColor = [UIColor whiteColor];
    }
    if (self.currentSelect.tag == 1) {
        TaskGrouoModel * taskGroup  = self.taskGroup[indexPath.section];
        NewTaskDataModel *task = taskGroup.tasks[indexPath.row];
        cell.model = task;
        return cell;
    }
    NewTaskDataModel * model = self.taskLists[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LWLog(@"%@",indexPath);
    NewTaskDataModel *task =  nil;
    
    if (self.currentSelect.tag == 1) {
        TaskGrouoModel * taskGroup  = self.taskGroup[indexPath.section];
        task = taskGroup.tasks[indexPath.row];
    }else{
        task = self.taskLists[indexPath.row];
    }
    detailViewController * vc =(detailViewController *)[UserLoginTool LoginCreateControllerWithNameOfStory:nil andControllerIdentify:@"detailViewController"];
  
    vc.taskModel = task;
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.currentSelect.tag == 1) {
        TaskGrouoModel * aaaa = self.taskGroup[section];
        return [[aaaa.timeSectionTitle componentsSeparatedByString:@" "] firstObject];;
    }
    
    return nil;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}




@end
