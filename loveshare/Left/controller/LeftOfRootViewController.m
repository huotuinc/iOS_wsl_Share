//
//  LeftOfRootViewController.m
//  loveshare
//
//  Created by lhb on 16/3/6.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "LeftOfRootViewController.h"
#import "MMRootViewController.h"
#import <UIViewController+MMDrawerController.h>
@interface LeftOfRootViewController ()<UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *userScore;

@property (weak, nonatomic) IBOutlet UIView *infoView;

@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;

@property (weak, nonatomic) IBOutlet UIView *ceter;

@property (weak, nonatomic) IBOutlet UITableView *optionTable;



@property(nonatomic,strong) NSArray * optionArray;

@end

@implementation LeftOfRootViewController


- (NSArray *)optionArray{
    if (_optionArray == nil) {
        _optionArray = [OptionModel OptionModelBringBackArray];
    }
    return _optionArray;
}

- (void)setup{
    
    self.navigationController.navigationBarHidden = YES;
    self.headImage.layer.cornerRadius = self.headImage.frame.size.height * 0.5;
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.borderWidth = 2;
    self.headImage.layer.borderColor = [UIColor whiteColor].CGColor;
    UserModel * userModel = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:userModel.userHead] placeholderImage:nil completed:nil];
    self.userName.text= userModel.userName;
    self.userScore.text =[NSString stringWithFormat:@"可用分红%@",[NSString xiaoshudianweishudeal:userModel.score]] ;
    
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headImage.userInteractionEnabled = YES;
    [self.headImage bk_whenTapped:^{//个人中心
        NSDictionary * objc = [NSDictionary dictionaryWithObject:@(8) forKey:@"option"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"backToHomeView" object:nil userInfo:objc];
        MMRootViewController * root = (MMRootViewController *)self.mm_drawerController;
        [root setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        [root toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JifenChange) name:@"jichenChange" object:nil];
    self.ceter.hidden = YES;
    self.arrowImage.hidden = YES;
    self.optionTable.backgroundColor = [UIColor clearColor];
    self.optionTable.scrollEnabled = NO;
    self.optionTable.tableFooterView = [[UIView alloc] init];
    self.optionTable.rowHeight = 60;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setup];
}


- (void)JifenChange{
    UserModel * userModel = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:userModel.userHead] placeholderImage:nil completed:nil];
    self.userName.text= userModel.userName;
    self.userScore.text =[NSString stringWithFormat:@"可用分红%@",[NSString xiaoshudianweishudeal:userModel.score]] ;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    
    UserModel * userInfo = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    LWLog(@"%d",userInfo.isSuper);
    return userInfo.isSuper?self.optionArray.count:self.optionArray.count-1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"optioncell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"optioncell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    OptionModel * model  = self.optionArray[indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:model.optionImageName];
    cell.textLabel.text = model.OptionName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {//首页
        case 0:{
            NSDictionary * objc = [NSDictionary dictionaryWithObject:@(0) forKey:@"option"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"backToHomeView" object:nil userInfo:objc];
            MMRootViewController * root = (MMRootViewController *)self.mm_drawerController;
            [root setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
            [root toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
            break;
        }
        case 1:{
            NSDictionary * objc = [NSDictionary dictionaryWithObject:@(1) forKey:@"option"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"backToHomeView" object:nil userInfo:objc];
            MMRootViewController * root = (MMRootViewController *)self.mm_drawerController;
            [root setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
            [root toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
            }];
            break;
        }
        case 2:{
            NSDictionary * objc = [NSDictionary dictionaryWithObject:@(2) forKey:@"option"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"backToHomeView" object:nil userInfo:objc];
            MMRootViewController * root = (MMRootViewController *)self.mm_drawerController;
            [root setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
            [root toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
            }];
            break;
        }
        case 3:{
            NSDictionary * objc = [NSDictionary dictionaryWithObject:@(3) forKey:@"option"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"backToHomeView" object:nil userInfo:objc];
            MMRootViewController * root = (MMRootViewController *)self.mm_drawerController;
            [root toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
            break;
        }
        case 4:{
            NSDictionary * objc = [NSDictionary dictionaryWithObject:@(4) forKey:@"option"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"backToHomeView" object:nil userInfo:objc];
            MMRootViewController * root = (MMRootViewController *)self.mm_drawerController;
            [root toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
            break;
        }
        case 5:{
            NSDictionary * objc = [NSDictionary dictionaryWithObject:@(5) forKey:@"option"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"backToHomeView" object:nil userInfo:objc];
            MMRootViewController * root = (MMRootViewController *)self.mm_drawerController;
            [root toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
            break;
        }
        case 6:{
            NSDictionary * objc = [NSDictionary dictionaryWithObject:@(6) forKey:@"option"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"backToHomeView" object:nil userInfo:objc];
            MMRootViewController * root = (MMRootViewController *)self.mm_drawerController;
            [root toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
            break;
        }
        case 7:{
            NSDictionary * objc = [NSDictionary dictionaryWithObject:@(7) forKey:@"option"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"backToHomeView" object:nil userInfo:objc];
            MMRootViewController * root = (MMRootViewController *)self.mm_drawerController;
            [root toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
            break;
        }
        default:
            break;
    }
    

}

@end
