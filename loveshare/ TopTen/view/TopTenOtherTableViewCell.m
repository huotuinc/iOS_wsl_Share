//
//  TopTenOtherTableViewCell.m
//  loveshare
//
//  Created by lhb on 16/6/7.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "TopTenOtherTableViewCell.h"


@interface TopTenOtherTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *namelable;
@property (weak, nonatomic) IBOutlet UILabel *times;

@end


@implementation TopTenOtherTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDate:(OtherTenModel *)date{
    
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:date.logo] placeholderImage:nil options:SDWebImageRetryFailed];
    self.headImage.backgroundColor = LWRandomColor;
    self.namelable.text = [NSString stringWithFormat:@"%@",date.name];
    self.times.text = [NSString stringWithFormat:@"%@次",date.value];
}

@end
