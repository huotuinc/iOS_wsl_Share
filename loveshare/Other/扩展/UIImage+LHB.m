//
//  UIImage+LHB.m
//  LuoHBWeiBo
//
//  Created by 罗海波 on 15-3-2.
//  Copyright (c) 2015年 LHB. All rights reserved.
//

#import "UIImage+LHB.h"

@implementation UIImage (LHB)


+ (UIImage *)imageWithName:(NSString *)name
{
   
    return [UIImage imageNamed:name];
}


+(UIImage*)resizedWithName:(NSString *) name
{
    
    return [UIImage resizedWithName:name left:0.5 top:0.5];
}
+(UIImage*)resizedWithName:(NSString *) name left:(CGFloat) left top:(CGFloat) top
{
    UIImage * image = [self imageWithName:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width*left topCapHeight:image.size.height*top];
}

@end
