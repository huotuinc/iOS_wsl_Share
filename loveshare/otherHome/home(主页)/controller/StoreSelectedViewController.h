//
//  StoreSelectedViewController.h
//  loveshare
//
//  Created by che on 16/5/12.
//  Copyright © 2016年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol storeSelectedDelegate <NSObject>

- (void)sendUserID:(NSInteger)userID;

@end

@interface StoreSelectedViewController : UIViewController

@property (nonatomic, weak) id <storeSelectedDelegate>delegate;

@end
