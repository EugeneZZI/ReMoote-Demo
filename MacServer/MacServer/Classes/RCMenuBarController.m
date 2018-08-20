//
//  RCMenuBarController.m
//  MacServer
//
//  Created by Eugene Zozulya on 12/28/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import "RCMenuBarController.h"
#import "RCStatusItemView.h"
#import "RCAppController.h"
#import "RCAboutWindowController.h"
#import "RCStartupLaunch.h"

#define STATUS_BAR_ITEM_WIDTH           25

@interface RCMenuBarController() <NSMenuDelegate>
{
    NSStatusItem                *_statusBarItem;
    NSMenu                      *_statusBarMenu;
    RCAppController             *_appController;
    
    RCStatusItemView            *_statusBarItemView;
}

@property (nonatomic, strong) RCAboutWindowController       *aboutWindowController;

@end

@implementation RCMenuBarController

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _statusBarMenu = [self createMenu];
        _statusBarItem = [self createStatusBartItem];
        _appController = [RCAppController new];
        [_appController startProcesses];
    }
    
    return self;
}

- (void)dealloc
{
    if([_appController isProcessRun])
        [_appController stopProcesses];
    
    [[NSStatusBar systemStatusBar] removeStatusItem:_statusBarItem];
    _statusBarItem      = nil;
}

- (RCAboutWindowController*)aboutWindowController
{
    if(_aboutWindowController)
        return _aboutWindowController;
    
    _aboutWindowController = [[RCAboutWindowController alloc] initWithWindowNibName:@"RCAboutWindowController"];
    return _aboutWindowController;
}

#pragma mark - Private Methods

- (NSStatusItem*)createStatusBartItem
{
    NSStatusItem *retItem   = [[NSStatusBar systemStatusBar] statusItemWithLength:STATUS_BAR_ITEM_WIDTH];
    _statusBarItemView      = [[RCStatusItemView alloc] initWithStatusItem:retItem];
    retItem.menu            = _statusBarMenu;
    
    return retItem;
}

- (NSMenu*)createMenu
{
    NSMenu *retMenu = [[NSMenu alloc] initWithTitle:@"Menu"];
    retMenu.delegate = self;
    
    NSMenuItem *separatorItem       = [NSMenuItem separatorItem];
    NSMenuItem *actionItem          = [[NSMenuItem alloc] initWithTitle:@"Start server" action:@selector(startStopServerItemPushed:) keyEquivalent:@""];
    actionItem.target               = self;
    
    NSMenuItem *launchOptionItem    = [[NSMenuItem alloc] initWithTitle:@"Launch at login" action:@selector(launchAtLoginPushed:) keyEquivalent:@""];
    [launchOptionItem setState:([RCStartupLaunch isLaunchApplicationAtLogin] ? NSOnState : NSOffState)];
    launchOptionItem.target         = self;
    
    NSMenuItem *abouItem            = [[NSMenuItem alloc] initWithTitle:@"About" action:@selector(aboutItemPushed:) keyEquivalent:@""];
    abouItem.target                 = self;
    
    NSMenuItem *quitItem            = [[NSMenuItem alloc] initWithTitle:@"Quit" action:@selector(quitItemPushed:) keyEquivalent:@""];
    quitItem.target                 = self;
    
    [retMenu insertItem:actionItem          atIndex:0];
    [retMenu insertItem:launchOptionItem    atIndex:1];
    [retMenu insertItem:separatorItem       atIndex:2];
    [retMenu insertItem:abouItem            atIndex:3];
    [retMenu insertItem:quitItem            atIndex:4];
    
    return retMenu;
}

- (void)startStopServerItemPushed:(NSMenuItem*)item
{
    if([_appController isProcessRun])
        [_appController stopProcesses];
    else
        [_appController startProcesses];
}

- (void)aboutItemPushed:(NSMenuItem*)item
{
    [self.aboutWindowController showWindow:nil];
    [self.aboutWindowController.window orderFront:nil];
}

- (void)quitItemPushed:(NSMenuItem*)item
{
    if([_appController isProcessRun])
        [_appController stopProcesses];
    [[NSApplication sharedApplication] terminate:nil];
}

- (void)launchAtLoginPushed:(NSMenuItem*)item
{
    [RCStartupLaunch launchApplicationAtLogin:![RCStartupLaunch isLaunchApplicationAtLogin]];
    [item setState:([RCStartupLaunch isLaunchApplicationAtLogin] ? NSOnState : NSOffState)];
}

#pragma mark - NSMenuDelegate

- (void)menuWillOpen:(NSMenu *)menu
{
    [[menu itemAtIndex:0] setTitle: ([_appController isProcessRun] ? @"Stop server" : @"Start server")];
}

@end
