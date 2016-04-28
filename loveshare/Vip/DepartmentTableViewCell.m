//
//  DepartmentTableViewCell.m
//  loveshare
//
//  Created by che on 16/4/28.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "DepartmentTableViewCell.h"

@implementation DepartmentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _labelName.adjustsFontSizeToFitWidth = YES;
    _labelScore.adjustsFontSizeToFitWidth = YES;
    _labelDetails.adjustsFontSizeToFitWidth = YES;
}
- (void)drawRect:(CGRect)rect {
    self.imageVHead.layer.cornerRadius = self.imageVHead.frame.size.height/2;
    self.imageVHead.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
