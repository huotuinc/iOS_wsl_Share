//
//  PersonViewController.m
//  loveshare
//
//  Created by lhb on 16/3/15.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "PersonViewController.h"
#import "HostTableViewCell.h"
#import "FollowList.h"


@interface PersonViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@property (weak, nonatomic) IBOutlet UILabel *scoreJifen;
/**徒弟列表*/
@property(nonatomic,strong) NSIndexPath * lastIndexPath;

@property (weak, nonatomic) IBOutlet UILabel *turnLable;


@property (weak, nonatomic) IBOutlet UILabel *browsLable;


@property (weak, nonatomic) IBOutlet UILabel *tudiLable;


@property (weak, nonatomic) IBOutlet UILabel *firstLable;

@property (weak, nonatomic) IBOutlet UILabel *secondLable;

@property (weak, nonatomic) IBOutlet UITableView *listLable;
@property (weak, nonatomic) IBOutlet UILabel *sssssss;

@property (weak, nonatomic) IBOutlet UIView *containView;

@property(nonatomic,strong) UIView *redView;

@property(nonatomic,strong) TudiTableViewCell *sectionFollowerView;//
//BC
@property(nonatomic,assign) int setTag;// = 1 为任务; = 2 为徒弟
@property (nonatomic, assign) NSInteger followerPageIndex;//徒弟页数
@property (nonatomic, assign) NSInteger taskPageSize;//任务页数 传100 暂无页数
@property (nonatomic, assign) NSInteger openSection;//点击的section (展开cell)
@property (nonatomic, assign) BOOL openStatus; //section是否展开

//任务
@property(nonatomic,strong)NSMutableArray * dateArray;

//徒弟
/**徒弟列表*/
@property(nonatomic,strong)NSMutableArray * lists;


@property(nonatomic,strong) MJRefreshNormalHeader * head;
@property(nonatomic,strong) MJRefreshAutoFooter * footer;


@end

@implementation PersonViewController


- (NSMutableArray *)dateArray{
    if (_dateArray == nil) {
        _dateArray = [NSMutableArray array];
    }
    return _dateArray;
}

- (NSMutableArray *)lists{
    if (_lists == nil) {
        _lists = [NSMutableArray array];
    }
    return _lists;
}
#pragma mark 刷新方法
- (void)setupRefresh {
    MJRefreshNormalHeader * headRe = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getPersonData)];
    self.listLable.mj_header = headRe;
    
    MJRefreshBackNormalFooter * Footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMorePersonData)];
    self.listLable.mj_footer = Footer;
    
}

//头部刷新
- (void)getPersonData  //加载最新数据
{
    if (self.setTag == 1) {
        [self.lists removeAllObjects];
        [self.listLable reloadData];
        [self GetDateWithOldTaskidPageSize:100];
    }else{
        [self.lists removeAllObjects];
        [self.listLable reloadData];
        self.followerPageIndex = 1;
        [self.lists removeAllObjects];
        [self setupTudiDateWithPageIndex:_followerPageIndex];
    }
}

//尾部刷新
- (void)getMorePersonData  //加载最新数据
{
    LWLog(@"下拉刷新了");
//    TodayAdvance * model =  [self.dateArray lastObject];
//    [self GetDateWithOldTaskid:model.taskId andPageSize:10];
    if (self.setTag == 1) {
        LWLog(@"暂无分页功能");
        [self.listLable.mj_footer endRefreshing];
    }else{
        ++_followerPageIndex;
        [self setupTudiDateWithPageIndex:_followerPageIndex];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getPersonData];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.setTag = 1;
    self.listLable.delegate = self;
    self.listLable.dataSource = self;
    self.listLable.tableFooterView = [[UIView alloc] init];
    [self setupRefresh];
    
    [self.listLable registerNib:[UINib nibWithNibName:@"HostTableViewCell" bundle:nil] forCellReuseIdentifier:@"HostTableViewCell"];
    [self.listLable registerNib:[UINib nibWithNibName:@"TudiTableViewCell" bundle:nil]  forCellReuseIdentifier:@"top"];
    [self.listLable registerNib:[UINib nibWithNibName:@"DownTudiTableViewCell" bundle:nil]  forCellReuseIdentifier:@"down"];
    
    
    
    
    [self setUp];
//    [self.head beginRefreshing];
    
    
}



- (void)setUp{
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    
    self.headImage.layer.cornerRadius = self.headImage.frame.size.height * 0.5;
    self.headImage.layer.masksToBounds = YES;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:self.model.logo] placeholderImage:nil];
    
    self.sssssss.text = self.xixi;
    
    self.turnLable.text = [NSString stringWithFormat:@" 转发%d次",self.model.totalTurnCount];
    self.browsLable.text = [NSString stringWithFormat:@" 浏览%d次",self.model.totalBrowseCount];
    self.tudiLable.text = [NSString stringWithFormat:@" 徒弟%d人",self.model.prenticeCount];
    self.scoreJifen.text = [NSString stringWithFormat:@"%@积分",[NSString xiaoshudianweishudeal:[self.model.totalScore floatValue]]];
    self.firstLable.userInteractionEnabled = YES;
    self.secondLable.userInteractionEnabled = YES;
    
    self.tudiLable.adjustsFontSizeToFitWidth = YES;
    self.browsLable.adjustsFontSizeToFitWidth = YES;
    self.tudiLable.adjustsFontSizeToFitWidth = YES;
    CGFloat aa  = (ScreenWidth - 60.0) / 2;
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor orangeColor];
    self.firstLable.textColor = [UIColor orangeColor];
    view.frame = CGRectMake(aa *0.5-aa/2/2+30, _containView.frame.size.height-2, aa / 2 , 2);
    [_containView addSubview:view];
    _redView = view;
    
//    self.listLable.userInteractionEnabled = NO;
    
    __weak PersonViewController * wself = self;
    [self.firstLable bk_whenTapped:^{
        _firstLable.textColor = [UIColor orangeColor];
        _secondLable.textColor = [UIColor blackColor];
        _redView.frame = CGRectMake(aa *0.5-aa/2/2+30, _containView.frame.size.height-2, aa / 2 , 2);
        self.setTag = 1;
//        [wself.head beginRefreshing];
        [self.lists removeAllObjects];
        [self.listLable reloadData];
        self.openStatus = NO;
        self.openSection = -1;
        [self GetDateWithOldTaskidPageSize:100];
       
    }];
    
    [self.secondLable bk_whenTapped:^{
        _firstLable.textColor = [UIColor blackColor];
        _secondLable.textColor = [UIColor orangeColor];
        _redView.frame = CGRectMake(aa *0.5-aa/2/2+30+aa, _containView.frame.size.height-2, aa / 2 , 2);
        self.setTag = 2;
//        [wself.head beginRefreshing];
        [self.dateArray removeAllObjects];
        [self.listLable reloadData];
        self.followerPageIndex = 1;
        self.openStatus = NO;
        self.openSection = -1;
        [self setupTudiDateWithPageIndex:_followerPageIndex];

        
    }];
    
}
//徒弟
- (void)setupTudiDateWithPageIndex:(NSInteger) pageIndex{
    self.followerPageIndex = pageIndex;
    __weak PersonViewController * wself = self;
    UserModel * userInfo = (UserModel * )[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"loginCode"] = userInfo.loginCode;
    parame[@"masterId"] = @(self.model.userid);
    LWLog(@"%d",self.model.userid);
    parame[@"pageIndex"] = @(pageIndex);
    [MBProgressHUD showMessage:nil];
    LWLog(@"*******开始请求数据********");

    [UserLoginTool loginRequestGet:@"GetUserListByMasterId" parame:parame success:^(id json) {
        LWLog(@"%@",json);
//        wself.setTag = 1;
        LWLog(@"**************请求数据成功********");
        if ([json[@"status"] integerValue] == 1 && [json[@"resultCode"] integerValue] == 1) {
            NSArray * array = [FollowModel mj_objectArrayWithKeyValuesArray:json[@"resultData"]];
//            wself.listLable.tableFooterView = _footer;
            if (pageIndex == 1) {
                [wself ToGroupList:array];
                [wself.listLable.mj_header endRefreshing];

            } else {
                [wself ToMoreGroupList:array];
                [wself.listLable.mj_footer endRefreshing];
            }
            [MBProgressHUD hideHUD];
            [wself.listLable reloadData];
        }
    } failure:^(NSError *error) {
        if (pageIndex == 1) {
            [wself.listLable.mj_header endRefreshing];
        } else {
            [wself.listLable.mj_footer endRefreshing];
        }
        LWLog(@"**************请求数据失败*************");
        [MBProgressHUD hideHUD];
    }];
    
};

/**
 *  分组
 *
 *  @param list <#list description#>
 */
- (void)ToGroupList:(NSArray * )list{
    
    [self.lists removeAllObjects];
    for (int i = 0; i<list.count; i++) {
        
        FollowList * mod = [[FollowList alloc] init];
        mod.groupId = i;
        NSMutableArray * marra = [NSMutableArray array];
        [marra addObject:list[i]];
        mod.list = marra;
        
        [self.lists addObject:mod];
    }
//    [self.listLable reloadData];
}
- (void)ToMoreGroupList:(NSArray * )list{
    
    for (int i = 0; i<list.count; i++) {
        
        FollowList * mod = [[FollowList alloc] init];
        mod.groupId = i;
        NSMutableArray * marra = [NSMutableArray array];
        [marra addObject:list[i]];
        mod.list = marra;
        
        [self.lists addObject:mod];
    }
    [self.listLable reloadData];
}

//任务
- (void)GetDateWithOldTaskidPageSize:(int)Pagesize{
    LWLog(@"*************请求的任务数据");
    __weak PersonViewController * wself = self;
    UserModel * user =  (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"loginCode"] = user.loginCode;
    parame[@"date"] = @"";
    parame[@"pageSize"] = @(Pagesize);
    parame[@"currentUserId"] = @(self.model.userid);
    [MBProgressHUD showMessage:nil];
    [UserLoginTool loginRequestGet:@"NewTotalScoreList" parame:parame success:^(id json) {
        LWLog(@"%@",json);
//         wself.setTag = 2;
        
        if ([json[@"resultCode"] integerValue] == 1 && [json[@"resultCode"] integerValue] == 1) {
            NSArray * array = [HistoryModel mj_objectArrayWithKeyValuesArray:json[@"resultData"][@"itemData"]];
            LWLog(@"%lu",(unsigned long)array.count);
            
            if (array.count) {
                [wself.dateArray removeAllObjects];
                [wself.dateArray addObjectsFromArray:array];
                [wself.listLable.mj_header endRefreshing];
                [wself.listLable reloadData];
                [MBProgressHUD hideHUD];

            }
        }
        
        
    } failure:^(NSError *error) {
        [wself.listLable.mj_header endRefreshing];
        [MBProgressHUD hideHUD];
    }];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    LWLog(@"%d",self.setTag);
    if (self.setTag== 1) {
        return  self.dateArray.count;
    }else{
        LWLog(@"%lu",(unsigned long)self.lists.count);
        return self.lists.count;
    }
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.setTag== 1) {
        HistoryModel * model =  self.dateArray[section];
        return model.awardList.count;
    }else{
        if (section == self.openSection && self.openStatus == YES) {
            FollowList * ss = self.lists[section];
            NSLog(@"%lu",(unsigned long)ss.list.count);
            return ss.list.count;
        } else {
            return 0;
        }
    }
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (self.setTag == 1) {
       return 30;
    }
    
    return 60;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.setTag == 1) {
        return 167;
    }
    return 60;
    
}


- ( UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.setTag == 1) {
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
    else {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TudiTableViewCell" owner:nil options:nil];
        _sectionFollowerView = [nib firstObject];
        _sectionFollowerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60);
        FollowList * fol =  self.lists[section];
        FollowModel * mod = (FollowModel *)fol.list[0];
        _sectionFollowerView.backgroundColor = [UIColor lightGrayColor];
        _sectionFollowerView.arrow.image = [UIImage imageNamed:@"downArrow"];
        _sectionFollowerView.model = mod;
        [_sectionFollowerView bk_whenTapped:^{
            self.openSection = section;
            LWLog(@"点击的是第%ld个section",(long)self.openSection);
            self.openStatus = YES;
//            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:self.openSection];
//            [self.listLable reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.listLable reloadData];
        }];
        return _sectionFollowerView;
    }
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.setTag == 1) {
        HostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HostTableViewCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HostTableViewCell" owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        HistoryModel * model =  self.dateArray[indexPath.section];
        AwardList * models = model.awardList[indexPath.row];
        LWLog(@"%@", [models mj_keyValues]);
        cell.model = models;
        return cell;
    }else{
        if (indexPath.section == self.openSection && self.openStatus == YES) {
            static NSString * reidess = @"down";
            DownTudiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reidess];
            LWLog(@"self.lists.count--------%ld",(unsigned long)self.lists.count);
            FollowList * fol =  self.lists[indexPath.section];
            FollowModel * mod = (FollowModel *)fol.list[0];

            LWLog(@"%@",[mod mj_keyValues]) ;
            cell.model = mod;
            //        cell.textLabel.text = [NSString stringWithFormat:@"昨日浏览/转发量: %d/%d次",[mod.yesterdayBrowseAmount integerValue],[mod.yesterdayTurnAmount integerValue]];
            //        cell.detailTextLabel.text = [NSString stringWithFormat:@"历史浏览/转发量: %d/%d次",[mod.historyTotalBrowseAmount integerValue],[mod.historyTotalTurnAmount integerValue]];
            return cell;
        }
        return nil;
//        if (indexPath.row == 0) {
//            static NSString * reide = @"top";
//            TudiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reide];
//            
//            FollowList * fol =  self.lists[indexPath.section];
//            FollowModel * mod = (FollowModel *)fol.list[0];
//            cell.backgroundColor = [UIColor lightGrayColor];
//            cell.arrow.image = [UIImage imageNamed:@"downArrow"];
//            cell.model = mod;
//            
//            return cell;
//            
//            
//            
//        }else{
//            static NSString * reidess = @"down";
//            DownTudiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reidess];
//            LWLog(@"self.lists.count--------%ld",self.lists.count);
//            FollowList * fol =  self.lists[indexPath.section];
//            FollowModel * mod = (FollowModel *)fol.list[1];
//            
//            LWLog(@"%@",[mod mj_keyValues]) ;
//            cell.model = mod;
//            //        cell.textLabel.text = [NSString stringWithFormat:@"昨日浏览/转发量: %d/%d次",[mod.yesterdayBrowseAmount integerValue],[mod.yesterdayTurnAmount integerValue]];
//            //        cell.detailTextLabel.text = [NSString stringWithFormat:@"历史浏览/转发量: %d/%d次",[mod.historyTotalBrowseAmount integerValue],[mod.historyTotalTurnAmount integerValue]];
//            return cell;
//        }
        
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    
//    if (self.setTag == 1) {
//        return;
//    }
//    
//    if (self.lastIndexPath.section == indexPath.section) {
//        TudiTableViewCell  * cella = (TudiTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
//        TudiTableViewCell * cellb = (TudiTableViewCell*)[tableView cellForRowAtIndexPath:self.lastIndexPath];
//        FollowList * fol = self.lists[indexPath.section];
//        if (fol.list.count > 1) {
//            [fol.list removeObjectAtIndex:1];
//            
//            cellb.arrow.image = [UIImage imageNamed:@"upArrow"];
//            //            UIImageView *aa = (UIImageView *)cellb.accessoryView;
//            //            aa.image = [UIImage imageNamed:@"upArrow"];
//            self.lastIndexPath = [NSIndexPath indexPathForRow:-1 inSection:-1];
//        }else{
//            
//            FollowModel * mod = fol.list[0];
//            [fol.list addObject:mod];
//            cella.arrow.image = [UIImage imageNamed:@"downArrow"];
//            //            UIImageView *aa = (UIImageView *)cella.accessoryView;
//            //            aa.image = [UIImage imageNamed:@"downArrow"];
//            self.lastIndexPath = indexPath;
//        }
//        
//        [self.listLable reloadData];
//        
//        return;
//        
//    }
//    
//    
//    TudiTableViewCell  * cella = (TudiTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
//    TudiTableViewCell * cellb = (TudiTableViewCell*)[tableView cellForRowAtIndexPath:self.lastIndexPath];
//    
//    
//    FollowList * fol = self.lists[indexPath.section];
//    FollowModel * mod = fol.list[0];
//    [fol.list addObject:mod];
//    cella.arrow.image = [UIImage imageNamed:@"upArrow"];
//    //    UIImageView *aa = (UIImageView *)cella.accessoryView;
//    //    aa.image = [UIImage imageNamed:@"downArrow"];
//    
//    if (indexPath.section != self.lastIndexPath.section && self.lastIndexPath.section >= 0) {
//        
//        FollowList * fols = self.lists[self.lastIndexPath.section];
//        if (fols.list.count == 2) {
//            
//            [fols.list removeObjectAtIndex:1];
//            cellb.arrow.image = [UIImage imageNamed:@"downArrow"];
//            //            UIImageView *aa = (UIImageView *)cellb.accessoryView;
//            //            aa.image = [UIImage imageNamed:@"upArrow"];
//            
//        }
//    }
//    
//    self.lastIndexPath = indexPath;
//    
//    [self.listLable reloadData];
//    
    
    
}


@end
