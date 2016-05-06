//
//  BCPNChartView.h
//  loveshare
//
//  Created by che on 16/5/6.
//  Copyright © 2016年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChart.h"
#import "HistoryModel.h"
@interface BCPNChartView : UIView

- (instancetype)initBCPNChartViewWithArray:(NSArray *)dataArray;

@property (nonatomic, strong) NSMutableArray *bcPointArray;
@property (nonatomic, strong) NSMutableArray *bcTitleArray;
@property (nonatomic, strong) PNLineChart *lineChart;

@end
