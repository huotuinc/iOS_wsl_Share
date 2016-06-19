//
//  EnViewCollectionViewCell.m
//  loveshare
//
//  Created by lhb on 16/6/17.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "EnViewCollectionViewCell.h"


@interface EnViewCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UILabel *namelable;

@end


@implementation EnViewCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.logoImage.layer.cornerRadius = 5;
    self.logoImage.layer.masksToBounds = YES;
    // Initialization code
    
    self.logoImage.backgroundColor = [UIColor clearColor];
    
    self.backgroundColor = [UIColor clearColor];
    self.namelable.adjustsFontSizeToFitWidth = YES;
    self.namelable.backgroundColor = [UIColor clearColor];

}

- (void)setModel:(StoreModel *)model{
    _model = model;
    LWLog(@"%@",[model mj_keyValues]);
    [self.logoImage sd_setImageWithURL:[NSURL URLWithString:model.Logo] placeholderImage:nil options:SDWebImageRetryFailed];
    self.namelable.text = model.UserNickName;
}

@end
