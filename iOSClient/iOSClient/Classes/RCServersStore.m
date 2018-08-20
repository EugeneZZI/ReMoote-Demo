//
//  RCServersStore.m
//  iOSClient
//
//  Created by Eugene Zozulya on 12/2/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import "RCServersStore.h"
#import "RCServer.h"

#define CURRENT_SERVER_FILE_NAME        @"CurrentServer.data"

@interface RCServersStore()

@property (nonatomic, readonly) NSString                *currentServerFilePath;

@end

@implementation RCServersStore

@synthesize currentServerFilePath = _currentServerFilePath;

+ (instancetype)sharedStore
{
    static RCServersStore *sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] init];
    });
    return sharedStore;
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [self restoreCurrentServer];
    }
    
    return self;
}

- (void)setCurrentServer:(RCServer *)currentServer
{
    _currentServer = currentServer ;
    if(_currentServer)
        [self storeCurrentServer];
    else
        [self removeCurrentServer];
}

#pragma mark - Private Methods

- (NSString*)currentServerFilePath
{
    if(_currentServerFilePath)
        return _currentServerFilePath;
    
    _currentServerFilePath = [RCDocumentsPath() stringByAppendingPathComponent:CURRENT_SERVER_FILE_NAME];
    return _currentServerFilePath;
}


- (void)storeCurrentServer
{
    if(_currentServer)
    {
        BOOL success = [NSKeyedArchiver archiveRootObject:_currentServer toFile:self.currentServerFilePath];
        DLog(@"---> %d", success);
    }
}

- (void)restoreCurrentServer
{
    if([[NSFileManager defaultManager] fileExistsAtPath:self.currentServerFilePath])
    {
        RCServer *server = [NSKeyedUnarchiver unarchiveObjectWithFile:self.currentServerFilePath];
        if(server && [server isKindOfClass:[RCServer class]])
            _currentServer = server;
    }
}

- (void)removeCurrentServer
{
    if([[NSFileManager defaultManager] fileExistsAtPath:self.currentServerFilePath])
    {
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:self.currentServerFilePath error:&error];
        if(error)
        {
            DLog(@"Error: %@", error);
        }
    }
}

@end
