//
//  AppDelegate.h
//  loveshare
//
//  Created by lhb on 16/3/4.
//  Copyright © 2016年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,assign) BOOL isflag;


@property (nonatomic,strong) NSMutableDictionary * TodayPredictingNumber;

@property (nonatomic,assign) BOOL isHaveLogin;


@property (nonatomic,strong) UIViewController * currentVC;


@property(nonatomic,strong) NSString * adUrl;

@end

