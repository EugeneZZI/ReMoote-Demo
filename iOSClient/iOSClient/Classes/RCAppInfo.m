//
//  RCAppInfo.m
//  iOSClient
//
//  Created by Eugene Zozulya on 12/24/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import "RCAppInfo.h"

static NSString      *kRCCheckFirstLaunchKey      = @"kFirstLaunchKey";

@implementation RCAppInfo

+ (BOOL)isFirstStart
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL flag = [defaults boolForKey:kRCCheckFirstLaunchKey];
    if(!flag)
        [defaults setBool:YES forKey:kRCCheckFirstLaunchKey];
    
    return !flag;
}

+ (NSString*)appVersion
{
    static NSString *appVersion;
    if(appVersion)
        return appVersion;
    
    appVersion =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return appVersion;
}

@end
