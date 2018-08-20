//
//  RCMacInfo.m
//  MacServer
//
//  Created by Eugene Zozulya on 12/9/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import "RCMacInfo.h"

@implementation RCMacInfo

#pragma mark - Public Methods

- (NSString*)getMacOSLoggedUserName
{
    return [[NSHost currentHost] localizedName];
}

#pragma mark - Private Methods

@end
