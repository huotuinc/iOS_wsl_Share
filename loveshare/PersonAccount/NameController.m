//
//  NameController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/8.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "NameController.h"

@interface NameController ()<UITextFieldDelegate>

@end

@implementation NameController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameLabel.delegate = self;
    self.title = @"姓名";
    [self.nameLabel becomeFirstResponder];

}


- (void)viewWillAppear:(BOOL)animated
{
   
    [super viewWillAppear:animated];
    self.nameLabel.text = self.name;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.delegate respondsToSelector:@selector(NameControllerpickName:)]) {
        [self.delegate NameControllerpickName:self.nameLabel.text];
    }
}

@end
