//
//  HomeTitleOption.h
//  loveshare
//
//  Created by lhb on 16/5/17.
//  Copyright © 2016年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeTitleButton;


@protocol HomeTitleOptionDelegate <NSObject>

@required

- (void)selectCurrentOption:(NSInteger) index;


@end

@interface HomeTitleOption : UIView

- (void)titleClick:(HomeTitleButton *)titleButton;

@property(nonatomic,weak) id <HomeTitleOptionDelegate> delegate;

@end
