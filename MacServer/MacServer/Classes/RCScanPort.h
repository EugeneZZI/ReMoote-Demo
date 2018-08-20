//
//  RCScanPort.h
//  MacServer
//
//  Created by Eugene Zozulya on 12/14/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RCScanFreePortsCompletionBlock)(NSArray* ports);
typedef void (^RCCheckPortCompletionBlock)(BOOL freeFlag);

@interface RCScanPort : NSObject

- (void)scanPort:(NSUInteger)port completion:(RCCheckPortCompletionBlock)completion;
- (void)getFreePortsInRange:(NSRange)portsRange amount:(NSUInteger)portsAmount completion:(RCScanFreePortsCompletionBlock)completion;

@end
