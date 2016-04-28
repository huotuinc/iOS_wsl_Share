//
//  EnterpriseTableViewController.h
//  loveshare
//
//  Created by lhb on 16/3/14.
//  Copyright © 2016年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  点击架构进入
 *  默认 转发 浏览
 */
@interface EnterpriseTableViewController : UIViewController
@property(nonatomic,strong)JiTuan * model;
@property (nonatomic, strong) NSNumber *taskId;

@end
