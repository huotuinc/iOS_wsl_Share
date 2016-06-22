//
//  VipAccountViewController.m
//  loveshare
//
//  Created by lhb on 16/3/14.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "VipAccountViewController.h"
#import "VipSearchViewController.h"
#import "DepartmentViewController.h"

#define homeCellidentify @"homeCellIdSH"

@interface VipAccountViewController ()<UISearchBarDelegate>


/**
 *  任务的索引
 */
@property(nonatomic,assign) int RenWupageIndex;

@property(nonatomic,assign) int JiTuanpageIndex;

@property(nonatomic,strong) NSMutableArray * JITuan;

@property(nonatomic,strong) NSMutableArray * VipRenWudates;

@property(nonatomic,strong) UISegmentedControl * CTL;

@property (nonatomic, strong) UISearchBar *searchBar;

@property(nonatomic,strong) MJRefreshNormalHeader * head;
@property(nonatomic,strong) MJRefreshAutoFooter * footer;

@property(nonatomic,strong) UIButton * searchButton;



@end

@implementation VipAccountViewController

- (UIButton *)searchButton {
    if (_searchButton == nil) {
        _searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_searchButton setBackgroundImage:[UIImage imageNamed:@"homeSearch"] forState:UIControlStateNormal];
        [_searchButton bk_whenTapped:^{
            VipSearchViewController *search = [[VipSearchViewController alloc] init];
            [self.navigationController pushViewController:search animated:YES];
        }];
    }
    return _searchButton;
}
- (UISearchBar *)searchBar {
    if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , 44)];
        _searchBar.placeholder=@"搜索";
        _searchBar.delegate=self;
        _searchBar.showsCancelButton=YES;
        [_searchBar becomeFirstResponder];
    }
    return _searchBar;
}
- (NSMutableArray *)VipRenWudates{
    if (_VipRenWudates == nil) {
        _VipRenWudates = [NSMutableArray array];
    }
    return _VipRenWudates;
}

- (NSMutableArray *)JITuan{
    if (_JITuan== nil) {
        _JITuan = [NSMutableArray array];
    }
    return _JITuan;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.RenWupageIndex = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    UISegmentedControl * CTL = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    _CTL = CTL;
    [CTL addTarget:self action:@selector(ctlChange:) forControlEvents:UIControlEventValueChanged];
    [CTL insertSegmentWithTitle:@"架构" atIndex:0 animated:YES];
    [CTL insertSegmentWithTitle:@"资讯" atIndex:1 animated:YES];
    CTL.selectedSegmentIndex = 0;
    //修改字体的默认颜色与选中颜色
    CTL.layer.borderWidth = 0.0;
    CTL.tintColor = [UIColor whiteColor];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:225.0/255 green:128/255.0 blue:0/255.0 alpha:1.000],UITextAttributeTextColor,  [UIFont systemFontOfSize:16.f],UITextAttributeFont ,[UIColor whiteColor],UITextAttributeTextShadowColor ,nil];
    [CTL setTitleTextAttributes:dic forState:UIControlStateSelected];
    
    
    self.navigationItem.titleView= CTL;
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchButton];

    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
//    self.tableView.backgroundColor = [UIColor colorWithRed:0.827 green:0.827 blue:0.808 alpha:1.000];
    
    [self RefreshJicheng];
    
    [self.head beginRefreshing];
}


- (void)RefreshJicheng{
    _head = [MJRefreshNormalHeader  headerWithRefreshingTarget:self refreshingAction:@selector(headRefreshVip)];
    self.tableView.mj_header = _head;
    
    _footer =  [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefreshVip)];
    self.tableView.mj_footer = _footer;
}


- (void)headRefreshVip{
    
    LWLog(@"%ld",(long)self.CTL.selectedSegmentIndex);
    if(self.CTL.selectedSegmentIndex){//任务
        //按任务
        [self setRenWuWithPageIndex:1];
    }else{//架构
        //按人的
        [self setupDate];
    }
    
}

- (void)footRefreshVip{
    
    LWLog(@"xxxx");
    if (self.CTL.selectedSegmentIndex) {
        
        //按任务
        [self setRenWuWithPageIndex:self.RenWupageIndex+1];
    }
}
- (void)setRenWuWithPageIndex:(int)PageIndex{
    LWLog(@"%d",PageIndex);
    __weak VipAccountViewController * wself = self;
    UserModel * userInfo = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"loginCode"] = userInfo.loginCode;
    parame[@"pageIndex"] = @(PageIndex);
    [MBProgressHUD showMessage:nil];
    [UserLoginTool loginRequestGet:@"UserOrganizeAllTask" parame:parame success:^(id json) {
        [MBProgressHUD hideHUD];
        LWLog(@"%@",json);
        wself.RenWupageIndex = [json[@"pageIndex"] intValue];
        if ([json[@"status"] integerValue] ==1 && [json[@"resultCode"] integerValue] ==1){
           NSMutableArray * dates = [NewTaskDataModel mj_objectArrayWithKeyValuesArray:json[@"resultData"]];
            if (dates.count) {//有数据
                if (PageIndex>1) {//尾部刷新
                    [wself.VipRenWudates addObjectsFromArray:dates];
                    [wself.tableView reloadData];
                    [wself.footer endRefreshing];
                }else{
                    [wself.VipRenWudates removeAllObjects];
                    [wself.VipRenWudates addObjectsFromArray:dates];
                    [wself.tableView reloadData];
                    [wself.head endRefreshing];
                }
            }
        }
        LWLog(@"%@",json[@"tip"]);
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [wself.head endRefreshing];
        [wself.footer endRefreshing];
    }];
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
    parame[@"orid"] = @(0);
    parame[@"taskId"] = @(0);
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



- (void)ctlChange:(UISegmentedControl *)ctl{
//    [self.head beginRefreshing];
    //BC 修改
    if (ctl.selectedSegmentIndex == 0) {
        [self.VipRenWudates removeAllObjects];
        [self.tableView reloadData];
        [self setupDate];

        
    } else {
        [self.JITuan removeAllObjects];
        [self.tableView reloadData];
        [self setRenWuWithPageIndex:1];

//        [self.tableView reloadData];

    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.CTL.selectedSegmentIndex==0) {
        return self.JITuan.count;
    }else{
        return self.VipRenWudates.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.CTL.selectedSegmentIndex == 0) {
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
    }else{
        
        
        HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:homeCellidentify];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeCell" owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
//        if (self.currentSelect.tag == 1) {
//            TaskGrouoModel * taskGroup  = self.taskGroup[indexPath.section];
//            NewTaskDataModel *task = taskGroup.tasks[indexPath.row];
//            cell.model = task;
//            return cell;
//        }
        LWLog(@"%s-----%lu",__func__,(unsigned long)self.VipRenWudates.count);
        NewTaskDataModel * model = self.VipRenWudates[indexPath.row];
        cell.model = model;
        return cell;
    }
    
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.CTL.selectedSegmentIndex == 0) {
       return 60;
    }
    return 150;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.CTL.selectedSegmentIndex == 0) {
        JiTuan * model = self.JITuan[indexPath.row];
        if ([model.children integerValue] == 1) {
            EnterpriseTableViewController* vc = (EnterpriseTableViewController*)[UserLoginTool LoginCreateControllerWithNameOfStory:nil andControllerIdentify:@"EnterpriseTableViewController"];
            vc.model = model;
            vc.title = model.name;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            DepartmentViewController* department = (DepartmentViewController*)[UserLoginTool LoginCreateControllerWithNameOfStory:nil andControllerIdentify:@"DepartmentViewController"];
            department.model = model;
            department.taskId = @(0);
            department.dilu = self.title;
            [self.navigationController pushViewController:department animated:YES];

        }
        
        
    }else{
        NewTaskDataModel * model = self.VipRenWudates[indexPath.row];
        AccountTableViewController* vc = [[AccountTableViewController alloc] initWithStyle:UITableViewStylePlain];
        vc.taskModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
    

}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MBProgressHUD hideHUD];
}
@end
