//
//  RCNetworkScaner.h
//  iOSClient
//
//  Created by Eugene Zozulya on 11/29/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import <Foundation/Foundation.h>

@class      RCServer;
@protocol   RCNetworkScanerDelegate;

extern NSString *kNetworkScanerErrorDomain;

typedef void (^RCNetworkScanerResolveServerCompletionBlock)(RCServer *server);

@interface RCNetworkScaner : NSObject

@property (nonatomic, weak) id<RCNetworkScanerDelegate>     delegate;

- (void)startScan;
- (void)stopScan;

@end

@protocol RCNetworkScanerDelegate <NSObject>

@optional
- (void)networkScanerWillStartSearch:(RCNetworkScaner*)networkScaner;
- (void)networkScanerDidStoptSearch:(RCNetworkScaner*)networkScaner withError:(NSError*)error;
- (void)networkScaner:(RCNetworkScaner*)networkScaner didUpdateServersList:(NSArray*)serversList;

@end

