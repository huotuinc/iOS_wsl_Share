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
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *showImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
;
@property (weak, nonatomic) IBOutlet UILabel *joinLabel;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *getImage;
@property (weak, nonatomic) IBOutlet UIImageView *topImage;
@property (weak, nonatomic) IBOutlet UILabel *lastLabel;
@end

@implementation HomeCell


- (void)setModel:(NewTaskDataModel *)model{
    _model = model;
    
    
    LWLog(@"%@",[model mj_keyValues]);
    
    [_showImage sd_setImageWithURL:[NSURL URLWithString:model.taskSmallImgUrl] placeholderImage:[UIImage imageNamed:@"Show Image"]];
    
    _nameLabel.text = model.taskName;
   
    _joinLabel.text = [NSString stringWithFormat:@"%@",model.sendCount];
    _introduceLabel.text = [NSString stringWithFormat:@"由[%@]提供",model.storeName?model.storeName:@"分红"];
    
    if (model.sendList.length) {
        _getImage.image = [UIImage imageNamed:@"已完成"];
    }else if(model.lastScore <= 0.001){
        _getImage.image = [UIImage imageNamed:@"已领完"];
    }else{
        _getImage.image = nil;
    }
   
    _joinLabel.text = [NSString stringWithFormat:@"%@", model.browseCount];
    _lastLabel.text = [NSString stringWithFormat:@"%@", model.sendCount];
}
//
//
//
- (void)awakeFromNib {
    
    self.showImage.layer.borderWidth = 2;
    self.showImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.showImage.layer.cornerRadius = self.showImage.frame.size.height * 0.5;
    self.showImage.layer.masksToBounds = YES;
    
    
    self.bgView.layer.cornerRadius = 3;
    self.bgView.layer.masksToBounds = YES;
    
}


@end
