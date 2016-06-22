//
//  WeekTableViewCell.m
//  loveshare
//
//  Created by lhb on 16/6/18.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "WeekTableViewCell.h"

@interface WeekTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *firstlable;
@property (weak, nonatomic) IBOutlet UILabel *second;
@property (weak, nonatomic) IBOutlet EAColourfulProgressView *programView;


@end


@implementation WeekTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.programView.layer.borderColor = [UIColor colorWithRed:207/255.0 green:207/255.0 blue:208/255.0 alpha:1].CGColor;
    self.programView.layer.borderWidth = 0.7;
    self.programView.borderLineWidth = 0.7;
    self.programView.containerColor = [UIColor whiteColor];
    self.programView.finalFillColor = LWRandomColor;
    self.programView.currentValue = 0;
    self.firstlable.textColor = LWRandomColor;
    
}


- (void)setModel:(WeekModel *)model{
    _model = model;
    
    LWLog(@"%d---%d",model.target,model.myFinishCount);
    self.title.text = model.title;
    self.firstlable.text = [NSString stringWithFormat:@"%d",model.myFinishCount];
    self.second.text = [NSString stringWithFormat:@"/%d",model.target];
    
    self.programView.maximumValue = model.target;
    
    [self.programView updateToCurrentValue:(model.myFinishCount) animated:YES];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
