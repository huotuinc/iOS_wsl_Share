//
//  OptionModel.m
//  loveshare
//
//  Created by lhb on 16/3/7.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "OptionModel.h"

@implementation OptionModel


+ (NSArray *)OptionModelBringBackArray{
    OptionModel * md1 = [[OptionModel alloc] init];
    md1.optionImageName = @"zhuye";
    md1.OptionName = @"领取任务";
    
    OptionModel * md2 = [[OptionModel alloc] init];
    md2.optionImageName = @"shouyi";
    md2.OptionName = @"历史浏览量";
    
    OptionModel * md3 = [[OptionModel alloc] init];
    md3.optionImageName = @"jifen";
    md3.OptionName = @"新手任务";
    
    OptionModel * md4 = [[OptionModel alloc] init];
    md4.optionImageName = @"guanli";
    md4.OptionName = @"进入商城";
    
    OptionModel * md5 = [[OptionModel alloc] init];
    md5.optionImageName = @"yugao";
    md5.OptionName = @"最新预告";
    
    OptionModel * md6 = [[OptionModel alloc] init];
    md6.optionImageName = @"lianmeng";
    md6.OptionName = @"伙伴联盟";
    
    OptionModel * md7 = [[OptionModel alloc] init];
    md7.optionImageName = @"lianmeng";
    md7.OptionName = @"排行榜";
    
    OptionModel * md8 = [[OptionModel alloc] init];
    md8.optionImageName = @"gengduo";
    md8.OptionName = @"更多选项";
    
    OptionModel * md9 = [[OptionModel alloc] init];
    md9.optionImageName = @"vip";
    md9.OptionName = @"监督管理";
    return @[md1,md2,md3,md4,md5,md6,md7,md8, md9];
}
@end
