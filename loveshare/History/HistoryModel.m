//
//  HistoryModel.m
//  loveshare
//
//  Created by lhb on 16/3/16.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "HistoryModel.h"
#import "AwardList.h"
@implementation HistoryModel

- (NSDictionary *)objectClassInArray
{
    return @{@"awardList":[AwardList class]};
}

@end
