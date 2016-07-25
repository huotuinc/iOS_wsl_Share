//
//  PersonData.h
//  loveshare
//
//  Created by lhb on 16/7/8.
//  Copyright © 2016年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonData : NSObject

@property(nonatomic,assign) BOOL IsEnable;

@property(nonatomic,strong) NSString * UserDepath;

@property(nonatomic,strong) NSString * logo;
@property(nonatomic,strong) NSString * name;
/**徒弟数量*/
@property(nonatomic,assign) int prenticeCount;
@property(nonatomic,assign) int totalBrowseCount;
@property(nonatomic,assign) int totalScore;
@property(nonatomic,assign) int totalTurnCount;
@property(nonatomic,strong) NSString * userName;
@property(nonatomic,assign) int userid;


@end
