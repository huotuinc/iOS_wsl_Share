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
}

- (void)setModel:(FollowModel *)model{
    _model = model;
    
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.headFace] placeholderImage:[UIImage imageNamed:@"xiangxtouxiang"]];
    
    self.name.text = [NSString stringWithFormat:@"我的徒弟:%@",model.userName];
    
    self.score.text = [NSString stringWithFormat:@"昨日贡献%@积分",[NSString xiaoshudianweishudeal:[model.recentScore floatValue]]];
    
    
}
@end
