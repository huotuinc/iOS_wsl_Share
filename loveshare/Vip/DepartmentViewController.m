//
//  DepartmentViewController.m
//  loveshare
//
//  Created by lhb on 16/3/15.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "DepartmentViewController.h"

@interface DepartmentViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *firstLable;
@property (weak, nonatomic) IBOutlet UILabel *secondLable;
@property (weak, nonatomic) IBOutlet UILabel *thirdLable;
@property (weak, nonatomic) IBOutlet UILabel *fourthLable;
@property (weak, nonatomic) IBOutlet UILabel *fiveLable;
@property (weak, nonatomic) IBOutlet UIView *containView;
@property(nonatomic,strong)UIView * redView;

@property (weak, nonatomic) IBOutlet UITableView *listTableView;


@property(nonatomic,strong) NSMutableArray * originArray;

@end

@implementation DepartmentViewController


- (NSMutableArray *)originArray{
    
    if (_originArray == nil) {
        
        _originArray = [NSMutableArray array];
    }
    
    return _originArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setInit];
    
    self.listTableView.rowHeight = 60;
    [self TogetDate:0];
}

- (void)TogetDate:(int)sortType{
    __weak DepartmentViewController * wself = self;
    UserModel * userInfo = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"pageIndex"] = @(1);
    parame[@"loginCode"] = userInfo.loginCode;
    parame[@"sort"] = @(sortType);
    parame[@"taskId"] = self.taskId;
    parame[@"pid"] = @(self.model.orgid);
    [UserLoginTool loginRequestGet:@"GetGroupPerson" parame:parame success:^(id json) {
        LWLog(@"%@",json);
        if([json[@"resultCode"] integerValue] == 1 ||[json[@"status"] integerValue] == 1){
           NSArray * arrays = [JiTuanModel mj_objectArrayWithKeyValuesArray:json[@"resultData"]];
            [_originArray removeAllObjects];
            [_originArray addObjectsFromArray:arrays];
            [wself.listTableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}
- (void)setInit{
    
    __weak DepartmentViewController * wself = self;
    self.listTableView.tableFooterView = [[UIView alloc] init];
    self.listTableView.rowHeight = 50;
    self.firstLable.userInteractionEnabled = YES;
    self.secondLable.userInteractionEnabled = YES;
    self.thirdLable.userInteractionEnabled = YES;
    
    self.fourthLable.userInteractionEnabled = YES;
    self.fiveLable.userInteractionEnabled = YES;
    
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    CGFloat aa  = (ScreenWidth - 40.0) / 5;
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor orangeColor];
    self.firstLable.textColor = [UIColor orangeColor];
    view.frame = CGRectMake(aa *0.5-aa/2/2+20, _containView.frame.size.height-2, aa / 2 , 2);
    [_containView addSubview:view];
    _redView = view;
    
    [self.firstLable bk_whenTapped:^{
        LWLog(@"xxx");
        _firstLable.textColor = [UIColor orangeColor];
        _secondLable.textColor = [UIColor blackColor];
        _thirdLable.textColor = [UIColor blackColor];
        _fourthLable.textColor = [UIColor blackColor];
        _fiveLable.textColor = [UIColor blackColor];
       
        _redView.frame = CGRectMake(aa *0.5-aa/2/2+20, _containView.frame.size.height-2, aa / 2 , 2);
//        [wself.SortArray removeAllObjects];
//        [wself.SortArray addObjectsFromArray:wself.JITuan];
        
        [wself TogetDate:0];
    }];
    [self.secondLable bk_whenTapped:^{
        LWLog(@"xxx");
        _firstLable.textColor = [UIColor blackColor];
        _secondLable.textColor = [UIColor orangeColor];
        _thirdLable.textColor = [UIColor blackColor];
        _fourthLable.textColor = [UIColor blackColor];
        _fiveLable.textColor = [UIColor blackColor];
        
        _redView.frame = CGRectMake(aa *0.5-aa/2/2+20+aa, _containView.frame.size.height-2, aa / 2 , 2);
        [wself TogetDate:1];
    }];
    [self.thirdLable bk_whenTapped:^{
        LWLog(@"xxx");
        _firstLable.textColor = [UIColor blackColor];
        _secondLable.textColor = [UIColor blackColor];
        _thirdLable.textColor = [UIColor orangeColor];
        _fourthLable.textColor = [UIColor blackColor];
        _fiveLable.textColor = [UIColor blackColor];
        
        _redView.frame = CGRectMake(aa *0.5-aa/2/2+20+2*aa, _containView.frame.size.height-2, aa / 2 , 2);
        [wself TogetDate:2];
    }];
    [self.fourthLable bk_whenTapped:^{
        LWLog(@"xxx");
        _firstLable.textColor = [UIColor blackColor];
        _secondLable.textColor = [UIColor blackColor];
        _thirdLable.textColor = [UIColor blackColor];
        _fourthLable.textColor = [UIColor orangeColor];
        _fiveLable.textColor = [UIColor blackColor];
        
        _redView.frame = CGRectMake(aa *0.5-aa/2/2+20+3*aa, _containView.frame.size.height-2, aa / 2 , 2);
        [wself TogetDate:3];
    }];
    [self.fiveLable bk_whenTapped:^{
        LWLog(@"xxx");
        _firstLable.textColor = [UIColor blackColor];
        _secondLable.textColor = [UIColor blackColor];
        _thirdLable.textColor = [UIColor blackColor];
        _fourthLable.textColor = [UIColor blackColor];
        _fiveLable.textColor = [UIColor orangeColor];
        
        _redView.frame = CGRectMake(aa *0.5-aa/2/2+20+4*aa, _containView.frame.size.height-2, aa / 2 , 2);
        [wself TogetDate:4];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    LWLog(@"%lu",(unsigned long)self.originArray.count);
    return self.originArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"jituan"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"jituan"];
        UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        lable.adjustsFontSizeToFitWidth = YES;
        cell.accessoryView = lable;
        lable.textAlignment = NSTextAlignmentRight;
        lable.text = @"xxx";
        cell.imageView.frame = CGRectMake(0, 0, 40, 40);
        cell.imageView.layer.cornerRadius = 20;
        cell.imageView.layer.masksToBounds = YES;
//        cell.imageView.backgroundColor = [UIColor redColor];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        cell.imageView.image = [UIImage imageNamed:@"iconfont-user"];
        
    }
    
    
    LWLog(@"%@", NSStringFromCGRect(cell.imageView.frame));
    JiTuanModel * model = self.originArray[indexPath.row];
    LWLog(@"%@",model.name);
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:model.logo] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        CGSize size = CGSizeMake(40, 40);
        UIGraphicsBeginImageContextWithOptions(size, NO,0.0);
        CGRect imageRect=CGRectMake(0.0, 0.0, size.width, size.height);
        [image drawInRect:imageRect];
        cell.imageView.image=UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [cell.imageView layoutIfNeeded];
    }];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"转发%d次/浏览%d次/徒弟%d人",model.totalTurnCount,model.totalBrowseCount, model.prenticeCount];
    UILabel * aa =  (UILabel *)cell.accessoryView;
    
    aa.text = [NSString stringWithFormat:@"%@积分",[NSString xiaoshudianweishudeal:[model.totalScore floatValue]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JiTuanModel * model = self.originArray[indexPath.row];
    
    PersonViewController* vc = (PersonViewController*)[UserLoginTool LoginCreateControllerWithNameOfStory:nil andControllerIdentify:@"PersonViewController"];
    vc.model = model;
    vc.title = model.name;
    vc.xixi = [NSString stringWithFormat:@"%@/%@",self.dilu,self.title];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
