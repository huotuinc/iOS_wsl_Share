//
//  TaskGrouoModel.m
//  fanmore---
//
//  Created by lhb on 15/7/30.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "TaskGrouoModel.h"

@implementation TaskGrouoModel


- (NSString *)timeSectionTitle{
    
    if (_timeSectionTitle.length) {
        
       return [[_timeSectionTitle componentsSeparatedByString:@" "] firstObject];
    }
    
    return _timeSectionTitle;
    
}
- (instancetype)init{
    
    if (self = [super init]) {
        _tasks = [NSMutableArray array];
    }
    return self;
}
@end
