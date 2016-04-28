//
//  DepartmentViewController.h
//  loveshare
//
//  Created by lhb on 16/3/15.
//  Copyright © 2016年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  默认 转发 浏览 徒弟 积分
 */
@interface DepartmentViewController : UIViewController
@property(nonatomic,strong)JiTuan * model;
@property (nonatomic, strong) NSNumber *taskId;

@property(nonatomic,copy)NSString * dilu;
@end
