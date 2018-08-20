//
//  AppDelegate.m
//  iOSClient
//
//  Created by Eugene Zozulya on 11/26/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import "RCAppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "UIColor+RCColor.h"
//#import "RCAppInfo.h"

@interface RCAppDelegate () <NSNetServiceBrowserDelegate, NSNetServiceDelegate>
@end

@implementation RCAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Fabric with:@[CrashlyticsKit]];
    
    [[UINavigationBar appearance] setTintColor:[UIColor mainTextColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor navigationBarTintColor]];
    
    UIViewController *rootVC = [UIViewController loadViewControllerFromStoryBoardWithIdentifier:@"RCControlViewController"];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
