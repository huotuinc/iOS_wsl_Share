//
//  BCPNChartView.m
//  loveshare
//
//  Created by che on 16/5/6.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "BCPNChartView.h"



@implementation BCPNChartView{
    NSArray *_bcDataArray;

}

- (instancetype)initBCPNChartViewWithArray:(NSArray *)dataArray {
    if (self = [super init]) {
        _bcDataArray = dataArray;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT / 3);
        [self lineChart];
    }
    
  
    return self;
}

- (PNLineChart *)lineChart {
    if (_lineChart == nil) {
        PNLineChart * lineChart = [[PNLineChart alloc]initWithFrame:CGRectMake(5,0,SCREEN_WIDTH-10,SCREEN_HEIGHT / 3-35)];
        
        
        
        //X轴数据
        [lineChart setXLabels:self.bcTitleArray];
        
        //Y轴数据
        NSArray * data01Array =self.bcPointArray;
        PNLineChartData *data01 = [PNLineChartData new];
        data01.color = [UIColor colorWithRed:0 green:193/255.0 blue:208/255 alpha:1];
        data01.itemCount = lineChart.xLabels.count;
//        data01.getData =
        
        data01.getData = ^(NSUInteger index) {
            CGFloat yValue = [data01Array[index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };
        lineChart.chartData = @[data01];
        [lineChart strokeChart];
        //加载在视图上
        [self addSubview:lineChart];
    }
    return _lineChart;
}
- (NSMutableArray *)bcPointArray {
    if (_bcPointArray == nil) {
        _bcPointArray = [NSMutableArray array];
        for (HistoryModel *item in _bcDataArray) {
            [_bcPointArray addObject:item.totalScore];
        }
    }
    _bcPointArray = [NSMutableArray arrayWithArray:_bcPointArray.reverseObjectEnumerator.allObjects];
    return _bcPointArray;

}

- (NSMutableArray *)bcTitleArray {
    if (_bcTitleArray == nil) {
        _bcTitleArray = [NSMutableArray array];
        for (int i = 0; i < _bcDataArray.count; i++) {
            HistoryModel *model = _bcDataArray[i];
            [_bcTitleArray addObject:model.date];
        }
        for (int i = 0; i < _bcTitleArray.count; i++) {
            NSMutableString *changeString = [[NSMutableString alloc] initWithString:_bcTitleArray[i]];
            NSRange range = NSMakeRange(5, 5);
            NSString *string = [changeString substringWithRange:range];
            [_bcTitleArray replaceObjectAtIndex:i withObject:string];
        }
        _bcTitleArray = [NSMutableArray arrayWithArray:_bcTitleArray.reverseObjectEnumerator.allObjects];
    }
    return _bcTitleArray;
}


@end
