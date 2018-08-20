//
//  RCNetworkScaner.m
//  iOSClient
//
//  Created by Eugene Zozulya on 11/29/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import "RCNetworkScaner.h"
#import "RCNetworkServices.h"
#import "RCServer.h"
#import "RCNetworkConstants.h"

@interface RCNetworkScaner() <NSNetServiceBrowserDelegate, NSNetServiceDelegate>
{
    NSMutableArray              *_serverList;
    NSNetServiceBrowser         *_serviceBrowser;
}

@end

@implementation RCNetworkScaner

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _serverList     = [NSMutableArray new];
        _serviceBrowser = [NSNetServiceBrowser new];
        _serviceBrowser.delegate = self;
    }
    
    return self;
}

#pragma mark - Publick Methods

- (void)startScan
{
    [self cleanForNewScanning];
    [_serviceBrowser searchForServicesOfType:kRCNetServiceType inDomain:kRCNetServiceDomain];
}

- (void)stopScan
{
    [_serviceBrowser stop];
}

#pragma mark - Private Methods

- (void)cleanForNewScanning
{
    [_serverList removeAllObjects];
    if([self.delegate respondsToSelector:@selector(networkScaner:didUpdateServersList:)])
        [self.delegate networkScaner:self didUpdateServersList:_serverList];
}

#pragma mark - NSNetServiceBrowserDelegate

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindService:(NSNetService *)aNetService moreComing:(BOOL)moreComing
{
    if([aNetService.name rangeOfString:kRCNetServiceName].length > 0)
    {
        RCServer *server = [[RCServer alloc] initWithNetService:aNetService];
        [_serverList addObject:server];
        
        if(!moreComing)
            if([self.delegate respondsToSelector:@selector(networkScaner:didUpdateServersList:)])
                [self.delegate networkScaner:self didUpdateServersList:_serverList];
    }
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didRemoveService:(NSNetService *)aNetService moreComing:(BOOL)moreComing
{
    NSUInteger index = [_serverList indexOfObjectPassingTest:^BOOL(RCServer *obj, NSUInteger idx, BOOL *stop) {
        if([obj.name isEqualToString:aNetService.name])
        {
            *stop = YES;
            return YES;
        }
        return NO;
    }];
    [_serverList removeObjectAtIndex:index];
    
    if(!moreComing)
        if([self.delegate respondsToSelector:@selector(networkScaner:didUpdateServersList:)])
            [self.delegate networkScaner:self didUpdateServersList:_serverList];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didNotSearch:(NSDictionary *)errorDict
{
    NSError *error = [NSError errorWithDomain:errorDict[NSNetServicesErrorDomain] code:[errorDict[NSNetServicesErrorCode] intValue] userInfo:errorDict];
    if([self.delegate respondsToSelector:@selector(networkScanerDidStoptSearch:withError:)])
        [self.delegate networkScanerDidStoptSearch:self withError:error];
}

- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)aNetServiceBrowser
{
    if([self.delegate respondsToSelector:@selector(networkScanerDidStoptSearch:withError:)])
        [self.delegate networkScanerDidStoptSearch:self withError:nil];
}

- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)aNetServiceBrowser
{
    if([self.delegate respondsToSelector:@selector(networkScanerWillStartSearch:)])
        [self.delegate networkScanerWillStartSearch:self];
}

@end
