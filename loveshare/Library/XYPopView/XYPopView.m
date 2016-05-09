//
//  XYPopView.m
//  pop
//
//  Created by 徐洋 on 16/5/3.
//  Copyright © 2016年 徐洋. All rights reserved.
//

#import "XYPopView.h"
#import "BCCollectionViewCell.h"
#define kWindow [[UIApplication sharedApplication].delegate window]


static NSString *bcCell = @"bcCell";


@implementation XYPopView
{
    NSArray *buttonItems;
    CGFloat popViewX;
    CGFloat popViewY;
    BOOL isShow;
    
    NSArray *bcImageArray;
    NSArray *bcTitleArray;
    UIView *bcfSuperView;
}


- (instancetype)initWXYPopViewWithImage:(NSArray *)imageArray andTitle:(NSArray *)titleArray andSuperView:(UIView *)superView
{
    if (self = [super init]) {
        bcImageArray = imageArray;
        bcTitleArray = titleArray;
        bcfSuperView = superView;
        self.backgroundColor = [UIColor whiteColor];
        [self loadUI:superView];
        isShow = NO;
    }
    return self;
}
/**
 *  布局
 *
 *  @param superView superView description
 */
- (void)loadUI:(UIView *)superView
{
    popViewX = superView.frame.origin.x;
    popViewY = superView.frame.origin.y;
    
    while ([bcfSuperView.superview isKindOfClass:[UIView class]]) {
        popViewX += bcfSuperView.superview.frame.origin.x;
        popViewY += bcfSuperView.superview.frame.origin.y;
        bcfSuperView = bcfSuperView.superview;
    }
    self.frame = CGRectMake(0, bcfSuperView.frame.origin.y + 44 - 2, SCREEN_WIDTH, 0);
    self.backgroundColor = [UIColor whiteColor];
    self.layer.masksToBounds = YES;
}

- (void)showPopView
{
    if (!isShow) {
//        [kWindow addSubview:self];
        [UIView animateWithDuration:0.3f animations:^{
            self.frame = CGRectMake(0,  bcfSuperView.frame.origin.y + 44 - 2, SCREEN_WIDTH, SCREEN_HEIGHT - 108 + 2);
            [self addSubview:self.bcCollectionView];
        }];
    }else{
        [UIView animateWithDuration:0.3f animations:^{
            self.frame = CGRectMake(0, bcfSuperView.frame.origin.y + 44 - 2, SCREEN_WIDTH, 0);
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
    isShow = !isShow;
}

- (UICollectionView *)bcCollectionView {
    if (_bcCollectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setMinimumLineSpacing:1];
        [flowLayout setMinimumInteritemSpacing:1];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _bcCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:flowLayout];
        _bcCollectionView.backgroundColor = [UIColor whiteColor];
        [_bcCollectionView registerNib:[UINib nibWithNibName:@"BCCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:bcCell];
        _bcCollectionView.dataSource = self;
        _bcCollectionView.delegate = self;
    }
    return _bcCollectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 30;
}
//返回每一个Item的布局
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    BCCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:bcCell forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.item % 4 == 0) {
            cell.viewBase.backgroundColor = [UIColor redColor];
    }
    if (indexPath.item % 4 == 1) {
        cell.viewBase.backgroundColor = [UIColor cyanColor];
    }
    if (indexPath.item % 4 == 2) {
        cell.viewBase.backgroundColor = [UIColor greenColor];
    }
    if (indexPath.item % 4 == 3) {
        cell.viewBase.backgroundColor = [UIColor blueColor];
    }

    cell.imageVIcon.image = [UIImage imageNamed:@"29"];
    cell.labelName.text = @"test";
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(chooseItem:andTag:)]) {
        [self.delegate chooseItem:@"万事利" andTag:indexPath.item];
        [self showPopView];
    }
}


#pragma mark  UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH / 3 - 1, SCREEN_WIDTH / 3 - 1);
}


@end
