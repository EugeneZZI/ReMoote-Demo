//
//  RCNetServiceManager.h
//  MacServer
//
//  Created by Eugene Zozulya on 12/14/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCNetServiceManager : NSObject

- (instancetype)initWithDomain:(NSString*)domain type:(NSString *)type name:(NSString *)name port:(int)port;
- (instancetype)initWithServiceName:(NSString*)serverName port:(NSInteger)port;

- (void)startService;
- (void)stopService;

@end
