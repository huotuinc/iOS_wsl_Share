//
//  HomeCell.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/5/25.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "HomeCell.h"

@interface HomeCell ()
/**
 *  showImage 图片
 *  nameLabel 名字
 *  timeLabel 时间
 *  receiveLabel 可领取的流量
 *  joinLabel 参与人数
 *  introduceLabel 店铺简介
 *  getImage 领取标识图片
 *  topImage 置顶标签
 */
@property (weak, nonatomic) IBOutlet UIImageView *showImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *joinLabel;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *getImage;
@property (weak, nonatomic) IBOutlet UIImageView *topImage;
@property (weak, nonatomic) IBOutlet UILabel *lastLabel;
@end

@implementation HomeCell


- (void)setModel:(NewTaskDataModel *)model{
    _model = model;
    
    [_showImage sd_setImageWithURL:[NSURL URLWithString:model.taskSmallImgUrl] placeholderImage:nil];
    
    _nameLabel.text = model.taskName;
    _timeLabel.text = model.orderTime;
    _receiveLabel.text = [NSString xiaoshudianweishudeal:model.awardSend];
    _joinLabel.text = [NSString stringWithFormat:@"%@",model.sendCount];
    _introduceLabel.text = [NSString stringWithFormat:@"由[%@]提供",model.storeName?model.storeName:@"万事利"];
    
    if (model.sendList.length) {
        _getImage.image = [UIImage imageNamed:@"已完成"];
    }else if(model.lastScore <= 0.001){
        _getImage.image = [UIImage imageNamed:@"已领完"];
    }else{
        _getImage.image = nil;
    }
   
    _lastLabel.text = [NSString stringWithFormat:@"参与,剩余%@积分", [NSString xiaoshudianweishudeal:model.lastScore]];
}
//
//
//
- (void)awakeFromNib {
    // Initialization code
    self.receiveLabel.layer.borderColor = [UIColor redColor].CGColor;
    self.receiveLabel.layer.borderWidth = 1;
    self.receiveLabel.layer.cornerRadius = 5.0;
    self.showImage.layer.cornerRadius = self.showImage.frame.size.height * 0.5;
    self.showImage.layer.masksToBounds = YES;
    self.backgroundView.layer.cornerRadius = 5;
    self.backgroundView.layer.masksToBounds = YES;
    
    self.contentView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
}


@end
