//
//  PLineView.m
//  loveshare
//
//  Created by lhb on 16/6/16.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "PLineView.h"

@implementation PLineView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setDate:(NSMutableArray *)date{
    _date = date;
    
    
    [self setNeedsDisplay];
   
}


- (void)setCurrentIndex:(int)currentIndex{
    
    _currentIndex = currentIndex;
    
}

- (void)drawRect:(CGRect)rect{
    
    LWLog(@"%@",NSStringFromCGRect(rect));
    
    LWLog(@"xxxxxxx");
    
    CGFloat rectH = rect.size.height - 10.0;
    CGFloat rate =  rectH / _max;
//    _date.count
    
    if (_date.count == 1) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGFloat X = rect.size.width * 0.5;
        CGFloat Y = rectH - rate * rectH;
        CGFloat WH = 5;
        
        CGMutablePathRef path=CGPathCreateMutable();
        //2.b.2把圆的绘图信息添加到路径里
        CGPathAddEllipseInRect(path, NULL, CGRectMake(X, Y, WH, WH));
        
        //2.b.3把圆的路径添加到图形上下文中
        CGContextAddPath(context, path);
        
        
        //3.渲染
        CGContextStrokePath(context);
        
             //4.释放前面创建的两条路径
        //第一种方法
        CGPathRelease(path);
        
    }else if(_date.count == 2) {
        
    }else if(_date.count == 3) {
        
    }else if(_date.count == 4) {
        
    }else if(_date.count == 5) {
        
    }
    
    
    
//    CGContextMoveToPoint(context,firstPoint);
//    CGContextAddLineToPoint(context,lastPoint);
    
    
    
    
}

@end
