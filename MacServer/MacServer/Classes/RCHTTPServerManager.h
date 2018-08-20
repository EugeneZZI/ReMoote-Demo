//
//  RCHTTPServerManager.h
//  MacServer
//
//  Created by Eugene Zozulya on 12/5/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RCHTTPServerManagerDelegate;

@interface RCHTTPServerManager : NSObject

@property(nonatomic, weak) id<RCHTTPServerManagerDelegate>              delegate;
@property(nonatomic, copy) NSString                                     *serverName;

+ (instancetype)sharedManager;

- (void)startServer;
- (void)stopServer;
- (BOOL)isServerRun;

@end

@protocol RCHTTPServerManagerDelegate <NSObject>

@required
- (NSDictionary*)getServerState;
- (NSInteger)setServerVolume:(float)setVolume;
- (void)muteServer;
- (void)unmuteServer;
- (void)sleepServer;
- (void)shutdownServer;

@end

