//
//  JiTuanModel.h
//  loveshare
//
//  Created by lhb on 16/3/15.
//  Copyright © 2016年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JiTuanModel : NSObject
@property(nonatomic,copy)NSString *logo;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,assign) int prenticeCount;
@property(nonatomic,assign) int totalBrowseCount;
@property(nonatomic,assign) int totalTurnCount;
@property(nonatomic,strong) NSNumber * totalScore;
@property(nonatomic,assign) int userid;

@end
