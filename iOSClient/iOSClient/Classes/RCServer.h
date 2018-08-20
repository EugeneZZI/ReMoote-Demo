//
//  RCServer.h
//  iOSClient
//
//  Created by Eugene Zozulya on 12/2/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCServer : NSObject <NSCoding>

@property (nonatomic, copy) NSString            *domain;
@property (nonatomic, copy) NSString            *type;
@property (nonatomic, copy) NSString            *name;
@property (nonatomic, retain) NSString          *shortName;

@property (nonatomic, copy) NSString            *hostName;
@property (nonatomic, copy) NSString            *port;

- (instancetype)initWithNetService:(NSNetService*)netService;

@end
