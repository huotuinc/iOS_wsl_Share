//
//  NewTaskDataModel.h
//  loveshare
//
//  Created by lhb on 16/3/7.
//  Copyright © 2016年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewTaskDataModel : NSObject



@property(nonatomic,strong) NSString * advancedseconds;
/**外链奖励*/
@property(nonatomic,assign) CGFloat awardLink;
/** 浏览奖励*/
@property(nonatomic,assign) CGFloat awardScan;

/**积分奖励描述-转发奖励*/
@property(nonatomic,assign) CGFloat awardSend;
@property(nonatomic,assign) int flagHaveIntro;
@property(nonatomic,assign) int flagLimitCount;

/**
 0、隐藏
 1、显示
*/
@property(nonatomic,assign) int flagShowSend;

@property(nonatomic,assign) BOOL isFav;

/**是否已转发*/
@property(nonatomic,assign) BOOL isSend;
@property(nonatomic,assign) int online;
/**剩余积分*/
@property(nonatomic,assign) CGFloat lastScore;
@property(nonatomic,strong) NSString * orderTime;
@property(nonatomic,assign) CGFloat rebate ;

@property(nonatomic,strong) NSNumber * sendCount;
/**转发渠道*/
@property(nonatomic,strong) NSString * sendList;


@property(nonatomic,assign) int status;

/**商家id*/
@property(nonatomic,assign) int  storeId;

/**商家名称*/
@property(nonatomic,strong) NSString * storeName;

/**任务号*/
@property(nonatomic,assign) int taskId;

/**任务内容(转发内容地址)*/
@property(nonatomic,strong) NSString * taskInfo;

/**任务名称*/
@property(nonatomic,strong) NSString *   taskName;

/**任务图url（小图）*/
@property(nonatomic,strong) NSString *  taskSmallImgUrl;
/**任务总分数*/
@property(nonatomic,assign) CGFloat  totalScore;
/**任务类型*/
@property(nonatomic,assign) int type;


/**
 {





 = "\U4e07\U4e8b\U5229";
= 41;
= "";
 = "\U738b\U77f3\Uff1a\U8001\U677f\U9009\U4eba\Uff0c\U6709\U4e00\U6837\U4e1c\U897f\U6bd4\U80fd\U529b\U66f4\U91cd\U8981\Uff01";
@property(nonatomic,strong) NSString *  taskSmallImgUrl = "http://192.168.1.56:8050/resource/taskimg/41e21c68a59d4f0e835570c84b3cdfd6_104X104.jpg";
@property(nonatomic,assign) CGFloat  totalScore = 66;
@property(nonatomic,assign) int type = 999999;
 }
 */
@end
