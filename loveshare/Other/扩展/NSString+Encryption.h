//
//  NSString+Encryption.h
//  Encryption
//
//  Created by Cho-Yeung Lam on 24/10/13.
//  Copyright (c) 2013 Cho-Yeung Lam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Encryption)

+ (NSString *)MD5FromData:(NSData *)data;
+ (NSString *)MD5FromDataWithMyMethod:(NSData *)data;

@end
