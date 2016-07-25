//
//  EnterpriseTableViewController.m
//  loveshare
//
//  Created by lhb on 16/3/14.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "EnterpriseTableViewController.h"
#import "DepartmentTableViewCell.h"
#import "JiTuanModel.h"
@interface EnterpriseTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *containView;

@property (weak, nonatomic) IBOutlet UILabel *defaultLable;
@property (weak, nonatomic) IBOutlet UILabel *turnLable;
@property (weak, nonatomic) IBOutlet UILabel *browsLable;
@property(nonatomic,strong) NSMutableArray * JITuan;
@property (weak, nonatomic) IBOutlet UITableView *optionLable;

@property(nonatomic,strong) NSMutableArray * SortArray;

@property(nonatomic,strong)UIView * redView;




/**企业下面的人*/
@property(nonatomic,strong) NSArray * enterPriseDownPerson;


@end

@implementation EnterpriseTableViewController
- (NSMutableArray *)SortArray{
    if (_SortArray== nil) {
        _SortArray = [NSMutableArray array];
    }
    return _SortArray;
}


- (NSMutableArray *)JITuan{
    if (_JITuan== nil) {
        _JITuan = [NSMutableArray array];
    }
    return _JITuan;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate * ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ad.currentVC = self;
    
    
    [self setInit];
    self.defaultLable.userInteractionEnabled = YES;
    self.turnLable.userInteractionEnabled = YES;
    self.browsLable.userInteractionEnabled = YES;
    
    self.optionLable.rowHeight = 100;
    CGFloat aa  = (ScreenWidth - 40.0) / 3;
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor orangeColor];
    self.defaultLable.textColor = [UIColor orangeColor];
    view.frame = CGRectMake(aa *0.5-aa/2/2+20, _containView.frame.size.height-2, aa / 2 , 2);
    [_containView addSubview:view];
    _redView = view;
    self.optionLable.delegate = self;
    self.optionLable.dataSource = self;
//    self.optionLable.rowHeight = 50;
    self.optionLable.tableFooterView = [[UIView alloc] init];
    [self ToGetDate];
    
    [self.optionLable registerNib:[UINib nibWithNibName:@"DepartmentTableViewCell" bundle:nil] forCellReuseIdentifier:@"departperson"];
}

- (void)setInit{
    
    __weak EnterpriseTableViewController * wself = self;
    CGFloat aa  = (ScreenWidth - 40.0) / 3;
    [self.defaultLable bk_whenTapped:^{
        LWLog(@"xxx");
        _defaultLable.textColor = [UIColor orangeColor];
        _turnLable.textColor = [UIColor blackColor];
        _browsLable.textColor = [UIColor blackColor];
        _redView.frame = CGRectMake(aa *0.5-aa/2/2+20, _containView.frame.size.height-2, aa / 2 , 2);
        [wself.SortArray removeAllObjects];
        [wself.SortArray addObjectsFromArray:wself.JITuan];
        [wself.optionLable reloadData];

    }];
    
    [self.turnLable bk_whenTapped:^{
         LWLog(@"xxx");
        _defaultLable.textColor = [UIColor blackColor];
        _turnLable.textColor = [UIColor orangeColor];
        _browsLable.textColor = [UIColor blackColor];
        _redView.frame = CGRectMake(aa *0.5-aa/2/2+20+aa, _containView.frame.size.height-2, aa / 2 , 2);
        [wself DateToSort:wself.SortArray withType:1];
        [wself.optionLable reloadData];
        
    }];
    
    [self.browsLable bk_whenTapped:^{
         LWLog(@"xxx");
        _defaultLable.textColor = [UIColor blackColor];
        _turnLable.textColor = [UIColor blackColor];
        _browsLable.textColor = [UIColor orangeColor];
         _redView.frame = CGRectMake(aa *0.5-aa/2/2+20+2*aa, _containView.frame.size.height-2, aa / 2 , 2);
        [wself DateToSort:wself.SortArray withType:2];
        [wself.optionLable reloadData];

    }];
}


- (void)DateToSort:(NSMutableArray * )originArray withType:(int)type{
    
    [originArray sortUsingComparator:^NSComparisonResult(JiTuan* obj1, JiTuan* obj2) {
        if (type == 1) {
            return obj1.totalTurnCount < obj2.totalTurnCount;
        }else if(type == 2){
            return obj1.totalBrowseCount < obj2.totalBrowseCount;
        }else{
            return true;
        }
        
    }];
    
    
    
}

- (void)ToGetDate{
    
    __weak EnterpriseTableViewController * wself = self;
    UserModel * userInfo = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
//    parame[@"level"] = @(self.model.level);
    parame[@"loginCode"] = userInfo.loginCode;
    parame[@"orid"] = @(self.model.orgid);
    parame[@"taskId"] = self.taskId;
    [MBProgressHUD showMessage:nil];
    [UserLoginTool loginRequestGet:@"UserOrganize" parame:parame success:^(id json) {
        LWLog(@"%@",json);
        [MBProgressHUD hideHUD];
        if ([json[@"status"] integerValue] == 1 || [json[@"resultCode"] integerValue] == 1) {
            NSArray * array = [JiTuan mj_objectArrayWithKeyValuesArray:json[@"resultData"]];
            ;
            [wself.SortArray addObjectsFromArray:array];
            [wself.JITuan addObjectsFromArray:array];
            
            /**部门下面的人员*/
            wself.enterPriseDownPerson =  [JiTuanModel mj_objectArrayWithKeyValuesArray:json[@"resultPersonData"]];
            [wself.optionLable reloadData];
            
            
            
        }
    } failure:^(NSError *error) {
        LWLog(@"%@",error.description);
        [MBProgressHUD hideHUD];
    }];

    
}
#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    if (self.SortArray.count == 0) {
        self.optionLable.backgroundColor = [UIColor colorWithPatternImage:[UserLoginTool LoginCreateImageWithNoDate]];
    }else{
        self.optionLable.backgroundColor = [UIColor whiteColor];
    }
    return  self.SortArray.count + self.enterPriseDownPerson.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"jituan"];
    
    if(indexPath.row < self.SortArray.count){
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"jituan"];
            UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
            cell.accessoryView = lable;
            lable.textAlignment = NSTextAlignmentRight;
            lable.text = @"xxx";
            lable.adjustsFontSizeToFitWidth = YES;
            cell.imageView.frame = CGRectMake(0, 0, 40, 40);
            cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
            cell.imageView.layer.cornerRadius = 5;
            cell.imageView.layer.masksToBounds = YES;
        }
        
        JiTuan * model = self.SortArray[indexPath.row];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"imglogo"]];
        cell.textLabel.text = model.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"总转发%d次/总浏览%d次",model.totalTurnCount,model.totalBrowseCount];
        UILabel * aa =  (UILabel *)cell.accessoryView;
        aa.text = [NSString stringWithFormat:@"%d人",model.personCount];
        return cell;
    }else{
//        DepartmentTableViewCell.h
        DepartmentTableViewCell * cell =  [tableView dequeueReusableCellWithIdentifier:@"departperson"];
        JiTuanModel * model = self.enterPriseDownPerson[(indexPath.row-self.SortArray.count)];
        [cell.imageVHead sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"xiangxtouxiang"]];
        cell.labelName.text = model.name;
        cell.labelDetails.text = [NSString stringWithFormat:@"转发%d次/浏览%d次/伙伴%d人",model.totalTurnCount,model.totalBrowseCount, model.prenticeCount];
        cell.labelScore.text = [NSString stringWithFormat:@"%@积分",[NSString xiaoshudianweishudeal:[model.totalScore floatValue]]];
        return cell;
        
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LWLog(@"xxxxxxxx");
    if (indexPath.row<self.SortArray.count) {
        
        JiTuan * model = self.SortArray[indexPath.row];

        if ([model.children integerValue] == 1) {
            EnterpriseTableViewController* vc = (EnterpriseTableViewController*)[UserLoginTool LoginCreateControllerWithNameOfStory:nil andControllerIdentify:@"EnterpriseTableViewController"];
            vc.model = model;
            vc.title = model.name;
            vc.taskId = self.taskId;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            DepartmentViewController* vc = (DepartmentViewController*)[UserLoginTool LoginCreateControllerWithNameOfStory:nil andControllerIdentify:@"DepartmentViewController"];
            vc.model = model;
            vc.title = model.name;
            vc.taskId = self.taskId;
            vc.dilu = self.title;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }
    else{
        
        JiTuanModel * model = self.enterPriseDownPerson[(indexPath.row-self.SortArray.count)];
        LWLog(@"%@",[model mj_keyValues]);
        PersonViewController* vc = (PersonViewController*)[UserLoginTool LoginCreateControllerWithNameOfStory:nil andControllerIdentify:@"PersonViewController"];
        vc.model = model;
        vc.title = model.name;
//        vc.xixi = [NSString stringWithFormat:@"%@/%@",self.dilu,self.title];
        [self.navigationController pushViewController:vc animated:YES];
    }

    
    
    
}


@end
