//
//  UserModel.m
//  loveshare
//
//  Created by lhb on 16/3/5.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
MJCodingImplementation


- (NSString *)UserPassword{
    if(_loginCode){
        NSArray * arr = [_loginCode componentsSeparatedByString:@"^"];
        return [arr lastObject];
    }
    return nil;
}
@end
