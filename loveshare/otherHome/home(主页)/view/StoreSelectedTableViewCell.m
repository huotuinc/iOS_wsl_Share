//
//  StoreSelectedTableViewCell.m
//  loveshare
//
//  Created by che on 16/5/12.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "StoreSelectedTableViewCell.h"

@implementation StoreSelectedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)loadData:(StoreModel *)model {
    [_imageVLogo sd_setImageWithURL:[NSURL URLWithString:model.Logo]];
    _labelName.text = model.UserNickName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
