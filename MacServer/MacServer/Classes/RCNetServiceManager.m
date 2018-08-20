//
//  RCNetServiceManager.m
//  MacServer
//
//  Created by Eugene Zozulya on 12/14/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import "RCNetServiceManager.h"
#import "RCNetworkConstants.h"

@interface RCNetServiceManager() <NSNetServiceDelegate>
{
    NSNetService                *_netService;
}

@end

@implementation RCNetServiceManager

- (instancetype)initWithDomain:(NSString*)domain type:(NSString *)type name:(NSString *)name port:(int)port
{
    self = [super init];
    if(self)
    {
        _netService = [[NSNetService alloc] initWithDomain:domain type:type name:name port:port];
        _netService.delegate = self;
    }
    
    return self;
}

- (instancetype)initWithServiceName:(NSString*)serverName port:(NSInteger)port
{
    self = [self initWithDomain:kRCNetServiceDomain type:kRCNetServiceType name:serverName port:(int)port];
    return self;
}

- (instancetype)init
{
    self = [self initWithServiceName:kRCNetServiceName port:[kRCNetServicePort integerValue]];
    return self;
}

- (void)dealloc
{
    [self stopService];
}

#pragma mark - Public Methods

- (void)startService
{
    [_netService publish];
}

- (void)stopService
{
    [_netService stop];
}

#pragma mark - NSNetServiceDelegate

- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict
{
    DLog(@"--->");
}

- (void)netServiceDidPublish:(NSNetService *)sender
{
    DLog(@"--->");
}

- (void)netServiceDidStop:(NSNetService *)sender
{
    DLog(@"--->");
}

- (void)netServiceWillPublish:(NSNetService *)sender
{
    DLog(@"--->");
}

@end
