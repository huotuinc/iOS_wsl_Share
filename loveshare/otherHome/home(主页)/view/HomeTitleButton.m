//
//  HomeTitleButton.m
//  loveshare
//
//  Created by lhb on 16/5/17.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "HomeTitleButton.h"

#define XMGCommonMargin 2

@implementation HomeTitleButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}



- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    
//    LWLog(@"%@",NSStringFromCGSize(self.frame.size));
    
    if (self.imageView.image == nil) return;
    
    
//    self.titleLabel.text boundingRectWithSize:<#(CGSize)#> options:<#(NSStringDrawingOptions)#> attributes:<#(nullable NSDictionary<NSString *,id> *)#> context:<#(nullable NSStringDrawingContext *)#>
    
    self.titleLabel.xmg_right = self.xmg_centerX;
    // 调整Label
//    self.titleLabel.xmg_x =  XMGCommonMargin;
    
    // 调整imageView
    self.imageView.xmg_x =self.xmg_centerX;
    
    
   

}
@end
