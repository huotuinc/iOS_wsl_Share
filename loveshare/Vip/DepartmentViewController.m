//
//  DepartmentViewController.m
//  loveshare
//
//  Created by lhb on 16/3/15.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "DepartmentViewController.h"
#import "DepartmentTableViewCell.h"

static NSString *deCell = @"deCell";
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

@property(nonatomic,assign) int currenctPageIndex;//当前页数
@property (nonatomic, assign) int currenctType;//排序类型，0默认排序,1转发，2浏览，3徒弟，4积分

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
    self.view.backgroundColor = [UIColor whiteColor];
    [self setInit];
    [self setupRefresh];
    [self.listTableView registerNib:[UINib nibWithNibName:@"DepartmentTableViewCell" bundle:nil] forCellReuseIdentifier:deCell];
//    self.listTableView.rowHeight = 60;
    [self getDataWithType:0 andPageIndex:1];
}
- (void)setupRefresh {
    MJRefreshNormalHeader * headRe = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    self.listTableView.mj_header = headRe;
    
    MJRefreshBackNormalFooter * Footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
    self.listTableView.mj_footer = Footer;

}
- (void)getData {
    self.currenctPageIndex = 1;
    [self getDataWithType:self.currenctType andPageIndex:self.currenctPageIndex];
}
- (void)getMoreData {
    LWLog(@"上拉加载");
    ++self.currenctPageIndex;
    [self getDataWithType:self.currenctType andPageIndex:self.currenctPageIndex];
    
}
- (void)getDataWithType:(int)sortType andPageIndex:(int)pageIndex{
    self.currenctType = sortType;
    self.currenctPageIndex = pageIndex;
    __weak DepartmentViewController * wself = self;
    UserModel * userInfo = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"pageIndex"] = @(pageIndex);
    parame[@"loginCode"] = userInfo.loginCode;
    parame[@"sort"] = @(sortType);
    parame[@"taskId"] = self.taskId;
    parame[@"pid"] = @(self.model.orgid);
    [UserLoginTool loginRequestGet:@"GetGroupPerson" parame:parame success:^(id json) {
        LWLog(@"%@",json);
        if([json[@"resultCode"] integerValue] == 1 ||[json[@"status"] integerValue] == 1){
           NSArray * arrays = [JiTuanModel mj_objectArrayWithKeyValuesArray:json[@"resultData"]];
            if (pageIndex != 1) {
                [_originArray addObjectsFromArray:arrays];
                [wself.listTableView.mj_footer endRefreshing];
            } else {
                [_originArray removeAllObjects];
                [_originArray addObjectsFromArray:arrays];
                [wself.listTableView.mj_header endRefreshing];

            }
            
            [wself.listTableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}
- (void)setInit{
    
    __weak DepartmentViewController * wself = self;
    self.listTableView.tableFooterView = [[UIView alloc] init];
//    self.listTableView.rowHeight = 50;
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
        self.currenctType = 0;
        [self getDataWithType:0 andPageIndex:1];
    }];
    [self.secondLable bk_whenTapped:^{
        LWLog(@"xxx");
        _firstLable.textColor = [UIColor blackColor];
        _secondLable.textColor = [UIColor orangeColor];
        _thirdLable.textColor = [UIColor blackColor];
        _fourthLable.textColor = [UIColor blackColor];
        _fiveLable.textColor = [UIColor blackColor];
        
        _redView.frame = CGRectMake(aa *0.5-aa/2/2+20+aa, _containView.frame.size.height-2, aa / 2 , 2);
        self.currenctType = 0;
        [self getDataWithType:1 andPageIndex:1];
    }];
    [self.thirdLable bk_whenTapped:^{
        LWLog(@"xxx");
        _firstLable.textColor = [UIColor blackColor];
        _secondLable.textColor = [UIColor blackColor];
        _thirdLable.textColor = [UIColor orangeColor];
        _fourthLable.textColor = [UIColor blackColor];
        _fiveLable.textColor = [UIColor blackColor];
        
        _redView.frame = CGRectMake(aa *0.5-aa/2/2+20+2*aa, _containView.frame.size.height-2, aa / 2 , 2);
        self.currenctType = 0;
        [self getDataWithType:2 andPageIndex:1];
    }];
    [self.fourthLable bk_whenTapped:^{
        LWLog(@"xxx");
        _firstLable.textColor = [UIColor blackColor];
        _secondLable.textColor = [UIColor blackColor];
        _thirdLable.textColor = [UIColor blackColor];
        _fourthLable.textColor = [UIColor orangeColor];
        _fiveLable.textColor = [UIColor blackColor];
        
        _redView.frame = CGRectMake(aa *0.5-aa/2/2+20+3*aa, _containView.frame.size.height-2, aa / 2 , 2);
        self.currenctType = 0;
        [self getDataWithType:3 andPageIndex:1];
    }];
    [self.fiveLable bk_whenTapped:^{
        LWLog(@"xxx");
        _firstLable.textColor = [UIColor blackColor];
        _secondLable.textColor = [UIColor blackColor];
        _thirdLable.textColor = [UIColor blackColor];
        _fourthLable.textColor = [UIColor blackColor];
        _fiveLable.textColor = [UIColor orangeColor];
        
        _redView.frame = CGRectMake(aa *0.5-aa/2/2+20+4*aa, _containView.frame.size.height-2, aa / 2 , 2);
        self.currenctType = 0;
        [self getDataWithType:4 andPageIndex:1];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    LWLog(@"%lu",(unsigned long)self.originArray.count);
    return self.originArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DepartmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deCell forIndexPath:indexPath];
    JiTuanModel * model = self.originArray[indexPath.row];
//    if (model.logo.length == 0) {
//        cell.imageVHead.image = [UIImage imageNamed:@"29"];
//    } else {
//        [cell.imageVHead sd_setImageWithURL:[NSURL URLWithString:model.logo]];
//    }
    [cell.imageVHead sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"xiangxtouxiang"]];
    cell.labelName.text = model.name;
    cell.labelDetails.text = [NSString stringWithFormat:@"转发%d次/浏览%d次/伙伴%d人",model.totalTurnCount,model.totalBrowseCount, model.prenticeCount];
    cell.labelScore.text = [NSString stringWithFormat:@"%@积分",[NSString xiaoshudianweishudeal:[model.totalScore floatValue]]];
    return cell;
//    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"jituan"];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"jituan"];
//        UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
//        lable.adjustsFontSizeToFitWidth = YES;
//        cell.accessoryView = lable;
//        lable.textAlignment = NSTextAlignmentRight;
//        lable.text = @"xxx";
//        cell.imageView.frame = CGRectMake(0, 0, 40, 40);
//        cell.imageView.layer.cornerRadius = 20;
//        cell.imageView.layer.masksToBounds = YES;
////        cell.imageView.backgroundColor = [UIColor redColor];
////        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
////        
////        cell.imageView.image = [UIImage imageNamed:@"iconfont-user"];
//
//        
//    }
//    
//    
//    LWLog(@"%@", NSStringFromCGRect(cell.imageView.frame));
//    JiTuanModel * model = self.originArray[indexPath.row];
//    LWLog(@"%@",model.name);
//    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"xiangxtouxiang"]];
////    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:model.logo] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
////        CGSize size = CGSizeMake(40, 40);
////        UIGraphicsBeginImageContextWithOptions(size, NO,0.0);
////        CGRect imageRect=CGRectMake(0.0, 0.0, size.width, size.height);
////        [image drawInRect:imageRect];
////        cell.imageView.image=UIGraphicsGetImageFromCurrentImageContext();
////        UIGraphicsEndImageContext();
////        [cell.imageView layoutIfNeeded];
////    }];
//    cell.textLabel.text =
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"转发%d次/浏览%d次/徒弟%d人",model.totalTurnCount,model.totalBrowseCount, model.prenticeCount];
//    UILabel * aa =  (UILabel *)cell.accessoryView;
//    
//    aa.text = [NSString stringWithFormat:@"%@积分",[NSString xiaoshudianweishudeal:[model.totalScore floatValue]]];
//    return cell;
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
