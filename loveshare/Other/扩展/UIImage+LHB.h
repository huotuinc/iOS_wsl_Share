//
//  UIImage+LHB.h
//  LuoHBWeiBo
//
//  Created by 罗海波 on 15-3-2.
//  Copyright (c) 2015年 LHB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LHB)

+(UIImage*)imageWithName:(NSString *) name;


/**
 *  根据文字返回一张自由拉伸的图片
 *
 *  @param name 文字
 *
 *  @return 拉伸后的图片
 */
+(UIImage*)resizedWithName:(NSString *) name;
+(UIImage*)resizedWithName:(NSString *) name left:(CGFloat) left top:(CGFloat) top;
@end
