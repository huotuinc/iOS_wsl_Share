//
//  JiTuan.h
//  loveshare
//
//  Created by lhb on 16/3/14.
//  Copyright © 2016年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JiTuan : NSObject


/**组织编号*/
@property(nonatomic,assign)int orgid;
/**组织级别*/
@property(nonatomic,assign)int level;
/**组织名称*/
@property(nonatomic,copy) NSString *logo;
/**组织人数*/
@property(nonatomic,copy) NSString *name;
/**总浏览数量*/
@property(nonatomic,assign)int personCount;
/**总转发数量*/
@property(nonatomic,assign)int totalBrowseCount;
/**组织编号*/
@property(nonatomic,assign)int totalTurnCount;

@property (nonatomic, strong) NSNumber *children;//o没有，1有

@end
