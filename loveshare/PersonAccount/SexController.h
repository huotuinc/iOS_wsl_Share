//
//  SexController.h
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/8.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol SexControllerdelegate <NSObject>

@optional

/**
 *  0 男
 *  1 女
 *  @param sex <#sex description#>
 */
- (void)selectSexOver:(NSInteger)sex;

@end
@interface SexController : UIViewController

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, assign) int sex;


@property(nonatomic,weak) id <SexControllerdelegate> delegate;

@end
