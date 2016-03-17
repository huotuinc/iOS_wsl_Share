//
//  DownTudiTableViewCell.m
//  loveshare
//
//  Created by lhb on 16/3/11.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "DownTudiTableViewCell.h"



@interface DownTudiTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *firstLable;
@property (weak, nonatomic) IBOutlet UILabel *secondLable;
@property (weak, nonatomic) IBOutlet UILabel *thirdLable;
@property (weak, nonatomic) IBOutlet UILabel *fourLable;

@end

@implementation DownTudiTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(FollowModel *)model{
    _model = model;
    LWLog(@"%@",[model mj_keyValues]);
    self.firstLable.text = [NSString stringWithFormat:@"%ld/%ld次",(long)[model.yesterdayBrowseAmount integerValue],[model.historyTotalBrowseAmount integerValue]];
    self.secondLable.text = [NSString stringWithFormat:@"%@积分",[NSString xiaoshudianweishudeal:[model.totalScore floatValue]]];
    self.thirdLable.text = [NSString stringWithFormat:@"%ld/%ld次",(long)[model.yesterdayTurnAmount integerValue],[model.historyTotalTurnAmount integerValue]];
    self.fourLable.text = model.time;
    
}
@end
