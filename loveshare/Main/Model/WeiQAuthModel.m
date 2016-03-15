//
//  WeiQAuthModel.m
//  loveshare
//
//  Created by lhb on 16/3/6.
//  Copyright © 2016年 HT. All rights reserved.
//  微信授权返回的数据模型

#import "WeiQAuthModel.h"

@implementation WeiQAuthModel
MJCodingImplementation

+ (instancetype)WeiQAuthModelWithDict:(NSDictionary *)dict{
    
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
    WeiQAuthModel * model = [[WeiQAuthModel alloc]  init];
    
    model.city = dict[@"city"];
    model.country =  dict[@"country"];
    model.headimgurl =  dict[@"headimgurl"];
    model.language =  dict[@"language"];
    model.nickname =  dict[@"nickname"];
    model.openid =  dict[@"openid"];
    model.sex = [dict[@"sex"] intValue];
    model.unionid = dict[@"unionid"];
    return model;
}
@end
