//
//  RCAppInfo.h
//  iOSClient
//
//  Created by Eugene Zozulya on 12/24/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCAppInfo : NSObject

+ (BOOL)isFirstStart;
+ (NSString*)appVersion;

@end
