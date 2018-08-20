//
//  RCNetServiceResolver.m
//  iOSClient
//
//  Created by Eugene Zozulya on 12/15/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import "RCNetServiceResolver.h"
#import "RCServer.h"

NSString *kRCNetServiceResolverErrorDomain = @"netServiceResolverErrorDomain";

@interface RCNetServiceResolver() <NSNetServiceDelegate>
{
    NSNetService                            *_netService;
    RCServer                                *_server;
    RCNetServiceResolverCompletionBlock      _completion;
}

@end

@implementation RCNetServiceResolver

+ (instancetype)resolveServer:(RCServer*)server withComplition:(RCNetServiceResolverCompletionBlock)completion
{
    __autoreleasing RCNetServiceResolver *resolver = [[RCNetServiceResolver alloc] initWithServer:server completion:completion];
    return resolver;
}

- (instancetype)initWithServer:(RCServer*)server completion:(RCNetServiceResolverCompletionBlock)completion
{
    self = [super init];
    if(self)
    {
        _netService     = [[NSNetService alloc] initWithDomain:server.domain type:server.type name:server.name];
        _server         = server;
        _completion     = (__bridge RCNetServiceResolverCompletionBlock)Block_copy((__bridge void*)completion);
        
        _netService.delegate = self;
    }
    
    return self;
}

- (void)dealloc
{
    Block_release((__bridge void*)_completion);
}

- (void)startResolving
{
    [_netService resolveWithTimeout:10.0];
}

#pragma mark - NSNetServiceDelegate

- (void)netServiceDidResolveAddress:(NSNetService *)sender
{
    _server.hostName = sender.hostName;
    _server.port = [NSString stringWithFormat:@"%d", (int)sender.port];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(_completion)
            _completion(_server, nil);
    });
}

- (void)netService:(NSNetService *)netService didNotResolve:(NSDictionary *)errorDict
{
    NSError *error = [NSError errorWithDomain:kRCNetServiceResolverErrorDomain code:[errorDict[NSNetServicesErrorCode] intValue] userInfo:errorDict];
    dispatch_async(dispatch_get_main_queue(), ^{
        if(_completion)
            _completion(nil, error);
    });
}

@end
