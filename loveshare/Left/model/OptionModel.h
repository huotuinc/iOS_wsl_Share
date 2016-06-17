//
//  OptionModel.h
//  loveshare
//
//  Created by lhb on 16/3/7.
//  Copyright © 2016年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OptionModel : NSObject


@property(nonatomic,copy)NSString * optionImageName;
@property(nonatomic,copy)NSString * OptionName;



+ (NSMutableArray *)OptionModelBringBackArray;
@end
