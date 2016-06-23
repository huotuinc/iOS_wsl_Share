//
//  NSMutableDictionary+WSLLOVESHARE.m
//  loveshare
//
//  Created by lhb on 16/6/21.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "NSMutableDictionary+WSLLOVESHARE.h"

@implementation NSMutableDictionary (WSLLOVESHARE)

- (NSString *) WSLFenHongSignWithDict:(NSDictionary *)dict withURl:(NSString * )url{
    //计算asign参数
    NSArray * arr = [dict allKeys];
    if (arr.count) {
        arr = [arr sortedArrayUsingComparator:^NSComparisonResult(NSString* obj1, NSString* obj2) {
            return [obj1 compare:obj2] == NSOrderedDescending;
        }];
        NSMutableString * signCap = [[NSMutableString alloc] init];
        //进行asign拼接
        for (NSString * dicKey in arr) {
            [signCap appendString:[NSString stringWithFormat:@"%@=%@&",dicKey,[dict valueForKey:dicKey]]];
        }
        NSString * sian = [signCap substringToIndex:signCap.length-1];
        LWLog(@"%@",sian);
        NSString * sianzz = [NSString stringWithFormat:@"%@%@",sian,MALLScrent];
        
        
         NSString *unicodeStr = [NSString stringWithCString:[sianzz UTF8String] encoding:NSUTF8StringEncoding];
        
        LWLog(@"%@",[NSString stringWithFormat:@"%@%@sign=%@",url,signCap,[MD5Encryption md5by32:unicodeStr]]);
        return [NSString stringWithFormat:@"%@%@sign=%@",url,signCap,[MD5Encryption md5by32:unicodeStr]];
    }
    return nil;
}



@end
