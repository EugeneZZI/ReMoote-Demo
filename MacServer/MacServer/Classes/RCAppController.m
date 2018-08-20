//
//  AppController.m
//  MacServer
//
//  Created by Eugene Zozulya on 12/9/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import "RCAppController.h"
#import "RCHTTPServerManager.h"
#import "RCMacInfo.h"
#import "RCMacState.h"
#import "RCNetworkConstants.h"
#import "RCKeysDefinition.h"

@interface RCAppController() <RCHTTPServerManagerDelegate>
{
    RCHTTPServerManager             *_serverManager;
    RCMacInfo                       *_macInfo;
    RCMacState                      *_macState;
}

@end

@implementation RCAppController

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _macInfo            = [RCMacInfo new];
        _macState           = [RCMacState new];
        
        NSString *serviceName       = [NSString stringWithFormat:@"%@%@", [_macInfo getMacOSLoggedUserName], kRCNetServiceName];
        _serverManager              = [RCHTTPServerManager sharedManager];
        _serverManager.serverName   = serviceName;
    }
    
    return self;
}

#pragma mark - Public Methods

- (void)startProcesses
{
    [_serverManager startServer];
    _serverManager.delegate = self;
}

- (void)stopProcesses
{
    [_serverManager stopServer];
    _serverManager.delegate = nil;
}

- (BOOL)isProcessRun
{
    return [_serverManager isServerRun];
}

#pragma mark - RCHTTPServerManagerDelegate

- (NSDictionary*)getServerState
{
    float currentVolume = [_macState getCurrentSystemVolumeValue];
    BOOL isMute = [_macState isSystemVolumeMuted];
    NSDictionary *retDict = @{ kRCServerStateVolumeValue : @(currentVolume), kRCServerStateMuted : @(isMute) };
    return retDict;
}

- (NSInteger)setServerVolume:(float)setVolume
{
    setVolume = setVolume < 0.1 ? 0.1 : setVolume;
    BOOL flag = [_macState setNewSystemVolumeValue:setVolume];
    return flag ? setVolume : -1;
}

- (void)muteServer
{
    [_macState muteSystemVolume];
}

- (void)unmuteServer
{
    [_macState unmuteSystemVolume];
}

- (void)sleepServer
{
    [_macState sleepSystem];
}

- (void)shutdownServer
{
    [_macState shutdownSystem];
}

#pragma mark - Private Methods

@end
