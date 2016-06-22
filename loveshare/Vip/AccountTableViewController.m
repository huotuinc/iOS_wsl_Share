//
//  AccountTableViewController.m
//  loveshare
//
//  Created by lhb on 16/3/20.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "AccountTableViewController.h"

@interface AccountTableViewController ()
@property(nonatomic,strong) MJRefreshNormalHeader * head;
@property(nonatomic,strong) MJRefreshAutoFooter * footer;

@property(nonatomic,strong) NSMutableArray * JITuan;
@end

@implementation AccountTableViewController


- (NSMutableArray *)JITuan{
    if (_JITuan== nil) {
        _JITuan = [NSMutableArray array];
    }
    return _JITuan;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self RefreshJicheng];
    
    
    AppDelegate * ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ad.currentVC = self;
    
    
    self.title = @"架构";
    [self.head beginRefreshing];
}

- (void)RefreshJicheng{
    _head = [MJRefreshNormalHeader  headerWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    self.tableView.mj_header = _head;
    
    _footer =  [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    self.tableView.tableFooterView = _footer;
}


- (void)headRefresh{
     //按人的
    [self setupDate];
}

- (void)footRefresh{
    
    
//        //按任务
//        [self setRenWuWithPageIndex:self.RenWupageIndex+1];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}



- (void)setupDate{
    __weak AccountTableViewController * wself = self;
    UserModel * userInfo = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"level"] = @(0);
    parame[@"loginCode"] = userInfo.loginCode;
    parame[@"pid"] = @(1);
    parame[@"taskId"] = @(self.taskModel.taskId);
    [MBProgressHUD showMessage:nil];
    [UserLoginTool loginRequestGet:@"UserOrganize" parame:parame success:^(id json) {
        LWLog(@"%@",json);
        [MBProgressHUD hideHUD];
        if ([json[@"status"] integerValue] == 1 || [json[@"resultCode"] integerValue] == 1) {
            NSArray * array = [JiTuan mj_objectArrayWithKeyValuesArray:json[@"resultData"]];
            ;
            if (array.count) {
                [wself.JITuan removeAllObjects];
                [wself.JITuan addObjectsFromArray:array];
                [wself.tableView reloadData];
                [wself.head endRefreshing];
            }
        }
    } failure:^(NSError *error) {
        [wself.head endRefreshing];
        LWLog(@"%@",error.description);
    }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.JITuan.count;
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"jituan"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"jituan"];
            cell.imageView.frame = CGRectMake(0, 0, 40, 40);
            cell.imageView.layer.cornerRadius = 5;
            cell.imageView.layer.masksToBounds = YES;
            cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
            
        }
        JiTuan * model = self.JITuan[indexPath.row];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"imglogo"]];
        cell.textLabel.text = model.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d人",model.personCount];
        return cell;
   
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
 
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        JiTuan * model = self.JITuan[indexPath.row];
        EnterpriseTableViewController* vc = (EnterpriseTableViewController*)[UserLoginTool LoginCreateControllerWithNameOfStory:nil andControllerIdentify:@"EnterpriseTableViewController"];
        vc.model = model;
        vc.title = model.name;
        vc.taskId = [NSNumber numberWithInt:self.taskModel.taskId];
        [self.navigationController pushViewController:vc animated:YES];
//    }
//    
//    JiTuan * model = self.JITuan[indexPath.row];
//    EnterpriseTableViewController* vc = (EnterpriseTableViewController*)[UserLoginTool LoginCreateControllerWithNameOfStory:nil andControllerIdentify:@"EnterpriseTableViewController"];
//    vc.model = model;
//    vc.title = model.name;
//    [self.navigationController pushViewController:vc animated:YES];

}
@end
