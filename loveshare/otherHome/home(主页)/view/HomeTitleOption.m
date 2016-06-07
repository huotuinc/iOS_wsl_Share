//
//  HomeTitleOption.m
//  loveshare
//
//  Created by lhb on 16/5/17.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "HomeTitleOption.h"
#import "HomeTitleButton.h"


@interface HomeTitleOption()


@property(nonatomic,strong) NSMutableArray * titleButtons;


@property(nonatomic,strong) UIView * titleBottomView;


@property (nonatomic,strong) HomeTitleButton * selectedTitleButton;

@end

@implementation HomeTitleOption


- (NSMutableArray *)titleButtons{
    if (_titleButtons == nil) {
        _titleButtons = [NSMutableArray array];
    }
    return _titleButtons;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
        [self setupTitlesView];
    }
    return self;
}


- (void)setupTitlesView
{
    NSArray * dateArrays = @[@"综合排序",@"转发人数"];
    // 标签栏内部的标签按钮
    NSUInteger count = dateArrays.count;
    CGFloat titleButtonH = self.xmg_height;
    CGFloat titleButtonW = (ScreenWidth-60) / count;
    for (int i = 0; i < count; i++) {
        // 创建
        HomeTitleButton *titleButton = [HomeTitleButton buttonWithType:UIButtonTypeCustom];
        titleButton.tag = i;
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:titleButton];
        [self.titleButtons addObject:titleButton];
        
//        titleButton.backgroundColor = LWRandomColor;
        
        
        LWLog(@"%@",dateArrays[i]);
        [titleButton setTitle:dateArrays[i] forState:UIControlStateNormal];
        

        
        // frame
        titleButton.xmg_y = 0;
        titleButton.xmg_height = titleButtonH;
        titleButton.xmg_width = titleButtonW;
        titleButton.xmg_x = i * titleButton.xmg_width;
        
        
//        if (i == 1 || i == 3) {
//            [titleButton setImage:[UIImage imageNamed:@"iconfont-jiantouxiangxiapaixu"] forState:UIControlStateNormal];
//        }
    }
    
    // 标签栏底部的指示器控件
    UIView *titleBottomView = [[UIView alloc] init];
    titleBottomView.backgroundColor = [self.titleButtons.lastObject titleColorForState:UIControlStateSelected];
    titleBottomView.xmg_height = 1;
    titleBottomView.xmg_y = self.xmg_height - titleBottomView.xmg_height;
    [self addSubview:titleBottomView];
    self.titleBottomView = titleBottomView;
    
    // 默认点击最前面的按钮
    HomeTitleButton *firstTitleButton = self.titleButtons.firstObject;
    [firstTitleButton.titleLabel sizeToFit];
    titleBottomView.xmg_width = firstTitleButton.titleLabel.xmg_width;
    titleBottomView.xmg_centerX = firstTitleButton.xmg_centerX;
    [self titleClick:firstTitleButton];
}


#pragma mark - 监听
- (void)titleClick:(HomeTitleButton *)titleButton
{
    // 控制按钮状态
    self.selectedTitleButton.selected = NO;
    titleButton.selected = YES;
    self.selectedTitleButton = titleButton;
    
    // 底部控件的位置和尺寸
    [UIView animateWithDuration:0.25 animations:^{
        self.titleBottomView.xmg_width = titleButton.titleLabel.xmg_width;
        self.titleBottomView.xmg_centerX = titleButton.xmg_centerX;
    }];
    
    [self.delegate  selectCurrentOption:titleButton.tag];
    
//    // 让scrollView滚动到对应的位置
//    CGPoint offset = self.scrollView.contentOffset;
//    offset.x = self.view.width * [self.titleButtons indexOfObject:titleButton];
//    [self.scrollView setContentOffset:offset animated:YES];
}


@end
