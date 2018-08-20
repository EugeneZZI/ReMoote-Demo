//
//  RCNetServiceResolver.h
//  iOSClient
//
//  Created by Eugene Zozulya on 12/15/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *kRCNetServiceResolverErrorDomain;

@class RCServer;
typedef void (^RCNetServiceResolverCompletionBlock)(RCServer *server, NSError *error);

@interface RCNetServiceResolver : NSObject

+ (instancetype)resolveServer:(RCServer*)server withComplition:(RCNetServiceResolverCompletionBlock)completion;
- (void)startResolving;

@end
