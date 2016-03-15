//
//  VipAccountViewController.m
//  loveshare
//
//  Created by lhb on 16/3/14.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "VipAccountViewController.h"

@interface VipAccountViewController ()


@property(nonatomic,strong) NSMutableArray * JITuan;


@property(nonatomic,strong) UISegmentedControl * CTL;
@end

@implementation VipAccountViewController


- (NSMutableArray *)JITuan{
    if (_JITuan== nil) {
        _JITuan = [NSMutableArray array];
    }
    return _JITuan;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UISegmentedControl * CTL = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    _CTL = CTL;
    [CTL addTarget:self action:@selector(ctlChange:) forControlEvents:UIControlEventValueChanged];
    [CTL insertSegmentWithTitle:@"公司" atIndex:0 animated:YES];
    [CTL insertSegmentWithTitle:@"任务" atIndex:1 animated:YES];
    CTL.selectedSegmentIndex = 0;
    self.navigationItem.titleView= CTL;
    // Do any additional setup after loading the view.
    
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    if (CTL.selectedSegmentIndex == 0) {
        self.tableView.rowHeight = 50;
    }
    [self setupDate];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}
- (void)setupDate{
    
    
    __weak VipAccountViewController * wself = self;
    UserModel * userInfo = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"level"] = @(0);
    parame[@"loginCode"] = userInfo.loginCode;
    parame[@"pid"] = @(1);
    parame[@"taskId"] = @(0);
    
    [UserLoginTool loginRequestGet:@"UserOrganize" parame:parame success:^(id json) {
        LWLog(@"%@",json);
        if ([json[@"status"] integerValue] == 1 || [json[@"resultCode"] integerValue] == 1) {
            NSArray * array = [JiTuan mj_objectArrayWithKeyValuesArray:json[@"resultData"]];
            ;
            [wself.JITuan addObjectsFromArray:array];
            [wself.tableView reloadData];
            
        }
    } failure:^(NSError *error) {
        LWLog(@"%@",error.description);
    }];
    
}



- (void)ctlChange:(UISegmentedControl *)ctl{
    
//    if (ctl.selectedSegmentIndex) {
//        <#statements#>
//    }
    LWLog(@"%ld",(long)ctl.selectedSegmentIndex);
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.CTL.selectedSegmentIndex==0) {
        return self.JITuan.count;
    }else{
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.CTL.selectedSegmentIndex == 0) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"jituan"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"jituan"];
        }
        
        JiTuan * model = self.JITuan[indexPath.row];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:nil];
        cell.textLabel.text = model.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d人",model.personCount];
        return cell;
    }
    
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JiTuan * model = self.JITuan[indexPath.row];
    EnterpriseTableViewController* vc = (EnterpriseTableViewController*)[UserLoginTool LoginCreateControllerWithNameOfStory:nil andControllerIdentify:@"EnterpriseTableViewController"];
    vc.model = model;
    vc.title = model.name;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
