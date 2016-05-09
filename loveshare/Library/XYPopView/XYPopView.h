//
//  XYPopView.h
//  pop
//
//  Created by 徐洋 on 16/5/3.
//  Copyright © 2016年 徐洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XYPopViewDelegate <NSObject>

- (void)chooseItem:(NSString *)title andTag:(NSInteger)tag;

@end



@interface XYPopView : UIView <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>


@property (nonatomic, strong) UICollectionView *bcCollectionView;

- (instancetype)initWXYPopViewWithImage:(NSArray *)imageArray andTitle:(NSArray *)titleArray andSuperView:(UIView *)superView;


/**
 *  弹出视图,再次点击消失
 */
- (void)showPopView;

/**
 *  代理
 */
@property (nonatomic, assign) id<XYPopViewDelegate>delegate;

@end
