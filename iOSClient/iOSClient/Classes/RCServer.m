//
//  RCServer.m
//  iOSClient
//
//  Created by Eugene Zozulya on 12/2/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import "RCServer.h"
#import "RCNetworkConstants.h"

@implementation RCServer

- (instancetype)initWithNetService:(NSNetService*)netService
{
    self = [super init];
    if(self)
    {
        _domain     = netService.domain;
        _type       = netService.type;
        _name       = netService.name;
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self                = [super init];
    self.domain         = [aDecoder decodeObjectForKey:@"domain"];
    self.type           = [aDecoder decodeObjectForKey:@"type"];
    self.name           = [aDecoder decodeObjectForKey:@"name"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_domain    forKey:@"domain"];
    [aCoder encodeObject:_type      forKey:@"type"];
    [aCoder encodeObject:_name      forKey:@"name"];
}

- (NSString*)description
{
    NSMutableString *retStr = [NSMutableString new];
    [retStr appendFormat:@"Server Name: %@", self.name];
    [retStr appendFormat:@"\rDomain: %@", self.domain];
    [retStr appendFormat:@"\rType: %@", self.type];
    
    return retStr;
}

- (NSString*)shortName
{
    if(_shortName)
        return _shortName;
    
    _shortName = [_name stringByReplacingOccurrencesOfString:kRCNetServiceName withString:@""];
    return _shortName;
}

@end
