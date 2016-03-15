//
//  PersonAccountViewController.m
//  loveshare
//
//  Created by lhb on 16/3/8.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "PersonAccountViewController.h"

@interface PersonAccountViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UIImageView *personHeadImage;
@property (weak, nonatomic) IBOutlet UILabel *perosonName;
@property (weak, nonatomic) IBOutlet UILabel *personScore;
@property (weak, nonatomic) IBOutlet UITableView *optionList;
@property (weak, nonatomic) IBOutlet UIButton *outButton;
- (IBAction)outBtnClick:(id)sender;

@property (nonatomic,strong)NSArray *optionArray;
@property (nonatomic,strong)NSArray *optionImageNameArray;


@end

@implementation PersonAccountViewController



- (NSArray *)optionImageNameArray{
    
    if (_optionImageNameArray == nil) {
        
        _optionImageNameArray = @[@"jlsc",@"zh",@"jb",@"xjk"];
    }
    return _optionImageNameArray;
}

- (NSArray *)optionArray{
    if (_optionArray  == nil) {
        
        _optionArray = @[@"进入商城",@"账户安全",@"基本信息",@"积分兑换"];
    }
    return _optionArray;
}

- (void)setup{

    
    self.personHeadImage.layer.cornerRadius = self.personHeadImage.frame.size.height * 0.5;
    self.optionList.scrollEnabled = NO;
    self.personHeadImage.layer.cornerRadius = self.personHeadImage.frame.size.width * 0.5;
    self.personHeadImage.layer.masksToBounds = YES;
    self.personHeadImage.layer.borderWidth = 2;
    self.personHeadImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.personScore.layer.cornerRadius = 3;
    self.personScore.layer.masksToBounds = YES;
    
    self.optionList.dataSource = self;
    self.optionList.delegate = self;
    
    self.optionList.rowHeight = 60;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     [self setup];
    
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    UserModel * user = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"loginCode"] = user.loginCode;
    NSDictionary * dict = [UserLoginTool LogingetDateSyncWith:@"GETUSERINFO" WithParame:parame];
    LWLog(@"%@",dict);
    UserModel * users = [UserModel mj_objectWithKeyValues:dict[@"resultData"]];
    if (users) {
        [UserLoginTool LoginModelWriteToShaHe:users andFileName:RegistUserDate];
    }
    self.personScore.text = [NSString xiaoshudianweishudeal:users.score];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.optionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"xxxxxxx"];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"xxxxxxx"];
    }
    
    cell.imageView.image = [UIImage imageNamed:self.optionImageNameArray[indexPath.row]];
    cell.textLabel.text = self.optionArray[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {//进入商城
        
    }else if(indexPath.row == 1){//账户安全
        
    }else if(indexPath.row == 2){//基本信息
        PersonMessageTableViewController * pers = (PersonMessageTableViewController *)[UserLoginTool LoginCreateControllerWithNameOfStory:nil andControllerIdentify:@"PersonMessageTableViewController"];
        [self.navigationController pushViewController:pers animated:YES];
    }else{//积分兑换
       JiFenToMallController * vc = (JiFenToMallController *)[UserLoginTool LoginCreateControllerWithNameOfStory:nil andControllerIdentify:@"JiFenToMallController"];
        [self.navigationController pushViewController:vc animated:YES];
    }

}


- (IBAction)outBtnClick:(id)sender {
    
    NSString * path =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager * manager = [NSFileManager defaultManager];
    LWLog(@"%@",path);
    [manager removeItemAtPath:path error:nil];
    
    ViewController * vc = (ViewController *)[UserLoginTool LoginCreateControllerWithNameOfStory:nil andControllerIdentify:@"ViewController"];
    [self presentViewController:vc animated:YES completion:nil];
    
}
@end
