//
//  ProfessionalController.h
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/9.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwoOption.h"

@protocol ProfessionalControllerDelegate <NSObject>

@optional
/**选择职业*/
- (void) ProfessionalControllerBringBackCareerWithValue:(NSString* )selectDictInt withName:(NSString* )selectDictName currentSelectType:(int)type;

- (void) ProfessionalControllerBringBackIncomeWithId:(NSMutableDictionary *)selectDictid WithName:(NSString *)name currentSelectType:(int)type;

@end

@interface ProfessionalController : UITableViewController

/**
 *  数据列表
 */
@property (strong, nonatomic) NSArray *Setgoods;

/**
 *  0是职业
 *  1收入
 *  2爱好
 */
@property (assign, nonatomic) int type;

/**
 *  保存选中的行方便操作
 */
@property (weak, nonatomic) NSIndexPath *selectIndexPath;

/**用户当前的职业*/
@property (nonatomic,assign) int DefauleDateID;


@property(weak,nonatomic) id<ProfessionalControllerDelegate> delegate;



@end
