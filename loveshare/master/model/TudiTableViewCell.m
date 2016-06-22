//
//  TudiTableViewCell.m
//  loveshare
//
//  Created by lhb on 16/3/11.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "TudiTableViewCell.h"

@interface TudiTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *score;


@end

@implementation TudiTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.headImage.layer.cornerRadius = self.headImage.frame.size.height * 0.5;
    self.headImage.layer.masksToBounds = YES;
}

- (void)setModel:(FollowModel *)model{
    _model = model;
    
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.headFace] placeholderImage:[UIImage imageNamed:@"xiangxtouxiang"]];
    
    self.name.text = [NSString stringWithFormat:@"我的伙伴:%@",model.userName];
    
    self.score.text = [NSString stringWithFormat:@"昨日贡献%@积分",[NSString xiaoshudianweishudeal:[model.recentScore floatValue]]];
    
    
}
@end
