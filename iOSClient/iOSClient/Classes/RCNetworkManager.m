//
//  RCNetworkManager.m
//  iOSClient
//
//  Created by Eugene Zozulya on 11/29/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import "RCNetworkManager.h"
#import "RCNetworkServices.h"
#import "RCServer.h"

#define ETALON_URL_STRING           @"http://%@:%@/%@"

@interface RCNetworkManager()
{
    NSURLSession                    *_checkServerStateSession;
    NSURLSession                    *_mainSession;
    
    BOOL                             _checkingServerState;
}

@property (nonatomic, readonly) NSString                *serverHostName;
@property (nonatomic, readonly) NSString                *serverPort;
@property (nonatomic, strong)   NSURLRequest            *checkServerStateRequest;

@end

@implementation RCNetworkManager

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        NSURLSessionConfiguration *mainConfig           = [NSURLSessionConfiguration defaultSessionConfiguration];
        mainConfig.HTTPMaximumConnectionsPerHost        = 999;
        _mainSession                                    = [NSURLSession sessionWithConfiguration:mainConfig];
        
        NSURLSessionConfiguration *volumeConfig         = [NSURLSessionConfiguration defaultSessionConfiguration];
        volumeConfig.HTTPMaximumConnectionsPerHost      = 2;
        volumeConfig.timeoutIntervalForRequest          = 3;
        _checkServerStateSession                        = [NSURLSession sessionWithConfiguration:volumeConfig];

    }
    
    return self;
}

- (void)setCurrentServer:(RCServer *)currentServer
{
    _currentServer = currentServer;
    _checkServerStateRequest = nil;
}

- (NSString*)serverHostName
{
    if(_currentServer)
        return _currentServer.hostName;
        
    return nil;
}

- (NSString*)serverPort
{
    if(_currentServer)
        return _currentServer.port;
    
    return nil;
}

- (NSURLRequest*)checkServerStateRequest
{
    if(_checkServerStateRequest)
        return _checkServerStateRequest;
    
    NSString *urlString         = [NSString stringWithFormat:ETALON_URL_STRING, self.serverHostName, self.serverPort, kRCNetworkServiceGetState];
    NSURL *url                  = [NSURL URLWithString:urlString];
    _checkServerStateRequest    = [NSURLRequest requestWithURL:url];
    
    return _checkServerStateRequest;
}

#pragma mark - Publick Methods

- (void)startCheckingServerState
{
    if(!_checkingServerState)
    {
        _checkingServerState = YES;
        _checkingServerState = -1;
        [self checkServerStateInLoop];
    }
}

- (void)stopCheckingServerState
{
    _checkingServerState = NO;
}

- (void)sendNewVolumeValue:(float)volumeValue
{
    NSString *urlString     = [NSString stringWithFormat:@"http://%@:%@/%@?setVolume=%f", self.serverHostName, self.serverPort, kRCNetworkServiceSetVolume, volumeValue];
    NSURL *url              = [NSURL URLWithString:urlString];
    NSURLRequest *request   = [NSURLRequest requestWithURL:url];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [[_mainSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *conectionError) {
        }] resume];
    });

}

- (void)sendMute
{
    NSString *urlString     = [NSString stringWithFormat:ETALON_URL_STRING, self.serverHostName, self.serverPort, kRCNetworkServiceMute];
    NSURL *url              = [NSURL URLWithString:urlString];
    NSURLRequest *request   = [NSURLRequest requestWithURL:url];
    [[_mainSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *conectionError) {
    }] resume];
}

- (void)sendUnmute
{
    NSString *urlString     = [NSString stringWithFormat:ETALON_URL_STRING, self.serverHostName, self.serverPort, kRCNetworkServiceUnmute];
    NSURL *url              = [NSURL URLWithString:urlString];
    NSURLRequest *request   = [NSURLRequest requestWithURL:url];
    [[_mainSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *conectionError) {
    }] resume];
}

- (void)sendShutdown
{
    NSString *urlString     = [NSString stringWithFormat:ETALON_URL_STRING, self.serverHostName, self.serverPort, kRCNetworkServiceShutdown];
    NSURL *url              = [NSURL URLWithString:urlString];
    NSURLRequest *request   = [NSURLRequest requestWithURL:url];
    [[_mainSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *conectionError) {
    }] resume];
}

- (void)sendSleep
{
    NSString *urlString     = [NSString stringWithFormat:ETALON_URL_STRING, self.serverHostName, self.serverPort, kRCNetworkServiceSleep];
    NSURL *url              = [NSURL URLWithString:urlString];
    NSURLRequest *request   = [NSURLRequest requestWithURL:url];
    [[_mainSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *conectionError) {
    }] resume];
}

- (void)cancelAllRequests
{
    [_mainSession flushWithCompletionHandler:^{
        
    }];
    [_checkServerStateSession flushWithCompletionHandler:^{
        
    }];
}

#pragma mark - Private Methods

- (void)checkServerStateInLoop
{
    if(!_checkingServerState) return;
    
    [[_checkServerStateSession dataTaskWithRequest:self.checkServerStateRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *conectionError) {
        
        if(conectionError)
        {
            DLog(@"Connection error %@", conectionError);
            dispatch_sync(dispatch_get_main_queue(), ^{
                if([self.delegate respondsToSelector:@selector(networkManager:serverRequestCompletedWithError:)])
                    [self.delegate networkManager:self serverRequestCompletedWithError:conectionError];
            });
            
            return;
        }
        
        NSError *error = nil;
        NSDictionary *serverState = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if(error)
        {
            DLog(@"Parsing error %@", error);
            return;
        }
        
        if(_checkingServerState)
        {
            if([self.delegate respondsToSelector:@selector(networkManager:serverState:)])
                [self.delegate networkManager:self serverState:serverState];
        }
        
        if(_checkingServerState)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self checkServerStateInLoop];
            });
        }
        
    }] resume];

}

@end
