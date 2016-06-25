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
    
//    self.programView.borderLineWidth = 1.0f;
//    UIColor *expectedInitialColor = [UIColor redColor];
//    UIColor *expectedOneThirdColor = [UIColor orangeColor];
//    UIColor *expectedTwoThirdsColor = [UIColor yellowColor];
//    UIColor *expectedFinalColor = [UIColor whiteColor];
    
//    self.programView.initialFillColor = expectedInitialColor;
//    self.programView.oneThirdFillColor = expectedOneThirdColor;
//    self.programView.twoThirdsFillColor = expectedTwoThirdsColor;
//    self.programView.finalFillColor = expectedFinalColor;
//    self.programView.containerColor = [UIColor blueColor];
//    self.programView.labelTextColor = [UIColor greenColor];
//    self.programView.currentValue = 0;
//    self.programView.maximumValue = 100;
//    
//    self.firstlable.textColor = [UIColor redColor];
//    self.programView.layer.borderColor = [UIColor colorWithRed:207/255.0 green:207/255.0 blue:208/255.0 alpha:1].CGColor;
//    self.programView.layer.borderWidth = 0.7;
//    self.programView.borderLineWidth = 0.7;
//    self.programView.containerColor = [UIColor whiteColor];
//    self.programView.finalFillColor = LWRandomColor;
//    self.programView.currentValue = 0;
    self.firstlable.textColor = [UIColor redColor];
    
    
}


- (void)setModel:(WeekModel *)model{
    _model = model;
    
    LWLog(@"%d---%d",model.target,model.myFinishCount);
    self.title.text = model.title;
//    self.programView.maximumValue = model.target;
//    model.myFinishCount = 1;
    
    if (model.myFinishCount>= model.target) {
        self.firstlable.hidden = YES;
        self.second.text = [NSString stringWithFormat:@"已完成"];
        self.second.textColor = [UIColor redColor];
    }else{
        self.firstlable.hidden = NO;
        self.firstlable.text = [NSString stringWithFormat:@"%d",model.myFinishCount];
        self.second.text = [NSString stringWithFormat:@"/%d",model.target];
        self.second.textColor = [UIColor blackColor];

    }
    
    LWLog(@"%d---%d----%d",model.myFinishCount,model.target,(model.myFinishCount * 100 / model.target));

    int current = 0;
    if (model.myFinishCount>0) {
        if (model.myFinishCount > model.target) {
            current = 100;
        }else{
            current =  (100 * (model.myFinishCount * 1.0 /model.target)) ;
        }
        
    }
    [self.programView updateToCurrentValue:current animated:YES];
    
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
