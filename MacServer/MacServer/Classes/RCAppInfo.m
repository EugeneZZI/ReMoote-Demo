//
//  RCAppInfo.m
//  MacServer
//
//  Created by Eugene Zozulya on 12/29/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import "RCAppInfo.h"

NSString *kRCFirstStartKey = @"FirstStartKey";

@implementation RCAppInfo

+ (NSString*)appVersion
{
    static NSString *appVersion;
    if(appVersion)
        return appVersion;
    
    appVersion =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return appVersion;
}

+ (BOOL)isFirstStart
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL flag = [defaults boolForKey:kRCFirstStartKey];
    if(!flag)
    {
        [defaults setBool:YES forKey:kRCFirstStartKey];
        return NO;
    }
    
    return YES;
}

@end
