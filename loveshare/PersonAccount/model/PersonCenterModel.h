//
//  PersonCenterModel.h
//  loveshare
//
//  Created by lhb on 16/3/9.
//  Copyright © 2016年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonCenterModel : NSObject


@property(nonatomic,copy) NSString * phone;
@property(nonatomic,copy) NSString * name;
@property(nonatomic,assign) int sex;
@property(nonatomic,copy) NSString * birth;
@property(nonatomic,assign) int industryId;
@property(nonatomic,copy) NSString *industry;
@property(nonatomic,assign) int favoriteId;
@property(nonatomic,copy) NSString * favorite;
@property(nonatomic,assign)int incomeId;
@property(nonatomic,copy) NSString* income;
@property(nonatomic,strong) NSArray * industryList;
@property(nonatomic,strong) NSArray * favoriteList;
@property(nonatomic,strong) NSArray * incomeList;

@end
