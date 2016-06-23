//
//  LinePoint.m
//  loveshare
//
//  Created by lhb on 16/6/16.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "LinePoint.h"
#import "PLineView.h"

#import "ANDLineChartView.h"
#import "BCPNChartView.h"


@interface LinePoint ()<ANDLineChartViewDataSource,ANDLineChartViewDelegate>



@property(nonatomic,strong) UILabel *score;

@property(nonatomic,strong) UILabel *time;


@property(nonatomic,assign) int cureSecontion;


@property (nonatomic,strong) BCPNChartView * chartView;


@property (nonatomic,strong) NSMutableArray * countaaa;

@property (nonatomic,strong) NSMutableArray * date;



@end


@implementation LinePoint


- (NSMutableArray *)date{
    if (_date == nil) {
        
        _date = [NSMutableArray array];
    }
    return _date;
    
}


- (NSMutableArray *)countaaa{
    if (_countaaa == nil) {
        
        _countaaa = [NSMutableArray array];
    }
    
    return _countaaa;
}


- (instancetype)initWithFrame:(CGRect)frame{
    
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:246/255.0];
        _cureSecontion = -1;
        
        
        
        UILabel * score = [[UILabel alloc] init];
        score.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:246/255.0];
        _score = score;
        score.adjustsFontSizeToFitWidth = YES;
        score.textAlignment = NSTextAlignmentCenter;
        [self addSubview:score];
        
        [score setTextColor:[UIColor blackColor]];
        
        UILabel * time = [[UILabel alloc] init];
        time.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:246/255.0];
        _time = time;
        time.adjustsFontSizeToFitWidth = YES;
        time.textAlignment = NSTextAlignmentCenter;
        [time setTextColor:[UIColor blackColor]];
        [self addSubview:time];

    }
    
    return self;
    
}


- (void)setDatas:(NSArray<HistoryModel *> *)datas{
   
    _datas = datas;
    
    if (datas.count) {
        self.chartView = [[BCPNChartView alloc] initBCPNChartViewWithArray:self.datas];
        self.chartView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 30);
        
        self.score.frame = CGRectMake(0, CGRectGetMaxY(self.chartView.frame), self.frame.size.width, 15);
        self.time.frame = CGRectMake(0, CGRectGetMaxY(self.score.frame), self.frame.size.width, 15);
        
        [self addSubview:_chartView];
    }else{
        
        
    }
    
    
//    LWLog(@"%lu",(unsigned long)datas.count);
//    if (datas.count) {
//        for (int i = 0; i<datas.count; i++) {
//            HistoryModel * model = [datas objectAtIndex:i];
//            LWLog(@"%@",[model mj_keyValues]);
//            
//            LWLog(@"%d",model.browseAmount);
//            
//            [self.countaaa addObject:[NSString stringWithFormat:@"%d",model.browseAmount]];
//            [self.date addObject:[[model.date componentsSeparatedByString:@" "] firstObject]];
//        }
//        
//        LWLog(@"-----%lu",(unsigned long)self.countaaa.count);
//        LWLog(@"------%lu",(unsigned long)self.date.count);
//        [self.chartView reloadData];
//
//    }
    
    
}

- (void)setIndex:(NSIndexPath *)index{ //to 刷新数据
    _index = index;
    if (_cureSecontion != index.section) {
        HistoryModel * model = [self.datas objectAtIndex:index.section];
        
        LWLog(@"%@",[model mj_keyValues]);
         _score.text = [NSString stringWithFormat:@"%d",model.browseAmount];
        
        _time.text = [NSString stringWithFormat:@"时间:%@",[[model.date componentsSeparatedByString:@" "] firstObject]];
        _cureSecontion = index.section;
    }
    
    
}

- (NSUInteger)numberOfElementsInChartView:(ANDLineChartView *)chartView{
    
    if (self.date.count) {
         return self.date.count;
    }
    return 0;
}


- (CGFloat)minValueForGridIntervalInChartView:(ANDLineChartView *)chartView{
    
    return 0.0;
}

- (CGFloat)chartView:(ANDLineChartView *)chartView valueForElementAtRow:(NSUInteger)row{
    
    if (self.countaaa.count) {
        return [[self.countaaa objectAtIndex:row] floatValue];
    }
    
    return 0;
    
}


- (CGFloat)maxValueForGridIntervalInChartView:(ANDLineChartView *)chartView{
    
    return self.max;
}
//- (void)layoutSubviews{
//    
//    [super layoutSubviews];
//    
//    LWLog(@"%@",NSStringFromCGRect(self.frame));
//   
////    _score.frame = CGRectMake(0, self.frame.size.height - 30, self.frame.size.width, 15);
////    _time.frame = CGRectMake(0, self.frame.size.height - 15, self.frame.size.width, 15);
//}

@end
