//
//  detailViewController.h
//  fanmore---
//
//  Created by lhb on 15/5/26.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol detailViewDelegate <NSObject>

@optional


@end



@interface detailViewController : UIViewController


@property(nonatomic,strong) NewTaskDataModel * taskModel;

@end
