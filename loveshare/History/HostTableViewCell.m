//
//  HostTableViewCell.m
//  loveshare
//
//  Created by lhb on 16/3/16.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "HostTableViewCell.h"


@interface HostTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *topRightLable;
@property (weak, nonatomic) IBOutlet UIImageView *HeadimageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *souyilable;

@property (weak, nonatomic) IBOutlet UILabel *browLable;

@property (weak, nonatomic) IBOutlet UIView *contaivciew;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;

@end



@implementation HostTableViewCell

- (void)awakeFromNib {
    
    self.contaivciew.layer.cornerRadius = 5;
    self.contaivciew.layer.masksToBounds = YES;
    self.HeadimageView.layer.cornerRadius = self.HeadimageView.frame.size.height * 0.5;
    self.HeadimageView.layer.masksToBounds = YES;
}

- (void)setModel:(AwardList *)model{
    _model = model;
    NSDictionary * dict = [model mj_keyValues];
   
    
    
    NSString * time = [dict objectForKey:@"date"];
    time = [[time componentsSeparatedByString:@" "] firstObject];
    self.timeLable.text = [NSString stringWithFormat:@"%@ ",time];
    
    [self.HeadimageView sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"imageUrl"]] placeholderImage:nil];
    
    self.browLable.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"browseAmount"]];
    
    self.nameLable.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"title"]];
    
    self.subTitle.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"taskdesc"]];
    
    self.souyilable.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"totalScore"]];
}
@end
