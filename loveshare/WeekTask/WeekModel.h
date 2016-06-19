//
//  WeekModel.h
//  loveshare
//
//  Created by lhb on 16/6/18.
//  Copyright © 2016年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeekModel : NSObject

/**
 *  操作类型
 */
@property(nonatomic,assign) int actionType;

@property(nonatomic,strong) NSString * createtime;

@property(nonatomic,assign) int weekid;

/**
 *  完成数
 */
@property(nonatomic,assign) int myFinishCount;
@property(nonatomic,assign) float reward;
@property(nonatomic,assign) int sort;
/**
 *  需求
 */
@property(nonatomic,assign) int target;

/**
 *  任务名称
 */
@property(nonatomic,strong) NSString * title;
@end
