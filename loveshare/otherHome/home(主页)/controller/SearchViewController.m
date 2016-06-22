//
//  SearchViewController.m
//  loveshare
//
//  Created by che on 16/5/10.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "SearchViewController.h"

#import "detailViewController.h"

#define COLOR_BACK_MAIN [UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1]
#define COLOR_TEXT_TITILE [UIColor colorWithRed:225.0/255 green:128/255.0 blue:0/255.0 alpha:1.000]
#define FONT_SIZE(i) SCREEN_WIDTH*((i)/750.0f)

static NSString *cellSearch = @"cellSearch";
@interface SearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSString *searchKey;//搜索关键字

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIImageView *imageVNone;

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, assign) NSInteger pageIndex;


@property(nonatomic,strong) MJRefreshNormalHeader * head;
@property(nonatomic,strong) MJRefreshAutoFooter * footer;


@property(nonatomic,strong) UIView * overView;

@end

@implementation SearchViewController


- (UIView *)overView{
    
    if (_overView == nil) {
        
        _overView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _overView.backgroundColor = [UIColor blackColor];
        _overView.alpha = 0.7;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remoteOver)];
        [_overView addGestureRecognizer:tap];
    
    }
    return _overView;
}



- (void)remoteOver{
    
    [self.overView removeFromSuperview];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _pageIndex = 0;
    _dataArray = [NSMutableArray array];

    AppDelegate * ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ad.currentVC = self;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = [self searchBar];
//    [self.view addSubview:self.searchBar];
//    [self.view addSubview:self.imageVNone];
    [self.view addSubview:[self tableView]];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    UIWindow * win = [[UIApplication sharedApplication] keyWindow];
    [win addSubview:[self overView]];
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
//        [_searchBar becomeFirstResponder];
    }
    return _searchBar;
}
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:@"HomeCell" bundle:nil] forCellReuseIdentifier:cellSearch];
//        _tableView.backgroundColor = [UIColor redColor];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.rowHeight = 150.f;
        [_tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    }
    return _tableView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellSearch forIndexPath:indexPath];
    
    
    NewTaskDataModel * model = [_dataArray objectAtIndex:indexPath.row];
    LWLog(@"%@",[model mj_keyValues]);
    cell.model = [_dataArray objectAtIndex:indexPath.row];

    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataArray.count;
}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return _dataArray.count;
//}
//

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    detailViewController * vc =(detailViewController *)[UserLoginTool LoginCreateControllerWithNameOfStory:nil andControllerIdentify:@"detailViewController"];

    vc.taskModel = [_dataArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 搜索方法

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    [self.navigationItem setHidesBackButton:YES]; 
    [self.overView removeFromSuperview];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    _searchKey = searchBar.text;
    [_searchBar resignFirstResponder];
    [self getDataArrayBySearchText:_searchKey andPageIndex:0];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [_searchBar resignFirstResponder];
//    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getDataArrayBySearchText:(NSString *)text andPageIndex:(NSInteger)PageIndex {
    UserModel * userInfo = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"loginCode"] = userInfo.loginCode;
    parame[@"pageIndex"] = @(PageIndex);
    parame[@"keyword"] = text;
    [UserLoginTool loginRequestGet:@"TaskList" parame:parame success:^(id json) {
        LWLog(@"%@",json);
        if ([json[@"status"] integerValue]==1 && [json[@"resultCode"] integerValue] == 1) {
            NSArray * array  =  [NewTaskDataModel mj_objectArrayWithKeyValuesArray:json[@"resultData"][@"taskData"]];
            
            
            
            if (array.count) {
                
                [_dataArray removeAllObjects];
                [_dataArray addObjectsFromArray:array];
            }
//            LWLog(@"%lu",(unsigned long)array.count);
//            if (PageIndex == 0) {
//                [_dataArray removeAllObjects];
//                [_dataArray addObjectsFromArray:array];
//            } else {
//                [_dataArray addObjectsFromArray:array];
//            }
            [_searchBar resignFirstResponder];
//            _dataArray = [self changeDataArrayByTaskStaus];
            [_head endRefreshing];
            [_footer endRefreshing];
            [_tableView reloadData];
        }
        LWLog(@"%@",json[@"description"]);
    }failure:^(NSError *error) {
            [_head endRefreshing];
            [_footer endRefreshing];
    }];
}

- (void)back{
   
    
    [self.searchBar resignFirstResponder];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.overView removeFromSuperview];
    [self.view endEditing:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}

@end
