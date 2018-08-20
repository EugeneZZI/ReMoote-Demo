//
//  RCAppInfo.h
//  MacServer
//
//  Created by Eugene Zozulya on 12/29/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCAppInfo : NSObject

+ (NSString*)appVersion;
+ (BOOL)isFirstStart;

@end
