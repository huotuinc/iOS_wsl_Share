//
//  TopTenModel.h
//  loveshare
//
//  Created by lhb on 16/6/7.
//  Copyright © 2016年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OtherTenModel.h"
@interface TopTenModel : NSObject

@property(nonatomic,strong) NSDictionary * myRank;
@property(nonatomic,strong) NSArray <OtherTenModel *>* rankList;

@end
