//
//  LeftTableViewCell.m
//  loveshare
//
//  Created by lhb on 16/3/21.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "LeftTableViewCell.h" 

@interface LeftTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UILabel *leftName;
@property (weak, nonatomic) IBOutlet UILabel *leftNumver;


@end





@implementation LeftTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(OptionModel *)model{
    _model = model;
    self.textLabel.text = model.OptionName;
    self.imageView.image = [UIImage imageNamed:model.optionImageName];
    
}

@end
