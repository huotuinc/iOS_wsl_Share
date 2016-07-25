//
//  AdList.h
//  loveshare
//
//  Created by lhb on 16/7/7.
//  Copyright © 2016年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdListModel : NSObject

@property(nonatomic,strong) NSString * itemCreateTime;

@property(nonatomic,assign) int itemId;
@property(nonatomic,strong) NSString * itemImgDescLink;
@property(nonatomic,strong) NSString * itemImgUrl;
@property(nonatomic,assign) int itemShowSort;
@property(nonatomic,assign) int itemShowTime;



@end
