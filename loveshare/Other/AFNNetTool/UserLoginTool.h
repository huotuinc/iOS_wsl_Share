//
//  UserLoginTool.h
//  fanmore---
//
//  Created by lhb on 15/5/21.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "NewShareModel.h"


@interface UserLoginTool : NSObject




/*账户网络请求Get*/
+ (void)loginRequestGet:(NSString *)urlStr parame:(NSMutableDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;


/*账户网络请求Post*/
+ (void)loginRequestPostWithFile:(NSString *)urlStr parame:(NSMutableDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure withFileKey:(NSString *)key;


+ (void)loginRequestPostImageWithFile:(NSString *)urlStr parame:(NSMutableDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure withFileKey:(NSString *)key;


+ (void)logintest:(NSString *)urlStr parame:(NSData *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failuree;

/**
 *  保存数据到沙盒
 *
 *  @param model    保存模型
 *  @param fileName 保存文件名
 */
+ (void)LoginModelWriteToShaHe:(id)model andFileName:(NSString *)fileName;



/**
 *  从沙盒中读取数据
 *
 *  @param fileName 文件名
 *
 *  @return 模型
 */
+ (id)LoginReadModelDateFromCacheDateWithFileName:(NSString *)fileName;

/**
 *  原生网络请求
 *
 *  @param url    <#url description#>
 *  @param parame <#parame description#>
 *
 *  @return <#return value description#>
 */
+ (NSDictionary *)LogingetDateSyncWith:(NSString *)url WithParame:(NSMutableDictionary *)parame;



/**
 *  返回控制器
 *
 *  @param controllerIdentify 控制器标拾
 *
 *  @return 控制器
 */ 
+ (id)LoginCreateControllerWithNameOfStory:(NSString *)StoryName andControllerIdentify:(NSString *)identfy ;



+ (void)LoginToShareMessageByShareSdk:(NewShareModel *)shareModel success:(void (^)(int json))success failure:(void (^)(id error))failure;

/**
 *  文本分享
 *
 *  @param shareModel <#shareModel description#>
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 */
+ (void)LoginToShareTextMessageByShareSdkWithShareTitle:(NSString *)shareTitle withShareDes:(NSString *)shareText andUrl:(NSString *) aaurl success:(void (^)(int json))success failure:(void (^)(id json))failure;


+ (UIImage *)LoginCreateImageWithNoDate;

@end
