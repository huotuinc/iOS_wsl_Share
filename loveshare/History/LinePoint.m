//
//  LinePoint.m
//  loveshare
//
//  Created by lhb on 16/6/16.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "LinePoint.h"
#import "PLineView.h"
#import "BCPNChartView.h"
@interface LinePoint ()


@property(nonatomic,strong) UILabel *score;

@property(nonatomic,strong) UILabel *time;


@property(nonatomic,assign) int cureSecontion;


@property(nonatomic,strong) PLineView * aa;

@end


@implementation LinePoint


- (instancetype)initWithFrame:(CGRect)frame{
    
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor blueColor];
        _cureSecontion = -1;
        
        PLineView * aa = [[PLineView alloc] init];
        _aa = aa;
        aa.backgroundColor = [UIColor greenColor];
        [self addSubview:aa];
        
        UILabel * score = [[UILabel alloc] init];
        score.backgroundColor = [UIColor clearColor];
        _score = score;
        score.adjustsFontSizeToFitWidth = YES;
        score.textAlignment = NSTextAlignmentCenter;
        [self addSubview:score];
        
        [score setTextColor:[UIColor whiteColor]];
        
        UILabel * time = [[UILabel alloc] init];
        time.backgroundColor = [UIColor clearColor];
        _time = time;
        time.adjustsFontSizeToFitWidth = YES;
        time.textAlignment = NSTextAlignmentCenter;
        [time setTextColor:[UIColor whiteColor]];
        [self addSubview:time];

    }
    
    return self;
    
}


- (void)setDatas:(NSArray<HistoryModel *> *)datas{
    
    
    
    
    _aa.max = _max;
    
    _datas = datas;
    NSMutableArray * count = [NSMutableArray array];
    if (datas.count) {
        for (int i = 0; i<datas.count; i++) {
            HistoryModel * model = [datas objectAtIndex:i];
            [count addObject:@(model.browseAmount)];
            
        }
        
        _aa.date = count;
    }
    
    
}

- (void)setIndex:(NSIndexPath *)index{ //to 刷新数据
    _index = index;
    
    if (_cureSecontion != index.section) {
        HistoryModel * model = [self.datas objectAtIndex:index.section];
        
        LWLog(@"%@",[model mj_keyValues]);
         _score.text = [NSString stringWithFormat:@"%@",model.totalScore];
        
        _time.text = [NSString stringWithFormat:@"时间:%@",[[model.date componentsSeparatedByString:@" "] firstObject]];
        _cureSecontion = index.section;
    }
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    LWLog(@"%@",NSStringFromCGRect(self.frame));
    _aa.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 30);
    _score.frame = CGRectMake(0, self.frame.size.height - 30, self.frame.size.width, 15);
    _time.frame = CGRectMake(0, self.frame.size.height - 15, self.frame.size.width, 15);
}

@end
