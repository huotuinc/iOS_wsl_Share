//
//  OptionModel.m
//  loveshare
//
//  Created by lhb on 16/3/7.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "OptionModel.h"

@implementation OptionModel


//  监督管理 更多


+ (NSMutableArray *)OptionModelBringBackArray{
    OptionModel * md1 = [[OptionModel alloc] init];
    md1.optionImageName = @"zx";
    md1.OptionName = @"乐享资讯";
    
    OptionModel * md2 = [[OptionModel alloc] init];
    md2.optionImageName = @"ls";
    md2.OptionName = @"历史浏览";
    
    
    OptionModel * md3 = [[OptionModel alloc] init];
    md3.optionImageName = @"ph";
    md3.OptionName = @"排行榜";
    
    
    OptionModel * md4 = [[OptionModel alloc] init];
    md4.optionImageName = @"bz";
    md4.OptionName = @"本周任务";
    
    
    
    OptionModel * md5 = [[OptionModel alloc] init];
    md5.optionImageName = @"hb";
    md5.OptionName = @"我要推荐";
    
    
    OptionModel * md6 = [[OptionModel alloc] init];
    md6.optionImageName = @"ng";
    md6.OptionName = @"内购商城";
    
    OptionModel * md7 = [[OptionModel alloc] init];
    md7.optionImageName = @"xs";
    md7.OptionName = @"新手指南";
    
    
    OptionModel * md8 = [[OptionModel alloc] init];
    md8.optionImageName = @"gd60X60";
    md8.OptionName = @"更多选项";
    
    
    OptionModel * md9 = [[OptionModel alloc] init];
    md9.optionImageName = @"jd";
    md9.OptionName = @"监督管理";
    
    
    
    NSMutableArray * option = [NSMutableArray arrayWithArray:@[md1,md2,md3,md4,md5,md6, md7, md8, md9]];
    return option;
}
@end
