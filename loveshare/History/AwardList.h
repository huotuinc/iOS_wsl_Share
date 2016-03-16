//
//  AwardList.h
//  loveshare
//
//  Created by lhb on 16/3/16.
//  Copyright © 2016年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AwardList : NSObject

@property(nonatomic,assign) int browseAmount;
@property(nonatomic,copy) NSString * date;
@property(nonatomic,copy) NSString * taskdesc;
@property(nonatomic,assign) int taskid;
@property(nonatomic,copy) NSString * imageUrl;
@property(nonatomic,assign) int  taskType;
@property(nonatomic,copy) NSString *  title;
@property(nonatomic,strong)NSNumber*  totalScore;
@property(nonatomic,assign) int type;

@end
