//
//  AppDelegate.m
//  MacServer
//
//  Created by Eugene Zozulya on 12/9/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import "AppDelegate.h"
#import "RCMenuBarController.h"
#import "RCAppInfo.h"
#import "RCStartupLaunch.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (nonatomic, strong) RCMenuBarController               *menuBarController;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
//    if([RCAppInfo isFirstStart])
//        [RCStartupLaunch launchApplicationAtLogin:YES];
    
    self.menuBarController = [RCMenuBarController new];
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    self.menuBarController = nil;
}

@end
