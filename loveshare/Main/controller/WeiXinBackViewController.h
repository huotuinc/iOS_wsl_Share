//
//  WeiXinBackViewController.h
//  Fanmore
//
//  Created by lhb on 15/12/4.
//  Copyright © 2015年 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiXinBackViewController : UIViewController


@property(nonatomic,strong)WeiQAuthModel * model;
@property(nonatomic,assign) int callType;
@property(nonatomic,copy)NSString *PhoneNumber;
@property(nonatomic,copy)NSString *codeNumber;
@end
