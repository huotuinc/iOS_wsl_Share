//
//  TodayAdvance.h
//  loveshare
//
//  Created by lhb on 16/3/16.
//  Copyright © 2016年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodayAdvance : NSObject

@property(nonatomic,copy) NSString * advancedseconds;
@property(nonatomic,assign) int awardLink;
@property(nonatomic,copy) NSString * awardScan;
@property(nonatomic,assign) int awardSend;
@property(nonatomic,assign) int flagHaveIntro;
@property(nonatomic,assign) int flagLimitCount;
@property(nonatomic,assign) int flagShowSend;
@property(nonatomic,assign) int isFav;
@property(nonatomic,assign) BOOL  isSend;
@property(nonatomic,assign) NSNumber * lastScore;
@property(nonatomic,assign) BOOL online;
@property(nonatomic,copy) NSString * orderTime;
@property(nonatomic,copy) NSString * rebate;
@property(nonatomic,assign) int  sendCount;
@property(nonatomic,copy) NSString * sendList;
@property(nonatomic,assign) int status;
@property(nonatomic,assign) int storeId;
@property(nonatomic,copy) NSString * storeName;
@property(nonatomic,assign) int taskId;
@property(nonatomic,copy) NSString *  taskInfo;
@property(nonatomic,copy) NSString * taskName;
@property(nonatomic,copy) NSString * taskSmallImgUrl;
@property(nonatomic,assign) NSNumber * totalScore;
@property(nonatomic,assign) int type;
@end
