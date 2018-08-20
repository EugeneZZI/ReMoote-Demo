//
//  RCScanPort.m
//  MacServer
//
//  Created by Eugene Zozulya on 12/14/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import "RCScanPort.h"

@implementation RCScanPort

#pragma mark - Publick Methods

- (void)scanPort:(NSUInteger)port completion:(RCCheckPortCompletionBlock)completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL result = [self checkIsFreePort:port];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(result);
        });
    });
}

- (void)getFreePortsInRange:(NSRange)portsRange amount:(NSUInteger)portsAmount completion:(RCScanFreePortsCompletionBlock)completion
{
    if(portsRange.length < portsAmount)
    {
        DLog(@"Ports amount is less then checking ports set");
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(@[]);
        });
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *freePorts = [NSMutableArray new];
        for(int i = (int)portsRange.location; i < (portsRange.location + portsRange.length); i++)
        {
            if([self checkIsFreePort:i])
                [freePorts addObject:@(i)];
            
            if(freePorts.count >= portsAmount)
                break;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(freePorts);
        });
    });
}

#pragma mark - Private Methods

- (BOOL)checkIsFreePort:(NSUInteger)port
{
    NSTask *task = [NSTask new];
    [task setLaunchPath:@"/usr/sbin/lsof"];
    [task setArguments:@[[NSString stringWithFormat:@"-i4tcp:%d", (int)port]]];
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    NSFileHandle *file = [pipe fileHandleForReading];
    [task launch];
    NSString *output = [[NSString alloc] initWithData:[file readDataToEndOfFile] encoding:NSUTF8StringEncoding];
    
    return (BOOL)!output.length;
}

@end
