//
//  MyNewTudiListcell.m
//  loveshare
//
//  Created by lhb on 16/6/24.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "MyNewTudiListcell.h"

@interface MyNewTudiListcell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *firstLable;
@property (weak, nonatomic) IBOutlet UILabel *secondLable;

@end

@implementation MyNewTudiListcell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconView.layer.cornerRadius = 30;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.borderWidth = 2;
    self.iconView.layer.borderColor = [UIColor whiteColor].CGColor;
    
}


- (void)setModel:(FollowModel *)model{
    
    _model = model;
    LWLog(@"%@",[model mj_keyValues]);
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.headFace] placeholderImage:[UIImage imageNamed:@"xiangxtouxiang"] options:SDWebImageRetryFailed];
    
    self.nameLable.text = model.userName;
    
    self.firstLable.text = [NSString stringWithFormat:@"%@/%@次",model.yesterdayBrowseAmount,model.yesterdayTurnAmount];
    self.secondLable.text = [NSString stringWithFormat:@"%@/%@次",model.historyTotalBrowseAmount,model.historyTotalTurnAmount];}

@end
