//
//  TodayTableViewCell.m
//  loveshare
//
//  Created by lhb on 16/3/16.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "TodayTableViewCell.h"


@interface TodayTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UILabel *totleScore;

@property (weak, nonatomic) IBOutlet UILabel *lastScore;

@property (weak, nonatomic) IBOutlet UILabel *timeLable;

@property (weak, nonatomic) IBOutlet UIView *containview;

@end


@implementation TodayTableViewCell

- (void)awakeFromNib {
    
    self.headImage.layer.cornerRadius = self.headImage.frame.size.height * 0.5;
    self.headImage.layer.masksToBounds = YES;
    
    self.containview.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    LWLog(@"xxx");
    // Configure the view for the selected state
}


- (void)setModel:(TodayAdvance *)model{
    _model = model;
    
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.taskSmallImgUrl] placeholderImage:nil];
    self.titleLable.text = model.taskName;
    self.totleScore.text = [NSString stringWithFormat:@"总积分:%@",[NSString xiaoshudianweishudeal:[model.totalScore floatValue]]];
    self.lastScore.text = [NSString stringWithFormat:@"剩余积分:%@",[NSString xiaoshudianweishudeal:[model.lastScore floatValue]]];
    self.timeLable.text = [NSString stringWithFormat:@"正式上线时间%@",model.orderTime];
}
@end
