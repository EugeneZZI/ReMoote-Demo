//
//  RCNetworkManager.h
//  iOSClient
//
//  Created by Eugene Zozulya on 11/29/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RCServer;
@protocol RCNetworkManagerDelegate;

@interface RCNetworkManager : NSObject

@property (nonatomic, weak) id<RCNetworkManagerDelegate>        delegate;
@property (nonatomic, strong) RCServer                          *currentServer;

- (void)startCheckingServerState;
- (void)stopCheckingServerState;

- (void)sendNewVolumeValue:(float)volumeValue;
- (void)sendMute;
- (void)sendUnmute;
- (void)sendShutdown;
- (void)sendSleep;

- (void)cancelAllRequests;

@end

@protocol RCNetworkManagerDelegate <NSObject>

@optional

- (void)networkManager:(RCNetworkManager*)networkManager    serverState:(NSDictionary*)currentState; // async invocation
- (void)networkManager:(RCNetworkManager*)networkManager    serverRequestCompletedWithError:(NSError*)error;

@end
