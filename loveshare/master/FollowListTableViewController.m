//
//  FollowListTableViewController.m
//  Fanmore
//
//  Created by lhb on 15/12/11.
//  Copyright © 2015年 Cai Jiang. All rights reserved.
//  徒弟列表
#import "FollowListTableViewController.h"
#import "FollowList.h"
#import "FollowModel.h"

@interface FollowListTableViewController ()


@property(nonatomic,strong)NSNumber * numbersOfFollowers;

/**徒弟列表*/
@property(nonatomic,strong)NSMutableArray * lists;

/**徒弟列表*/
@property(nonatomic,strong) NSIndexPath * lastIndexPath;

@end

@implementation FollowListTableViewController




- (NSIndexPath *)lastIndexPath{
    if (_lastIndexPath == nil) {
        _lastIndexPath = [NSIndexPath indexPathForRow:-1 inSection:-1];
    }
    return _lastIndexPath;
}

- (NSMutableArray *)lists{
    if (_lists == nil) {
        _lists = [NSMutableArray array];
    }
    return _lists;
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.title = @"徒弟列表";
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = 50;
    self.tableView.rowHeight = 60;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TudiTableViewCell" bundle:nil]  forCellReuseIdentifier:@"top"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DownTudiTableViewCell" bundle:nil]  forCellReuseIdentifier:@"down"];
    
    [self setup];
}

- (void)setup{
    __weak FollowListTableViewController * wself = self;
    UserModel * userInfo = (UserModel * )[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"loginCode"] = userInfo.loginCode;
    parame[@"orderType"] = @(0);
    parame[@"pageTag"] = @(0);
    parame[@"pageSize"] = @(10);
    [UserLoginTool loginRequestGet:@"PrenticeList" parame:parame success:^(id json) {
        LWLog(@"%@",json);
        if ([json[@"status"] integerValue] == 1 && [json[@"resultCode"] integerValue] == 1) {
            NSArray * aa = [FollowModel mj_objectArrayWithKeyValuesArray:json[@"resultData"][@"list"]];
            [wself ToGroupList:aa];
        }
        

        
    } failure:^(NSError *error) {
        
    }];
    
};



- (void)setupRefresh{
    
    
    
    
    
    
}

/**
 *  分组
 *
 *  @param list <#list description#>
 */
- (void)ToGroupList:(NSArray * )list{
    
    for (int i = 0; i<list.count; i++) {
        
        FollowList * mod = [[FollowList alloc] init];
        mod.groupId = i;
        NSMutableArray * marra = [NSMutableArray array];
        [marra addObject:list[i]];
        mod.list = marra;
        
        [self.lists addObject:mod];
    }
    
    [self.tableView reloadData];
    
}


#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    LWLog(@"%lu",(unsigned long)self.lists.count);
    return self.lists.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    FollowList * ss = self.lists[section];
    NSLog(@"%lu",(unsigned long)ss.list.count);
    
    return ss.list.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        static NSString * reide = @"top";
        TudiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reide];
        FollowList * fol =  self.lists[indexPath.section];
        FollowModel * mod = (FollowModel *)fol.list[0];
        cell.arrow.image = [UIImage imageNamed:@"downArrow"];
        cell.model = mod;
        return cell;
        
        
        
    }else{
        static NSString * reidess = @"down";
        DownTudiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reidess];
        FollowList * fol =  self.lists[indexPath.section];
        FollowModel * mod = (FollowModel *)fol.list[1];
        
        cell.model = mod;
//        cell.textLabel.text = [NSString stringWithFormat:@"昨日浏览/转发量: %d/%d次",[mod.yesterdayBrowseAmount integerValue],[mod.yesterdayTurnAmount integerValue]];
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"历史浏览/转发量: %d/%d次",[mod.historyTotalBrowseAmount integerValue],[mod.historyTotalTurnAmount integerValue]];
        return cell;
    }
}

#pragma mark - Table view data delegate


//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 10;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    
//    return 0;
//}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.lastIndexPath.section == indexPath.section) {
        TudiTableViewCell  * cella = (TudiTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        TudiTableViewCell * cellb = (TudiTableViewCell*)[tableView cellForRowAtIndexPath:self.lastIndexPath];
        FollowList * fol = self.lists[indexPath.section];
        if (fol.list.count > 1) {
            [fol.list removeObjectAtIndex:1];
            
            cellb.arrow.image = [UIImage imageNamed:@"upArrow"];
//            UIImageView *aa = (UIImageView *)cellb.accessoryView;
//            aa.image = [UIImage imageNamed:@"upArrow"];
            self.lastIndexPath = [NSIndexPath indexPathForRow:-1 inSection:-1];
        }else{
            
            FollowModel * mod = fol.list[0];
            [fol.list addObject:mod];
            cella.arrow.image = [UIImage imageNamed:@"downArrow"];
//            UIImageView *aa = (UIImageView *)cella.accessoryView;
//            aa.image = [UIImage imageNamed:@"downArrow"];
            self.lastIndexPath = indexPath;
        }
        
        [self.tableView reloadData];
        
        return;
        
    }
    
    
     TudiTableViewCell  * cella = (TudiTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    TudiTableViewCell * cellb = (TudiTableViewCell*)[tableView cellForRowAtIndexPath:self.lastIndexPath];
    
    
    FollowList * fol = self.lists[indexPath.section];
    FollowModel * mod = fol.list[0];
    [fol.list addObject:mod];
    cella.arrow.image = [UIImage imageNamed:@"upArrow"];
//    UIImageView *aa = (UIImageView *)cella.accessoryView;
//    aa.image = [UIImage imageNamed:@"downArrow"];
    
    if (indexPath.section != self.lastIndexPath.section && self.lastIndexPath.section >= 0) {
        
        FollowList * fols = self.lists[self.lastIndexPath.section];
        if (fols.list.count == 2) {
            
            [fols.list removeObjectAtIndex:1];
            cellb.arrow.image = [UIImage imageNamed:@"downArrow"];
//            UIImageView *aa = (UIImageView *)cellb.accessoryView;
//            aa.image = [UIImage imageNamed:@"upArrow"];
            
        }
    }
    
    self.lastIndexPath = indexPath;
    
    [self.tableView reloadData];
    
    
    
}



@end
