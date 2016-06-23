//
//  RedBagController.m
//  loveshare
//
//  Created by lhb on 16/6/21.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "RedBagController.h"


@interface RedBagController ()

@property(nonatomic,strong) UIImageView * red;

@end


@implementation RedBagController



- (void)viewDidLoad{
    [super viewDidLoad];
    
    UIImageView * red = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hb-1"]];
    _red = red;
    [red sizeToFit];
    
    
    [self.view addSubview:red];
}
@end
