//
//  RCStartupLaunch.h
//  MacServer
//
//  Created by Eugene Zozulya on 1/9/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCStartupLaunch : NSObject

+ (void)launchApplicationAtLogin:(BOOL)flag;
+ (BOOL)isLaunchApplicationAtLogin;

@end
