//
//  PersonCenterViewController.m
//  loveshare
//
//  Created by lhb on 16/6/19.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "PersonCenterViewController.h"

@interface PersonCenterViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconview;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *leveLable;
@property (weak, nonatomic) IBOutlet UITableView *option;


@property (nonatomic,strong) NSArray * optionList;

@property (nonatomic,strong) NSArray * optionImageName;

@end

@implementation PersonCenterViewController

- (NSArray *)optionImageName{
    if (_optionImageName == nil) {
        _optionImageName = @[@"personhzf",@"personxhll",@"personh"];
    }
    return _optionImageName;
}
- (NSArray *)optionList{
    if (_optionList == nil) {
         _optionList = @[@"转发数",@"浏览量",@"我的收徒数"];
    }
    return _optionList;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.iconview.layer.cornerRadius = self.iconview.frame.size.height*0.5;
    self.iconview.layer.masksToBounds = YES;
    self.iconview.layer.borderWidth = 3;
    self.iconview.layer.borderColor = [UIColor whiteColor].CGColor;
    self.leveLable.layer.cornerRadius = 5;
    self.leveLable.layer.masksToBounds = YES;
    
    
    self.option.tableFooterView = [[UIView alloc] init];
    
    self.option.rowHeight = 60;
    
    self.title = @"个人中心";
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UserModel * usermodel = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    
    [self.iconview sd_setImageWithURL:[NSURL URLWithString:usermodel.userHead] placeholderImage:nil options:SDWebImageRetryFailed];
    self.nickName.text = usermodel.RealName;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.optionList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"xxx"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"xxx"];
    }
    cell.imageView.image = [UIImage imageNamed:self.optionImageName[indexPath.row]];
    cell.textLabel.text = self.optionList[indexPath.row];
    cell.detailTextLabel.text = @"123";
    return cell;
    
}
@end
