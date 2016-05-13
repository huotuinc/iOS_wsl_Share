//
//  StoreSelectedViewController.m
//  loveshare
//
//  Created by che on 16/5/12.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "StoreSelectedViewController.h"

#import "StoreModel.h"
#import "StoreSelectedTableViewCell.h"
static NSString *cellStore = @"cellStore";
@interface StoreSelectedViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSString *searchKey;

@property (nonatomic, strong) NSMutableArray *storeList;
@property (nonatomic, strong) NSMutableArray *searchList;


@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIImageView *imageVNone;

@property (nonatomic, strong) UISearchBar *searchBar;

@property(nonatomic,strong) MJRefreshNormalHeader * head;
@property(nonatomic,strong) MJRefreshAutoFooter * footer;

@property (nonatomic, assign) NSInteger pageNumber;

@end

@implementation StoreSelectedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _storeList = [NSMutableArray array];
    _searchList = [NSMutableArray array];
    // Do any additional setup after loading the view
    self.view.backgroundColor = [UIColor whiteColor];
    _pageNumber = 1;
    [self RefreshJicheng];
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getNewStoreList];
    
}
- (UISearchBar *)searchBar {
    if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _searchBar.showsCancelButton = YES;
        _searchBar.delegate = self;
    }
    return _searchBar;
}
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-64 -44) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:@"StoreSelectedTableViewCell" bundle:nil] forCellReuseIdentifier:cellStore];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        [_tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    }
    return _tableView;
}
- (void)RefreshJicheng{
    _head = [MJRefreshNormalHeader  headerWithRefreshingTarget:self refreshingAction:@selector(getNewStoreList)];
    self.tableView.mj_header = _head;
    
    _footer =  [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreStoreList)];
    self.tableView.mj_footer = _footer;
}
- (void)getNewStoreList {
    LWLog(@"%ld",_pageNumber);
    UserModel * userInfo = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"loginCode"] = userInfo.loginCode;
    parame[@"pageIndex"] = @(1);
    [UserLoginTool loginRequestGet:@"StoreList" parame:parame success:^(id json) {
        LWLog(@"%@",json);
        if ([json[@"status"] integerValue] ==1 && [json[@"resultCode"] integerValue] ==1){
            NSArray *array = [StoreModel mj_objectArrayWithKeyValuesArray:json[@"resultData"]];
            [self.storeList removeAllObjects];
            [self.storeList addObjectsFromArray:array];
            [self.tableView reloadData];
            [self.head endRefreshing];
        }
    } failure:^(NSError *error) {
        [self.head endRefreshing];
    }];
}
- (void)getMoreStoreList {
    [self getMoreStoreListWithPageIndex:_pageNumber + 1];

}
- (void)getMoreStoreListWithPageIndex:(NSInteger)pageIndex{
    LWLog(@"%ld",pageIndex);
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    UserModel * userInfo = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    parame[@"pageIndex"] = @(pageIndex);
    parame[@"loginCode"] = userInfo.loginCode;
    [UserLoginTool loginRequestGet:@"UserOrganizeAllTask" parame:parame success:^(id json) {
        LWLog(@"%@",json);
        if ([json[@"status"] integerValue] ==1 && [json[@"resultCode"] integerValue] ==1){
            NSArray *array = [StoreModel mj_objectArrayWithKeyValuesArray:json[@"resultData"]];
            [self.storeList addObjectsFromArray:array];
            [self.tableView reloadData];
            [self.footer endRefreshing];
        }
    } failure:^(NSError *error) {
        [self.footer endRefreshing];
    }];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoreSelectedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStore forIndexPath:indexPath];
    if (_searchList.count > 0) {
        StoreModel *model = _searchList[indexPath.row];
        [cell loadData:model];
    } else {
        StoreModel *model = _storeList[indexPath.row];
        [cell loadData:model];
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_searchList.count > 0) {
        return _searchList.count;
    }
    return _storeList.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    StoreModel *model = [[StoreModel alloc] init];
    if (_searchList.count > 0) {
        model = _searchList[indexPath.row];
    } else {
        model =  _storeList[indexPath.row];
    }
    if ([self.delegate respondsToSelector:@selector(sendUserID:)]) {
        [self.delegate sendUserID:[model.UserId integerValue]];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    for (StoreModel *model in _storeList) {
        NSRange range = [model.UserName rangeOfString:searchBar.text];
        if (range.length > 0) {
            [_searchList addObject:model];
        }
    }
    [_tableView reloadData];
    [searchBar resignFirstResponder];

}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [_searchList removeAllObjects];
    [searchBar resignFirstResponder];
    [_tableView reloadData];
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
