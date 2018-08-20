//
//  RCServersStore.h
//  iOSClient
//
//  Created by Eugene Zozulya on 12/2/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RCServer;

@interface RCServersStore : NSObject

@property (nonatomic, strong) RCServer          *currentServer;

+ (instancetype)sharedStore;

@end
