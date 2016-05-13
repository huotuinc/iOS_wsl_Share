//
//  VipSearchViewController.m
//  loveshare
//
//  Created by che on 16/5/12.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "VipSearchViewController.h"
#import "NewTaskDataModel.h"


static NSString *cellVIPSearch = @"cellVIPSearch";
@interface VipSearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSString *searchKey;//搜索关键字

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIImageView *imageVNone;

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation VipSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _pageIndex = 0;
    _dataArray = [NSMutableArray array];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.searchBar];
    //    [self.view addSubview:self.imageVNone];
    [self.view addSubview:self.tableView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.navigationBar.translucent=NO;
}


- (UIImageView *)imageVNone {
    if (_imageVNone == nil) {
        _imageVNone = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
        //        _imageVNone.image = [UIImage imageNamed:@"wss"];
    }
    return _imageVNone;
}
- (UISearchBar *)searchBar {
    if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH , 44)];
        _searchBar.placeholder=@"搜索";
        _searchBar.delegate=self;
        _searchBar.showsCancelButton=YES;
        [_searchBar becomeFirstResponder];
    }
    return _searchBar;
}
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64 ) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:@"HomeCell" bundle:nil] forCellReuseIdentifier:cellVIPSearch];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.rowHeight = 150.f;
        [_tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    }
    return _tableView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellVIPSearch forIndexPath:indexPath];
    if (indexPath.section == 0) {
        NewTaskDataModel * model = self.dataArray[0][indexPath.row];
        cell.model = model;
    } else {
        NewTaskDataModel * model = self.dataArray[1][indexPath.row];
        cell.model = model;
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [_dataArray[0] count];
    }
    return [_dataArray[1] count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"已上架";
    }
    return @"已下架";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountTableViewController* vc = [[AccountTableViewController alloc] initWithStyle:UITableViewStylePlain];
    if (indexPath.section == 0) {
        vc.taskModel = _dataArray[0][indexPath.row];
    } else {
        vc.taskModel = _dataArray[1][indexPath.row];
    }
    [self.navigationController pushViewController:vc animated:YES];
}
//#pragma mark 搜索方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    _searchKey = searchBar.text;
    [self getDataArrayBySearchText:_searchKey andPageIndex:0];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getDataArrayBySearchText:(NSString *)text andPageIndex:(NSInteger)PageIndex {
    UserModel * userInfo = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"loginCode"] = userInfo.loginCode;
    parame[@"pageIndex"] = @(PageIndex);
    parame[@"keyword"] = text;
    [UserLoginTool loginRequestGet:@"UserOrganizeAllTask" parame:parame success:^(id json) {
        LWLog(@"%@",json);
        if ([json[@"status"] integerValue]==1 && [json[@"resultCode"] integerValue] == 1) {
            NSArray * array  =  [NewTaskDataModel mj_objectArrayWithKeyValuesArray:json[@"resultData"]];
            if (PageIndex == 0) {
                [_dataArray removeAllObjects];
                [_dataArray addObjectsFromArray:array];
            } else {
                [_dataArray addObjectsFromArray:array];
            }
            [_searchBar resignFirstResponder];
            _dataArray = [self changeDataArrayByTaskStaus];

            [_tableView reloadData];
        }
        LWLog(@"%@",json[@"description"]);
    }failure:^(NSError *error) {
        
    }];
}

- (NSMutableArray *)changeDataArrayByTaskStaus {
    NSMutableArray *freshArray = [NSMutableArray array];
    NSMutableArray *oldArray = [NSMutableArray array];
    for (NewTaskDataModel *model in _dataArray) {
        if (model.flagShowSend == 1) {
            [freshArray addObject:model];
        } else {
            [oldArray addObject:model];
        }
    }
    [_dataArray removeAllObjects];
    [_dataArray addObject:freshArray];
    [_dataArray addObject:oldArray];
    return _dataArray;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
