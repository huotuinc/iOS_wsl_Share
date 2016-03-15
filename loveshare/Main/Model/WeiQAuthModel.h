//
//  WeiQAuthModel.h
//  loveshare
//
//  Created by lhb on 16/3/6.
//  Copyright © 2016年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiQAuthModel : NSObject


/**
 city = "";
 country = CN;
 headimgurl = "http://wx.qlogo.cn/mmopen/V6Kz8lZhPChECnQOjicvbyG0CW4HAy2XXzoZgHFwfp1pqp9AhLL4KIra0bWp29dpCFkndylH2IjQn9VZic6FqKfYjQV2ztNslW/0";
 language = "zh_CN";
 nickname = cosy;
 openid = omStCwjDZ5qRtpaZFtsZaNB9DVqc;
 privilege =     (
 );
 province = "";
 sex = 0;
 unionid = "oecoZv5Gp5XxWh38L7rR0Dx_kNxs";
 */

@property(nonatomic,copy) NSString * city;
@property(nonatomic,copy) NSString * country;
@property(nonatomic,copy) NSString * headimgurl;
@property(nonatomic,copy) NSString * language;
@property(nonatomic,copy) NSString * nickname;
@property(nonatomic,copy) NSString * openid;
@property(nonatomic,copy) NSString * unionid;
@property(nonatomic,copy) NSString * province;
@property(nonatomic,assign) int sex;


+ (instancetype)WeiQAuthModelWithDict:(NSDictionary *)dict;
@end
