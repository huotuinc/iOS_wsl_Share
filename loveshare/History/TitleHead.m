//
//  TitleHead.m
//  loveshare
//
//  Created by lhb on 16/3/16.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "TitleHead.h"

@implementation TitleHead

- (void)awakeFromNib{
    
    self.rightLable.layer.cornerRadius = 4;
    self.rightLable.layer.masksToBounds = YES;
}
@end
