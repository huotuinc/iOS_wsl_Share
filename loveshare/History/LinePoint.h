//
//  LinePoint.h
//  loveshare
//
//  Created by lhb on 16/6/16.
//  Copyright © 2016年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryModel.h"

@interface LinePoint : UIView



@property(nonatomic,strong) NSArray<HistoryModel *>*datas;


@property(nonatomic,strong) NSIndexPath * index;


@property(nonatomic,assign) long  max;

@property(nonatomic,assign) long min;


@property(nonatomic,assign) int totalCount;

@end
