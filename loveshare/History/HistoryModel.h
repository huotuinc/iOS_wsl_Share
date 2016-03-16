//
//  HistoryModel.h
//  loveshare
//
//  Created by lhb on 16/3/16.
//  Copyright © 2016年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryModel : NSObject



@property(nonatomic,strong) NSNumber *totalScore;
@property(nonatomic,copy) NSString *date;
@property(nonatomic,assign) int browseAmount;
@property(nonatomic,strong)NSArray * awardList;
/*
awardList =                 (
                             {
                                 browseAmount = 0;
                                 date = "2016-02-28 01-00-02";
                                 description = "";
                                 id = 29;
                                 imageUrl = "http://192.168.1.6:8050/resource/taskimg/_104X104.jpg";
                                 taskType = 0;
                                 title = "";
                                 totalScore = 0;
                                 type = 1;
                             }
                             );
browseAmount = 0;
date = "2016-02-28 00-00-00";
totalScore = 0;
},

*/

@end
