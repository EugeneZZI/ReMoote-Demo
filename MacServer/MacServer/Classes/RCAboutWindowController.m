//
//  RCAboutWindowController.m
//  MacServer
//
//  Created by Eugene Zozulya on 12/29/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import "RCAboutWindowController.h"
#import "RCAppInfo.h"

@interface RCAboutWindowController ()

@property (weak) IBOutlet NSTextField *infoTextField;
@property (weak) IBOutlet NSTextField *versionTextField;

@end

@implementation RCAboutWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    [self.versionTextField setStringValue:[NSString stringWithFormat:@"%@%@", self.versionTextField.stringValue, [RCAppInfo appVersion]]];
}

@end
