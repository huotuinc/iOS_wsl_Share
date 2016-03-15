//
//  PersonViewController.m
//  loveshare
//
//  Created by lhb on 16/3/15.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "PersonViewController.h"

@interface PersonViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@property (weak, nonatomic) IBOutlet UILabel *scoreJifen;


@property (weak, nonatomic) IBOutlet UILabel *turnLable;


@property (weak, nonatomic) IBOutlet UILabel *browsLable;


@property (weak, nonatomic) IBOutlet UILabel *tudiLable;


@property (weak, nonatomic) IBOutlet UILabel *firstLable;

@property (weak, nonatomic) IBOutlet UILabel *secondLable;

@property (weak, nonatomic) IBOutlet UITableView *listLable;
@property (weak, nonatomic) IBOutlet UILabel *sssssss;

@property (weak, nonatomic) IBOutlet UIView *containView;

@property(nonatomic,strong) UIView *redView;
@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setUp];
    
    
}

- (void)setUp{
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    
    self.headImage.layer.cornerRadius = self.headImage.frame.size.height * 0.5;
    self.headImage.layer.masksToBounds = YES;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:self.model.logo] placeholderImage:nil];
    
    self.sssssss.text = self.xixi;
    
    self.turnLable.text = [NSString stringWithFormat:@" 转发%d次",self.model.totalTurnCount];
    self.browsLable.text = [NSString stringWithFormat:@" 浏览%d次",self.model.totalBrowseCount];
    self.tudiLable.text = [NSString stringWithFormat:@" 徒弟%d人",self.model.prenticeCount];
    self.scoreJifen.text = [NSString stringWithFormat:@"%@积分",[NSString xiaoshudianweishudeal:[self.model.totalScore floatValue]]];
    self.firstLable.userInteractionEnabled = YES;
    self.secondLable.userInteractionEnabled = YES;
    
    self.tudiLable.adjustsFontSizeToFitWidth = YES;
    self.browsLable.adjustsFontSizeToFitWidth = YES;
    self.tudiLable.adjustsFontSizeToFitWidth = YES;
    CGFloat aa  = (ScreenWidth - 60.0) / 2;
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor orangeColor];
    self.firstLable.textColor = [UIColor orangeColor];
    view.frame = CGRectMake(aa *0.5-aa/2/2+30, _containView.frame.size.height-2, aa / 2 , 2);
    [_containView addSubview:view];
    _redView = view;
    
    
    [self.firstLable bk_whenTapped:^{
        _firstLable.textColor = [UIColor orangeColor];
        _secondLable.textColor = [UIColor blackColor];
        _redView.frame = CGRectMake(aa *0.5-aa/2/2+30, _containView.frame.size.height-2, aa / 2 , 2);
    }];
    
    [self.secondLable bk_whenTapped:^{
        _firstLable.textColor = [UIColor blackColor];
        _secondLable.textColor = [UIColor orangeColor];
        _redView.frame = CGRectMake(aa *0.5-aa/2/2+30+aa, _containView.frame.size.height-2, aa / 2 , 2);

    }];
    
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
