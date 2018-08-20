//
//  RCStartupLaunch.m
//  MacServer
//
//  Created by Eugene Zozulya on 1/9/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import "RCStartupLaunch.h"

@implementation RCStartupLaunch

NSString* RCApplicationPath()
{
    static NSString *_applicationPath;
    if(_applicationPath)
        return _applicationPath;
    
    _applicationPath = [[NSBundle mainBundle] bundlePath];
    return _applicationPath;
}

void RCEnableLoginItemWithLoginItemsReference(LSSharedFileListRef theLoginItemsRefs, NSString *appPath)
{
    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:appPath];
    LSSharedFileListItemRef item = LSSharedFileListInsertItemURL(theLoginItemsRefs, kLSSharedFileListItemLast, NULL, NULL, url, NULL, NULL);
    if (item)
        CFRelease(item);
}

void RCDisableLoginItemWithLoginItemsReference(LSSharedFileListRef theLoginItemsRefs, NSString *appPath)
{
    UInt32 seedValue;
    CFURLRef thePath = NULL;
    CFArrayRef loginItemsArray = LSSharedFileListCopySnapshot(theLoginItemsRefs, &seedValue);
    for (id item in (__bridge NSArray *)loginItemsArray) {
        LSSharedFileListItemRef itemRef = (__bridge LSSharedFileListItemRef)item;
        if (LSSharedFileListItemResolve(itemRef, 0, (CFURLRef*) &thePath, NULL) == noErr) {
            if ([[(__bridge NSURL *)thePath path] hasPrefix:appPath]) {
                LSSharedFileListItemRemove(theLoginItemsRefs, itemRef);
            }
            if (thePath != NULL) CFRelease(thePath);
        }
    }
    if (loginItemsArray != NULL) CFRelease(loginItemsArray);
}

BOOL RCLoginItemExistsWithLoginItemReference(LSSharedFileListRef theLoginItemsRefs, NSString *appPath)
{
    BOOL found = NO;
    UInt32 seedValue;
    CFURLRef thePath = NULL;
    
    CFArrayRef loginItemsArray = LSSharedFileListCopySnapshot(theLoginItemsRefs, &seedValue);
    for (id item in (__bridge NSArray *)loginItemsArray) {
        LSSharedFileListItemRef itemRef = (__bridge LSSharedFileListItemRef)item;
        if (LSSharedFileListItemResolve(itemRef, 0, (CFURLRef*) &thePath, NULL) == noErr) {
            if ([[(__bridge NSURL *)thePath path] hasPrefix:appPath]) {
                found = YES;
                break;
            }
            if (thePath != NULL) CFRelease(thePath);
        }
    }
    if (loginItemsArray != NULL) CFRelease(loginItemsArray);
    
    return found;
}

BOOL RCCurrentAppLaunchesAtStartup()
{
    LSSharedFileListRef items = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    BOOL exists = RCLoginItemExistsWithLoginItemReference(items, RCApplicationPath());
    CFRelease(items);
    return exists;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
#pragma mark -
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

+ (void)launchApplicationAtLogin:(BOOL)flag
{
    LSSharedFileListRef items = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    
    if (items) {
        if (!RCCurrentAppLaunchesAtStartup() && flag)
            RCEnableLoginItemWithLoginItemsReference(items, RCApplicationPath());
        else if(RCCurrentAppLaunchesAtStartup() && !flag)
            RCDisableLoginItemWithLoginItemsReference(items, RCApplicationPath());
        CFRelease(items);
    }
}

+ (BOOL)isLaunchApplicationAtLogin
{
    return  RCCurrentAppLaunchesAtStartup();
}

@end
