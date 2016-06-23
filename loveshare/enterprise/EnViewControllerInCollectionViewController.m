//
//  EnViewControllerInCollectionViewController.m
//  loveshare
//
//  Created by lhb on 16/6/17.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "EnViewControllerInCollectionViewController.h"
#import "StoreModel.h"
#import "EnViewCollectionViewCell.h"
#define Margin 5

@interface EnViewControllerInCollectionViewController ()

@property(nonatomic,strong) NSMutableArray * datesArray;

@property(nonatomic,strong) MJRefreshNormalHeader  *mjHeader;

@property(nonatomic,strong) MJRefreshFooter * mjFooter;

@property(nonatomic,assign) int pageIndex;

@end

@implementation EnViewControllerInCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (NSMutableArray *)datesArray{
    if (_datesArray == nil) {
        _datesArray = [NSMutableArray array];
    }
    return _datesArray;
}

+ (instancetype)EnMyInit{
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc
                                        ] init];
    CGFloat with =  (ScreenWidth - 5 * Margin) /3.0;
    CGFloat height = with * 100 / 80.0;
    layout.minimumLineSpacing = Margin;
    layout.minimumInteritemSpacing = Margin;
    layout.itemSize = CGSizeMake(with, height);
    return  [[self alloc] initWithCollectionViewLayout:layout];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    AppDelegate * ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ad.currentVC = self;
    
    
    self.pageIndex = 1;
    
//    [self getNewStoreList];
    
    self.collectionView.backgroundColor = [UIColor colorWithRed:241/255.0 green:242/255.0 blue:243/255.0 alpha:1];
    
    self.collectionView.contentInset = UIEdgeInsetsMake(44+Margin, Margin, 64, Margin);    // Register cell classes
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"EnViewCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    
    _mjHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getNewStoreList)];
    self.collectionView.mj_header = self.mjHeader;
    [self.mjHeader beginRefreshing];
    
    
    _mjFooter = [MJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreStoreListWithPageIndex)];
    self.collectionView.mj_footer = self.mjFooter;
}

- (void)getNewStoreList {
//    LWLog(@"%ld",_pageNumber);
    UserModel * userInfo = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"loginCode"] = userInfo.loginCode;
    parame[@"pageIndex"] = @(self.pageIndex);
    [UserLoginTool loginRequestGet:@"StoreList" parame:parame success:^(id json) {
        LWLog(@"%@",json);
        if ([json[@"status"] integerValue] ==1 && [json[@"resultCode"] integerValue] ==1){
            self.pageIndex = [[json objectForKey:@"pageIndex"] intValue];
            NSArray *array = [StoreModel mj_objectArrayWithKeyValuesArray:json[@"resultData"]];
            if (array.count) {
                [self.datesArray removeAllObjects];
                [self.datesArray addObjectsFromArray:array];
                [self.collectionView reloadData];
                
            }
        }
        [self.mjHeader endRefreshing];
    } failure:^(NSError *error) {
        [self.mjHeader endRefreshing];
    }];
}


- (void)getMoreStoreListWithPageIndex{
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    UserModel * userInfo = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    parame[@"pageIndex"] = @(self.pageIndex);
    parame[@"loginCode"] = userInfo.loginCode;
    [UserLoginTool loginRequestGet:@"UserOrganizeAllTask" parame:parame success:^(id json) {
        LWLog(@"%@",json);
        if ([json[@"status"] integerValue] ==1 && [json[@"resultCode"] integerValue] ==1){
            NSArray *array = [StoreModel mj_objectArrayWithKeyValuesArray:json[@"resultData"]];
            if (array.count) {
               [self.datesArray addObjectsFromArray:array];
               [self.collectionView reloadData];
            }
            
        }
        [self.mjFooter endRefreshing];
    } failure:^(NSError *error) {
        [self.mjFooter endRefreshing];
    }];
    
}

#pragma mark <UICollectionViewDataSource>



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.datesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EnViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
//    cell.backgroundColor = [UIColor lightGrayColor];
    LWLog(@"%@",cell);
    StoreModel * model = [self.datesArray objectAtIndex:indexPath.row];
    LWLog(@"%@",[model mj_keyValues]);
    cell.model = model;
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    StoreModel * model = [self.datesArray objectAtIndex:indexPath.row];
    LWLog(@"%@",[model mj_keyValues]);
    
    
    HomeListTableController * vc = [[HomeListTableController alloc] init];
    vc.ISEnter = YES;
    vc.title = model.UserNickName;
    vc.userenterId = [model.UserId intValue];
    [self.navigationController pushViewController:vc animated:YES];
}

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
