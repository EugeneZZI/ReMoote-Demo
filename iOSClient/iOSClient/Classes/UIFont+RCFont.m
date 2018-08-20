//
//  UIFont+RCFont.m
//  iOSClient
//
//  Created by Eugene Zozulya on 12/29/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import "UIFont+RCFont.h"

@implementation UIFont (RCFont)

+ (UIFont*)mainHelveticaNeueThinFontWithSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"HelveticaNeue-Thin" size:fontSize];
}

+ (UIFont*)mainHelveticaNeueFontWithSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"HelveticaNeue" size:fontSize];
}

@end
