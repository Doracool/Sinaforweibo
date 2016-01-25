//
//  NSString+StringSize.m
//  SoftLink
//
//  Created by qingyun on 16/1/19.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "NSString+StringSize.h"

@implementation NSString (StringSize)


-(CGSize)stringSizeWith:(CGFloat)width Font:(UIFont *)font
{
    CGSize size = CGSizeMake(width, MAXFLOAT);
    NSDictionary *attr = @{NSFontAttributeName : font};
    
    CGRect rect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil];
    
    return rect.size;
}
@end
