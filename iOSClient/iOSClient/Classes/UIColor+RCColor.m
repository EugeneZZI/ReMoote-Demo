//
//  UIColor+RCColor.m
//  iOSClient
//
//  Created by Eugene Zozulya on 12/29/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import "UIColor+RCColor.h"

@implementation UIColor (RCColor)

+ (UIColor*)mainTextColor
{
    static UIColor *rcMainTextColor;
    if(rcMainTextColor)
        return rcMainTextColor;
    
    rcMainTextColor = [UIColor colorWithRed:181/255.0 green:122/255.0 blue:181/255.0 alpha:1.0];
    return rcMainTextColor;
}

+ (UIColor*)navigationBarTintColor
{
    static UIColor *rcNavigationBarTintColor;
    if(rcNavigationBarTintColor)
        return rcNavigationBarTintColor;
    
    rcNavigationBarTintColor = [UIColor colorWithRed:246/255.0 green:242/255.0 blue:243/255.0 alpha:1.0];
    return rcNavigationBarTintColor;
}

+ (UIColor*)buttonHighlightedColor
{
    static UIColor *rcButtonHighlightedColor;
    if(rcButtonHighlightedColor)
        return rcButtonHighlightedColor;
    
    rcButtonHighlightedColor = [UIColor colorWithRed:190/255.0 green:143/255.0 blue:196/255.0 alpha:1.0];
    return rcButtonHighlightedColor;
}

+ (UIColor*)rcGreenColor
{
    static UIColor *rcGreenColor;
    if(rcGreenColor)
        return rcGreenColor;
    
    rcGreenColor = [UIColor colorWithRed:122/255.0 green:184/255.0 blue:131/255.0 alpha:1.0];
    return rcGreenColor;
}

+ (UIColor*)rcRedColor
{
    static UIColor *rcRedColor;
    if(rcRedColor)
        return rcRedColor;
    
    rcRedColor = [UIColor colorWithRed:192/255.0 green:46/255.0 blue:70/255.0 alpha:1.0];
    return rcRedColor;
}

@end
