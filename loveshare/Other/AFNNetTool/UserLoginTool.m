//
//  UserLoginTool.m
//  fanmore---
//
//  Created by lhb on 15/5/21.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "UserLoginTool.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <MKNetworkKit.h>


@interface UserLoginTool()

@end


@implementation UserLoginTool

+ (UIImage *)LoginCreateImageWithNoDate{
    if(ScreenWidth == 320){
        if(ScreenHeight == 480){
            return [UIImage imageNamed:@"tbg320x480"];
        }
        return [UIImage imageNamed:@"tbg320x568"];
    }else if(ScreenWidth == 375){
        return [UIImage imageNamed:@"tbg375x667"];
    }
    return [UIImage imageNamed:@"tbg621x1104"];
}
+ (void)loginRequestGet:(NSString *)urlStr parame:(NSMutableDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
    
    NSMutableDictionary * paramsOption = [NSMutableDictionary dictionary];
    paramsOption[@"req"] = urlStr;
    paramsOption[@"operation"] = OPERATION_parame;
    paramsOption[@"version"] = AppVersion;

    paramsOption[@"imei"] = DeviceNo;
    paramsOption[@"p"] = [params mj_JSONString];
    paramsOption[@"sign"] = [NSDictionary asignWithMutableDictionary:paramsOption];  //计算asign
    [paramsOption removeObjectForKey:@"appSecret"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager GET:MainUrl parameters:paramsOption progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        LWLog(@"%@",task.originalRequest);
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        LWLog(@"%@",task);
        failure(error);
    }];
    
}

+ (void)loginRequestPostWithFile:(NSString *)urlStr parame:(NSMutableDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure withFileKey:(NSString *)key{
    
    
    
    NSMutableDictionary * paramsOption = [NSMutableDictionary dictionary];
    paramsOption[@"req"] = urlStr;
    paramsOption[@"operation"] = OPERATION_parame;
    paramsOption[@"version"] = AppVersion;
    paramsOption[@"imei"] = DeviceNo;
    paramsOption[@"sign"] = [NSDictionary asignWithMutableDictionary:paramsOption];  //计算asign
    NSArray * parameKey = [paramsOption allKeys];
    NSMutableString * paremUrl = [[NSMutableString alloc] init];
    for (int i = 0; i<parameKey.count; i++) {
        [paremUrl appendFormat:@"%@=%@&",parameKey[i],[paramsOption objectForKey:parameKey[i]]];
        
    }
    NSMutableString * urlss =[NSMutableString stringWithFormat:@"%@?%@",MainUrl, [paremUrl substringToIndex:paremUrl.length-2]];
    
    
    NSDictionary * dict = @{@"p":[params mj_JSONString]};
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    [manager POST:urlss parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:[params[@"pic"] dataUsingEncoding:NSUTF8StringEncoding] name:@"pic" fileName:@"head" mimeType:@"image/png"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        LWLog(@"%@",task.originalRequest);
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        LWLog(@"%@",error.description);
        failure(error);
    }];
    
    
//    [manager POST:urlss parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        LWLog(@"%@",task.originalRequest);
//        success(responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure(error);
//    }];
//
}


+ (NSDictionary *)LogingetDateSyncWith:(NSString *)url WithParame:(NSMutableDictionary *)parame
 {
     NSMutableDictionary * paramsOption = [NSMutableDictionary dictionary];
     paramsOption[@"req"] = url;
     paramsOption[@"operation"] = OPERATION_parame;
     paramsOption[@"version"] = AppVersion;
     paramsOption[@"imei"] = DeviceNo;
     paramsOption[@"p"] = [parame mj_JSONString];
     paramsOption[@"sign"] = [NSDictionary asignWithMutableDictionary:paramsOption];  //计算asign
     NSArray * parameKey = [paramsOption allKeys];
     NSMutableString * paremUrl = [[NSMutableString alloc] init];
     for (int i = 0; i<parameKey.count; i++) {
         [paremUrl appendFormat:@"%@=%@&",parameKey[i],[paramsOption objectForKey:parameKey[i]]];
         
     }
     NSMutableString * urlss =[NSMutableString stringWithFormat:@"%@?%@",MainUrl, [paremUrl substringToIndex:paremUrl.length-2]];
       //拼接URL字符串
     //将中文转码
    NSString *strUrl = [urlss stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     
     LWLog(@"%@",strUrl);
     //获取URL
    NSURL *urls = [NSURL URLWithString:strUrl];
     //设置请求
    NSURLRequest *request = [NSURLRequest requestWithURL:urls];
     
    //发生GET同步请求（Sync）
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSError *error =nil;
    if (data) {
         //解析JSON数据
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         if (error) {
             return nil;
         }
         return dic;
         
     }
     return nil;
}


+ (void)LoginModelWriteToShaHe:(id)model andFileName:(NSString *)fileName{
    
    if (!model) {
        return;
    }
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //1、保存全局信息
    NSString *fileNames = [path stringByAppendingPathComponent:fileName];
    LWLog(@"%@",fileNames);
    [NSKeyedArchiver archiveRootObject:model toFile:fileNames]; //保存用户信息
}



+ (id)LoginReadModelDateFromCacheDateWithFileName:(NSString *)fileName{
    if (!fileName.length) {
        return nil;
    }
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //1、保存全局信息
    NSString *fileNames = [path stringByAppendingPathComponent:fileName];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:fileNames];
}


+ (id)LoginCreateControllerWithNameOfStory:(NSString *)StoryName andControllerIdentify:(NSString *)identfy{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:(StoryName.length?StoryName:@"Main") bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:identfy];
}


+ (void)LoginToShareMessageByShareSdk:(NewShareModel *)shareModel success:(void (^)(int json))success failure:(void (^)(id json))failure{
    
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:nil images:(shareModel.taskSmallImgUrl?@[shareModel.taskSmallImgUrl]:@[[UIImage imageNamed:@"29"]])
                                            url:[NSURL URLWithString:shareModel.taskInfo]
                                          title:shareModel.taskName
                                           type:SSDKContentTypeAuto];
    
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               LWLog(@"%lu",(unsigned long)platformType);
                               if (platformType == 23 || platformType == 22 || platformType == 37) {
                                  success(1);//weixin
                               }
                               if (platformType == 6 || platformType == 24) {
                                   success(3);//qq
                               }
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               failure(false);
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];
   
    
    
}

+ (void)LoginToShareTextMessageByShareSdk:(NSString *)shareText andUrl:(NSString *) aaurl success:(void (^)(int json))success failure:(void (^)(id json))failure{
    
    NSArray* imageArray = @[[UIImage imageNamed:@"29"]];
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:nil images:imageArray
                                        url:[NSURL URLWithString:aaurl]
                                      title:shareText
                                       type:SSDKContentTypeAuto];
    
    //2、分享（可以弹出我们的分享菜单和编辑界面）
    [ShareSDK showShareActionSheet:nil items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                       case SSDKResponseStateSuccess:
                       {
                           LWLog(@"%lu",(unsigned long)platformType);
                           if (platformType == 23 || platformType == 22 || platformType == 37) {
                               success(1);//weixin
                           }
                           if (platformType == 6 || platformType == 24) {
                               success(3);//qq
                           }
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           failure(false);
                           break;
                       }
                       default:
                           break;
                   }
               }
     ];
    
}

+ (void)loginRequestPostImageWithFile:(NSString *)urlStr parame:(NSMutableDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure withFileKey:(NSString *)key{
    
    
//    //   AFHTTPRequestOperationManager * manager  = [AFHTTPRequestOperationManager manager];
//    UserModel * userInfo = (UserModel *)[self LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
//    
//    NSMutableDictionary * paramsOption = [NSMutableDictionary dictionary];
////    paramsOption[@"req"] = urlStr;
//    paramsOption[@"operation"] = OPERATION_parame;
//    paramsOption[@"version"] = AppVersion;
//    paramsOption[@"loginCode"] = userInfo.loginCode;
//    paramsOption[@"imei"] = DeviceNo;
//
//    if (params != nil) { //传入参数不为空
//        [paramsOption addEntriesFromDictionary:params];
//    }
//    if (key != nil) {
//        NSData *data = [[paramsOption objectForKey:key] dataUsingEncoding:NSUTF8StringEncoding];
//        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        [paramsOption removeObjectForKey:key];
//        paramsOption[@"profileData"] = str;
//    }
//    
//    paramsOption[@"sign"] = [NSDictionary asignWithMutableDictionary:paramsOption];
//    [paramsOption removeObjectForKey:@"appSecret"];
//    
//    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:MKMainUrl customHeaderFields:nil];
//    
//    MKNetworkOperation *op = [engine operationWithPath:urlStr params:paramsOption httpMethod:@"POST"];
//    
//    LWLog(@"%@",op.url);
//    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
//        success(completedOperation.responseJSON);
//    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
//        failure(error);
//    }];
//    [engine enqueueOperation:op];
}



+ (void)logintest:(NSString *)urlStr parame:(NSData *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
    
    
    UserModel * userInfo = (UserModel *)[self LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    
    NSMutableDictionary * paramsOption = [NSMutableDictionary dictionary];
    paramsOption[@"req"] = urlStr;
    paramsOption[@"operation"] = OPERATION_parame;
    paramsOption[@"version"] = AppVersion;
    paramsOption[@"loginCode"] = userInfo.loginCode;
    paramsOption[@"imei"] = DeviceNo;
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager POST:MainUrl parameters:paramsOption constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFormData:params name:@"pic"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        LWLog(@"%@",task.originalRequest);
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
@end
