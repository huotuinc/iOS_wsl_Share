//
//  UserModel.h
//  loveshare
//
//  Created by lhb on 16/3/5.
//  Copyright © 2016年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property(nonatomic,copy) NSString * RealName;
@property(nonatomic,copy) NSString * UserNickName;
@property(nonatomic,assign) BOOL IsBindMobile;
@property(nonatomic,assign) int checkInDays;
@property(nonatomic,assign) int city;
@property(nonatomic,copy) NSString * alipayId;
@property(nonatomic,assign) BOOL completeInfo;
@property(nonatomic,assign) int completeTaskCount;
@property(nonatomic,assign) CGFloat crashCount;
@property(nonatomic,assign) int dayCheckIn ;
@property(nonatomic,assign) int exp;
@property(nonatomic,assign) int favoriteAmount;
@property(nonatomic,assign) int judgeEmulator;
@property(nonatomic,assign) CGFloat lockScore;
@property(nonatomic,copy) NSString * loginCode;
@property(nonatomic,assign) int mallUserId;
@property(nonatomic,copy) NSString * mobile;
@property(nonatomic,copy) NSString * msg;
@property(nonatomic,copy) NSString * msgpicUrl;
/**用户注册时间*/
@property(nonatomic,copy) NSString *regTime;
@property(nonatomic,assign) CGFloat score;
@property(nonatomic,copy) NSString *shareContent;
@property(nonatomic,copy) NSString *shareDes;
@property(nonatomic,assign) int todayBrowseCount;
@property(nonatomic,assign) CGFloat totalScore;
@property(nonatomic,assign) int totalTaskCount;
@property(nonatomic,assign) int turnAmount;
@property(nonatomic,assign) int turnUserId;
@property(nonatomic,copy) NSString *unionId;
@property(nonatomic,copy) NSString *userHead;
@property(nonatomic,copy) NSString *userName;
@property(nonatomic,assign) int welfareCount;
@property(nonatomic,copy) NSString * withdrawalPassword;
@property(nonatomic,assign) CGFloat yesScore;

/**是否是管理员*/
@property(nonatomic,assign) BOOL isSuper;
/**用户密码*/
@property(nonatomic,copy)NSString * UserPassword;
@end
