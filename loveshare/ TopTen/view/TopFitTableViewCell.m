//
//  TopFitTableViewCell.m
//  loveshare
//
//  Created by lhb on 16/6/7.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "TopFitTableViewCell.h"

@interface TopFitTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;


@property (weak, nonatomic) IBOutlet UILabel *des;
@property (weak, nonatomic) IBOutlet UILabel *nuber;

@end

@implementation TopFitTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDate:(NSDictionary *)date{
    _date = date;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:[date objectForKey:@"logo"]] placeholderImage:nil options:SDWebImageProgressiveDownload];
//    UserModel * userInfo = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    self.nameLable.text = @"我";
    self.des.text = [NSString stringWithFormat:@"累计浏览量:%@",[date objectForKey:@"value"]];
    self.nuber.text = [NSString stringWithFormat:@"第%@名",[date objectForKey:@"rankValue"]];
}
@end
