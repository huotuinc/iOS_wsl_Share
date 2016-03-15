//
//  PersonCenterModel.m
//  loveshare
//
//  Created by lhb on 16/3/9.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "PersonCenterModel.h"
#import "TwoOption.h"

@implementation PersonCenterModel

- (NSDictionary *)objectClassInArray
{
    return @{@"industryList":[TwoOption class],@"favoriteList":[TwoOption class],@"incomeList":[TwoOption class]};
}


@end
