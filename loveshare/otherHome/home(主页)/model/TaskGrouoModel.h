//
//  TaskGrouoModel.h
//  fanmore---
//
//  Created by lhb on 15/7/30.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NewTaskDataModel;

@interface TaskGrouoModel : NSObject

@property(nonatomic,strong) NSString * timeSectionTitle;

@property(nonatomic,strong) NSMutableArray<NewTaskDataModel *> * tasks;

@end
