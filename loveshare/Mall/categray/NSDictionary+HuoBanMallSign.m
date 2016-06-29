//
//  NSDictionary+HuoBanMallSign.m
//  HuoBanMallBuy
//
//  Created by lhb on 15/10/13.
//  Copyright (c) 2015年 HT. All rights reserved.
//  网页链接签名   SISJAVAAPPID

#import "NSDictionary+HuoBanMallSign.h"
#import "MD5Encryption.h"
//#import "AccountTool.h"
//#import "UserInfo.h"
@implementation NSDictionary (HuoBanMallSign)

+ (NSString *)asignWithMutableDictionary:(NSMutableDictionary *)dict{
    
    NSMutableDictionary * InDict = nil;
    if (dict) {
        InDict = [NSMutableDictionary dictionaryWithDictionary:dict];
        InDict[@"timestamp"] = timestamp;
    }else{
        InDict = [NSMutableDictionary dictionary];
        InDict[@"timestamp"] = timestamp;
    }
    
    //计算asign参数
    NSArray * arr = [InDict allKeys];
    [arr enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        
        NSString * cc = [NSString stringWithFormat:@"%@",[InDict objectForKey:obj]];
        
        LWLog(@"%@",cc);
        if (cc.length==0) {
//            NSLog(@"%@",cc);
            [InDict removeObjectForKey:obj];
        }
        
    }];
    //计算asign参数
    arr = [InDict allKeys];
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(NSString* obj1, NSString* obj2) {
        return [obj1 compare:obj2] == NSOrderedDescending;
    }];
    NSMutableString * signCap = [[NSMutableString alloc] init];
    //进行asign拼接
    for (NSString * dicKey in arr) {
        [signCap appendString:[NSString stringWithFormat:@"%@=%@&",dicKey,[InDict valueForKey:dicKey]]];
    }
    NSString * aa = [signCap substringToIndex:signCap.length-1];
    
    LWLog(@"%@",aa);
    
    NSString * cc  = [NSString stringWithFormat:@"%@%@",aa,APPScreat];
    
    NSString *unicodeStr = [NSString stringWithCString:[cc UTF8String] encoding:NSUTF8StringEncoding];
    
    InDict[@"sign"] = [MD5Encryption md5by32:unicodeStr];
    return [InDict mj_JSONString];

}




+ (NSString *)ToSignUrlWithString:(NSString *)urlStr{
    
    
    
//   UserModel * userInfo = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    NSMutableString * signUrl = [NSMutableString stringWithString:urlStr]; //元素url
//    NSDate * timestamp = [[NSDate alloc] init];
//    NSString *timeSp = [NSString stringWithFormat:@"%lld", (long long)[timestamp timeIntervalSince1970] * 1000];  //转化为UNIX时间戳
    [signUrl appendFormat:@"&appid=%@",HuoBanMallBuyAppId];
    [signUrl appendFormat:@"&timestamp=%@",timestamp];
    
    NSString * bu = nil;
    NSString * un = nil;

    bu = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:ChoneMallAccount]];
    un = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:PhoneLoginunionid]];

    
    LWLog(@"%@--------%@----%@",bu,un,[[NSUserDefaults standardUserDefaults] objectForKey:@"unionid"]);
    [signUrl appendFormat:@"&buserid=%@",bu];
    [signUrl appendFormat:@"&unionid=%@",un];
    NSRange new = [signUrl rangeOfString:@"?"];
    
    if (new.location != NSNotFound) {
        
        NSString * newUrlStr = [signUrl substringFromIndex:new.location+1];
        NSArray * separeArray = [newUrlStr componentsSeparatedByString:@"&"]; //？后面的东西
        NSMutableArray * keys = [NSMutableArray array];
        for (int i = 0; i<separeArray.count; i++) {//参数的键
            NSString * sr =  separeArray[i];
            NSArray *keyArray = [sr componentsSeparatedByString:@"="];
            [keys addObject:keyArray[0]];
        }
        
        
        NSMutableArray * sssdasdasd = [NSMutableArray array];
        for (int i = 0; i<keys.count; i++) {
            NSString * sss =  separeArray[i];
            NSString * ccc =  keys[i];
            NSString * aaaaaaaa = [sss stringByReplacingOccurrencesOfString:keys[i] withString:[ccc lowercaseString]];
            [sssdasdasd addObject:aaaaaaaa];
        }
        NSArray * arr = [sssdasdasd sortedArrayUsingComparator:^NSComparisonResult(NSString* obj1, NSString* obj2) {
            return [obj1 compare:obj2] == NSOrderedDescending;
        }];
        NSMutableString * signCap = [[NSMutableString alloc] init];
        for (int i = 0; i<arr.count; i++) {
            if (i == 0) {
                [signCap appendString:arr.firstObject];
            }else{
                [signCap appendFormat:@"&%@",arr[i]];
            }
        }
        [signCap appendFormat:@"%@",HuoBanMallBuyAppSecrect];
        NSString * sign = [MD5Encryption md5by32:signCap];
        [signUrl appendFormat:@"&sign=%@",sign];
        return signUrl;
    }
    return nil;
}
@end
