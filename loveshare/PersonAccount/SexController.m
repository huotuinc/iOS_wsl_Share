//
//  SexController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/8.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "SexController.h"

@interface SexController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSIndexPath *selected;

@property(nonatomic,strong)NSArray * sexs;

@end

@implementation SexController



- (NSArray *)sexs
{
    if (_sexs == nil) {
        
        _sexs =  @[@"男",@"女"];
      
    }
    return _sexs;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"性别";
    UITableView * tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView = tableView;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];;

    
}


#pragma mark tableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sexs.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    NSString * SEX = self.sexs[indexPath.row];
    cell.textLabel.text = SEX;
    
    if(self.sex == indexPath.row){
        self.selected = indexPath;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = self.sexs[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
     LWLog(@"%s",__func__);
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.selected = indexPath;
    
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([self.delegate respondsToSelector:@selector(selectSexOver:)]) {
        [self.delegate selectSexOver:self.selected.row];
    }
}


@end
