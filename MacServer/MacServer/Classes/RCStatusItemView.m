//
//  RCStatusItemView.m
//  MacServer
//
//  Created by Eugene Zozulya on 12/28/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import "RCStatusItemView.h"

@interface RCStatusItemView()
{
    NSStatusItem            *_statusBarItem;
}

@end

@implementation RCStatusItemView

- (instancetype)initWithStatusItem:(NSStatusItem*)statusBarItem
{
    CGFloat itemWidth   = [statusBarItem length];
    CGFloat itemHeight  = [[NSStatusBar systemStatusBar] thickness];
    NSRect itemRect     = NSMakeRect(0.0, 0.0, itemWidth, itemHeight);
    self = [super initWithFrame:itemRect];
    if(self)
    {
        _statusBarItem = statusBarItem;
        if([_statusBarItem respondsToSelector:@selector(button)])
            [self setupStatusBarItemMacOs1010];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    if(![_statusBarItem respondsToSelector:@selector(button)])
    {
        NSImage *image;
        if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"AppleInterfaceStyle"]  isEqual: @"Dark"])
        {
            image = [NSImage imageNamed:@"StatusBarImage"];
        }
        else
        {
            image = [NSImage imageNamed:@"StatusBarImage"];
        }
        [_statusBarItem drawStatusBarBackgroundInRect:dirtyRect withHighlight:NO];
        
        NSImage *icon = image;
        NSSize iconSize = [icon size];
        NSRect bounds = self.bounds;
        CGFloat iconX = roundf((NSWidth(bounds) - iconSize.width) / 2);
        CGFloat iconY = roundf((NSHeight(bounds) - iconSize.height) / 2);
        NSPoint iconPoint = NSMakePoint(iconX, iconY);
        
        [icon drawAtPoint:iconPoint fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    }
}

#pragma mark - Private Methods

- (void)setupStatusBarItemMacOs1010
{
    [_statusBarItem.button setImage:[NSImage imageNamed:@"StatusBarImage"]];
}

@end
