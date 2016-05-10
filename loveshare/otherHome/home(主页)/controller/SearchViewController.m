//
//  SearchViewController.m
//  loveshare
//
//  Created by che on 16/5/10.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "SearchViewController.h"


#define COLOR_BACK_MAIN [UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1]
#define COLOR_TEXT_TITILE [UIColor colorWithRed:225.0/255 green:128/255.0 blue:0/255.0 alpha:1.000]
#define FONT_SIZE(i) SCREEN_WIDTH*((i)/750.0f)

static NSString *cellSearch = @"cellSearch";
@interface SearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSString *searchKey;

@property (nonatomic, strong) NSMutableArray *searchList;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIImageView *imageVNone;

@property (nonatomic, strong) UISearchBar *searchBar;




@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.navigationBar.translucent=NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;

    self.view.backgroundColor = [UIColor whiteColor];
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
//    button.backgroundColor = [UIColor redColor];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.imageVNone];
    [self.view addSubview:self.tableView];
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
//        [_searchBar setImage:[UIImage imageNamed:@"search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
//        for (UIView* subview in [[_searchBar.subviews lastObject] subviews]) {
//            if ([subview isKindOfClass:[UITextField class]]) {
//                UITextField *textField = (UITextField*)subview;
//                [textField setBackgroundColor:COLOR_BACK_MAIN];      //修改输入框的颜色
//            }
//        }
//        for(UIView *view in  [[[_searchBar subviews] objectAtIndex:0] subviews]) {
//            if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
//                UIButton * cancel =(UIButton *)view;
//                [cancel setTitle:@"取消" forState:UIControlStateNormal];
//                [cancel setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//                [cancel setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
//
//                cancel.titleLabel.font=[UIFont systemFontOfSize:FONT_SIZE(26)];
//                [cancel setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//                [cancel setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
//                [cancel bk_whenTapped:^{
//                    [self.navigationController popViewControllerAnimated:YES];
//                }];
//            }
//        }
//        _searchBar.barTintColor = COLOR_TEXT_TITILE;
        [_searchBar becomeFirstResponder];
    }
    return _searchBar;
}
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64 -44) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:@"HomeCell" bundle:nil] forCellReuseIdentifier:cellSearch];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        [_tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    }
    return _tableView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellSearch];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeCell" owner:nil options:nil] lastObject];
        cell.backgroundColor = [UIColor whiteColor];
    }
//    if (self.currentSelect.tag == 1) {
//        TaskGrouoModel * taskGroup  = self.taskGroup[indexPath.section];
//        NewTaskDataModel *task = taskGroup.tasks[indexPath.row];
//        cell.model = task;
//        return cell;
//    }
//    NewTaskDataModel * model = self.taskLists[indexPath.row];
//    cell.model = model;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

#pragma mark 搜索方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
//    self.searchTitle = searchBar.text;
//    [self getSearchList];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
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
