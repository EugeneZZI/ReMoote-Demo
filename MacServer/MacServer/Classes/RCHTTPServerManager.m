//
//  RCHTTPServerManager.m
//  MacServer
//
//  Created by Eugene Zozulya on 12/5/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import "RCHTTPServerManager.h"
#import "NSDictionary+QueryString.h"
#import "NSDictionary+JSON.h"
#import "RCNetServiceManager.h"
#import "RCScanPort.h"
#import "RCKeysDefinition.h"
#include "mongoose.h"

#define CHECK_SERVER_ID                 "CheckServerIdentifier"
#define CONTROL_SERVER_ID               "ControlServerIdentifier"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// HTTP Server
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

const int kRCHTTPServicePortRangeLocation    = 20000;
const int kRCHTTPServicePortRangeLenght      = 500;

const char *kRCHTTPServiceGetState           = "/getState";
const char *kRCHTTPServiceSetVolume          = "/setVolume";
const char *kRCHTTPServiceMute               = "/mute";
const char *kRCHTTPServiceUnmute             = "/unmute";
const char *kRCHTTPServiceShutdown           = "/shutDown";
const char *kRCHTTPServiceSleep              = "/sleep";

static RCHTTPServerManager *pSharedManager   = NULL;

int ev_handler(struct mg_connection *conn, enum mg_event ev);
int handle_request(struct mg_connection *conn);
void *serve(void *server);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Keys
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

const NSString *kRCServerCurrentVolumeKey               = @"currentVolume";
const NSString *kRCClientCurrentVolumeKey               = @"setVolume";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface RCHTTPServerManager()
{
    struct mg_server            *_controlServer;
    BOOL                         _isServerRun;
    
    RCNetServiceManager         *_serviceManager;
    RCScanPort                  *_scanPort;
}

@end

@implementation RCHTTPServerManager

+ (instancetype)sharedManager
{
    static RCHTTPServerManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager   = [[self alloc] init];
        pSharedManager  = sharedManager;
    });
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _isServerRun            = NO;
        _controlServer          = mg_create_server((void *) CONTROL_SERVER_ID, ev_handler);
        
        _scanPort               = [RCScanPort new];
    }
    
    return self;
}

- (void)dealloc
{
    mg_destroy_server(&_controlServer);
}

#pragma mark - Publick Methods

- (void)startServer
{
    [_scanPort getFreePortsInRange:NSMakeRange(kRCHTTPServicePortRangeLocation, kRCHTTPServicePortRangeLenght) amount:1 completion:^(NSArray *ports) {
        NSNumber *port = ports.firstObject;
        _serviceManager = [[RCNetServiceManager alloc] initWithServiceName:self.serverName port:[port integerValue]];
        [_serviceManager startService];
        mg_set_option(_controlServer, "listening_port", [[port stringValue] cStringUsingEncoding:NSUTF8StringEncoding]);
        
        _isServerRun = YES;
        mg_start_thread(serve, _controlServer);
    }];
}

- (void)stopServer
{
    [_serviceManager stopService];
    _serviceManager     = nil;
    _isServerRun        = NO;
}

- (BOOL)isServerRun
{
    return _isServerRun;
}

#pragma mark - Private Methods

- (NSData*)serverStateJSON
{
    NSDictionary *info;
    if([self.delegate respondsToSelector:@selector(getServerState)])
        info =  [self.delegate getServerState];
    
    NSData *retData;
    if(info)
    {
        NSData *data = [info JSONData];
        retData = data ? data : [NSData data];
    }
    
    return retData;
}

- (NSData*)setServerVolumeWithQueryString:(const char*)queryStr
{
    NSString *qString = [NSString stringWithCString:queryStr encoding:NSUTF8StringEncoding];
    NSDictionary *params = [NSDictionary dictionaryWithQueryString:qString];
    NSData *retData = [NSData data];
    
    if(params[kRCClientCurrentVolumeKey])
    {
        float newVolume = [params[kRCClientCurrentVolumeKey] floatValue];
        BOOL result = NO;
        if([self.delegate respondsToSelector:@selector(setServerVolume:)])
            result = [self.delegate setServerVolume:newVolume];
        
        if(result)
        {
            NSDictionary *info = @{ kRCServerCurrentVolumeKey : @(newVolume)};
            if(info)
            {
                NSData *data = [info JSONData];
                if(data)
                    retData = data;
            }
        }
    }
    
    return retData;
}

- (void)muteServer
{
    if([self.delegate respondsToSelector:@selector(muteServer)])
        [self.delegate muteServer];
}

- (void)unmuteServer
{
    if([self.delegate respondsToSelector:@selector(unmuteServer)])
        [self.delegate unmuteServer];
}

- (void)sleepServer
{
    if([self.delegate respondsToSelector:@selector(sleepServer)])
        [self.delegate sleepServer];
}

- (void)shutdownServer
{
    if([self.delegate respondsToSelector:@selector(shutdownServer)])
        [self.delegate shutdownServer];
}

#pragma mark - Server Part

int ev_handler(struct mg_connection *conn, enum mg_event ev)
{
    switch (ev) {
        case MG_AUTH:
        case MG_CONNECT:
        case MG_REPLY:
        case MG_RECV:
        case MG_CLOSE:
        case MG_WS_HANDSHAKE:
        case MG_WS_CONNECT:
        case MG_HTTP_ERROR:
            return MG_TRUE;
        case MG_REQUEST:
            return handle_request(conn);
        default: return MG_FALSE;
    }
}

int handle_request(struct mg_connection *conn)
{
    if(pSharedManager.delegate == nil)
        return MG_FALSE;
        
    if (strcmp(conn->uri, kRCHTTPServiceGetState) == 0)
    {
        NSData *response = [pSharedManager serverStateJSON];
        mg_send_data(conn, response.bytes, (int)response.length);
        return MG_TRUE;
    }
    else if (strcmp(conn->uri, kRCHTTPServiceSetVolume) == 0)
    {
        const char *param = conn->query_string;
        if(param != NULL)
        {
            NSData *response = [pSharedManager setServerVolumeWithQueryString:param];
            mg_send_data(conn, response.bytes, (int)response.length);
            return MG_TRUE;
        }
        
        return MG_FALSE;
    }
    else if (strcmp(conn->uri, kRCHTTPServiceMute) == 0)
    {
        [pSharedManager muteServer];
        return MG_TRUE;
    }
    else if (strcmp(conn->uri, kRCHTTPServiceUnmute) == 0)
    {
        [pSharedManager unmuteServer];
        return MG_TRUE;
    }
    else if (strcmp(conn->uri, kRCHTTPServiceSleep) == 0)
    {
        [pSharedManager sleepServer];
        return MG_TRUE;
    }
    else if (strcmp(conn->uri, kRCHTTPServiceShutdown) == 0)
    {
        [pSharedManager shutdownServer];
        return MG_TRUE;
    }
    
    return MG_FALSE;
}

void *serve(void *server) {
    while(pSharedManager.isServerRun)
    {
        mg_poll_server((struct mg_server *) server, 1000);
    }
    
    return NULL;
}

@end
